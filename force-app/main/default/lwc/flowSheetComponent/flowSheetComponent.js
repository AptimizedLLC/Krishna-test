import { LightningElement,track ,api, wire} from 'lwc';
import { getObjectInfo, getPicklistValues} from 'lightning/uiObjectInfoApi';
import { createRecord,updateRecord ,getRecord} from 'lightning/uiRecordApi';
import flowSheetObject from '@salesforce/schema/Flowhsheet__c';
import exercise1 from '@salesforce/schema/Flowhsheet__c.Exercise_1__c';
import exercise2 from '@salesforce/schema/Flowhsheet__c.Exercise_2__c';
import exercise3 from '@salesforce/schema/Flowhsheet__c.Exercise_3__c';
import exercise4 from '@salesforce/schema/Flowhsheet__c.Exercise_4__c';
import exercise5 from '@salesforce/schema/Flowhsheet__c.Exercise_5__c';
import exercise6 from '@salesforce/schema/Flowhsheet__c.Exercise_6__c';
import exercise7 from '@salesforce/schema/Flowhsheet__c.Exercise_7__c';
import exercise8 from '@salesforce/schema/Flowhsheet__c.Exercise_8__c';
import exercise9 from '@salesforce/schema/Flowhsheet__c.Exercise_9__c';
import exercise10 from '@salesforce/schema/Flowhsheet__c.Exercise_10__c';


import Code1 from '@salesforce/schema/Flowhsheet__c.Code_1__c';
import Code2 from '@salesforce/schema/Flowhsheet__c.Code_2__c';
import Code3 from '@salesforce/schema/Flowhsheet__c.Code_3__c';
import Code4 from '@salesforce/schema/Flowhsheet__c.Code_4__c';
import Code5 from '@salesforce/schema/Flowhsheet__c.Code_5__c';
import Code6 from '@salesforce/schema/Flowhsheet__c.Code_6__c';
import Code7 from '@salesforce/schema/Flowhsheet__c.Code_7__c';
import Code8 from '@salesforce/schema/Flowhsheet__c.Code_8__c';
import Code9 from '@salesforce/schema/Flowhsheet__c.Code_9__c';
import Code10 from '@salesforce/schema/Flowhsheet__c.Code_10__c';

import MinutesSpent1 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_1__c';
import MinutesSpent2 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_2__c';
import MinutesSpent3 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_3__c';
import MinutesSpent4 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_4__c';
import MinutesSpent5 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_5__c';
import MinutesSpent6 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_6__c';
import MinutesSpent7 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_7__c';
import MinutesSpent8 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_8__c';
import MinutesSpent9 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_9__c';
import MinutesSpent10 from '@salesforce/schema/Flowhsheet__c.Minutes_spent_10__c';
import UnitsSpentcalucation1 from '@salesforce/schema/Flowhsheet__c.Units_1__c';
import UnitsSpentcalucation2 from '@salesforce/schema/Flowhsheet__c.Units_2__c';
import UnitsSpentcalucation3 from '@salesforce/schema/Flowhsheet__c.Units_3__c';
import UnitsSpentcalucation4 from '@salesforce/schema/Flowhsheet__c.Units_4__c';
import UnitsSpentcalucation5 from '@salesforce/schema/Flowhsheet__c.Units_5__c';
import UnitsSpentcalucation6 from '@salesforce/schema/Flowhsheet__c.Units_6__c';
import UnitsSpentcalucation7 from '@salesforce/schema/Flowhsheet__c.Units_7__c';
import UnitsSpentcalucation8 from '@salesforce/schema/Flowhsheet__c.Units_8__c';
import UnitsSpentcalucation9 from '@salesforce/schema/Flowhsheet__c.Units_9__c';
import UnitsSpentcalucation10 from '@salesforce/schema/Flowhsheet__c.Units_10__c';

import otherExercisesUnits1 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits1__c';
import otherExercises1 from '@salesforce/schema/Flowhsheet__c.OtherExercises1__c';

import otherExercisesUnits2 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits2__c';
import otherExercises2 from '@salesforce/schema/Flowhsheet__c.OtherExercises2__c';

import otherExercisesUnits3 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits3__c';
import otherExercises3 from '@salesforce/schema/Flowhsheet__c.OtherExercises3__c';

import otherExercisesUnits4 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits4__c';
import otherExercises4 from '@salesforce/schema/Flowhsheet__c.OtherExercises4__c';

import otherExercisesUnits5 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits5__c';
import otherExercises5 from '@salesforce/schema/Flowhsheet__c.OtherExercises5__c';

import otherExercisesUnits6 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits6__c';
import otherExercises6 from '@salesforce/schema/Flowhsheet__c.OtherExercises6__c';

import otherExercisesUnits7 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits7__c';
import otherExercises7 from '@salesforce/schema/Flowhsheet__c.OtherExercises7__c';

import otherExercisesUnits8 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits8__c';
import otherExercises8 from '@salesforce/schema/Flowhsheet__c.OtherExercises8__c';

import otherExercisesUnits9 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits9__c';
import otherExercises9 from '@salesforce/schema/Flowhsheet__c.OtherExercises9__c';

import otherExercisesUnits10 from '@salesforce/schema/Flowhsheet__c.OtherExercisesUnits10__c';
import otherExercises10 from '@salesforce/schema/Flowhsheet__c.OtherExercises10__c';

import MinutesTotal1 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_1__c';
import MinutesTotal2 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_2__c';
import MinutesTotal3 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_3__c';
import MinutesTotal4 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_4__c';
import MinutesTotal5 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_5__c';
import MinutesTotal6 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_6__c';
import MinutesTotal7 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_7__c';
import MinutesTotal8 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_8__c';
import MinutesTotal9 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_9__c';
import MinutesTotal10 from '@salesforce/schema/Flowhsheet__c.Minutes_Total_10__c';

import UnitsTotal1 from '@salesforce/schema/Flowhsheet__c.Units_Total_1__c';
import UnitsTotal2 from '@salesforce/schema/Flowhsheet__c.Units_Total_2__c';
import UnitsTotal3 from '@salesforce/schema/Flowhsheet__c.Units_Total_3__c';
import UnitsTotal4 from '@salesforce/schema/Flowhsheet__c.Units_Total_4__c';

import UnitsTotal5 from '@salesforce/schema/Flowhsheet__c.Units_Total_5__c';
import UnitsTotal6 from '@salesforce/schema/Flowhsheet__c.Units_Total_6__c';
import UnitsTotal7 from '@salesforce/schema/Flowhsheet__c.Units_Total_7__c';

import UnitsTotal8 from '@salesforce/schema/Flowhsheet__c.Units_Total_8__c';
import UnitsTotal9 from '@salesforce/schema/Flowhsheet__c.Units_Total_9__c';
import UnitsTotal10 from '@salesforce/schema/Flowhsheet__c.Units_Total_10__c';

import Total_Units from '@salesforce/schema/Flowhsheet__c.Total_Units__c';

import Appointment from '@salesforce/schema/Flowhsheet__c.Appointment__c';


import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
//import { CloseActionScreenEvent } from "lightning/actions";

import ApprovalController from '@salesforce/apex/ApprovalController.submitForApproval';
import patientNameVisitReason from '@salesforce/apex/ApprovalController.patientNameVisitReason';
import last3Appointments from '@salesforce/apex/ApprovalController.last3Appointments';
import updateFlowsheets from '@salesforce/apex/ApprovalController.updateFlowsheets';
import returnLatestAppFsRecord from '@salesforce/apex/ApprovalController.returnLatestAppFsRecord';
import providerData from '@salesforce/apex/ApprovalController.providerData';
import lightningModalLWC from 'c/myCheckComponent';
import chiroAlertComponent from 'c/chiroAlertComponent';
import { refreshApex } from '@salesforce/apex';


const VISIT_REASON_FIELD = 'Appointment__c.Visit_Reason__c';
// List of keywords for Visit Reason to filter by 
const FILTER_KEYWORDS = ['CHIRO', 'ESTABLISHED 1 YEAR CMO F/U', 'OT -', 'PT -', 'NEW YEAR EVALUATION'];
const FIELDS1 = ['Flowhsheet__c.Patient__r.Name','Appointment__c.Visit_Reason__c'];

const FIELDS = [
    'Flowhsheet__c.Exercise_1__c','Flowhsheet__c.Exercise_2__c','Flowhsheet__c.Exercise_3__c','Flowhsheet__c.Exercise_4__c','Flowhsheet__c.Exercise_5__c',
    'Flowhsheet__c.Exercise_6__c','Flowhsheet__c.Exercise_7__c','Flowhsheet__c.Exercise_8__c','Flowhsheet__c.Exercise_9__c','Flowhsheet__c.Exercise_10__c',
     
    'Flowhsheet__c.Code_1__c','Flowhsheet__c.Code_2__c','Flowhsheet__c.Code_3__c','Flowhsheet__c.Code_4__c','Flowhsheet__c.Code_5__c',
    'Flowhsheet__c.Code_6__c','Flowhsheet__c.Code_7__c','Flowhsheet__c.Code_8__c','Flowhsheet__c.Code_9__c','Flowhsheet__c.Code_10__c',
    
    'Flowhsheet__c.Minutes_spent_1__c','Flowhsheet__c.Minutes_spent_2__c','Flowhsheet__c.Minutes_spent_3__c','Flowhsheet__c.Minutes_spent_4__c','Flowhsheet__c.Minutes_spent_5__c',
    'Flowhsheet__c.Minutes_spent_6__c','Flowhsheet__c.Minutes_spent_7__c','Flowhsheet__c.Minutes_spent_8__c','Flowhsheet__c.Minutes_spent_9__c','Flowhsheet__c.Minutes_spent_10__c','Flowhsheet__c.OtherExercises1__c'
    ,'Flowhsheet__c.OtherExercises2__c','Flowhsheet__c.OtherExercises3__c','Flowhsheet__c.OtherExercises4__c','Flowhsheet__c.OtherExercises5__c','Flowhsheet__c.OtherExercises6__c','Flowhsheet__c.OtherExercises7__c'
    ,'Flowhsheet__c.OtherExercises8__c','Flowhsheet__c.OtherExercises9__c','Flowhsheet__c.OtherExercises10__c'
    
    
    ];

export default class FlowSheetComponent extends LightningElement {
//--------------------------------------------------------------

@track handleChangeOtherForOtherExercises5Flag=true;
@track handleChangeOtherForOtherExercises6Flag=true;
@track handleChangeOtherForOtherExercises3Flag=true;
@track handleChangeOtherForOtherExercises4Flag=true;


@track  updateCheck=true;
showModal = true;
    @track result;
    async handleShowModal() {
        const data = `You should clear previous sessions and begin new only if your patient is returning for a new set of PT/OT appointments where the previous set of appointments no longer apply.
        If you clear the previous flowsheet entries, they will be stored in the backend for reporting purposes, but you will NOT be able to pull them back into this screen when entering new flowsheets.
        If you mistakenly clear flowsheets, you will need to start fresh to track the progressions through future appointments.`;
        this.showTable=false;
        try{
         this.result = await lightningModalLWC.open({
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: data,
            headerText:'Clear Previous Sessions and Begin New'
        });
        if (this.result == 'Cancel') {
            console.log('User clicked Cancel');
        } else if (this.result == 'Yes, begin a new set of flowsheet entries for this patient') {
            console.log('User clicked Yes, begin a new set of flowsheet entries for this patient');
            this.updateFlowsheets();
            this.refreshFlowsheetRecords();
        }    }catch(error) {
        console.error('Error opening modal:', error);
    }
    }
//--------------------------------------------------------------
    

   
     
//----------------------------------------------------------------
@track chiroFlag = true;
@track result1;
async handleShowModal2() {
    console.log('entered');
    
    const data ='Please Select CPT code for Chiro if needed or Ignore'
    try{
        this.result1 = await chiroAlertComponent.open({
           size: 'large',
           description: 'Accessible description of modal\'s purpose',
           content1: data,
           headerText1:'CPT Code for Chiro is Not Selected'
       });
       if (this.result1 == 'Cancel') {
        console.log('User clicked Cancel');
    } if (this.result1 == 'IgnoreChiro') {
        this.chiroFlag =false;
        console.log('User clicked Cancel');
    } 
}catch(error) {
    console.error('Error opening modal:', error);
}
}

get chiroDataFlag() { 
   
    return !this.formfield?.checkbox5 && !this.formfield?.checkbox6;
}



//-----------------------------------------------------------------
joinStrings(string1, string2) {
    return `${string1};${string2}`;
}
//--------------------------connectedCallback()

connectedCallback(){
    if (this.recordId) {
        this.fetchPatientInfo();

    }
}
renderedCallback() {
    if (!this._hasRendered && this.recordId) {
        this._hasRendered = true;
        this.fetchPatientInfo();
        console.log('recordId is now available in renderedCallback:', this.recordId);
        // If you need to do anything once with recordId, do it here
    }
}

//------------------------------



@api recordId;
@track flowsheetRecords;
@track error;
@track wiredResult; // Store the wire result for refreshing
@track showTable=false;
_hasRendered = false;



//-----------get Account name--------------------------------------
@track PatientName;
    @track visitReason;  // Used for filtering logic
    @track visitReasonFull; // NEW Variable for UI display

    /*
@wire(getRecord,{recordId: '$recordId', fields: FIELDS1 })
flowSheetPatientName({ error, data }){
if (data ) {
    console.log( 'Patient Name '+JSON.stringify(data.fields));
    const visitReasondata = data.fields.Visit_Reason__c?.value;
    this.PatientName=data.fields.Patient__r.displayValue;

    
     // Ensure visitReasondata is a non-empty string before calling includes()
     if (visitReasondata && typeof visitReasondata === 'string') {
        // Find the first keyword that exists in visitReasondata
        const matchingKeyword = FILTER_KEYWORDS.find(keyword => visitReasondata.includes(keyword));

        // Set visitReason to the matching keyword, or show a default message if no match is found
        this.visitReason = matchingKeyword ? matchingKeyword : 'No relevant visit reason';
    } else {
        this.visitReason = 'No visit reason available';
    }
     // Store FULL Visit Reason separately for UI display
     this.visitReasonFull = visitReasondata ? visitReasondata.toString() : 'No visit reason available';
}
}*/

//---------------------imperative methode------------------------
fetchPatientInfo() {
    if (!this.recordId) {
        console.warn('No recordId provided');
        return;
    }

    patientNameVisitReason({ recordId: this.recordId })
        .then(result => {
            console.log('Apex result:', result);

            const visitReasondata = result.Visit_Reason__c;
            this.PatientName = result.Patient__r?.Name;

            if (visitReasondata && typeof visitReasondata === 'string') {
                // Find the first keyword that exists in visitReasondata
                const matchingKeyword = FILTER_KEYWORDS.find(keyword => visitReasondata.includes(keyword));
        
                // Set visitReason to the matching keyword, or show a default message if no match is found
                this.visitReason = matchingKeyword ? matchingKeyword : 'No relevant visit reason';
            } else {
                this.visitReason = 'No visit reason available';
            }

            this.visitReasonFull = visitReasondata
                ? visitReasondata.toString()
                : 'No visit reason available';
        })
        .catch(error => {
            console.error('Error in Apex call:', error);
        });
    }

get flowsheetRecordsDataFlag() { 
   
    return Array.isArray(this.flowsheetRecords) && this.flowsheetRecords.length == 0; 
}

get flowsheetRecordsDataFlag2() {
    
    return Array.isArray(this.flowsheetRecords) && this.flowsheetRecords.length !== 0;
}

@track sessionValue=3;

sessionValueHandler(event){
    this.sessionValue=event.target.value;
}

checkForOther(items) {
    console.log('class value entered');
    if (items.includes("Other")) {
return 'bullet-item';
}
}

@wire(ApprovalController, { recordId: '$recordId',countSize:'$sessionValue',visitReason:'$visitReason' })
wiredContacts(result) {
    this.flowsheetRecords = null; // Store the wire result
    const { error, data } = result;

    if (data) {
        console.log('flowsheetRecords are'+JSON.stringify(data));
        console.log('***visitReason are',this.visitReason);
        this.showTable=true;
        this.flowsheetRecords = data.map(record => ({
            ...record,
           // AppointmentDate: record.Appointment__c ? record.Appointment__r.Appointment_Date__c : 'NA',
           AppointmentDate1: record.appointmentDate? record.appointmentDate:'Empty',
           AppointementVisitReason1:record.visitReason?record.visitReason:'Empty',
           // AppointementVisitReason:record.Appointment__c ? record.Appointment__r.Visit_Reason__c : 'NA',
            Minutes_spent_1__c: this.splitTextBySemicolon(record.Minutes_spent_1__c),
            Units_1__c: this.splitTextBySemicolon(record.Units_1__c),
            

            Minutes_spent_2__c: this.splitTextBySemicolon(record.Minutes_spent_2__c),
            Minutes_spent_3__c: this.splitTextBySemicolon(record.Minutes_spent_3__c),
            Minutes_spent_4__c: this.splitTextBySemicolon(record.Minutes_spent_4__c),
            Minutes_spent_5__c: this.splitTextBySemicolon(record.Minutes_spent_5__c),

            Minutes_spent_6__c: this.splitTextBySemicolon(record.Minutes_spent_6__c),
            Minutes_spent_7__c: this.splitTextBySemicolon(record.Minutes_spent_7__c),
            Minutes_spent_8__c: this.splitTextBySemicolon(record.Minutes_spent_8__c),
            Minutes_spent_9__c: this.splitTextBySemicolon(record.Minutes_spent_9__c),
            Minutes_spent_10__c: this.splitTextBySemicolon(record.Minutes_spent_10__c),

            OtherExercises1__c: this.splitTextBySemicolon(record.OtherExercises1__c),
            //-------------------------yyyy
            otherExercises1: this.splitTextBySemicolon(record.otherExercises1),
            otherExercises2: this.splitTextBySemicolon(record.otherExercises2),
            otherExercises3: this.splitTextBySemicolon(record.otherExercises3),
            otherExercises4: this.splitTextBySemicolon(record.otherExercises4),
            otherExercises5: this.splitTextBySemicolon(record.otherExercises5),
            otherExercises6: this.splitTextBySemicolon(record.otherExercises6),
            otherExercises7: this.splitTextBySemicolon(record.otherExercises7),
            otherExercises8: this.splitTextBySemicolon(record.otherExercises8),
            otherExercises9: this.splitTextBySemicolon(record.otherExercises9),
            otherExercises10: this.splitTextBySemicolon(record.otherExercises10),

            //--------------------------

            OtherExercises2__c: this.splitTextBySemicolon(record.OtherExercises2__c),
            OtherExercises3__c: this.splitTextBySemicolon(record.OtherExercises3__c),
            OtherExercises4__c: this.splitTextBySemicolon(record.OtherExercises4__c),
            OtherExercises5__c: this.splitTextBySemicolon(record.OtherExercises5__c),
            OtherExercises6__c: this.splitTextBySemicolon(record.OtherExercises6__c),
            OtherExercises7__c: this.splitTextBySemicolon(record.OtherExercises7__c),
            OtherExercises8__c: this.splitTextBySemicolon(record.OtherExercises8__c),
            OtherExercises9__c: this.splitTextBySemicolon(record.OtherExercises9__c),
            OtherExercises10__c: this.splitTextBySemicolon(record.OtherExercises10__c), 


        }));
        this.error = undefined;
        console.log('Data values:', data);
        console.log('Flow record values:', this.flowsheetRecords);
    } else if (error) {
        this.error = error;
        this.flowsheetRecords = undefined;
        console.error(error);
    }
}

// Helper function to split text by semicolon
splitTextBySemicolon(text) {
    return text ? text.split(';') : [];
}
splitTextBySemicolon2(text1, text2) {
    const sanitize = (text) => text?.replace(/\s+/g, ' ').trim(); // Remove excessive whitespace
    const a = sanitize(text1) ? sanitize(text1).split(';') : [];
    const b = sanitize(text2) ? sanitize(text2).split(';') : [];
    return [...a, ...b].join(';'); // Combine and join with semicolons
}

// Method to manually refresh the data
async refreshFlowsheetRecords() {
    try {
        await refreshApex(this.flowsheetRecords );//this.wiredResult);
        this.flowsheetRecords = [...this.flowsheetRecords];
        console.log('Flowsheet records refreshed');
        this.showTable=false;
    } catch (error) {
        console.error('Error refreshing flowsheet records:', error);
    }
}


//----------------------------------------------------------------
@track isCheckArray = {
    isChecked: true,
    isChecked2: true,
    isChecked3: true,
    isChecked4: true,
    isChecked5: true,
    isChecked6: true,
    isChecked7: true,
    isChecked8: true,
    isChecked9: true,
    isChecked10: true
};
//--------------------------------
@track exerciseMap={
    TePt:true,
    TeOt:true,
    NMRPt:true,
    NMROt:true,
    PPTOt:true,
    PPTPt:true
};

handleexerciseMap(event) {
    const { value, checked } = event.target;
    this.exerciseMap[value] = checked;
    console.log(this.exerciseMap[value]);
}
//--------------------------------


// Handler for checkbox change
handleCheckboxValue(event) {
    const checkboxId = event.target.name;

    // Check if the id exists in the isCheckArray and update its value
    if (this.isCheckArray.hasOwnProperty(checkboxId)) {
        this.isCheckArray[checkboxId] = event.target.checked;
    }
}
//---------------------------------------------------------------


   
    @track cptFlag=true;
    @track ExcerciseFlag=false;
    @track ApprovalFlag=false;

