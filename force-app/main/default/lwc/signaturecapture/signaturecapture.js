import { LightningElement, track ,wire} from 'lwc';
import saveNPP from '@salesforce/apex/NPP_SignatureController.saveNPP';
import getAccountDat from '@salesforce/apex/NPP_SignatureController.getAccountDat';
import getNppData from '@salesforce/apex/NPP_SignatureController.getNppData';
import { CurrentPageReference } from 'lightning/navigation';
import allianceImage from '@salesforce/resourceUrl/allianceImage';
import allianceHeader from '@salesforce/resourceUrl/allianceHeader';

export default class NppSignatureForm extends LightningElement {
    logoUrl = allianceImage ; 
    bannerUrl =allianceHeader;
recordId;

    @wire(CurrentPageReference)
    getPageReference(pageRef) {
        if (pageRef) {
            this.recordId = pageRef.state.recordId;   // capture ?recordId=
            console.log('Record ID:', this.recordId);
        }
    }

    accountName;

    @wire(getAccountDat, { accId: '$recordId' })
    wiredAccount({ data, error }) {
        if (data) {
            this.accountName = data.Name;
        } else if (error) {
            console.error(error);
        }
    }

    @track issuesValue = '';
    issuesOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];

    canvas;
    ctx;
    isDrawing = false;
    isLoading = false;
    hasRendered = false;

    renderedCallback() {
        if (this.hasRendered) return;
        this.hasRendered = true;

        this.canvas = this.template.querySelector('canvas.sig-pad');
        this.canvas.width = 350;
        this.canvas.height = 200;

        this.ctx = this.canvas.getContext('2d');
        this.ctx.lineWidth = 2;

        this.canvas.addEventListener('mousedown', this.startDraw.bind(this));
        this.canvas.addEventListener('mousemove', this.draw.bind(this));
        this.canvas.addEventListener('mouseup', this.stopDraw.bind(this));
        this.canvas.addEventListener('mouseleave', this.stopDraw.bind(this));
    }

    startDraw(e) {
        this.isDrawing = true;
        this.ctx.beginPath();
        this.ctx.moveTo(e.offsetX, e.offsetY);
    }

    draw(e) {
        if (!this.isDrawing) return;
        this.ctx.lineTo(e.offsetX, e.offsetY);
        this.ctx.stroke();
    }

    stopDraw() {
        this.isDrawing = false;
    }

    clearSignature() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }

    handleIssuesChange(event) {
        this.issuesValue = event.detail.value;
    }

    async handleSubmit() {
        if (!this.issuesValue) {
            alert('Please select Yes/No.');
            return;
        }

        const dataURL = this.canvas.toDataURL('image/png');

        const blank = document.createElement('canvas');
        blank.width = this.canvas.width;
        blank.height = this.canvas.height;

        if (dataURL === blank.toDataURL()) {
            alert('Please sign before submitting.');
            return;
        }

        const signatureData = dataURL;

        this.isLoading = true;

        try {
            const recId = await saveNPP({
    issuesValue: this.issuesValue,
    signatureData: signatureData,

    weight: this.formData.Weight,
    employer: this.formData.Employer,
    jobTitle: this.formData.Job_Title,
    covidStatus: this.formData.Covid_Vaccination_Status,
    chiefComplaint: this.formData.Chief_Complaint,
    currentMedicationsStatus: this.formData.Current_Medications_Status,
    currentMedicationsText: this.formData.Current_Medications_Text,
    yearValue: this.formData.Year,
    painStart: this.formData.Pain_Start,
    feet: this.formData.Height_Feet,
    inches: this.formData.Height_Inches,
    painLevel: this.formData.Pain_Level,
    onsetOfPain: this.formData.Onset_Of_Pain,
    additionalPainComplaints: this.formData.Additional_Pain_Complaints,
    medicalDoctorConsultation: this.formData.Medical_Doctor_Consultation,
    doctorsName: this.formData.Doctors_Name,
    Account:this.recordId
});

            alert('Record created successfully! ID: ' + recId);

            this.clearSignature();
            this.issuesValue = '';

        } catch (err) {
            console.error(JSON.stringify(err));
            alert('Error: ' + (err?.body?.message || err?.message || JSON.stringify(err)));
        }

        this.isLoading = false;
    }


@track formData = {
        Weight: "",
        Employer: "",
        Job_Title: "",
        Covid_Vaccination_Status: "",
        Chief_Complaint: "",
        Current_Medications_Status: "",
        Current_Medications_Text: "",
        Year: "",
        Pain_Start: "",
        Height_Feet: "",
        Height_Inches: "",
        Pain_Level: "",
        Onset_Of_Pain: "",
        Additional_Pain_Complaints: "",
        Medical_Doctor_Consultation: "",
        Doctors_Name: ""
    };

    @wire(getNppData, { accId: '$recordId' })
wiredNpp({ data, error }) {
    if (data) {
        this.formData = {
            Weight: data.HQ_Weight__c,
            Employer: data.HQ_Employer__c,
            Job_Title: data.HQ_Job_Title__c,
            Covid_Vaccination_Status: data.HQ_COVID_19_Vaccination_Status__c,
            Chief_Complaint: data.HQ_Chief_Complaint__c,
            Current_Medications_Status: data.HQ_Current_Medications__c,
            Current_Medications_Text: data.HQ_Current_Medications_If_YES__c,
            Year: data.Year__c,
            Pain_Start: data.Pain_Start__c,
            Height_Feet: data.HQ_Feet__c,
            Height_Inches: data.HQ_Inches__c,
            Pain_Level: data.HQ_Pain_Level_Numeric_Rating_Scale__c,
            Onset_Of_Pain: data.HQ_Onset_of_Pain__c,
            Additional_Pain_Complaints: data.HQ_Additional_Pain_Complaints__c,
            Medical_Doctor_Consultation: data.HQ_Medical_Doctor_Consultation__c,
            Doctors_Name: data.HQ_Doctor_s_Name__c
        };

        // Pre-fill dependent fields like issuesValue etc
        this.issuesValue = data.HQ_Any_issues_or_concerns_with_immune__c;
    }

    if (error) {
        console.error('Error loading NPP data', error);
    }
}

    // Universal handler
    handleChange(event) {
        this.formData[event.target.name] = event.target.value;
        console.log('Updated Data => ', JSON.stringify(this.formData));
    }

    // Picklist options
    covidOptions = [
        { label: '--None--', value: '' },
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];

    medicationOptions = [
        { label: '--None--', value: '' },
        { label: 'Yes', value: 'Yes' },
        { label: 'No current medications', value: 'No current medications' }
    ];

    painLevelOptions = Array.from({ length: 10 }, (_, i) => ({
        label: `${i + 1}`,
        value: `${i + 1}`
    }));

    onsetOptions = [
        { label: '--None--', value: '' },
        { label: '1-3 Months', value: '1-3 Months' },
        { label: '4-6 Months', value: '4-6 Months' }
    ];

    yesNoOptions = [
        { label: '--None--', value: '' },
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];

}