    @track status='not runned';
    @track DiagnosisData='';
    @track CptClass="slds-button slds-button_brand";
    @track ExcerciseClass="slds-button slds-button_neutral";
    @track SubmitClass="slds-button slds-button_neutral";

    DiagnosisDataChangeHandler(event){
        this.DiagnosisData=event.target.value;
        console.log('DiagnosisData valu',this.DiagnosisData);
    }
    
    //----------------------------------------------------------------------c/errorLogMonitoring
    @track  formfield={
        checkbox1:false,
        checkbox2:false,
        checkbox3:false,
        checkbox4:false,
        checkbox5:false,
        checkbox6:false,
        checkbox7:false,
        checkbox8:false,
        checkbox9:false,
        checkbox10:false,        
        Excercise1:'',
        Excercise2:'',
        Excercise3:'',
        Excercise4:'',
        Excercise5:'',
        Excercise6:'',
        Excercise7:'',
        Excercise8:'',
        Excercise9:'',
        Excercise10:'',
        minutesSpent1:'',
        othersMin01:'',
        minutesSpent2:'',
        othersMin02:'',
        minutesSpent3:'',
        othersMin03:'' ,
        minutesSpent4:'',
        othersMin04:'',
        minutesSpent5:'',
        othersMin05:'' ,
        minutesSpent6:'',
        othersMin06:'',
        minutesSpent7:'',
        othersMin07:'',
        minutesSpent8:'',
        othersMin08:'',
        minutesSpent9:'',
        othersMin09:'' ,
        minutesSpent10:'',
        othersMin010:'',
        totalUnits:'',
        others1:'',        
        others2:'',        
        others3:'',
        others4:'',
        others5:'',
        others6:'',
        others7:'',
        others8:'',
        others9:'',
        others10:'',

        Excercises1:'',
        Excercises2:'',
        Excercises3:'',
        Excercises4:'',
        Excercises5:'',
        Excercises6:'',
        Excercises7:'',
        Excercises8:'',
        Excercises9:'',
        Excercises10:''
        }
        //--------------------------------------------------------------------
        @track recentAppflowsheetId; // Holds the returned Flowsheet Id
      @track ActiveProviderNotAvailble;
         @wire(providerData, { recordId: '$recordId' })//'$visitReason'})visitReasonFull
    wiredFlowsheet2({ error, data }) {
        if (data ) {      
            console.log('**data-data',JSON.stringify(data));
            this.ActiveProviderNotAvailble=data;
            if(data==true){
                this.callError();
            }
        }if(error){
             console.log('**errordata-data',error);
            this.ActiveProviderNotAvailble=false;
            //this.callError();
        }
    }
    callError(){
        this.showToast('Error', 'Provider is incorrect', 'Error');
    }

        @wire(returnLatestAppFsRecord, { recordId: '$recordId',visitReason:'$visitReason' })//'$visitReason'})visitReasonFull
    wiredFlowsheet({ error, data }) {
        if (data ) {
        console.log('***data fields',JSON.stringify(data));
       console.log('***data fields',data.OtherExercises1__c);

        this.formfield.checkbox1 = data.Code_1__c;
        this.formfield.checkbox2 = data.Code_2__c;
        this.formfield.checkbox3 = data.Code_3__c;
        this.formfield.checkbox4 = data.Code_4__c;
        //this.formfield.checkbox5 = data.Code_5__c;
        this.formfield.checkbox6 = data.Code_6__c;
        //this.formfield.checkbox7 = data.Code_7__c;
        this.formfield.checkbox8 = data.Code_8__c;
        this.formfield.checkbox9 = data.Code_9__c;
        this.formfield.checkbox10 = data.Code_10__c;
         
        this.formfield.Excercises1 = data.Exercise_1__c;
        this.formfield.Excercises2 =  data.Exercise_2__c;
        this.formfield.Excercises3 =  data.Exercise_3__c;
        this.formfield.Excercises4 = data.Exercise_4__c;
        //this.formfield.Excercises5 =  data.Exercise_5__c;
        this.formfield.Excercises6 =  data.Exercise_6__c;
        //this.formfield.Excercises7 =  data.Exercise_7__c;
        this.formfield.Excercises8 =  data.Exercise_8__c;
        this.formfield.Excercises9 = data.Exercise_9__c;
        this.formfield.Excercises10 =  data.Exercise_10__c;
/*
        this.formfield.minutesSpent1 =data.fields.Minutes_spent_1__c.value;
        this.formfield.minutesSpent2 =data.fields.Minutes_spent_2__c.value;
        this.formfield.minutesSpent3 = data.fields.Minutes_spent_3__c.value;
        this.formfield.minutesSpent4 = data.fields.Minutes_spent_4__c.value;
        this.formfield.minutesSpent5 = data.fields.Minutes_spent_5__c.value;
        this.formfield.minutesSpent6 = data.fields.Minutes_spent_6__c.value;
        this.formfield.minutesSpent7 = data.fields.Minutes_spent_7__c.value;
        this.formfield.minutesSpent8 = data.fields.Minutes_spent_8__c.value;
        this.formfield.minutesSpent9 = data.fields.Minutes_spent_9__c.value;
        this.formfield.minutesSpent10 = data.fields.Minutes_spent_10__c.value;*/

        this.formfield.othersMin01 =data.OtherExercises1__c;
        this.formfield.othersMin02 =data.OtherExercises2__c;
        this.formfield.othersMin03 =data.OtherExercises3__c;
        this.formfield.othersMin04 =data.OtherExercises4__c;
        this.formfield.othersMin05 =data.OtherExercises5__c;
        this.formfield.othersMin06 =data.OtherExercises6__c;
        this.formfield.othersMin07 =data.OtherExercises7__c;
        this.formfield.othersMin08 =data.OtherExercises8__c;
        this.formfield.othersMin09 =data.OtherExercises9__c;
        this.formfield.othersMin010 =data.OtherExercises10__c;
        this.DiagnosisData = data.FSDiagnostics__c ?? '';

        this.formfield[`others1`] = this.getOtherExercises(data.OtherExercises1__c);
        //this.formfield[`others3`] = this.getOtherExercises(data.fields[`OtherExercises3__c`]?.value);
        console.log(this.getOtherExercises(data.OtherExercises1__c));

        // Process OtherExercises2 to OtherExercises10
            for (let i = 2; i <= 10; i++) {
                const fieldValue = data[`OtherExercises${i}__c`] ?? data.fields?.[`OtherExercises${i}__c`]?.value;
                this.formfield[`others${i}`] = this.getOtherExercises(fieldValue);
                console.log(this.getOtherExercises(fieldValue));
            }




        

        if(this.formfield !== null && this.updateCheck) {
            this.setcomboboxData();
            this.setcomboboxOtherData();
            this.updateCheck=false;
        }
        
        


}else if (error) {
    console.error('Error fetching record data:');
    this.formfield.othersMin03 ='Kinetisense-15 Minutes';
        this.formfield.othersMin04 ='See Daily Note-15 Minutes';
        this.formfield.othersMin05 ='Physical Performance Test-15 Minutes';
        this.formfield.othersMin06 ='Traction-15 Minutes';
        this.formfield.othersMin07 ='VALD-15 Minutes';
}
    }

    

    

        //-------------------------------------------------------------------
        
       /* @wire(getRecord,{recordId: '$recentAppflowsheetId', fields: FIELDS})
flowSheetData({ error, data }){
    if (data ) {
        console.log(data.fields);
        
        this.formfield.checkbox1 = data.fields.Code_1__c.value;
        this.formfield.checkbox2 = data.fields.Code_2__c.value;
        this.formfield.checkbox3 = data.fields.Code_3__c.value;
        this.formfield.checkbox4 = data.fields.Code_4__c.value;
        this.formfield.checkbox5 = data.fields.Code_5__c.value;
        this.formfield.checkbox6 = data.fields.Code_6__c.value;
        this.formfield.checkbox7 = data.fields.Code_7__c.value;
        this.formfield.checkbox8 = data.fields.Code_8__c.value;
        this.formfield.checkbox9 = data.fields.Code_9__c.value;
        this.formfield.checkbox10 = data.fields.Code_10__c.value;
        
        this.formfield.Excercise1 = data.fields.Exercise_1__c.displayValue || data.fields.Exercise_1__c.value;
        this.formfield.Excercise2 = data.fields.Exercise_2__c.displayValue || data.fields.Exercise_2__c.value;
        this.formfield.Excercise3 = data.fields.Exercise_3__c.displayValue || data.fields.Exercise_3__c.value;
        this.formfield.Excercise4 = data.fields.Exercise_4__c.displayValue || data.fields.Exercise_4__c.value;
        this.formfield.Excercise5 = data.fields.Exercise_5__c.displayValue || data.fields.Exercise_5__c.value;
        this.formfield.Excercise6 = data.fields.Exercise_6__c.displayValue || data.fields.Exercise_6__c.value;
        this.formfield.Excercise7 = data.fields.Exercise_7__c.displayValue || data.fields.Exercise_7__c.value;
        this.formfield.Excercise8 = data.fields.Exercise_8__c.displayValue || data.fields.Exercise_8__c.value;
        this.formfield.Excercise9 = data.fields.Exercise_9__c.displayValue || data.fields.Exercise_9__c.value;
        this.formfield.Excercise10 = data.fields.Exercise_10__c.displayValue || data.fields.Exercise_10__c.value;

        this.formfield.minutesSpent1 =data.fields.Minutes_spent_1__c.value;
        this.formfield.minutesSpent2 =data.fields.Minutes_spent_2__c.value;
        this.formfield.minutesSpent3 = data.fields.Minutes_spent_3__c.value;
        this.formfield.minutesSpent4 = data.fields.Minutes_spent_4__c.value;
        this.formfield.minutesSpent5 = data.fields.Minutes_spent_5__c.value;
        this.formfield.minutesSpent6 = data.fields.Minutes_spent_6__c.value;
        this.formfield.minutesSpent7 = data.fields.Minutes_spent_7__c.value;
        this.formfield.minutesSpent8 = data.fields.Minutes_spent_8__c.value;
        this.formfield.minutesSpent9 = data.fields.Minutes_spent_9__c.value;
        this.formfield.minutesSpent10 = data.fields.Minutes_spent_10__c.value;

        this.formfield.othersMin01 =data.fields.OtherExercises1__c.value;
        this.formfield.othersMin02 =data.fields.OtherExercises2__c.value;
        this.formfield.othersMin03 =data.fields.OtherExercises3__c.value;
        this.formfield.othersMin04 =data.fields.OtherExercises4__c.value;
        this.formfield.othersMin05 =data.fields.OtherExercises5__c.value;
        this.formfield.othersMin06 =data.fields.OtherExercises6__c.value;
        this.formfield.othersMin07 =data.fields.OtherExercises7__c.value;
        this.formfield.othersMin08 =data.fields.OtherExercises8__c.value;
        this.formfield.othersMin09 =data.fields.OtherExercises9__c.value;
        this.formfield.othersMin010 =data.fields.OtherExercises10__c.value;

        this.formfield[`others1`] = this.getOtherExercises(data.fields[`OtherExercises1__c`]?.value);
        //this.formfield[`others3`] = this.getOtherExercises(data.fields[`OtherExercises3__c`]?.value);
        console.log(this.getOtherExercises(data.fields[`OtherExercises1__c`]?.value));

        // Process other exercises using getOtherExercises function
        for (let i = 2; i <= 10; i++) {
            this.formfield[`others${i}`] = this.getOtherExercises(data.fields[`OtherExercises${i}__c`]?.value);
            console.log(this.getOtherExercises(data.fields[`OtherExercises${i}__c`]?.value));
        }




        
        console.log('form field values are here:'+this.formfield.Excercise1);

        if(this.formfield !== null && this.updateCheck) {
            this.setcomboboxData();
            this.setcomboboxOtherData();
            this.updateCheck=false;
        }
        
        


}else if (error) {
    console.error('Error fetching record data:');
}

}*/
//----------------------------------------------------------------------------

//----------------------get Other exercises----c/editFlowsheetComponent
/*
getOtherExercises(string) {
    // Check if the string is not null and not empty
    if (string != null && string !== '') {
        // Split the string by semicolons to get individual segments
        let segments = string.split(';');

        // Extract the keys (the part before the hyphen)
        let other = segments.map(segment => segment.split('-')[0]);

        // Join the result into a semicolon-separated string
        return other.join(';');
    } else {
        // Return an empty string if input is null or empty
        return '';
    }
}*/

getOtherExercises(string) {
    // Check if the string is not null and not empty
    if (string != null && string.trim() !== '') {
        // Split the string by semicolons to get individual segments
        let segments = string.split(';').filter(segment => segment.trim() !== '');

        // Extract the part before the last hyphen in each segment
        let other = segments.map(segment => {
            const trimmedSegment = segment.trim();
            const lastDashIndex = trimmedSegment.lastIndexOf('-');
            return lastDashIndex !== -1
                ? trimmedSegment.substring(0, lastDashIndex).trim()
                : trimmedSegment;
        });

        // Join the result into a semicolon-separated string
        return other.join(';');
    } else {
        // Return an empty string if input is null or empty
        return '';
    }
}





//------------------------------------------------------c/editFlowsheetComponent
@track comboboxData1 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData2 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData3 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData4 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData5 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData6 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData7 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData8 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData9 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];
@track comboboxData10 = [{ id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}];


@track comboboxOtherData1 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false,Chiro:false}   ];
@track comboboxOtherData2 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:false,Ot:true}   ];
@track comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData4 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData5 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData6 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData7 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData8 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
@track comboboxOtherData9 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:true}   ];
@track comboboxOtherData10 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:true}   ];






// Dynamically populate comboboxData arrays
setcomboboxData() {
    if(this.updateCheck){
    // Loop through 5 sets of exercises and minutes (adjust if necessary)
    for (let i = 1; i <= 10; i++) {
        // Check if the exercise and minutes fields are not null or undefined
        const exerciseField = this.formfield[`Excercise${i}`];
        const minutesField = this.formfield[`minutesSpent${i}`];
    
        if (exerciseField && minutesField) {
            // If the fields are not null, split the values
            //const exercises = exerciseField.split(';');
            const minutes = minutesField.split(';');
            const exercises = minutes.map(item => item.split('-')[0].trim());
    
            let comboboxArray = this[`comboboxData${i}`];
            comboboxArray.length = 0; // Clear previous data
    
            exercises.forEach((exercise, index) => {
                let exerciseData = exercise.trim();
                let minuteData = minutes[index] ? minutes[index].match(/-(\d+)/)[1] : ''; // Extract minutes
    
                comboboxArray.push({
                    id: index + 1,
                    label: `Exercise ${index + 1}`,
                    value: exerciseData,
                    Min: minuteData,
                    showDelete: true
                });
            });
        }
    }
}
    
}

//------------------------------------------------------------------------------------------
// Dynamically populate comboboxData arrays
/*
setcomboboxOtherData() {
    // Loop through 5 sets of exercises and minutes (adjust if necessary)
    for (let i = 1; i <= 10; i++) {
        // Check if the exercise and minutes fields are not null or undefined
        const exerciseField = this.formfield[`others${i}`];
        const minutesField = this.formfield[`othersMin0${i}`];
    
        if (exerciseField && minutesField) {
            // If the fields are not null, split the values
            const exercises = exerciseField.split(';');
            const minutes = minutesField.split(';');
    
            let comboboxOtherArray = this[`comboboxOtherData${i}`];
            comboboxOtherArray.length = 0; // Clear previous data
    
            exercises.forEach((exercise, index) => {
                let exerciseData = exercise.trim();
                let minuteData = minutes[index] ? minutes[index].match(/-(\d+)/)[1] : ''; // Extract minutes
    
                comboboxOtherArray.push({
                    id: index + 1,
                    label: `Other  ${index + 1}`,
                    value: exerciseData,
                    Min: minuteData,
                    showDelete: true,
                    Pt:true,
                    Ot:true
                });
            });
        }
    }
    
}
setcomboboxOtherData() {
    // Loop through 10 sets of exercises and minutes
    for (let i = 1; i <= 10; i++) {
        const exerciseField = this.formfield[`others${i}`];
        const minutesField = this.formfield[`othersMin0${i}`];

        if (exerciseField && minutesField) {
            const exercises = exerciseField.split(';').filter(e => e.trim() !== '');
            const minutes = minutesField.split(';').filter(m => m.trim() !== '');

            let comboboxOtherArray = this[`comboboxOtherData${i}`];
            comboboxOtherArray.length = 0; // Clear existing data

            exercises.forEach((exercise, index) => {
                const trimmedExercise = exercise.trim();

                const rawMinute = minutes[index] || '';
                const matches = rawMinute.match(/\d+/g); // extract all numbers
                const minuteData = matches && matches.length > 0 ? matches[matches.length - 1] : '';

                comboboxOtherArray.push({
                    id: index + 1,
                    label: `Other ${index + 1}`,
                    value: trimmedExercise, // Use full name
                    Min: minuteData,
                    showDelete: true,
                    Pt:true,
                    Ot:true,
                    Chiro:true
                });
            });
        }
    }
}*/
/*
setcomboboxOtherData() {
    // Loop through 10 sets of exercises and minutes
    for (let i = 1; i <= 10; i++) {
        const exerciseField = this.formfield[`others${i}`];
        const minutesField = this.formfield[`othersMin0${i}`];
        const PtOtChiroValues=this.formfield[`Excercise${i}`];

        if (exerciseField && minutesField) {
            const exercises = exerciseField.split(';').filter(e => e.trim() !== '');
            const minutes = minutesField.split(';').filter(m => m.trim() !== '');

            let comboboxOtherArray = this[`comboboxOtherData${i}`];
            comboboxOtherArray.length = 0; // Clear existing data

            exercises.forEach((exercise, index) => {
                const trimmedExercise = exercise.trim();
                const rawMinute = minutes[index] || '';
                const matches = rawMinute.match(/\d+/g); // extract all numbers
                const minuteData = matches && matches.length > 0 ? matches[matches.length - 1] : '';

                // Set defaults
                let Pt = true, Ot = false, Chiro = false;

                // Override for i = 2
                if (i === 2) {
                    Pt = false;
                    Ot = true;
                    Chiro = false;
                }

                comboboxOtherArray.push({
                    id: index + 1,
                    label: `Other ${index + 1}`,
                    value: trimmedExercise,
                    Min: minuteData,
                    showDelete: true,
                    Pt,
                    Ot,
                    Chiro
                });
            });
        }
    }
}*/
setcomboboxOtherData() {
    // Loop through 10 sets of exercises and minutes
    for (let i = 1; i <= 10; i++) {
        const exerciseField = this.formfield[`others${i}`];
        const minutesField = this.formfield[`othersMin0${i}`];
        const ptOtChiroField = this.formfield[`Excercises${i}`];

        if (exerciseField && minutesField && ptOtChiroField) {
            const exercises = exerciseField.split(';').filter(e => e.trim() !== '');
            const minutes = minutesField.split(';').filter(m => m.trim() !== '');
            const ptOtChiroValues = ptOtChiroField.split(';').map(v => v.trim().toUpperCase());

            let comboboxOtherArray = this[`comboboxOtherData${i}`];
            comboboxOtherArray.length = 0; // Clear existing data

            exercises.forEach((exercise, index) => {
                const trimmedExercise = exercise.trim();
                const rawMinute = minutes[index] || '';
                const matches = rawMinute.match(/\d+/g); // extract all numbers
                const minuteData = matches && matches.length > 0 ? matches[matches.length - 1] : '';

                const type = ptOtChiroValues[index] || '';
                let Pt = false, Ot = false, Chiro = false;

                if (type === 'PT') {
                    Pt = true;
                } else if (type === 'OT') {
                    Ot = true;
                } else if (type === 'CHIRO') {
                    Chiro = true;
                }else{
                    Pt = true; // default fallback
                }

                comboboxOtherArray.push({
                    id: index + 1,
                    label: `Other ${index + 1}`,
                    value: trimmedExercise,
                    Min: minuteData,
                    showDelete: true,
                    Pt,
                    Ot,
                    Chiro
                });
            });
        }
    }
}


//-------------------------------------------------------------------------------------------


        //---------------------------------------------------------------------
       // Function to calculate the class based on formattedKey
    get itemsWithClass() {
        return this.nonEmptyMinutesSpent.map(item => {
            // Calculate the class based on formattedKey
            let className = this.checkForOther(item.formattedKey);
            return {
                ...item,
                className: className
            };
        });
    }

    // Check if formattedKey contains 'Other' and return the class
    checkForOther(formattedKey) {
        if (formattedKey.includes("Other")) {
            return 'bullet-item'; // Class for keys containing 'Other'
        } else {
            return ''; // Default class
        }
    }



        //---------------------------------------------------------------

        get nonEmptyMinutesSpent() {
            return Object.entries(this.formfield)
            .filter(([key, value]) => 
                (key.startsWith('minutesSpent') || key.startsWith('othersMin')) && 
                (typeof value === 'string' ? value.trim() !== '' : value !== null && value !== undefined)
            )                
            .map(([key, value]) => {
                    // Extract the number from the key and format it as 'CPT Code X'
                    const index = key.replace('minutesSpent', '').replace('othersMin', '');
                                // Map the number to the desired formattedKey value
            let formattedKey;
            switch (index) {
                case '1':
                    formattedKey = '97110(Therapeutic exercises)'
                    ;
                    break;
                case '2':
                    formattedKey = '97530(Therapeutic activities)'
                    ;
                    break;
                case '3':
                    formattedKey = '97112(Neuromuscular re-education)'
                    ;
                    break;
                case '4':
                    formattedKey = '97140(Manual therapy techniques)'
                    ;
                    break;
                case '5':
                    formattedKey = '97750(Physical Performance Test)'
                    ;
                    break;
                case '6':
                    formattedKey = '97012(Traction)'
                    ;
                    break;
                case '7':
                    formattedKey = '90901(Biofeedback)'
                    ;
                    break;
                case '8':
                    formattedKey ='97016(Normatec/GameReady)'
                    ;
                    break;
                case '9':
                    formattedKey = '97014/G0283(Premod ES w/ MH or Ice)'
                    ;
                    break;
                case '10':
                    formattedKey = '9039/S8948(Laser Therapy)'
                    ;
                    break;
                case '01':
                        formattedKey = 'Therapeutic Exercises(97110)';
                        break;

                        case '02':
                            formattedKey = 'Therapeutic Activities(97530)';
                            break;

                            case '03':
                                formattedKey = 'Neuromuscular Re-Education(97112)';
                                break;

                                case '04':
                                    formattedKey = 'Manual Therapy Techniques(97140)';
                                    break;

                                    case '05':
                                        formattedKey = 'Physical Performance Test(99750)';
                                        break;

                                        case '06':
                                            formattedKey = 'Traction(97012)';
                                            break;
                    
                                            case '07':
                                                formattedKey = 'Other exercises(90901)';
                                                break;
                    
                                                case '08':
                                                    formattedKey = 'Other exercises(97016)';
                                                    break;
                    
                                                    case '09':
                                                        formattedKey = 'Other exercises(97014/G0283)';
                                                        break;
                    
                                                        case '010':
                                                            formattedKey = 'Other exercises(9039/S8948)';
                                                            break;

                                
                
                default:
                    formattedKey = `Exercise`;
            }



                    return { formattedKey, value };
                });
                //this.itemsWithClass();
        }

 get ptItemsFormattedArray() {
    return [
        { label: 'Therapeutic Exercises(97110):', value: this.formfield.checkbox1 ? this.getPtItemsFormatted(this.comboboxOtherData1) || 0 : 0 },
        { label: 'Therapeutic Activities(97530):', value: this.formfield.checkbox2 ? this.getPtItemsFormatted(this.comboboxOtherData2) || 0 : 0  },
        { label: 'Neuromuscular Re-Education(97112):', value: this.formfield.checkbox3 ? this.getPtItemsFormatted(this.comboboxOtherData3) || 0 : 0  },
        { label: 'Manual Therapy Techniques(97140):', value: this.formfield.checkbox4 ? this.getPtItemsFormatted(this.comboboxOtherData4) || 0 : 0  },
        { label: 'Physical Performance Test(97750):', value: this.formfield.checkbox5 ? this.getPtItemsFormatted(this.comboboxOtherData5) || 0 : 0  },
        { label: 'Traction(97012):', value: this.formfield.checkbox6 ? this.getPtItemsFormatted(this.comboboxOtherData6) || 0 : 0  },
        { label: 'Range of Motion Testing(95851):', value: this.formfield.checkbox7 ? this.getPtItemsFormatted(this.comboboxOtherData7) || 0 : 0  }
    ];
}

get OtItemsFormattedArray() {
    return [
        { label:  'Therapeutic Exercises(97110):', value: this.formfield.checkbox1 ? this.getOtItemsFormatted(this.comboboxOtherData1) || 0 : 0 },
        { label: 'Therapeutic Activities(97530):',  value: this.formfield.checkbox2 ? this.getOtItemsFormatted(this.comboboxOtherData2) || 0 : 0 },
        { label: 'Neuromuscular Re-Education(97112):', value: this.formfield.checkbox3 ? this.getOtItemsFormatted(this.comboboxOtherData3) || 0 : 0 },
        { label: 'Manual Therapy Techniques(97140):', value: this.formfield.checkbox4 ? this.getOtItemsFormatted(this.comboboxOtherData4) || 0 : 0 },
        { label: 'Physical Performance Test(97750):', value: this.formfield.checkbox5 ? this.getOtItemsFormatted(this.comboboxOtherData5) || 0 : 0 },
        { label: 'Traction(97012):', value: this.formfield.checkbox6 ? this.getOtItemsFormatted(this.comboboxOtherData6) || 0 : 0 },
        { label: 'Range of Motion Testing(95851):', value: this.formfield.checkbox7 ? this.getOtItemsFormatted(this.comboboxOtherData7) || 0 : 0  } 
    ];
}

get ChiroItemsFormattedArray() {
    return [
        { label:  'Therapeutic Exercises(97110):', value: this.formfield.checkbox1 ?  this.getChiroItemsFormatted(this.comboboxOtherData1) || 0 : 0 },
        { label: 'Therapeutic Activities(97530):', value: this.formfield.checkbox2 ?  this.getChiroItemsFormatted(this.comboboxOtherData2) || 0 : 0 },
        { label: 'Neuromuscular Re-Education(97112):', value: this.formfield.checkbox3 ?  this.getChiroItemsFormatted(this.comboboxOtherData3) || 0 : 0 },
        { label: 'Manual Therapy Techniques(97140):', value: this.formfield.checkbox4 ?  this.getChiroItemsFormatted(this.comboboxOtherData4) || 0 : 0 },
        { label: 'Physical Performance Test(97750):', value: this.formfield.checkbox5 ?  this.getChiroItemsFormatted(this.comboboxOtherData5) || 0 : 0 },
        { label: 'Traction(97012):', value: this.formfield.checkbox6 ?  this.getChiroItemsFormatted(this.comboboxOtherData6) || 0 : 0 },
        { label: 'Range of Motion Testing(95851):', value: this.formfield.checkbox7 ? this.getChiroItemsFormatted(this.comboboxOtherData7) || 0 : 0  } 

    ];
}



        /*
        get disableButton() {
            // Check each checkbox and its corresponding minutesSpent field
            for (let i = 1; i <= 10; i++) {
                // Dynamically construct the checkbox and minutesSpent keys
                const checkboxKey = `checkbox${i}`;
                const minutesSpentKey = `minutesSpent${i}`;
                
                // If the checkbox is true and the corresponding minutesSpent is empty, return true
                if (this.formfield[checkboxKey] && !this.formfield[minutesSpentKey].trim()) {
                    return true; // Disable button if condition is met
                }
            }
            return false; // Enable button if all conditions are satisfied
        }*/

        handleCheckboxChange(event) {
            const { value, checked } = event.target;
            this.formfield[value] = checked;
            if( this.formfield.othersMin03==''){ 	
     	this.formfield.othersMin03='Kinetisense-15 Minutes';                
            }
            if( this.formfield.othersMin04==''){ 	
     	this.formfield.othersMin04='See Daily Note-15 Minutes';                
            }
            if( this.formfield.othersMin05==''){ 	
     	this.formfield.othersMin05='Physical Performance Test -15 Minutes';                
            }

             if( this.formfield.othersMin06==''){ 	
     	this.formfield.othersMin06='Traction-15 Minutes';                
            }

             if( this.formfield.othersMin07==''){ 	
     	this.formfield.othersMin07='VALD -15 Minutes';                
            }
           
        }
        

        handleSubmitval() {
            const inputField = this.template.querySelector('lightning-input');
            if (!inputField.checkValidity()) {
                inputField.reportValidity(); // Shows validation message
                return;
            }
            // Proceed with form submission
        }
        @track ptotchiroFlag=false;
       buttonHandler(event){
        if(event.target.name=='Cpt'){
            this.cptFlag=true;
            this.ptotchiroFlag=false;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_neutral";
            

        }
        if(event.target.name=='Excercise'){
            /*if(this.chiroFlag &&( !this.formfield?.checkbox6 || this.formfield?.checkbox6 === null || this.formfield?.checkbox6 === ''  )){
                console.log('chiro data not entered');
                console.log('data'+this.chiroFlag ||(!this.formfield?.checkbox4 || !this.formfield?.checkbox6));
                this.handleShowModal2();
                return;
            }*/
            this.ptotchiroFlag=true;
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
            // Check if all exercise fields are false
            
            if(this.formfield.checkbox5)
                {
                    this.handleChangeOtherForOtherExercises5();
                }
                if(this.formfield.checkbox6)
                {
                    this.handleChangeOtherForOtherExercises6();
                }
                if(this.formfield.checkbox3)
                    {
                    this.handleChangeOtherForOtherExercises3();
                }
                if(this.formfield.checkbox4)
                    {
                    this.handleChangeOtherForOtherExercises4();
                }
            this.throwError();
            this.clearValues()
    
        }
        if(event.target.name=='Next' ){
            console.log('value for next');
            console.log('value for next '+!this.formfield.checkbox4 || !this.formfield.checkbox6);
           /* if(this.chiroFlag &&( !this.formfield?.checkbox6 || this.formfield?.checkbox6 === null || this.formfield?.checkbox6 === ''  )){
                console.log('chiro data not entered');
                console.log('data'+this.chiroFlag &&(!this.formfield?.checkbox4 && !this.formfield?.checkbox6));
                this.handleShowModal2();
                return;
            }*/
            this.ptotchiroFlag=true;
                //this.chirodataFlag=false;
                this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
            // Check if all exercise fields are false
            
           
            if(this.formfield.checkbox5)
            {
               // this.handleChangeOtherForOtherExercises5();
            }
            if(this.formfield.checkbox6)
            {
               // this.handleChangeOtherForOtherExercises6();
            }
            if(this.formfield.checkbox3)
                {
               // this.handleChangeOtherForOtherExercises3();
            }
            if(this.formfield.checkbox4)
                {
                //this.handleChangeOtherForOtherExercises4();
            }
            
            this.throwError();
            this.clearValues()
            
            
               
            
            
        }
        if(event.target.name=='Submit'){
            //-----------------------------------------------------------\
            this.ptotchiroFlag=true;
            // Query all lightning-input elements within the template
        const allInputs = this.template.querySelectorAll('lightning-input');
        const allInputs2 = this.template.querySelectorAll('lightning-combobox');

        // Flag to check if all inputs are valid
        let isValid = true;

        // Iterate over each input to validate
        allInputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity(); // Display validation message for invalid inputs
                isValid = false;
            }
        });

        allInputs2.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity(); // Display validation message for invalid inputs
                isValid = false;
            }
        });

        // If all inputs are valid, proceed with logic
        if (isValid) {
            console.log('All inputs are valid! Proceeding...');
            // Add your form submission or processing logic here
        } else {
            console.error('Validation failed! Ensure all required fields are filled.');
            return;
        }


        //-----------------------------------------------------
            this.cptFlag=false;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=true;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_brand";
            this.joinValues();
        }
        if(event.target.name=='Back'){
            this.cptFlag=true;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_neutral";

        }
        if(event.target.name=='Back1'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";

        }
        if(event.target.name=='Clear'){
            this.formfield={
                
                    checkbox1:false,
                    checkbox2:false,
                    checkbox3:false,
                    checkbox4:false,
                    checkbox5:false,
                    checkbox6:false,
                    checkbox7:false,
                    checkbox8:false,
                    checkbox9:false,
                    checkbox10:false,        
                    Excercise1:'',
                    Excercise2:'',
                    Excercise3:'',
                    Excercise4:'',
                    Excercise5:'',
                    Excercise6:'',
                    Excercise7:'',
                    Excercise8:'',
                    Excercise9:'',
                    Excercise10:'',
                    minutesSpent1:'',
                    othersMin01:'',
                    minutesSpent2:'',
                    othersMin02:'',
                    minutesSpent3:'',
                    othersMin03:'' ,
                    minutesSpent4:'',
                    othersMin04:'',
                    minutesSpent5:'',
                    othersMin05:'' ,
                    minutesSpent6:'',
                    othersMin06:'',
                    minutesSpent7:'',
                    othersMin07:'',
                    minutesSpent8:'',
                    othersMin08:'',
                    minutesSpent9:'',
                    othersMin09:'' ,
                    minutesSpent10:'',
                    othersMin010:'',
                    totalUnits:'',
                    others1:'',        
                    others2:'',        
                    others3:'',
                    others4:'',
                    others5:'',
                    others6:'',
                    others7:'',
                    others8:'',
                    others9:'',
                    others10:''
            
                   

            };
            this.comboboxData1 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData2 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData3 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData4 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData5 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData6 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData7 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData8 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData9 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];
            this.comboboxData10 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];

            this.comboboxOtherData1 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Chiro:false}   ];
            this.comboboxOtherData2 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:false,Ot:true}   ];
            //this.comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
            this.comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: 'Kinetisense',Min:'15',showDelete:true,Pt:true,Ot:false}   ];
            this.comboboxOtherData4 = [{ id: 1, label: 'Other 1', value: 'See Daily Note',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];
            this.comboboxOtherData5 = [{ id: 1, label: 'Other 1', value: 'Physical Performance Test ',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];
            this.comboboxOtherData6 = [ { id: 1, label: 'Other 1', value: 'Traction',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}    ];
            this.comboboxOtherData7 = [ { id: 1, label: 'Other 1', value: 'VALD',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}   ];
            this.comboboxOtherData8 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
            this.comboboxOtherData9 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];
            this.comboboxOtherData10 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];




        }
        if(event.target.name=='Next'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
            this.throwError();
            this.clearValues()
        }
        if(event.target.name=='Back'){
            this.cptFlag=true;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_neutral";
        }
        if(event.target.name=='Next1'){

            //-----------------------------------------------------------
             // Query all lightning-input elements within the template
        const allInputs = this.template.querySelectorAll('lightning-input');
        const allInputs2 = this.template.querySelectorAll('lightning-combobox');

        // Flag to check if all inputs are valid
        let isValid = true;

        // Iterate over each input to validate
        allInputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity(); // Display validation message for invalid inputs
                isValid = false;
            }
        });

        allInputs2.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity(); // Display validation message for invalid inputs
                isValid = false;
            }
        });

        // If all inputs are valid, proceed with logic
        if (isValid) {
            console.log('All inputs are valid! Proceeding...');
            // Add your form submission or processing logic here
        } else {
            console.error('Validation failed! Ensure all required fields are filled.');
            return;
        }

        //-----------------------------------------------------
            this.cptFlag=false;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=true;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_brand";
           
        }
        
       }
       throwError(){
        const allExercisesFalse = [
            this.formfield.checkbox1,
            this.formfield.checkbox2,
            this.formfield.checkbox3,
            this.formfield.checkbox4,
            this.formfield.checkbox5,
            this.formfield.checkbox6,
            this.formfield.checkbox7,
            this.formfield.checkbox8,
            this.formfield.checkbox9,
            this.formfield.checkbox10
        ].every(field => field === false);
    
        if (allExercisesFalse) {
            this.showToast('Error', 'Please select at least (1) CPT code to continue', 'error');
            this.cptFlag=true;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_neutral";
        }
       }
       clearValues(){
        for (let i = 1; i <= 10; i++) {
            if (this.formfield[`checkbox${i}`] == false) {
                this.formfield[`checkbox${i}`] = false;
                this.formfield[`Excercise${i}`] = '';
                this.formfield[`minutesSpent${i}`] = '';
                this.formfield[`othersMin0${i}`] = '';
                this.formfield[`others${i}`] = '';
            }
        }
        

       }

       checkForZero(x) {
        // Check if the string contains the digit '0'
        if (x.includes('0')==true) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Flowsheets minutes must be entered.',
                    variant: 'error',
                })
            );
           
        }
        //return true;
    }

    joinValues() {
        let x = ''; // Initialize x as an empty string
        for (let i = 1; i <= 10; i++) {
            if (this.formfield[`checkbox${i}`] == false) {
                // Join values and append to x
                x += this.formfield[`Excercise${i}`] + ';' +
                     this.formfield[`minutesSpent${i}`] + ';' +
                     this.formfield[`othersMin0${i}`] + ';' +
                     this.formfield[`others${i}`] + ';';
            }
        }

        // Remove trailing semicolon if x is not empty
        if (x.endsWith(';')) {
            x = x.slice(0, -1);
        }
        console.log('joined values'+x);
        this. checkForZero(x);
    }
  
//--------------------------------------------------------------------c/errorLogMonitoring
@track picklistOptions = [];
@track error;
@track flowSheetId=null;

// Get object info
@wire(getObjectInfo, { objectApiName: flowSheetObject })
objectInfo;

// Get picklist values
@wire(getPicklistValues, {
    fieldApiName: exercise1,    
    recordTypeId: '012UP00000A7RovYAF'//'012U8000001anxhIAA'//'012U80000015vZlIAI'//'012U8000001KFTlIAO'//
})
picklistValues({ error, data }) {
    if (data) {
        this.picklistOptions = data.values;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.picklistOptions = [];
    }
}
//--------------------------------
//get all last 3 appointments(PT,OT,Chiro)
ptId;
otId;
chiroId;
@wire(last3Appointments, { recordId: '$recordId', countSize: 3 })
last3Appointments({ error, data }) {
    if (data) {
        console.log('Raw data:', JSON.stringify(data));

        data.forEach(appointment => {
            console.log('Processing appointment:', JSON.stringify(appointment));

            if (appointment.Visit_Reason__c) {
                console.log(`Visit_Reason__c: ${appointment.Visit_Reason__c}`);

                if (appointment.Visit_Reason__c.startsWith('PT')) {
                    this.ptId = appointment.Id; // Correcting case of 'Id'
                    console.log('PT Match found:', this.ptId);
                } else if (appointment.Visit_Reason__c.startsWith('OT')) {
                    this.otId = appointment.Id;
                    console.log('OT Match found:', this.otId);
                } else if (appointment.Visit_Reason__c.startsWith('CHIRO')) {
                    
                    this.chiroId = appointment.Id;
                    console.log('Chiro Match found:', this.chiroId);
                }
            }
        });

        console.log('Final values:');
        console.log(`ptId: ${this.ptId}, otId: ${this.otId}, chiroId: ${this.chiroId}`);
    } else if (error) {
        console.error('Error fetching appointments:', error);
    }
}
//---------------------------------------

getPtItemsFormatted(data) {
    return data
        .filter(item => item.Pt)
        .map(item => `${item.value}-${item.Min} Minutes`)
        .join(';');
}

getOtItemsFormatted(data) {
    return data
        .filter(item => item.Ot)
        .map(item => `${item.value}-${item.Min} Minutes`)
        .join(';');
}
getChiroItemsFormatted(data) {
    return data
        .filter(item => item.Chiro)
        .map(item => `${item.value}-${item.Min} Minutes`)
        .join(';');
}
//===---------------------SubmitHandler
@track DisableSubmitHandler=false;
SubmitHandler(){
    
    const fields = {};

    this.DisableSubmitHandler=true;

    
    fields[Appointment.fieldApiName] = this.recordId; 

    fields[Code1.fieldApiName] = this.formfield.checkbox1;     
    fields[Code2.fieldApiName] = this.formfield.checkbox2;
    fields[Code3.fieldApiName] = this.formfield.checkbox3;
    fields[Code4.fieldApiName] = this.formfield.checkbox4;
    fields[Code5.fieldApiName] = this.formfield.checkbox5;
    fields[Code6.fieldApiName] = this.formfield.checkbox6;
    fields[Code7.fieldApiName] = this.formfield.checkbox7;
    fields[Code8.fieldApiName] = this.formfield.checkbox8;
    fields[Code9.fieldApiName] = this.formfield.checkbox9;
    fields[Code10.fieldApiName] = this.formfield.checkbox10;

    fields[exercise1.fieldApiName]=this.formfield.Excercise1;
    fields[exercise2.fieldApiName]=this.formfield.Excercise2;
    fields[exercise3.fieldApiName]=this.formfield.Excercise3;
    fields[exercise4.fieldApiName]=this.formfield.Excercise4;
    fields[exercise5.fieldApiName]=this.formfield.Excercise5;
    fields[exercise6.fieldApiName]=this.formfield.Excercise6;
    fields[exercise7.fieldApiName]=this.formfield.Excercise7;
    fields[exercise8.fieldApiName]=this.formfield.Excercise8;
    fields[exercise9.fieldApiName]=this.formfield.Excercise9;
    fields[exercise10.fieldApiName]=this.formfield.Excercise10;

    fields[MinutesSpent1.fieldApiName]=this.formfield.minutesSpent1;
    fields[MinutesSpent2.fieldApiName]=this.formfield.minutesSpent2;
    fields[MinutesSpent3.fieldApiName]=this.formfield.minutesSpent3;
    fields[MinutesSpent4.fieldApiName]=this.formfield.minutesSpent4;
    fields[MinutesSpent5.fieldApiName]=this.formfield.minutesSpent5;
    fields[MinutesSpent6.fieldApiName]=this.formfield.minutesSpent6;
    fields[MinutesSpent7.fieldApiName]=this.formfield.minutesSpent7;
    fields[MinutesSpent8.fieldApiName]=this.formfield.minutesSpent8;
    fields[MinutesSpent9.fieldApiName]=this.formfield.minutesSpent9;
    fields[MinutesSpent10.fieldApiName]=this.formfield.minutesSpent10;

    fields[otherExercises1.fieldApiName]=this.formfield.othersMin01;
    fields[otherExercisesUnits1.fieldApiName]=(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '';

    fields[otherExercises2.fieldApiName]=this.formfield.othersMin02;
    fields[otherExercisesUnits2.fieldApiName]=(this.formfield.othersMin02 != '')? this.calculateUnits(this.formfield.othersMin02) : '';

    fields[otherExercises3.fieldApiName]=this.formfield.othersMin03;
    fields[otherExercisesUnits3.fieldApiName]=(this.formfield.othersMin03 != '')? this.calculateUnits(this.formfield.othersMin03) : '';

    fields[otherExercises4.fieldApiName]=this.formfield.othersMin04;
    fields[otherExercisesUnits4.fieldApiName]=(this.formfield.othersMin04 != '')? this.calculateUnits(this.formfield.othersMin04) : '';

    fields[otherExercises5.fieldApiName]=this.formfield.othersMin05;
    fields[otherExercisesUnits5.fieldApiName]=(this.formfield.othersMin05 != '')? this.calculateUnits(this.formfield.othersMin05) : '';

    fields[otherExercises6.fieldApiName]=this.formfield.othersMin06;
    fields[otherExercisesUnits6.fieldApiName]=(this.formfield.othersMin06 != '')? this.calculateUnits(this.formfield.othersMin06) : '';

    fields[otherExercises7.fieldApiName]=this.formfield.othersMin07;
    fields[otherExercisesUnits7.fieldApiName]=(this.formfield.othersMin07 != '')? this.calculateUnits(this.formfield.othersMin07) : '';

    fields[otherExercises8.fieldApiName]=this.formfield.othersMin08;
    fields[otherExercisesUnits8.fieldApiName]=(this.formfield.othersMin08 != '')? this.calculateUnits(this.formfield.othersMin08) : '';

    fields[otherExercises9.fieldApiName]=this.formfield.othersMin09;
    fields[otherExercisesUnits9.fieldApiName]=(this.formfield.othersMin09 != '')? this.calculateUnits(this.formfield.othersMin09) : '';

    fields[otherExercises10.fieldApiName]=this.formfield.othersMin010;
    fields[otherExercisesUnits10.fieldApiName]=(this.formfield.othersMin010 != '')? this.calculateUnits(this.formfield.othersMin010) : '';

    fields[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',
        (this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);

        fields[MinutesTotal2.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent2 != '')? this.formfield.minutesSpent2 : '',
            (this.formfield.othersMin02 != '')? this.formfield.othersMin02 : '']);

        fields[MinutesTotal3.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent3 != '')? this.formfield.minutesSpent3 : '',
            (this.formfield.othersMin03 != '')? this.formfield.othersMin03 : '']);

        fields[MinutesTotal4.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent4 != '')? this.formfield.minutesSpent4 : '',
                (this.formfield.othersMin04 != '')? this.formfield.othersMin04 : '']);

        fields[MinutesTotal5.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent5 != '')? this.formfield.minutesSpent5 : '',
                    (this.formfield.othersMin05!= '')? this.formfield.othersMin05 : '']);

    fields[MinutesTotal6.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent6 != '')? this.formfield.minutesSpent6 : '',
        (this.formfield.othersMin06 != '')? this.formfield.othersMin06 : '']);

        fields[MinutesTotal7.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent7 != '')? this.formfield.minutesSpent7 : '',
            (this.formfield.othersMin07 != '')? this.formfield.othersMin07 : '']);

        fields[MinutesTotal8.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent8 != '')? this.formfield.minutesSpent8 : '',
            (this.formfield.othersMin08 != '')? this.formfield.othersMin08 : '']);

        fields[MinutesTotal9.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent9 != '')? this.formfield.minutesSpent9 : '',
                (this.formfield.othersMin09 != '')? this.formfield.othersMin09 : '']);

        fields[MinutesTotal10.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent10 != '')? this.formfield.minutesSpent10 : '',
                    (this.formfield.othersMin010!= '')? this.formfield.othersMin010 : '']);

    fields[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
    fields[UnitsSpentcalucation2.fieldApiName]=(this.formfield.minutesSpent2 != '')? this.calculateUnits(this.formfield.minutesSpent2) : '';
    fields[UnitsSpentcalucation3.fieldApiName]=(this.formfield.minutesSpent3 != '')? this.calculateUnits(this.formfield.minutesSpent3) : '';
    fields[UnitsSpentcalucation4.fieldApiName]=(this.formfield.minutesSpent4 != '')? this.calculateUnits(this.formfield.minutesSpent4) : '';
    fields[UnitsSpentcalucation5.fieldApiName]=(this.formfield.minutesSpent5 != '')? this.calculateUnits(this.formfield.minutesSpent5) : '';
    fields[UnitsSpentcalucation6.fieldApiName]=(this.formfield.minutesSpent6 != '')? this.calculateUnits(this.formfield.minutesSpent6) : '';
    fields[UnitsSpentcalucation7.fieldApiName]=(this.formfield.minutesSpent7 != '')? this.calculateUnits(this.formfield.minutesSpent7) : '';
    fields[UnitsSpentcalucation8.fieldApiName]=(this.formfield.minutesSpent8 != '')? this.calculateUnits(this.formfield.minutesSpent8) : '';
    fields[UnitsSpentcalucation9.fieldApiName]=(this.formfield.minutesSpent9 != '')? this.calculateUnits(this.formfield.minutesSpent9) : '';
    fields[UnitsSpentcalucation10.fieldApiName]=(this.formfield.minutesSpent10 != '')? this.calculateUnits(this.formfield.minutesSpent10) : '';

    fields[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',
        (this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
    fields[UnitsTotal2.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent2 != '')? this.calculateUnits(this.formfield.minutesSpent2) : '',
            (this.formfield.othersMin02 != '')? this.calculateUnits(this.formfield.othersMin02) : '']);
    fields[UnitsTotal3.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent3 != '')? this.calculateUnits(this.formfield.minutesSpent3) : '',
        (this.formfield.othersMin03 != '')? this.calculateUnits(this.formfield.othersMin03) : '']);
    fields[UnitsTotal4.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent4 != '')? this.calculateUnits(this.formfield.minutesSpent4) : '',
        (this.formfield.othersMin04 != '')? this.calculateUnits(this.formfield.othersMin04) : '']);
    fields[UnitsTotal5.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent5 != '')? this.calculateUnits(this.formfield.minutesSpent5) : '',
        (this.formfield.othersMin05 != '')? this.calculateUnits(this.formfield.othersMin05) : '']);

    fields[UnitsTotal6.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent6 != '')? this.calculateUnits(this.formfield.minutesSpent6) : '',
        (this.formfield.othersMin06 != '')? this.calculateUnits(this.formfield.othersMin06) : '']);
    fields[UnitsTotal7.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent7 != '')? this.calculateUnits(this.formfield.minutesSpent7) : '',
            (this.formfield.othersMin07 != '')? this.calculateUnits(this.formfield.othersMin07) : '']);
    fields[UnitsTotal8.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent8 != '')? this.calculateUnits(this.formfield.minutesSpent8) : '',
        (this.formfield.othersMin08 != '')? this.calculateUnits(this.formfield.othersMin08) : '']);
    fields[UnitsTotal9.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent9 != '')? this.calculateUnits(this.formfield.minutesSpent9) : '',
        (this.formfield.othersMin09 != '')? this.calculateUnits(this.formfield.othersMin09) : '']);
    fields[UnitsTotal10.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent10 != '')? this.calculateUnits(this.formfield.minutesSpent10) : '',
        (this.formfield.othersMin010 != '')? this.calculateUnits(this.formfield.othersMin010) : '']);

    const inputs = [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',
        (this.formfield.minutesSpent2 != '')? this.formfield.minutesSpent2 : '',
        (this.formfield.minutesSpent3 != '')? this.formfield.minutesSpent3 : '',
        (this.formfield.minutesSpent4 != '')? this.formfield.minutesSpent4 : '',
        (this.formfield.minutesSpent5 != '')? this.formfield.minutesSpent5 : '',
        (this.formfield.minutesSpent6 != '')? this.formfield.minutesSpent6 : '',
        (this.formfield.minutesSpent7 != '')? this.formfield.minutesSpent7 : '',
        (this.formfield.minutesSpent8 != '')? this.formfield.minutesSpent8 : '',
        (this.formfield.minutesSpent9 != '')? this.formfield.minutesSpent9 : '',
        (this.formfield.minutesSpent10 != '')? this.formfield.minutesSpent10 : '',
        (this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '',
        (this.formfield.othersMin02 != '')? this.formfield.othersMin02 : '',
        (this.formfield.othersMin03 != '')? this.formfield.othersMin03 : '',
        (this.formfield.othersMin04 != '')? this.formfield.othersMin04 : '',
        (this.formfield.othersMin05 != '')? this.formfield.othersMin05 : '',
        (this.formfield.othersMin06 != '')? this.formfield.othersMin06 : '',
        (this.formfield.othersMin07 != '')? this.formfield.othersMin07 : '',
        (this.formfield.othersMin08 != '')? this.formfield.othersMin08 : '',
        (this.formfield.othersMin09 != '')? this.formfield.othersMin09 : '',
        (this.formfield.othersMin010 != '')? this.formfield.othersMin010 : ''

    ];
    fields[Total_Units.fieldApiName]=this.sumUnitscalculator(inputs);
    console.log('**',this.formfield);
    //---------------------------------------------------------------------
 // Check if at least one of the required fields has a value
 if ( this.ptId)  {
    let inputs1 = [];

    const fields1 = {};
    fields1[Appointment.fieldApiName] = this.ptId;//'a0EU8000002EioEMAS';//this.recordId; 

      
        //---------------------------   
        if(this.formfield.checkbox1){
            fields1[Code1.fieldApiName] = this.formfield.checkbox1;
            fields1[exercise1.fieldApiName] = this.formfield.Excercise1;
            fields1[MinutesSpent1.fieldApiName] = this.formfield.minutesSpent1;
            //-------------------------------------
             //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
         const Otvalues1=this.getPtItemsFormatted(this.comboboxOtherData1);
         fields1[otherExercises1.fieldApiName]=Otvalues1;
         //fields1[otherExercisesUnits1.fieldApiName]=
         fields1[otherExercisesUnits1.fieldApiName]=(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '';
         // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
         fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(Otvalues1 != '')? Otvalues1 : '']);
         //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
         fields1[UnitsSpentcalucation1.fieldApiName]=(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '';
         //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
         fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '']);
         //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
         inputs1=[...inputs1,(Otvalues1 != '')? Otvalues1 : ''];
    }

        
        if(this.formfield.checkbox2){
            fields1[Code2.fieldApiName] = this.formfield.checkbox2;
            fields1[exercise2.fieldApiName] = this.formfield.Excercise2;
            fields1[MinutesSpent2.fieldApiName] = this.formfield.minutesSpent2;
            //-------------------------------------
             //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
         const Otvalues2=this.getPtItemsFormatted(this.comboboxOtherData2);
         fields1[otherExercises2.fieldApiName]=Otvalues2;
         //fields1[otherExercisesUnits1.fieldApiName]=
         fields1[otherExercisesUnits2.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
         // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
         fields1[MinutesTotal2.fieldApiName]=this.sumUnits( [(Otvalues2 != '')? Otvalues2 : '']);
         //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
         fields1[UnitsSpentcalucation2.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
         //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
         fields1[UnitsTotal2.fieldApiName]=this.sumUnits([(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '']);
         //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
         inputs1=[...inputs1,(Otvalues2 != '')? Otvalues2 : ''];
    }
         if(this.formfield.checkbox3){
        fields1[Code3.fieldApiName] = this.formfield.checkbox3;
        fields1[exercise3.fieldApiName]=this.formfield.Excercise3;
        fields1[MinutesSpent3.fieldApiName]=this.formfield.minutesSpent3;
        //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const ptvalues3=this.getPtItemsFormatted(this.comboboxOtherData3);
       fields1[otherExercises3.fieldApiName]=ptvalues3;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits3.fieldApiName]=(ptvalues3 != '')? this.calculateUnits(ptvalues3) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal3.fieldApiName]=this.sumUnits( [(ptvalues3 != '')? ptvalues3 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation3.fieldApiName]=(ptvalues3 != '')? this.calculateUnits(ptvalues3) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal3.fieldApiName]=this.sumUnits([(ptvalues3 != '')? this.calculateUnits(ptvalues3) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs1=[...inputs1,(ptvalues3 != '')? ptvalues3 : ''];
         }
         //---------------------------------------------------------
         if(this.formfield.checkbox4){
            fields1[Code4.fieldApiName] = this.formfield.checkbox4;
            fields1[exercise4.fieldApiName]=this.formfield.Excercise4;
            fields1[MinutesSpent4.fieldApiName]=this.formfield.minutesSpent4;            
            //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
            const Otvalues=this.getPtItemsFormatted(this.comboboxOtherData4);
            fields1[otherExercises4.fieldApiName]=Otvalues;
            //fields1[otherExercisesUnits1.fieldApiName]=
            fields1[otherExercisesUnits4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
            // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
            fields1[MinutesTotal4.fieldApiName]=this.sumUnits( [(Otvalues != '')? Otvalues : '']);
            //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
            fields1[UnitsSpentcalucation4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
            //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
            fields1[UnitsTotal4.fieldApiName]=this.sumUnits([(Otvalues != '')? this.calculateUnits(Otvalues) : '']);
            //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
            inputs1=[...inputs1,(Otvalues != '')? Otvalues : ''];
        }
            
 //----------------------------------------------------------------------
 if(this.formfield.checkbox5){
    fields1[Code5.fieldApiName] = this.formfield.checkbox5;
    fields1[exercise5.fieldApiName] = this.formfield.Excercise5;
    fields1[MinutesSpent5.fieldApiName] = this.formfield.minutesSpent5;
     //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const ptvalues5=this.getPtItemsFormatted(this.comboboxOtherData5);
       fields1[otherExercises5.fieldApiName]=ptvalues5;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits5.fieldApiName]=(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal5.fieldApiName]=this.sumUnits( [(ptvalues5 != '')? ptvalues5 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation5.fieldApiName]=(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal5.fieldApiName]=this.sumUnits([(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs1=[...inputs1,(ptvalues5 != '')? ptvalues5 : ''];
 }

 if(this.formfield.checkbox6){
    fields1[Code6.fieldApiName] = this.formfield.checkbox6;
    fields1[exercise6.fieldApiName] = this.formfield.Excercise6;
    fields1[MinutesSpent6.fieldApiName] = this.formfield.minutesSpent6;
    //-------------------------------------
     //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
 const Ptvalues2=this.getPtItemsFormatted(this.comboboxOtherData6);
 fields1[otherExercises6.fieldApiName]=Ptvalues2;
 //fields1[otherExercisesUnits1.fieldApiName]=
 fields1[otherExercisesUnits6.fieldApiName]=(Ptvalues2 != '')? this.calculateUnits(Ptvalues2) : '';
 // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
 fields1[MinutesTotal6.fieldApiName]=this.sumUnits( [(Ptvalues2 != '')? Ptvalues2 : '']);
 //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
 fields1[UnitsSpentcalucation6.fieldApiName]=(Ptvalues2 != '')? this.calculateUnits(Ptvalues2) : '';
 //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
 fields1[UnitsTotal6.fieldApiName]=this.sumUnits([(Ptvalues2 != '')? this.calculateUnits(Ptvalues2) : '']);
 //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
 inputs1=[...inputs1,(Ptvalues2 != '')? Ptvalues2 : ''];
}

 if(this.formfield.checkbox7){
    fields1[Code7.fieldApiName] = this.formfield.checkbox7;
    fields1[exercise7.fieldApiName] = this.formfield.Excercise7;
    fields1[MinutesSpent7.fieldApiName] = this.formfield.minutesSpent7;
     //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const ptvalues7=this.getPtItemsFormatted(this.comboboxOtherData7);
       fields1[otherExercises7.fieldApiName]=ptvalues7;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits7.fieldApiName]=(ptvalues7 != '')? this.calculateUnits(ptvalues7) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal7.fieldApiName]=this.sumUnits( [(ptvalues7 != '')? ptvalues7 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation7.fieldApiName]=(ptvalues7 != '')? this.calculateUnits(ptvalues7) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal7.fieldApiName]=this.sumUnits([(ptvalues7 != '')? this.calculateUnits(ptvalues7) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs1=[...inputs1,(ptvalues7 != '')? ptvalues7 : ''];
 }
 
 //----------------------------------------------------------------------

    console.log(inputs1);
    
     fields1[Total_Units.fieldApiName]=this.totalPtunitsValue1;//this.sumUnitscalculator(inputs1);


    let recordInput1 = { apiName: flowSheetObject.objectApiName, fields: fields1 };
    console.log('recordInput1 is '+recordInput1);

    createRecord(recordInput1)
        .then((result) => {
            console.log('***Record Created Successfully:', result);
            let flowSheetId1=result.id;

            const fields = {
                Id: this.ptId,//'a0EU8000002EioEMAS', 
                Appointment_Status__c: 'Provider Review', 
                Flowsheet__c:flowSheetId1,
                FlowSheet_Generated__c:true,
                Flowsheet_Updated__c:true,
                Diagnostics__c:this.DiagnosisData
            };
        
                const recordInput = { fields };
        
           
            updateRecord(recordInput).then(() => {
                console.log('***Record update Successfully:');
                // Handle success, show success toast or message
                //this.handleNavSelection();
                //this.dispatchEvent(new CustomEvent('close'))
                //this.showToast('Success', 'Exercise\'s Added Successfully', 'success');
                //this.status='Aproval sucess'
            })
            .catch(error => {
                // Handle error, show error toast or message
                //this.status='Aproval failed'
                //this.showToast('Error', error.body.message, 'error');
            });

        })
        .catch((error) => {
            console.error('Error creating record:', error);
        });
}

if (this.otId)  {
    let inputs2 = [ ];

    const fields1 = {};
    fields1[Appointment.fieldApiName] = this.otId;

   

if(this.formfield.checkbox2){
    fields1[Code2.fieldApiName] = this.formfield.checkbox2;
    fields1[exercise2.fieldApiName] = this.formfield.Excercise2;
    fields1[MinutesSpent2.fieldApiName] = this.formfield.minutesSpent2;
    //-------------------------------------
     //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
 const Otvalues2=this.getOtItemsFormatted(this.comboboxOtherData2);
 fields1[otherExercises2.fieldApiName]=Otvalues2;
 //fields1[otherExercisesUnits1.fieldApiName]=
 fields1[otherExercisesUnits2.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
 fields1[MinutesTotal2.fieldApiName]=this.sumUnits( [(Otvalues2 != '')? Otvalues2 : '']);
 //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
 fields1[UnitsSpentcalucation2.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
 fields1[UnitsTotal2.fieldApiName]=this.sumUnits([(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '']);
 //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
 inputs2=[...inputs2,(Otvalues2 != '')? Otvalues2 : ''];
}

    if(this.formfield.checkbox3){
    fields1[Code3.fieldApiName] = this.formfield.checkbox3;
    fields1[exercise3.fieldApiName]=this.formfield.Excercise3;
    fields1[MinutesSpent3.fieldApiName]=this.formfield.minutesSpent3;
    //--------------------------------------------------
     //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
     const Otvalues1=this.getOtItemsFormatted(this.comboboxOtherData3);
     fields1[otherExercises3.fieldApiName]=Otvalues1;
     //fields1[otherExercisesUnits1.fieldApiName]=
     fields1[otherExercisesUnits3.fieldApiName]=(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '';
     // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
     fields1[MinutesTotal3.fieldApiName]=this.sumUnits( [(Otvalues1 != '')? Otvalues1 : '']);
     //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
     fields1[UnitsSpentcalucation3.fieldApiName]=(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '';
     //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
     fields1[UnitsTotal3.fieldApiName]=this.sumUnits([(Otvalues1 != '')? this.calculateUnits(Otvalues1) : '']);
     //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
     inputs2=[...inputs2,(Otvalues1 != '')? Otvalues1 : ''];
}

if(this.formfield.checkbox4){
    fields1[Code4.fieldApiName] = this.formfield.checkbox4;
    fields1[exercise4.fieldApiName]=this.formfield.Excercise4;
    fields1[MinutesSpent4.fieldApiName]=this.formfield.minutesSpent4;
    //---------------------------
    console.log('Entered here');
    //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
    const Otvalues=this.getOtItemsFormatted(this.comboboxOtherData4);
    console.log('Exited here');

    fields1[otherExercises4.fieldApiName]=Otvalues;
    //fields1[otherExercisesUnits1.fieldApiName]=
    fields1[otherExercisesUnits4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
    // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
    fields1[MinutesTotal4.fieldApiName]=this.sumUnits( [(Otvalues != '')? Otvalues : '']);
    //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
    fields1[UnitsSpentcalucation4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
    //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
    fields1[UnitsTotal4.fieldApiName]=this.sumUnits([(Otvalues != '')? this.calculateUnits(Otvalues) : '']);
    //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
    inputs2=[...inputs2,(Otvalues != '')? Otvalues : ''];
}      

    if(this.formfield.checkbox5){
        fields1[Code5.fieldApiName] = this.formfield.checkbox5;
        fields1[exercise5.fieldApiName] = this.formfield.Excercise5;
        fields1[MinutesSpent5.fieldApiName] = this.formfield.minutesSpent5;
        //-------------------------------------
         //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
     const Otvalues2=this.getOtItemsFormatted(this.comboboxOtherData5);
     fields1[otherExercises5.fieldApiName]=Otvalues2;
     //fields1[otherExercisesUnits1.fieldApiName]=
     fields1[otherExercisesUnits5.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
     // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
     fields1[MinutesTotal5.fieldApiName]=this.sumUnits( [(Otvalues2 != '')? Otvalues2 : '']);
     //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
     fields1[UnitsSpentcalucation5.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
     //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
     fields1[UnitsTotal5.fieldApiName]=this.sumUnits([(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '']);
     //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
     inputs2=[...inputs2,(Otvalues2 != '')? Otvalues2 : ''];
}
           
    
if(this.formfield.checkbox6){
    fields1[Code6.fieldApiName] = this.formfield.checkbox6;
    fields1[exercise6.fieldApiName] = this.formfield.Excercise6;
    fields1[MinutesSpent6.fieldApiName] = this.formfield.minutesSpent6;
    //-------------------------------------
     //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
 const Otvalues2=this.getOtItemsFormatted(this.comboboxOtherData6);
 fields1[otherExercises6.fieldApiName]=Otvalues2;
 //fields1[otherExercisesUnits1.fieldApiName]=
 fields1[otherExercisesUnits6.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
 fields1[MinutesTotal6.fieldApiName]=this.sumUnits( [(Otvalues2 != '')? Otvalues2 : '']);
 //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
 fields1[UnitsSpentcalucation6.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
 fields1[UnitsTotal6.fieldApiName]=this.sumUnits([(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '']);
 //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
 inputs2=[...inputs2,(Otvalues2 != '')? Otvalues2 : ''];
}


if(this.formfield.checkbox7){
    fields1[Code7.fieldApiName] = this.formfield.checkbox7;
    fields1[exercise7.fieldApiName] = this.formfield.Excercise7;
    fields1[MinutesSpent7.fieldApiName] = this.formfield.minutesSpent7;
     //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const Otvalues7=this.getOtItemsFormatted(this.comboboxOtherData7);
       fields1[otherExercises7.fieldApiName]=Otvalues7;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits7.fieldApiName]=(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal7.fieldApiName]=this.sumUnits( [(Otvalues7 != '')? Otvalues7 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation7.fieldApiName]=(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal7.fieldApiName]=this.sumUnits([(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs2=[...inputs2,(Otvalues7 != '')? Otvalues7 : ''];
 }


    fields1[Total_Units.fieldApiName] = this.totalOtunitsValue1;//this.sumUnitscalculator(inputs2);

    //-----------
    console.log('comboboxOtherData2',this.comboboxOtherData2);
    console.log('***fields1 data',fields1);
    console.log('comboboxOtherData2',this.comboboxOtherData2);
    let recordInput2 = { apiName: flowSheetObject.objectApiName, fields: fields1 };

    createRecord(recordInput2)
        .then((result) => {
            console.log('***Record Created Successfully:', result);
            let flowSheetId1=result.id;

            const fields = {
                Id: this.otId,//'a0EU8000002EioEMAS', 
                Appointment_Status__c: 'Provider Review', 
                Flowsheet__c:flowSheetId1,
                FlowSheet_Generated__c:true,
                Flowsheet_Updated__c:true,
                Diagnostics__c:this.DiagnosisData
            };
        
                const recordInput = { fields };
        
           
            updateRecord(recordInput).then(() => {
                console.log('***Record update Successfully:');
                // Handle success, show success toast or message
                //this.handleNavSelection();
                //this.dispatchEvent(new CustomEvent('close'))
                //this.showToast('Success', 'Exercise\'s Added Successfully', 'success');
                //this.status='Aproval sucess'
            })
            .catch(error => {
                // Handle error, show error toast or message
                //this.status='Aproval failed'
                //this.showToast('Error', error.body.message, 'error');
            });

        })
        .catch((error) => {
            console.error('Error creating record:', error);
        });
}

if (this.chiroId) {
    const fields1 = {};
    let inputs3=[];
    fields1[Appointment.fieldApiName] = this.chiroId;//'a0EU8000002EioEMAS'; //this.recordId;

//-------------------------------------------------
if(this.formfield.checkbox1){
    fields1[Code1.fieldApiName] = this.formfield.checkbox1;
    fields1[exercise1.fieldApiName]=this.formfield.Excercise1;
    fields1[MinutesSpent1.fieldApiName]=this.formfield.minutesSpent1;
    //---------------------------
    console.log('Entered here');
    //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
    const Chirovalues=this.getChiroItemsFormatted(this.comboboxOtherData1);
    console.log('Exited here');

    fields1[otherExercises1.fieldApiName]=Chirovalues;
    //fields1[otherExercisesUnits1.fieldApiName]=
    fields1[otherExercisesUnits1.fieldApiName]=(Chirovalues != '')? this.calculateUnits(Chirovalues) : '';
    // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
    fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(Chirovalues != '')? Chirovalues : '']);
    //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
    fields1[UnitsSpentcalucation1.fieldApiName]=(Chirovalues != '')? this.calculateUnits(Chirovalues) : '';
    //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
    fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(Chirovalues != '')? this.calculateUnits(Chirovalues) : '']);
    //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
    inputs3=[...inputs3,(Chirovalues != '')? Chirovalues : ''];
}

if(this.formfield.checkbox4){
    fields1[Code4.fieldApiName] = this.formfield.checkbox4;
    fields1[exercise4.fieldApiName]=this.formfield.Excercise4;
    fields1[MinutesSpent4.fieldApiName]=this.formfield.minutesSpent4;
    //---------------------------
    console.log('Entered here');
    //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
    const Otvalues=this.getChiroItemsFormatted(this.comboboxOtherData4);
    console.log('Exited here');

    fields1[otherExercises4.fieldApiName]=Otvalues;
    //fields1[otherExercisesUnits1.fieldApiName]=
    fields1[otherExercisesUnits4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
    // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
    fields1[MinutesTotal4.fieldApiName]=this.sumUnits( [(Otvalues != '')? Otvalues : '']);
    //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
    fields1[UnitsSpentcalucation4.fieldApiName]=(Otvalues != '')? this.calculateUnits(Otvalues) : '';
    //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
    fields1[UnitsTotal4.fieldApiName]=this.sumUnits([(Otvalues != '')? this.calculateUnits(Otvalues) : '']);
    //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
    inputs3=[...inputs3,(Otvalues != '')? Otvalues : ''];
}

if(this.formfield.checkbox5){
    fields1[Code5.fieldApiName] = this.formfield.checkbox5;
    fields1[exercise5.fieldApiName] = this.formfield.Excercise5;
    fields1[MinutesSpent5.fieldApiName] = this.formfield.minutesSpent5;
     //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const ptvalues5=this.getChiroItemsFormatted(this.comboboxOtherData5);
       fields1[otherExercises5.fieldApiName]=ptvalues5;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits5.fieldApiName]=(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal5.fieldApiName]=this.sumUnits( [(ptvalues5 != '')? ptvalues5 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation5.fieldApiName]=(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal5.fieldApiName]=this.sumUnits([(ptvalues5 != '')? this.calculateUnits(ptvalues5) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs3=[...inputs3,(ptvalues5 != '')? ptvalues5 : ''];
 }

//-------------------------------------------------

     
    
if(this.formfield.checkbox6){
    fields1[Code6.fieldApiName] = this.formfield.checkbox6;
    fields1[exercise6.fieldApiName] = this.formfield.Excercise6;
    fields1[MinutesSpent6.fieldApiName] = this.formfield.minutesSpent6;
    //-------------------------------------
     //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
 const Otvalues2=this.getChiroItemsFormatted(this.comboboxOtherData6);
 fields1[otherExercises6.fieldApiName]=Otvalues2;
 //fields1[otherExercisesUnits1.fieldApiName]=
 fields1[otherExercisesUnits6.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
 fields1[MinutesTotal6.fieldApiName]=this.sumUnits( [(Otvalues2 != '')? Otvalues2 : '']);
 //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
 fields1[UnitsSpentcalucation6.fieldApiName]=(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '';
 //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
 fields1[UnitsTotal6.fieldApiName]=this.sumUnits([(Otvalues2 != '')? this.calculateUnits(Otvalues2) : '']);
 //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
 inputs3=[...inputs3,(Otvalues2 != '')? Otvalues2 : ''];
}

if(this.formfield.checkbox7){
    fields1[Code7.fieldApiName] = this.formfield.checkbox7;
    fields1[exercise7.fieldApiName] = this.formfield.Excercise7;
    fields1[MinutesSpent7.fieldApiName] = this.formfield.minutesSpent7;
     //---------
       //fields1[otherExercises1.fieldApiName]=this.formfield.othersMin01;
       const Otvalues7=this.getChiroItemsFormatted(this.comboboxOtherData7);
       fields1[otherExercises7.fieldApiName]=Otvalues7;
       //fields1[otherExercisesUnits1.fieldApiName]=
       fields1[otherExercisesUnits7.fieldApiName]=(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '';
       // fields1[MinutesTotal1.fieldApiName]=this.sumUnits( [(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : '']);
       fields1[MinutesTotal7.fieldApiName]=this.sumUnits( [(Otvalues7 != '')? Otvalues7 : '']);
       //fields1[UnitsSpentcalucation1.fieldApiName]=(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '';
       fields1[UnitsSpentcalucation7.fieldApiName]=(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '';
       //fields1[UnitsTotal1.fieldApiName]=this.sumUnits([(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '']);
       fields1[UnitsTotal7.fieldApiName]=this.sumUnits([(Otvalues7 != '')? this.calculateUnits(Otvalues7) : '']);
       //inputs1=[...inputs1,(this.formfield.minutesSpent1 != '')? this.formfield.minutesSpent1 : '',(this.formfield.othersMin01 != '')? this.formfield.othersMin01 : ''];
       inputs3=[...inputs3,(Otvalues7 != '')? Otvalues7 : ''];
 }



    fields1[Total_Units.fieldApiName] = this.totalChirounitsValue1;//this.sumUnitscalculator(inputs3);

    let recordInput3 = { apiName: flowSheetObject.objectApiName, fields: fields1 };

    createRecord(recordInput3)
        .then((result) => {
            console.log('***Record Created Successfully:', result);
            let flowSheetId1 = result.id;

            const fields = {
                Id: this.chiroId,//'a0EU8000002EioEMAS',
                Appointment_Status__c: 'Provider Review',
                Flowsheet__c: flowSheetId1,
                FlowSheet_Generated__c: true,
                Flowsheet_Updated__c:true,
                Diagnostics__c:this.DiagnosisData
            };

            const recordInput = { fields };

            updateRecord(recordInput).then(() => {
                console.log('***Record update Successfully:');
            })
            .catch(error => {
                console.error('Error updating record:', error);
            });

        })
        .catch((error) => {
            console.error('Error creating record:', error);
        });


 
    
}
//this.handleNavSelection();
this.dispatchEvent(new CustomEvent('close'))
this.showToast('Success', 'Exercise\'s Added Successfully', 'success');
this.status='Aproval sucess'
}

get DisableSubmitHandler1(){
return this.DisableSubmitHandler;
}

updateFlowsheets(){
    updateFlowsheets({ recordId: this.recordId })
        .then(() => {
            // Success message after the update
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Flowsheets have been Cleared.',
                    variant: 'success',
                })
            );
        })
        .catch((error) => {
            // Error handling
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        });
}
//--------------totalunits
_totalunitsValue = 0; // Private variable to store the total
//------------------------------


get totalPtunitsValue1() {
    return this.getUnits(this.totalPtminutesvalue);
  }

  get totalOtunitsValue1() {
    return this.getUnits(this.totalOtminutesvalue);
  }

  get totalChirounitsValue1() {
    return this.getUnits(this.totalChiroMinutesValue);
  }
//-------------------------------


get totalPtunitsValue() {
    const inputs = [
        this.formfield.checkbox1 ? this.getPtItemsFormatted(this.comboboxOtherData1) || 0 : 0,
        this.formfield.checkbox3 ? this.getPtItemsFormatted(this.comboboxOtherData3) || 0 : 0,
        this.formfield.checkbox5 ? this.getPtItemsFormatted(this.comboboxOtherData5) || 0 : 0,
        this.formfield.checkbox4 ? (this.formfield.othersMin04 !== '' ? this.formfield.othersMin04 : 0) : 0
    ];
    
    return this.sumUnitscalculator(inputs);
}set totalPtunitsValue(value) {
    this._totalunitsValue = value; // Optionally, you can store the value
}

get totalOtunitsValue() {
    const inputs = [
        this.formfield.checkbox1 ? this.getOtItemsFormatted(this.comboboxOtherData1) || 0 : 0,
        this.formfield.checkbox2 ? (this.formfield.othersMin02 !== '' ? this.formfield.othersMin02 : 0) : 0,
        this.formfield.checkbox3 ? this.getOtItemsFormatted(this.comboboxOtherData3) || 0 : 0,
        this.formfield.checkbox5 ? this.getOtItemsFormatted(this.comboboxOtherData5) || 0 : 0
    ];
    
    return this.sumUnitscalculator(inputs);
}set totalOtunitsValue(value) {
    //this._totalunitsValue = value; // Optionally, you can store the value
}
get totalChirounitsValue() {
    const inputs = [
        this.formfield.checkbox6 ? (this.formfield.othersMin06 !== '' ? this.formfield.othersMin06 : 0) : 0
    ];
    
    return this.sumUnitscalculator(inputs);
}set totalChirounitsValue(value) {
    //this._totalunitsValue = value; // Optionally, you can store the value
}


//------------------------------total minutes--------------------------



totalPTMinutesValue = 0; // Private variable to store the total
totalOTMinutesValue = 0;
totalCHIROMinutesValue = 0;
get totalPtminutesvalue() {
   
    const totalInputs = [
    this.formfield.checkbox1 ? this.getPtItemsFormatted(this.comboboxOtherData1) || 0 : 0, 
    this.formfield.checkbox2 ? this.getPtItemsFormatted(this.comboboxOtherData2) || 0 : 0, 
    this.formfield.checkbox3 ? this.getPtItemsFormatted(this.comboboxOtherData3) || 0 : 0, 
    this.formfield.checkbox4 ? this.getPtItemsFormatted(this.comboboxOtherData4) || 0 : 0, 
    this.formfield.checkbox5 ? this.getPtItemsFormatted(this.comboboxOtherData5) || 0 : 0,
    this.formfield.checkbox6 ? this.getPtItemsFormatted(this.comboboxOtherData6) || 0 : 0,
    this.formfield.checkbox7 ? this.getPtItemsFormatted(this.comboboxOtherData7) || 0 : 0
];

    return this.sumUnits2(totalInputs);
}

set totalPtminutesvalue(value) {
    this.totalPTMinutesValue = value; // Optionally, you can store the value
}
get totalOtminutesvalue() {
    const totalInputs = [
        this.formfield.checkbox2 ? this.getOtItemsFormatted(this.comboboxOtherData2) || 0 : 0,
        this.formfield.checkbox3 ? this.getOtItemsFormatted(this.comboboxOtherData3) || 0 : 0,
        this.formfield.checkbox4 ? this.getOtItemsFormatted(this.comboboxOtherData4) || 0 : 0,
        this.formfield.checkbox5 ? this.getOtItemsFormatted(this.comboboxOtherData5) || 0 : 0,
        this.formfield.checkbox6 ? this.getOtItemsFormatted(this.comboboxOtherData6) || 0 : 0,
        this.formfield.checkbox7 ? this.getOtItemsFormatted(this.comboboxOtherData7) || 0 : 0

    ];
    
    return this.sumUnits2(totalInputs);
}
set totalOtminutesvalue(value) {
    this.totalOTMinutesValue = value; // Optionally, you can store the value
}

get totalChiroMinutesValue() {
    const totalInputs = [     
       //this.formfield.checkbox6 ? this.formfield.othersMin06 || 0 : 0,
        this.formfield.checkbox1 ? this.getChiroItemsFormatted(this.comboboxOtherData1) || 0 : 0,
        this.formfield.checkbox4 ? this.getChiroItemsFormatted(this.comboboxOtherData4) || 0 : 0,
        this.formfield.checkbox5 ? this.getChiroItemsFormatted(this.comboboxOtherData5) || 0 : 0,
        this.formfield.checkbox6 ? this.getChiroItemsFormatted(this.comboboxOtherData6) || 0 : 0,
        this.formfield.checkbox7 ? this.getChiroItemsFormatted(this.comboboxOtherData7) || 0 : 0

    ];
    return this.sumUnits2(totalInputs);
}set totalChiroMinutesValue(value) {
    this.totalCHIROMinutesValue = value; // Optionally, you can store the value
}


//cpt1 total minutes------------------

_totalminutesvalueCPT1 = 0;

get totalminutesvalueCPT1() {
    const totalInputs1 = [
        this.formfield.minutesSpent1 || 0,
        this.formfield.othersMin01 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT1(value) {
    this._totalminutesvalueCPT1 = value; // Optionally, you can store the value
}

//cpt1 total minutes------------------

_totalminutesvalueCPT2 = 0;

get totalminutesvalueCPT2() {
    const totalInputs1 = [
        this.formfield.minutesSpent2 || 0,
        this.formfield.othersMin02 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT2(value) {
    this._totalminutesvalueCPT2 = value; // Optionally, you can store the value
}

//cpt3 total minutes------------------

_totalminutesvalueCPT3 = 0;

get totalminutesvalueCPT3() {
    const totalInputs1 = [
        this.formfield.minutesSpent3 || 0,
        this.formfield.othersMin03 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT3(value) {
    this._totalminutesvalueCPT3 = value; // Optionally, you can store the value
}

//cpt4 total minutes------------------

_totalminutesvalueCPT4 = 0;

get totalminutesvalueCPT4() {
    const totalInputs1 = [
        this.formfield.minutesSpent4 || 0,
        this.formfield.othersMin04 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT4(value) {
    this._totalminutesvalueCPT4 = value; // Optionally, you can store the value
}

//cpt5 total minutes------------------

_totalminutesvalueCPT5 = 0;

get totalminutesvalueCPT5() {
    const totalInputs1 = [
        this.formfield.minutesSpent5 || 0,
        this.formfield.othersMin05 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT5(value) {
    this._totalminutesvalueCPT5 = value; // Optionally, you can store the value
}

//cpt6 total minutes------------------

_totalminutesvalueCPT6 = 0;

get totalminutesvalueCPT6() {

        if (!this.formfield || !this.formfield.checkbox6) {
        return 0;
    }
    const totalInputs1 = [
       this.formfield.checkbox6? this.formfield.minutesSpent6?this.formfield.minutesSpent6:0:0,
        this.formfield.checkbox6?this.formfield.othersMin06?this.formfield.othersMin06:0:0
    ];

    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT6(value) {
    this._totalminutesvalueCPT6 = value; // Optionally, you can store the value
}

//cpt7 total minutes------------------

_totalminutesvalueCPT7 = 0;

get totalminutesvalueCPT7() {
    const totalInputs1 = [
        this.formfield.minutesSpent7 || 0,
        this.formfield.othersMin07 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT7(value) {
    this._totalminutesvalueCPT7 = value; // Optionally, you can store the value
}

//cpt8 total minutes------------------

_totalminutesvalueCPT8 = 0;

get totalminutesvalueCPT8() {
    const totalInputs1 = [
        this.formfield.minutesSpent8 || 0,
        this.formfield.othersMin08 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT8(value) {
    this._totalminutesvalueCPT8 = value; // Optionally, you can store the value
}

//cpt9 total minutes------------------

_totalminutesvalueCPT9 = 0;

get totalminutesvalueCPT9() {
    const totalInputs1 = [
        this.formfield.minutesSpent9 || 0,
        this.formfield.othersMin09 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT9(value) {
    this._totalminutesvalueCPT9 = value; // Optionally, you can store the value
}

//cpt10 total minutes------------------

_totalminutesvalueCPT10 = 0;

get totalminutesvalueCPT10() {
    const totalInputs1 = [
        this.formfield.minutesSpent10 || 0,
        this.formfield.othersMin010 || 0
    ];
    return this.sumUnits3(totalInputs1);
}

set totalminutesvalueCPT10(value) {
    this._totalminutesvalueCPT10 = value; // Optionally, you can store the value
}

//--------------------------------units calculator----------------c/editFlowsheetComponent
/*calculateUnits(input) {
    // Check if input is null or empty
    if (!input || input.trim() === '') {
        return ""; // Return empty string for invalid input
    }

    const exercises = input.split(';').filter(exercise => exercise.trim() !== ''); // Filter out empty entries
  
    const output = exercises
      .map(exercise => {
        if (!exercise.includes('-')) {
          return ''; // Skip invalid exercises that don't contain a hyphen
        }

        const [name, minutesStr] = exercise.split('-');
        const minutes = parseInt(minutesStr);

        // Ensure minutes is a valid number
        if (isNaN(minutes)) {
          return `${name}-invalid time`; // Handle invalid time values
        }
  
        // Determine units based on minutes
        let units;
        if (minutes > 0 && minutes <= 22) {
          units = 1;
        } else if (minutes >= 23 && minutes <= 37) {
          units = 2;
        } else if (minutes >= 38 && minutes <= 52) {
          units = 3;
        } else if (minutes >= 53 && minutes <= 67) {
          units = 4;
        } else if (minutes >= 68 && minutes <= 82) {
          units = 5;
        } else if (minutes >= 83 && minutes <= 97) {
          units = 6;
        } else if (minutes >= 98 && minutes <= 112) {
          units = 7;
        } else if (minutes >= 113 && minutes <= 127) {
          units = 8;
        } else {
          units = 8; // For cases where minutes are outside expected ranges
        }
  
        return `${name}-${units} unit${units !== 1 ? 's' : ''}`; // Handle pluralization
      })
      .filter(result => result !== '') // Remove empty or invalid results
      .join(';');
  
    return output;
}*/

 calculateUnits(input) {
    // Check if input is null or empty
    if (!input || input.trim() === '') {
        return ""; // Return empty string for invalid input
    }

    const exercises = input.split(';').filter(exercise => exercise.trim() !== ''); // Filter out empty entries

    const output = exercises
        .map(exercise => {
            if (!exercise.includes('-')) {
                return ''; // Skip invalid exercises
            }

            const lastDashIndex = exercise.lastIndexOf('-');
            const name = exercise.substring(0, lastDashIndex).trim();
            const minutesStr = exercise
                .substring(lastDashIndex + 1)
                .replace(/[^0-9]/g, '') // Remove non-numeric characters (e.g., " Minutes")
                .trim();

            const minutes = parseInt(minutesStr);

            if (isNaN(minutes)) {
                return `${name}-invalid time`; // Handle invalid time values
            }

            // Determine units based on minutes
            let units;
            if (minutes >= 8 && minutes <= 22) {
                units = 1;
            } else if (minutes >= 23 && minutes <= 37) {
                units = 2;
            } else if (minutes >= 38 && minutes <= 52) {
                units = 3;
            } else if (minutes >= 53 && minutes <= 67) {
                units = 4;
            } else if (minutes >= 68 && minutes <= 82) {
                units = 5;
            } else if (minutes >= 83 && minutes <= 97) {
                units = 6;
            } else if (minutes >= 98 && minutes <= 112) {
                units = 7;
            } else if (minutes >= 113) {
                units = 8; // For 113+ minutes
            }
            else {
                units = 0;
            }

            return `${name}-${units} unit${units !== 1 ? 's' : ''}`; // Handle pluralization
        })
        .filter(result => result !== '') // Remove empty or invalid results
        .join(';');

    return output;
}

//------------------------total units convertr and calculator-------------------------
/*
sumUnitscalculator(inputStrings) {
    let totalMinutes = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {  // Ignore null, undefined, or empty strings
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    if (parts.length > 1) {
                        const minutesStr = parts[1].match(/\d+/); // Extract the number
                        if (minutesStr) {
                            totalMinutes += parseInt(minutesStr[0], 10); // Convert to integer and add to totalMinutes
                        }
                    }
                });
            }
        });
    }

    // Convert total minutes to units
    return this.calculateUnitsFromMinutes(totalMinutes);
}

calculateUnitsFromMinutes(totalMinutes) {
    if (totalMinutes > 8 && totalMinutes <= 22) {
        return 1;
    } else if (totalMinutes >= 23 && totalMinutes <= 37) {
        return 2;
    } else if (totalMinutes >= 38 && totalMinutes <= 52) {
        return 3;
    } else if (totalMinutes >= 53 && totalMinutes <= 67) {
        return 4;
    } else if (totalMinutes >= 68 && totalMinutes <= 82) {
        return 5;
    } else if (totalMinutes >= 83 && totalMinutes <= 97) {
        return 6;
    } else if (totalMinutes >= 98 && totalMinutes <= 112) {
        return 7;
    } else if (totalMinutes >= 113) {
        return 8;
    } else {
        return 0; // Handle cases where totalMinutes is 0 or invalid
    }
}*/

sumUnitscalculator(inputStrings) {
    let totalMinutes = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    if (parts.length > 2) {
                        const minutesStr = parts[2].match(/\d+/); // Extract duration from third part
                        if (minutesStr) {
                            totalMinutes += parseInt(minutesStr[0], 10);
                        }
                    }
                });
            }
        });
    }

    return this.calculateUnitsFromMinutes(totalMinutes);
}

calculateUnitsFromMinutes(totalMinutes) {
    if (totalMinutes >= 8 && totalMinutes <= 22) {
        return 1;
    } else if (totalMinutes >= 23 && totalMinutes <= 37) {
        return 2;
    } else if (totalMinutes >= 38 && totalMinutes <= 52) {
        return 3;
    } else if (totalMinutes >= 53 && totalMinutes <= 67) {
        return 4;
    } else if (totalMinutes >= 68 && totalMinutes <= 82) {
        return 5;
    } else if (totalMinutes >= 83 && totalMinutes <= 97) {
        return 6;
    } else if (totalMinutes >= 98 && totalMinutes <= 112) {
        return 7;
    } else if (totalMinutes >= 113) {
        return 8;
    } else {
        return 0;
    }
}

//----------------------------------------------------------
getUnits(minutes) {
   let units;
   if (minutes >= 8 && minutes <= 22) {
     units = 1;
   } else if (minutes >= 23 && minutes <= 37) {
     units = 2;
   } else if (minutes >= 38 && minutes <= 52) {
     units = 3;
   } else if (minutes >= 53 && minutes <= 67) {
     units = 4;
   } else if (minutes >= 68 && minutes <= 82) {
     units = 5;
   } else if (minutes >= 83 && minutes <= 97) {
     units = 6;
   } else if (minutes >= 98 && minutes <= 112) {
     units = 7;
   } else if (minutes >= 113 ) {
     units = 8;
   } else {
     units = 0; // Default to 8 if minutes exceed expected range
   }
   return units;
 }
 

//------------------------total units caluculator-----------------c/editFlowsheetComponent

sumUnits(inputStrings) {
    let totalSum = 0;

        if (inputStrings && Array.isArray(inputStrings)) {
            inputStrings.forEach(input => {
                if (input && input.trim() !== '') {  // Ignore null, undefined, or empty strings
                    const exercises = input.split(';');
                    exercises.forEach(exercise => {
                        const parts = exercise.split('-');
                        const lastPart = parts[parts.length - 1]; // Get the last part after the last '-'
                        
                        const unitStr = lastPart.match(/(\d+)(?=\s*Minute[s]?)/i); // Match number before 'Minute' or 'Minutes' (case-insensitive)
                        if (unitStr) {
                            totalSum += parseInt(unitStr[0], 10); // Convert to integer and add to totalSum
                        }
                    });
                }
            });
        }
    
    return totalSum;
}

 sumUnits2(inputStrings) {
    let totalSum = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {  // Ignore null, undefined, or empty strings
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    const lastPart = parts[parts.length - 1]; // Get the last part after the last '-'
                    
                    const unitStr = lastPart.match(/(\d+)(?=\s*Minute[s]?)/i); // Match number before 'Minute' or 'Minutes' (case-insensitive)
                    if (unitStr) {
                        totalSum += parseInt(unitStr[0], 10); // Convert to integer and add to totalSum
                    }
                });
            }
        });
    }

    return totalSum;
}


sumUnits3(inputStrings) {
    let totalSum = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {  // Ignore null, undefined, or empty strings
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    const lastPart = parts[parts.length - 1]; // Get the last part after the last '-'
                    
                    const unitStr = lastPart.match(/(\d+)(?=\s*Minute[s]?)/i); // Match number before 'Minute' or 'Minutes' (case-insensitive)
                    if (unitStr) {
                        totalSum += parseInt(unitStr[0], 10); // Convert to integer and add to totalSum
                    }
                });
            }
        });
    }

    return totalSum;
}


//------------------------submit for Approval----------------------
/*
handleApprovalSubmit(){
    const fields = {
        Id: this.recordId, 
        Status__c: 'Provider_Review', 
        Flowsheet__c:this.flowSheetId,
        FlowSheet_Generated__c:true
    };

        const recordInput = { fields };

    
    updateRecord(recordInput).then(() => {
        // Handle success, show success toast or message
        //this.handleNavSelection();
        this.dispatchEvent(new CustomEvent('close'))
        this.showToast('Success', 'Exercise\'s Added Successfully', 'success');
        this.status='Aproval sucess'
    })
    .catch(error => {
        // Handle error, show error toast or message
        this.status='Aproval failed'
        this.showToast('Error', error.body.message, 'error');
    });
}
*/
//---------------------------------------------------------------------

showToast(title, message, variant) {
    // Correctly creating and dispatching a toast event
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(event);
}


//-------------------comboboxData1--------------------------------------------------
@track comboboxData1 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}   ];

@track comboboxOtherData1 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false,Chiro:false} ];


handleOtherPtOtChiroCheckboxChange(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot = false;
            comboboxItem.Chiro =false;
        } else if (label === 'Ot') {
             comboboxItem.Pt =false;
             comboboxItem.Ot = isChecked;
             comboboxItem.Chiro =false;
        }else if (label === 'Chiro') {
            comboboxItem.Pt =false;
            comboboxItem.Ot = false;
            comboboxItem.Chiro = isChecked;
        }
    }
    console.log('checkbox values'+isChecked);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false && comboboxItem.Chiro ==false){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}

 
 handleAddComboboxOtherData() {
    const newId = this.comboboxOtherData1.length + 1;
    this.comboboxOtherData1.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:false,
        Chiro:false
        
    });
}

handleComboboxChangeOther(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxOtherData1.map(option => option.value).join(';');
    this.formfield.others1 = concatenatedString;
    console.log( concatenatedString);

    console.log( this.formfield.others1);
    console.log( this.formfield);
    this.updateFormFieldsFromComboboxData();


}

handleChangeOther(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin01 = resultString;
this.updateFormFieldsFromComboboxData();

}
//---------------------------------------
updateFormFieldsFromComboboxData() {
    this.formfield.others1 = this.comboboxOtherData1.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin01 = this.comboboxOtherData1.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');


}
//------------------------------------------
handleAddCombobox() {
    const newId = this.comboboxData1.length + 1;
    this.comboboxData1.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

handleComboboxChange(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData1.map(option => option.value).join(';');
    this.formfield.Excercise1 = concatenatedString;
    console.log( this.formfield.Excercise1);
    console.log( this.formfield);

}

handleChange(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData1.find((item) => item.id == selectedId);
    /*if (value === '' || value === null) {
        // Throw error if the value is null or empty
        event.target.setCustomValidity('This field is required.');
    } */
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent1 = resultString;
//this.formfield.UnitsSpent1=this.calculateUnits(resultString);
//console.log(this.formfield.UnitsSpent1);
}
deleteHandler(event){
const minSpentId=event.target.name;

this.comboboxData1 = this.comboboxData1.filter(item => item.id !== minSpentId);
this.comboboxData1 = this.comboboxData1.map((item, index) => ({
    ...item,
    id: index + 1 // Assign new sequential ids starting from 1
}));

console.log(this.comboboxData1);
this.formfield.minutesSpent1 =this.comboboxData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.Excercise1 = this.comboboxData1.map(option => option.value).join(';');
console.log(this.formfield);

}

deleteHandlerOther(event) {
    const minSpentId = parseInt(event.target.name, 10);

    // Remove the selected item
    this.comboboxOtherData1 = this.comboboxOtherData1.filter(item => item.id !== minSpentId);

    // Reassign sequential IDs to maintain order
    this.comboboxOtherData1 = this.comboboxOtherData1.map((item, index) => ({
        ...item,
        id: index + 1 
    }));

    console.log('Updated comboboxOtherData1:', this.comboboxOtherData1);

    // Update formfield.others1
    this.formfield.others1 = this.comboboxOtherData1
        .map(item => `${item.value}-${item.Min || '0'} Minutes`)
        .join(';');

    // Also update formfield.othersMin01
    this.formfield.othersMin01 = this.comboboxOtherData1.length
        ? this.comboboxOtherData1.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';')
        : ''; // Clear if empty

    console.log('Updated others1:', this.formfield.others1);
    console.log('Updated othersMin01:', this.formfield.othersMin01);
}




get hideButtonProperty() {
    // Check each entry in comboboxData1 for the conditions
   // return this.comboboxData1.every(item => item.value === '' && item.Min === '');
}


//---------------------------comboboxData2----------------------------------------------
@track comboboxData2 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}   ];

@track comboboxOtherData2 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:false,Ot:true} ];;



handleOtherPtOtCheckboxChange2(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData2.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot = false;
        } else if (label === 'Ot') {
            comboboxItem.Ot = isChecked;
            comboboxItem.Pt = false;
        }
    }
    console.log('checkbox values'+this.comboboxOtherData2);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false ){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}


 
 handleAddComboboxOtherData2() {
    const newId = this.comboboxOtherData2.length + 1;
    this.comboboxOtherData2.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,Pt:false,
        Ot:true
        
    });
}

handleComboboxChangeOther2(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData2.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData2.map(option => option.value).join(';');
    this.formfield.others2 = concatenatedString;
    this.updateFormFieldsFromComboboxData2();

}

handleChangeOther2(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData2.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData2.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin02 = resultString;
this.updateFormFieldsFromComboboxData2();

}
//---------------------------------
updateFormFieldsFromComboboxData2() {
    this.formfield.others2 = this.comboboxOtherData2.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin02 = this.comboboxOtherData2.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');


}
//---------------------------------

handleAddCombobox2() {
    const newId = this.comboboxData2.length + 1;
    this.comboboxData2.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true
    });

}

handleComboboxChange2(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData2.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData2.map(option => option.value).join(';');
    this.formfield.Excercise2 = concatenatedString;
    console.log( this.formfield.Excercise2);
    console.log( this.formfield);

}

handleChange2(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData2.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData2.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent2 = resultString;
}  
deleteHandler2(event){
    const minSpentId=event.target.name;
    
    this.comboboxData2 = this.comboboxData2.filter(item => item.id !== minSpentId);
    this.comboboxData2 = this.comboboxData2.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData2);
    this.formfield.minutesSpent2 =this.comboboxData2.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise2 = this.comboboxData2.map(option => option.value).join(';');
    console.log(this.formfield);
}
get hideButtonProperty2() {
    // Check each entry in comboboxData for the conditions
    //return this.comboboxData2.every(item => item.value === '' && item.Min === '');
}
deleteHandlerOther2(event) {
    const minSpentId = parseInt(event.target.name, 10);

    // Remove the selected item
    this.comboboxOtherData2 = this.comboboxOtherData2.filter(item => item.id !== minSpentId);

    // Reassign sequential IDs to maintain order
    this.comboboxOtherData2 = this.comboboxOtherData2.map((item, index) => ({
        ...item,
        id: index + 1 
    }));

    console.log('Updated comboboxOtherData2:', this.comboboxOtherData2);

    // Update formfield.others1
    this.formfield.others2 = this.comboboxOtherData2
        .map(item => `${item.value}-${item.Min || '0'} Minutes`)
        .join(';');

    // Also update formfield.othersMin02
    this.formfield.othersMin02 = this.comboboxOtherData2.length
        ? this.comboboxOtherData2.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';')
        : ''; // Clear if empty

    console.log('Updated others2:', this.formfield.others2);
    console.log('Updated othersMin02:', this.formfield.othersMin02);
}

//-------------------------------------------------------------------------
//---------------------------comboboxData3----------------------------------------------
@track comboboxData3 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];

@track comboboxOtherData3 = [{ id: 1, label: 'Other 1', value: 'Kinetisense',Min:'15',showDelete:true,Pt:true,Ot:false}  ];
 // @track comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:false}   ];

handleOtherPtOtCheckboxChange3(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData3.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot =false;
        } else if (label === 'Ot') {
            comboboxItem.Pt =false;
            comboboxItem.Ot = isChecked;
        }
    }
    console.log('checkbox values'+this.comboboxOtherData3);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false ){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}

 
 handleAddComboboxOtherData3() {
    const newId = this.comboboxOtherData3.length + 1;
    this.comboboxOtherData3.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:false
        
    });
}

handleComboboxChangeOther3(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData3.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData3.map(option => option.value).join(';');
    this.formfield.others3 = concatenatedString;
    this.updateFormFieldsFromComboboxData3();

}

handleChangeOther3(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData3.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData3.map(item => `${item.value}-${item.Min || ''} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin03 = resultString;
this.updateFormFieldsFromComboboxData3();

}
//---------------------
updateFormFieldsFromComboboxData3() {
    this.formfield.others3 = this.comboboxOtherData3.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin03 = this.comboboxOtherData3.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}

//---------------------
//--------------------------handleChangeOther3 for auto added other exercises---------

handleChangeOtherForOtherExercises3(){
    if(this.handleChangeOtherForOtherExercises3Flag==true){
       // this.formfield.othersMin03 ='Kinetisense -15 Minutes';
    this.handleChangeOtherForOtherExercises3Flag=false;
    console.log('my handleChangeOtherForOtherExercises3Flag is : '+this.handleChangeOtherForOtherExercises3Flag);
    //this.comboboxOtherData3 = [{ id: 1, label: 'Other 1', value: 'Kinetisense',Min:'15',showDelete:true,Pt:true,Ot:false}  ];
   // this.comboboxOtherData3 = [{ id: 1, label: '', value: '',Min:'',showDelete:true,Pt:true,Ot:false}  ];

    }
    
}

handleAddCombobox3() {
    const newId = this.comboboxData3.length + 1;
    this.comboboxData3.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true
    });
}

handleComboboxChange3(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData3.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData3.map(option => option.value).join(';');
    this.formfield.Excercise3 = concatenatedString;
    console.log( this.formfield.Excercise3);
    console.log( this.formfield);

}

handleChange3(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData3.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData3.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent3 = resultString;
}  
deleteHandler3(event){
    const minSpentId=event.target.name;
    
    this.comboboxData3 = this.comboboxData3.filter(item => item.id !== minSpentId);
    this.comboboxData3 = this.comboboxData3.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData3);
    this.formfield.minutesSpent3 =this.comboboxData3.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise3 = this.comboboxData3.map(option => option.value).join(';');
    console.log(this.formfield);
    
    }
    get hideButtonProperty3() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData3.every(item => item.value === '' && item.Min === '');
    }

    deleteHandlerOther3(event) {
        const minSpentId = parseInt(event.target.name, 10); // Ensure ID is an integer
    
        // Filter out the deleted item
        this.comboboxOtherData3 = this.comboboxOtherData3.filter(item => item.id !== minSpentId);
    
        // Reassign sequential IDs
        this.comboboxOtherData3 = this.comboboxOtherData3.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
    
        console.log(this.comboboxOtherData3);
    
        // Update formfield.others3
        this.formfield.others3 = this.comboboxOtherData3.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
    
        // Ensure othersMin05 is updated correctly
        if (this.comboboxOtherData3.length === 0) {
            this.formfield.othersMin03 = ''; // Clear if no items left
        } else {
            this.formfield.othersMin03 = this.comboboxOtherData3.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
        }
    
        console.log('Updated othersMin03:', this.formfield.othersMin03);
    }
    

    

//-------------------------------------------------------------------------
//---------------------------comboboxData4----------------------------------------------
@track comboboxData4 = [ { id: 1, label: 'Exercise 1', value: '',Min:'' ,showDelete:true }   ];

@track comboboxOtherData4 = [{ id: 1, label: 'Other 1', value: 'See Daily Note',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}    ];


handleOtherPtOtChiroCheckboxChange4(event) {        
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData4.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot =false;
            comboboxItem.Chiro =false;
        } else if (label === 'Ot') {
            comboboxItem.Pt =false;
            comboboxItem.Ot = isChecked;
            comboboxItem.Chiro =false;
        }else if (label === 'Chiro') {
            comboboxItem.Pt =false;
            comboboxItem.Ot =false;
            comboboxItem.Chiro = isChecked;
        }
    }
    console.log('checkbox values'+isChecked);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false && comboboxItem.Chiro ==false){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}

 
 handleAddComboboxOtherData4() {
    const newId = this.comboboxOtherData4.length + 1;
    this.comboboxOtherData4.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:false,
        Chiro:false
        
    });
}

handleComboboxChangeOther4(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData4.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData4.map(option => option.value).join(';');
    this.formfield.others4 = concatenatedString;
    this.updateFormFieldsFromComboboxData4();
}

handleChangeOther4(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData4.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData4.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin04 = resultString;
this.updateFormFieldsFromComboboxData4();

}
//---------------------
updateFormFieldsFromComboboxData4() {
    this.formfield.others4 = this.comboboxOtherData4.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin04 = this.comboboxOtherData4.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}

//---------------------

handleAddCombobox4() {
    const newId = this.comboboxData4.length + 1;
    this.comboboxData4.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true
    });
}

handleComboboxChange4(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData4.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData4.map(option => option.value).join(';');
    this.formfield.Excercise4 = concatenatedString;
    console.log( this.formfield.Excercise4);
    console.log( this.formfield);

}

handleChange4(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData4.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData4.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent4 = resultString;
}  
deleteHandler4(event){
    const minSpentId=event.target.name;
    
    this.comboboxData4 = this.comboboxData4.filter(item => item.id !== minSpentId);
    this.comboboxData4 = this.comboboxData4.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData4);
    this.formfield.minutesSpent4 =this.comboboxData4.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise4 = this.comboboxData4.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }
    get hideButtonProperty4() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData4.every(item => item.value === '' && item.Min === '');
    }

    deleteHandlerOther4(event) {
        const minSpentId = parseInt(event.target.name, 10); // Ensure ID is an integer
    
        // Filter out the deleted item
        this.comboboxOtherData4 = this.comboboxOtherData4.filter(item => item.id !== minSpentId);
    
        // Reassign sequential IDs
        this.comboboxOtherData4 = this.comboboxOtherData4.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
    
        console.log(this.comboboxOtherData4);
    
        // Update formfield.others5
        this.formfield.others4 = this.comboboxOtherData4.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
    
        // Ensure othersMin05 is updated correctly
        if (this.comboboxOtherData4.length === 0) {
            this.formfield.othersMin04 = ''; // Clear if no items left
        } else {
            this.formfield.othersMin04 = this.comboboxOtherData4.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
        }
    
        console.log('Updated othersMin04:', this.formfield.othersMin04);
    }

    handleChangeOtherForOtherExercises4(){
        if(this.handleChangeOtherForOtherExercises4Flag==true){
           // this.formfield.othersMin04 ='See Daily Note -15 Minutes';
        this.handleChangeOtherForOtherExercises4Flag=false;
        console.log('my handleChangeOtherForOtherExercises4Flag is : '+this.handleChangeOtherForOtherExercises4Flag);
       // this.comboboxOtherData4 = [{ id: 1, label: 'Other 1', value: 'See Daily Note',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];
    
        }
        
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData5----------------------------------------------
@track comboboxData5 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true }   ];

@track comboboxOtherData5 = [{ id: 1, label: 'Other 1', value: 'Physical Performance Test ',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];

handleOtherPtOtChiroCheckboxChange5(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData5.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot = false;
            comboboxItem.Chiro =false;

        } else if (label === 'Ot') {
            comboboxItem.Pt = false;
            comboboxItem.Ot = isChecked;
            comboboxItem.Chiro =false;
        }else if (label === 'Chiro') {
            comboboxItem.Pt = false;
            comboboxItem.Ot = false;
            comboboxItem.Chiro = isChecked;
        }
    }
    console.log('checkbox values'+isChecked);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false && comboboxItem.Chiro ==false){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}


 
 handleAddComboboxOtherData5() {
    const newId = this.comboboxOtherData5.length + 1;
    this.comboboxOtherData5.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:false,
        Chiro:false
        
    });
}

handleComboboxChangeOther5(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData5.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData5.map(option => option.value).join(';');
    this.formfield.others5 = concatenatedString;
    this.updateFormFieldsFromComboboxData5();

}

handleChangeOther5(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData5.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData5.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin05 = resultString;
this.updateFormFieldsFromComboboxData5();

}
//-------------------------------
updateFormFieldsFromComboboxData5() {
    this.formfield.others5 = this.comboboxOtherData5.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin05 = this.comboboxOtherData5.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}

//---------------------------------

//--------------------------handleChangeOther5 for auto added other exercises---------

handleChangeOtherForOtherExercises5(){
    if(this.handleChangeOtherForOtherExercises5Flag==true){
      //  this.formfield.othersMin05 ='Physical Performance Test -15 Minutes';
    this.handleChangeOtherForOtherExercises5Flag=false;
    console.log('my handleChangeOtherForOtherExercises5Flag is : '+this.handleChangeOtherForOtherExercises5Flag);
    //this.comboboxOtherData5 = [{ id: 1, label: 'Other 1', value: 'Physical Performance Test ',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];


    }
    
}


//----------------------------------------------------------------------------------
handleAddCombobox5() {
    const newId = this.comboboxData5.length + 1;
    this.comboboxData5.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true

    });
}

handleComboboxChange5(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData5.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData5.map(option => option.value).join(';');
    this.formfield.Excercise5 = concatenatedString;
    console.log( this.formfield.Excercise5);
    console.log( this.formfield);

}

handleChange5(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData5.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData5.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent5 = resultString;
}  
deleteHandler5(event){
    const minSpentId=event.target.name;
    
    this.comboboxData5 = this.comboboxData5.filter(item => item.id !== minSpentId);
    this.comboboxData5 = this.comboboxData5.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData5);
    this.formfield.minutesSpent5 =this.comboboxData5.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise5 = this.comboboxData5.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }

    deleteHandlerOther5(event) {
        const minSpentId = parseInt(event.target.name, 10); // Ensure ID is an integer
    
        // Filter out the deleted item
        this.comboboxOtherData5 = this.comboboxOtherData5.filter(item => item.id !== minSpentId);
    
        // Reassign sequential IDs
        this.comboboxOtherData5 = this.comboboxOtherData5.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
    
        console.log(this.comboboxOtherData5);
    
        // Update formfield.others5
        this.formfield.others5 = this.comboboxOtherData5.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
    
        // Ensure othersMin05 is updated correctly
        if (this.comboboxOtherData5.length === 0) {
            this.formfield.othersMin05 = ''; // Clear if no items left
        } else {
            this.formfield.othersMin05 = this.comboboxOtherData5.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
        }
    
        console.log('Updated othersMin05:', this.formfield.othersMin05);
    }
    

        get hideButtonProperty5() {
            // Check each entry in comboboxData1 for the conditions
            //return this.comboboxData5.every(item => item.value === '' && item.Min === '');
        }

//-------------------------------------------------------------------------
//---------------------------comboboxData6----------------------------------------------
@track comboboxData6 = [ { id: 1, label: 'Exercise 1', value: '',Min:'' ,showDelete:true}   ];

@track comboboxOtherData6 = [{ id: 1, label: 'Other 1', value: 'Traction',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];

handleOtherPtOtChiroCheckboxChange6(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData6.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot = false;
            comboboxItem.Chiro = false;
        } else if (label === 'Ot') {
             comboboxItem.Pt = false;
            comboboxItem.Ot = isChecked;
            comboboxItem.Chiro = false;
        }else if (label === 'Chiro') {
            comboboxItem.Pt = false;
            comboboxItem.Ot = false;
            comboboxItem.Chiro = isChecked;
        }
    }
    console.log('checkbox values'+isChecked);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false && comboboxItem.Chiro ==false){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}

 
 handleAddComboboxOtherData6() {
    const newId = this.comboboxOtherData6.length + 1;
    this.comboboxOtherData6.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:false,
        Chiro:false
        
    });
}

handleComboboxChangeOther6(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData6.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData6.map(option => option.value).join(';');
    this.formfield.others6 = concatenatedString;
    this.updateFormFieldsFromComboboxData6();

}

handleChangeOther6(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData6.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData6.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin06 = resultString;

this.updateFormFieldsFromComboboxData6();

}

//-----------------------------
updateFormFieldsFromComboboxData6() {
    this.formfield.others6 = this.comboboxOtherData6.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin06 = this.comboboxOtherData6.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//-----------------------------

//--------------------------handleChangeOther6 for auto added other exercises---------

handleChangeOtherForOtherExercises6(){
    if(this.handleChangeOtherForOtherExercises6Flag==true){
       // this.formfield.othersMin06 ='Traction -15 Minutes';
    this.handleChangeOtherForOtherExercises6Flag=false;
    console.log('my handleChangeOtherForOtherExercises6Flag is : '+this.handleChangeOtherForOtherExercises6Flag);
    //this.comboboxOtherData6 = [{ id: 1, label: 'Other 1', value: 'Traction',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false}  ];

    }
    
}


handleAddCombobox6() {
    const newId = this.comboboxData6.length + 1;
    this.comboboxData6.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true
    });
}

handleComboboxChange6(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData6.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData6.map(option => option.value).join(';');
    this.formfield.Excercise6 = concatenatedString;
    console.log( this.formfield.Excercise6);
    console.log( this.formfield);

}

handleChange6(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData6.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData6.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent6 = resultString;
}  
deleteHandler6(event){
    const minSpentId=event.target.name;
    
    this.comboboxData6 = this.comboboxData6.filter(item => item.id !== minSpentId);
    this.comboboxData6 = this.comboboxData6.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData6);
    this.formfield.minutesSpent6 =this.comboboxData6.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise6 = this.comboboxData6.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }

    deleteHandlerOther6(event) {
        const minSpentId = parseInt(event.target.name, 10); // Ensure ID is an integer
    
        // Filter out the deleted item
        this.comboboxOtherData6 = this.comboboxOtherData6.filter(item => item.id !== minSpentId);
    
        // Reassign sequential IDs
        this.comboboxOtherData6 = this.comboboxOtherData6.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
    
        console.log(this.comboboxOtherData6);
    
        // Update formfield.others5
        this.formfield.others6 = this.comboboxOtherData6.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
    
        // Ensure othersMin05 is updated correctly
        if (this.comboboxOtherData6.length === 0) {
            this.formfield.othersMin06 = ''; // Clear if no items left
        } else {
            this.formfield.othersMin06 = this.comboboxOtherData6.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
        }
    
        console.log('Updated othersMin06:', this.formfield.othersMin06);
    }
    
        get hideButtonProperty6() {
            // Check each entry in comboboxData1 for the conditions
            //return this.comboboxData6.every(item => item.value === '' && item.Min === '');
        }

//-------------------------------------------------------------------------
//---------------------------comboboxData7----------------------------------------------
@track comboboxData7 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}   ];

@track comboboxOtherData7 = [ { id: 1, label: 'Other 1', value: 'VALD',Min:'15',showDelete:true,Pt:true,Ot:false,Chiro:false} ];

handleOtherPtOtChiroCheckboxChange7(event) {
    const selectedId = event.target.name;
    const label = event.target.label;
    const isChecked = event.target.checked;

    const comboboxItem = this.comboboxOtherData7.find((item) => item.id == selectedId);
    if (comboboxItem) {
        if (label === 'Pt') {
            comboboxItem.Pt = isChecked;
            comboboxItem.Ot = false;
            comboboxItem.Chiro =false;

        } else if (label === 'Ot') {
            comboboxItem.Pt = false;
            comboboxItem.Ot = isChecked;
            comboboxItem.Chiro =false;
        }else if (label === 'Chiro') {
            comboboxItem.Pt = false;
            comboboxItem.Ot = false;
            comboboxItem.Chiro = isChecked;
        }
    }
    console.log('checkbox values'+isChecked);
    if( comboboxItem.Pt ==false && comboboxItem.Ot == false && comboboxItem.Chiro ==false){
            alert('At least ANY one of PT,OT,Chiro checkbox should be checked');
    }
}


 
 handleAddComboboxOtherData7() {
    const newId = this.comboboxOtherData7.length + 1;
    this.comboboxOtherData7.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,Pt:true
       
        
    });
}

handleComboboxChangeOther7(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData7.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData7.map(option => option.value).join(';');
    this.formfield.others7 = concatenatedString;
    this.updateFormFieldsFromComboboxData7();

}

handleChangeOther7(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData7.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin07 = resultString;
this.updateFormFieldsFromComboboxData7();

}
//-----------------------
updateFormFieldsFromComboboxData7() {
    this.formfield.others7 = this.comboboxOtherData7.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin07 = this.comboboxOtherData7.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//-----------------------

handleAddCombobox7() {
    const newId = this.comboboxData7.length + 1;
    this.comboboxData7.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true

    });
}

handleComboboxChange7(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData7.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData7.map(option => option.value).join(';');
    this.formfield.Excercise7 = concatenatedString;
    console.log( this.formfield.Excercise7);
    console.log( this.formfield);

}

handleChange7(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData7.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent7 = resultString;
}  
deleteHandler7(event){
    const minSpentId=event.target.name;
    
    this.comboboxData7 = this.comboboxData7.filter(item => item.id !== minSpentId);
    this.comboboxData7 = this.comboboxData7.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData7);
    this.formfield.minutesSpent7 =this.comboboxData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise7 = this.comboboxData7.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }/*
    deleteHandlerOther7(event){
        const minSpentId=event.target.name;
        
        this.comboboxOtherData7 = this.comboboxOtherData7.filter(item => item.id !== minSpentId);
        this.comboboxOtherData7 = this.comboboxOtherData7.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
        
        console.log(this.comboboxData7);
        this.formfield.others7 =this.comboboxOtherData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
        .join(';');
       
        
        }*/

        deleteHandlerOther7(event) {
    const minSpentId = parseInt(event.target.name, 10); // Ensure ID is an integer

    // Filter out the deleted item
    this.comboboxOtherData7 = this.comboboxOtherData7.filter(item => item.id !== minSpentId);

    // Reassign sequential IDs
    this.comboboxOtherData7 = this.comboboxOtherData7.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));

    console.log(this.comboboxOtherData7);

    // Update formfield.others7
    this.formfield.others7 = this.comboboxOtherData7.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');

    // Ensure othersMin07 is updated correctly
    if (this.comboboxOtherData7.length === 0) {
        this.formfield.othersMin07 = ''; // Clear if no items left
    } else {
        this.formfield.othersMin07 = this.comboboxOtherData7.map(item => `${item.value}-${item.Min || '0'} Minutes`).join(';');
    }

    console.log('Updated othersMin07:', this.formfield.othersMin07);
}


        get hideButtonProperty7() {
            // Check each entry in comboboxData1 for the conditions
            //return this.comboboxData7.every(item => item.value === '' && item.Min === '');
        }
//-------------------------------------------------------------------------
//---------------------------comboboxData8----------------------------------------------
@track comboboxData8 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}   ];

@track comboboxOtherData8 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:true} ];




 
 handleAddComboboxOtherData8() {
    const newId = this.comboboxOtherData8.length + 1;
    this.comboboxOtherData8.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:true
        
    });
}

handleComboboxChangeOther8(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData8.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData8.map(option => option.value).join(';');
    this.formfield.others8 = concatenatedString;
    this.updateFormFieldsFromComboboxData8();

}

handleChangeOther8(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData8.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin08 = resultString;
this.updateFormFieldsFromComboboxData8();
}
//---------------
updateFormFieldsFromComboboxData8() {
    this.formfield.others8 = this.comboboxOtherData8.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin08 = this.comboboxOtherData8.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//---------------
handleAddCombobox8() {
    const newId = this.comboboxData8.length + 1;
    this.comboboxData8.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true

    });
    
}

handleComboboxChange8(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData8.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData8.map(option => option.value).join(';');
    this.formfield.Excercise8 = concatenatedString;
    console.log( this.formfield.Excercise8);
    console.log( this.formfield);

}

handleChange8(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData8.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent8 = resultString;
}  
deleteHandler8(event){
    const minSpentId=event.target.name;
    
    this.comboboxData8 = this.comboboxData8.filter(item => item.id !== minSpentId);
    this.comboboxData8 = this.comboboxData8.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData8);
    this.formfield.minutesSpent8 =this.comboboxData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise8 = this.comboboxData8.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }

    deleteHandlerOther8(event){
        const minSpentId=event.target.name;
        
        this.comboboxOtherData8 = this.comboboxOtherData8.filter(item => item.id !== minSpentId);
        this.comboboxOtherData8 = this.comboboxOtherData8.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
        
        console.log(this.comboboxData8);
        this.formfield.others8 =this.comboboxOtherData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
        .join(';');
       
        
        }

        get hideButtonProperty8() {
            // Check each entry in comboboxData1 for the conditions
            //return this.comboboxData8.every(item => item.value === '' && item.Min === '');
        }
//-------------------------------------------------------------------------
//---------------------------comboboxData9----------------------------------------------
@track comboboxData9 = [ { id: 1, label: 'Exercise 1', value: '',Min:'' ,showDelete:true}   ];


@track comboboxOtherData9 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:true} ];




 
 handleAddComboboxOtherData9() {
    const newId = this.comboboxOtherData9.length + 1;
    this.comboboxOtherData9.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:true
        
    });
}

handleComboboxChangeOther9(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData9.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData9.map(option => option.value).join(';');
    this.formfield.others9 = concatenatedString;
    this.updateFormFieldsFromComboboxData9();

}

handleChangeOther9(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData9.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin09 = resultString;
this.updateFormFieldsFromComboboxData9();

}
//----------------------
updateFormFieldsFromComboboxData9() {
    this.formfield.others9 = this.comboboxOtherData9.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin09 = this.comboboxOtherData9.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//----------------------

handleAddCombobox9() {
    const newId = this.comboboxData9.length + 1;
    this.comboboxData9.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true

    });
}

handleComboboxChange9(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData9.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData9.map(option => option.value).join(';');
    this.formfield.Excercise9 = concatenatedString;
    console.log( this.formfield.Excercise9);
    console.log( this.formfield);

}

handleChange9(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData9.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent9 = resultString;
}  
deleteHandler9(event){
    const minSpentId=event.target.name;
    
    this.comboboxData9 = this.comboboxData9.filter(item => item.id !== minSpentId);
    this.comboboxData9 = this.comboboxData9.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData9);
    this.formfield.minutesSpent9 =this.comboboxData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise9 = this.comboboxData9.map(option => option.value).join(';');
    console.log(this.formfield);   
    
    }

    deleteHandlerOther9(event){
        const minSpentId=event.target.name;
        
        this.comboboxOtherData9 = this.comboboxOtherData9.filter(item => item.id !== minSpentId);
        this.comboboxOtherData9 = this.comboboxOtherData9.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
        
        console.log(this.comboboxData9);
        this.formfield.others9 =this.comboboxOtherData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
        .join(';');
       
        
        }

        get hideButtonProperty9() {
            // Check each entry in comboboxData1 for the conditions
           // return this.comboboxData9.every(item => item.value === '' && item.Min === '');
        }

//-------------------------------------------------------------------------
//---------------------------comboboxData10----------------------------------------------
@track comboboxData10 = [ { id: 1, label: 'Exercise 1', value: '',Min:'',showDelete:true}   ];

@track comboboxOtherData10 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true,Pt:true,Ot:true} ];




 
 handleAddComboboxOtherData10() {
    const newId = this.comboboxOtherData10.length + 1;
    this.comboboxOtherData10.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true,
        Pt:true,
        Ot:true
        
    });
}

handleComboboxChangeOther10(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData10.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData10.map(option => option.value).join(';');
    this.formfield.others10 = concatenatedString;
    this.updateFormFieldsFromComboboxData10();


}

handleChangeOther10(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxOtherData10.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxOtherData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin010 = resultString;
this.updateFormFieldsFromComboboxData10();

}
//---------------
updateFormFieldsFromComboboxData10() {
    this.formfield.others10 = this.comboboxOtherData10.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin010 = this.comboboxOtherData10.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//--------------

handleAddCombobox10() {
    const newId = this.comboboxData10.length + 1;
    this.comboboxData10.push({
        id: newId,
        label: `Exercise ${newId}`,
        value: '',
        Min:'',
        showDelete:true

    });
}

handleComboboxChange10(event) {
    const selectedId = event.target.dataset.id;
    const selectedValue = event.detail.value;
    const comboboxItem = this.comboboxData10.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.value = selectedValue;
    }
    const concatenatedString = this.comboboxData10.map(option => option.value).join(';');
    this.formfield.Excercise10 = concatenatedString;
    console.log( this.formfield.Excercise10);
    console.log( this.formfield);

}

handleChange10(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData10.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent10 = resultString;
}  

deleteHandler10(event){
    const minSpentId=event.target.name;
    
    this.comboboxData10 = this.comboboxData10.filter(item => item.id !== minSpentId);

    this.comboboxData10 = this.comboboxData10.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData10);
    this.formfield.minutesSpent10 =this.comboboxData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.Excercise10 = this.comboboxData10.map(option => option.value).join(';');
    console.log(this.formfield);     
    
    }
    deleteHandlerOther10(event){
        const minSpentId=event.target.name;
        
        this.comboboxOtherData10 = this.comboboxOtherData10.filter(item => item.id !== minSpentId);
        this.comboboxOtherData10 = this.comboboxOtherData10.map((item, index) => ({
            ...item,
            id: index + 1 // Assign new sequential ids starting from 1
        }));
        
        console.log(this.comboboxData10);
        this.formfield.others10 =this.comboboxOtherData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
        .join(';');
       
        
        }
        get hideButtonProperty10() {
            // Check each entry in comboboxData1 for the conditions
            //return this.comboboxData10.every(item => item.value === '' && item.Min === '');
        }
//-------------------------------------------------------------------------
}