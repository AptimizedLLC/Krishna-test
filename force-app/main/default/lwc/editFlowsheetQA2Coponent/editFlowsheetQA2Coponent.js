import { LightningElement ,track,api,wire} from 'lwc';

import { getObjectInfo, getPicklistValues} from 'lightning/uiObjectInfoApi';
import { createRecord,updateRecord ,getRecord} from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from "lightning/actions";
import modal from "@salesforce/resourceUrl/custommodalcss";
import { loadStyle } from "lightning/platformResourceLoader";

import flowSheetObject from '@salesforce/schema/Flowhsheet__c';
import flowSheetId from '@salesforce/schema/Flowhsheet__c.Id';

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
import FLOWSHEET_FIELD from '@salesforce/schema/Appointment__c.Flowsheet__c'; 

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
import Total_Units from '@salesforce/schema/Flowhsheet__c.Total_Units__c';

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

const FlowsheetFIELDS = ['Appointment__c.Flowsheet__c'];



import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
const VISIT_REASON_FIELD = 'Appointment__c.Visit_Reason__c';
// List of keywords for Visit Reason to filter by 
const FILTER_KEYWORDS = ['CHIRO -', 'ESTABLISHED 1 YEAR CMO F/U', 'OT - ', 'PT - ', 'NEW YEAR EVALUATION'];

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

import ApprovalController from '@salesforce/apex/ApprovalController.submitForApproval';
import patientNameVisitReason from '@salesforce/apex/ApprovalController.patientNameVisitReason';
import updateFlowsheets from '@salesforce/apex/ApprovalController.updateFlowsheets';
import returnLatestAppFsRecord from '@salesforce/apex/ApprovalController.returnLatestAppFsRecord';

import lightningModalLWC from 'c/myCheckComponent';
import { refreshApex } from '@salesforce/apex';

export default class EditFlowsheetQA2Coponent extends LightningElement {

      //--------quick action size setup---------------------
      connectedCallback() {
        loadStyle(this, modal);
        console.log('Record ID in Child Component:', this.recordId); // Use this recordId as needed
        this.fetchPatientInfo();
    }
    renderedCallback() {
        if (!this._hasRendered && this.recordId) {
            this._hasRendered = true;
            this.fetchPatientInfo();
            console.log('recordId is now available in renderedCallback:', this.recordId);
            // If you need to do anything once with recordId, do it here
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

// Handler for checkbox change
handleCheckboxValue(event) {
    const checkboxId = event.target.name;

    // Check if the id exists in the isCheckArray and update its value
    if (this.isCheckArray.hasOwnProperty(checkboxId)) {
        this.isCheckArray[checkboxId] = event.target.checked;
    }
}
//---------------------------------------------------------------
    @api recordId;
@track flowSheetId;  



@wire(getRecord, { recordId: '$recordId', fields: FlowsheetFIELDS })
    appointments({ error, data }) {
        if (data) {
            // Extract the 'Id' field value
            this.flowSheetId = data.fields.Flowsheet__c.value;
        }else if (error) {
            console.error('Error:');
        }
    }

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
        others10:''
 
        }

        //--------------------------------------------------------------------
                @track recentAppflowsheetId; // Holds the returned Flowsheet Id
                @wire(returnLatestAppFsRecord, { recordId: '$recordId' ,visitReason:'$visitReason'})
            wiredFlowsheet({ error, data }) {
                if (data) {
                    this.recentAppflowsheetId = data;
                    this.error = undefined;
                    console.log('recent App flowsheet Id is:'+this.recentAppflowsheetId);
                } else if (error) {
                    this.error = error;
                    this.recentAppflowsheetId = undefined;
                }
            }

        /*get nonEmptyMinutesSpent() {
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
                    formattedKey = '99750(Physical Performance Test)'
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
        }*/
        get nonEmptyMinutesSpent() {
    return Object.entries(this.formfield)
        .filter(([key, value]) =>
            // Filter only relevant fields
            (key.startsWith('minutesSpent') || key.startsWith('othersMin')) &&
            (typeof value === 'string' ? value.trim() !== '' : value != null)
        )
        .filter(([key]) => {
            // Get the index from key: e.g., 'minutesSpent4' -> '4', 'othersMin04' -> '04'
            const index = key.replace('minutesSpent', '').replace('othersMin', '');
            const checkboxKey = `checkbox${parseInt(index, 10)}`; // normalize to checkbox1..10
            return this.formfield[checkboxKey] === true;
        })
        .map(([key, value]) => {
            const index = key.replace('minutesSpent', '').replace('othersMin', '');

            let formattedKey;
            switch (index) {
                case '1':
                case '01':
                    formattedKey = '97110(Therapeutic exercises)';
                    break;
                case '2':
                case '02':
                    formattedKey = '97530(Therapeutic activities)';
                    break;
                case '3':
                case '03':
                    formattedKey = '97112(Neuromuscular re-education)';
                    break;
                case '4':
                case '04':
                    formattedKey = '97140(Manual therapy techniques)';
                    break;
                case '5':
                case '05':
                    formattedKey = '97750(Physical Performance Test)';
                    break;
                case '6':
                case '06':
                    formattedKey = '97012(Traction)';
                    break;
                case '7':
                case '07':
                    formattedKey = '95851(Range of Motion Testing)';
                    break;
                case '8':
                case '08':
                    formattedKey = '97016(Normatec/GameReady)';
                    break;
                case '9':
                case '09':
                    formattedKey = '97014/G0283(Premod ES w/ MH or Ice)';
                    break;
                case '10':
                case '010':
                    formattedKey = '9039/S8948(Laser Therapy)';
                    break;
                default:
                    formattedKey = 'Exercise';
            }

            return { formattedKey, value };
        });
}


@wire(getRecord,{recordId: '$flowSheetId', fields: FIELDS})
flowSheetData({ error, data }){
    if (data) {
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

        
        console.log(this.formfield);

        if(this.formfield !== null) {
            this.setcomboboxData();
            this.setcomboboxOtherData();
        }
        
        


}else if (error) {
    console.error('Error fetching record data:');
}

}
//------------------------------------get latest flowsheets for table-----c/editFlowsheetComponent

@track flowsheetRecords;
@track error;
@track wiredResult; // Store the wire result for refreshing
@track showTable=false;

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
/*
@wire(ApprovalController, { recordId: '$recordId',countSize:'$sessionValue', visitReason:'$visitReason' })
wiredContacts(result) {
    this.flowsheetRecords = null; // Store the wire result
    const { error, data } = result;

    if (data) {
        this.showTable=true;
        this.flowsheetRecords = data.map(record => ({
            ...record,
            AppointmentDate: record.Appointment__c ? record.Appointment__r.Appointment_Date__c : 'NA',
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
            OtherExercises2__c: this.splitTextBySemicolon(record.OtherExercises2__c),
            OtherExercises3__c: this.splitTextBySemicolon(record.OtherExercises3__c),
            OtherExercises4__c: this.splitTextBySemicolon(record.OtherExercises4__c),
            OtherExercises5__c: this.splitTextBySemicolon(record.OtherExercises5__c),
            OtherExercises6__c: this.splitTextBySemicolon(record.OtherExercises6__c),
            OtherExercises7__c: this.splitTextBySemicolon(record.OtherExercises7__c),
            OtherExercises8__c: this.splitTextBySemicolon(record.OtherExercises8__c),
            OtherExercises9__c: this.splitTextBySemicolon(record.OtherExercises9__c),
            OtherExercises10__c: this.splitTextBySemicolon(record.OtherExercises10__c)

        }));
        this.error = undefined;
        console.log('Data values:', data);
        console.log('Flow record values:', this.flowsheetRecords);
    } else if (error) {
        this.error = error;
        this.flowsheetRecords = undefined;
        console.error(error);
    }
}*/
@wire(ApprovalController, { recordId: '$recordId',countSize:'$sessionValue',visitReason:'$visitReason' })
wiredContacts(result) {
    this.flowsheetRecords = null; // Store the wire result
    const { error, data } = result;
 
    if (data) {
        console.log('flowsheetRecords are'+JSON.stringify(data));
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
//--------------------------------------------------------------
@track  updateCheck=true;
showModal = true;
    @track result;
    async handleShowModal() {
        const data = `You should clear previous sessions and begin new only if your patient is returning for a new set of PT/OT appointments where the previous set of appointments no longer apply.
        If you clear the previous flowsheet entries, they will be stored in the backend for reporting purposes, but you will NOT be able to pull them back into this screen when entering new flowsheets.
        If you mistakenly clear flowsheets, you will need to start fresh to track the progressions through future appointments.`;
        
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

     
//----------------------------------------------------------------

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






//---------------------------------editflowsheet scxript---
@track cptFlag=true;
    @track ExcerciseFlag=false;
    @track ApprovalFlag=false;

    @track status='not runned';

    @track CptClass="slds-button slds-button_brand";
    @track ExcerciseClass="slds-button slds-button_neutral";
    @track SubmitClass="slds-button slds-button_neutral";

    buttonHandler(event){
        if(event.target.name=='Cpt'){
            this.cptFlag=true;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_neutral";

        }
        if(event.target.name=='Excercise'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
             // Check if all exercise fields are false
             this.throwError();
             
     
         }
         if(event.target.name=='Submit'){
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
 
        }
        if(event.target.name=='Submit'){
            this.cptFlag=false;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=true;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_brand";
        }
        if(event.target.name=='Back'){
            this.cptFlag=true;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_brand";
            this.ExcerciseClass="slds-button slds-button_neutral";
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

            this.comboboxOtherData1 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData2 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData4 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData5 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData6 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData7 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData8 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData9 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];
            this.comboboxOtherData10 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}   ];




        }
        if(event.target.name=='Next'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
            this.throwError();
            
        }
        if(event.target.name=='Back2'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
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
      
        handleCheckboxChange(event) {
            const { value, checked } = event.target;
            this.formfield[value] = checked;
        }

        handleChange(event) {
            const { name, value } = event.target;
            this.formfield[name] = value;
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
    recordTypeId:  '012U8000001anxhIAA'//'012U80000015vZlIAI'//'012UP00000A7RovYAF'//'012U8000001KFTlIAO'//
})
picklistValues({ error, data }) {
    if (data) {
        this.picklistOptions = data.values.map(option => ({
            label: option.label,
            value: option.value
        }));
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.picklistOptions = [];
    }
}

//-------------------------submit handler----------------------------------
@track DisableSubmitHandler=false;
SubmitHandler(){
    
    //
    
    const fields = {};

    this.DisableSubmitHandler=true;
    
        fields[flowSheetId.fieldApiName]=this.flowSheetId;
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
        fields[Total_Units.fieldApiName]=this.totalunitsValue;//sumUnitscalculator(inputs);

        fields[otherExercises1.fieldApiName]=this.formfield.othersMin01;
        fields[otherExercisesUnits1.fieldApiName]=(this.formfield.othersMin01 != '')? this.calculateUnits(this.formfield.othersMin01) : '';
        console.log('** error data',this.formfield.othersMin01);
        console.log('** error data', fields[otherExercisesUnits1.fieldApiName]);
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

console.log('*** fields data is ::',this.formfield.othersMin01);

console.log('*** fields data is ::',this.formfield.othersMin01 != ''? this.calculateUnits(this.formfield.othersMin01) : '');


        const recordInput={fields}
        updateRecord(recordInput).then(() => {
            // Handle success, show success toast or message
            //this.showToast('Success', 'Record Cretated  successfully', 'success');
            this.status='Aproval sucess'
            this.UpdateAppointment();
            
        })
        .catch(error => {
            // Handle error, show error toast or message
            this.status='Aproval failed'
            this.showToast('Error', 'Record failed at flowsheet', 'error');
        });
        
    }
    UpdateAppointment(){
        const fields = {};
        fields.Id = this.recordId; // Set the record ID
        fields.Appointment_Status__c = 'Provider Review';

        const recordInput = { fields };

        updateRecord(recordInput).then(() => {
            // Handle success, show success toast or message
            this.dispatchEvent(new CloseActionScreenEvent());
            this.showToast('Success', 'Record Updated  successfully', 'success');
            //this.status='Aproval sucess'
        })
        .catch(error => {
            // Handle error, show error toast or message
            this.status='Aproval failed'
            this.showToast('Error', 'Record failed at appointment', 'error');
        });


    }
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
        if ( minutes < 8) {
          units = 0;
        } else if (minutes >= 8 && minutes <= 22) {
          units = 1;
        } else if (minutes >= 23 && minutes <= 37) {
          units =  2 ;
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
          units = 0; // For cases where minutes are outside expected ranges
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



//------------------------total units caluculator-----------------c/editFlowsheetComponent

sumUnits(inputStrings) {
    let totalSum = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {  // Ignore null, undefined, or empty strings
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    if (parts.length > 1) {
                        const unitStr = parts[1].match(/\d+/); // Extract the number
                        if (unitStr) {
                            totalSum += parseInt(unitStr[0], 10); // Convert to integer and add to totalSum
                        }
                    }
                });
            }
        });
    }

    return totalSum;
}

    //-----------get Account name--------------------------------------
    @track PatientName;
    @track visitReason;  // Used for filtering logic
    @track visitReasonFull; // NEW Variable for UI display
    _hasRendered = false;

    /*@wire(getRecord,{recordId: '$recordId', fields: FIELDS1 })
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


@track comboboxOtherData1 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData2 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData3 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData4 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData5 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData6 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData7 = [{ id: 1, label: 'Other 1', value: '',Min:'',showDelete:true}  ];
@track comboboxOtherData8 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData9 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];
@track comboboxOtherData10 = [ { id: 1, label: 'Other 1', value: '',Min:'',showDelete:true} ];






// Dynamically populate comboboxData arrays
setcomboboxData() {
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
                let exerciseData = exercise.split(";").reverse().join(",");
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

//------------------------------------------------------------------------------------------
// Dynamically populate comboboxData arrays
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
                    showDelete: true
                });
            });
        }
    }
}


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
                let minuteData = minutes[index] ? minutes[index].match(/(\d+)(?=\s*Minute[s]?)/i)[1] : ''; // Extract minutes
    
                comboboxOtherArray.push({
                    id: index + 1,
                    label: `Other  ${index + 1}`,
                    value: exerciseData,
                    Min: minuteData,
                    showDelete: true
                });
            });
        }
    }
    
}*/

//--------------totalunits
_totalunitsValue = 0; // Private variable to store the total


get totalunitsValue() {
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
    return this.sumUnitscalculator(inputs);
}

set totalunitsValue(value) {
    this._totalunitsValue = value; // Optionally, you can store the value
}

//-------------------------------------------------------------------------------------------

//------------------------------total minutes--------------------------



_totalMinutesValue = 0; // Private variable to store the total


get totalminutesvalue() {
    const totalInputs = [
        this.formfield.checkbox1 ? this.formfield.minutesSpent1 || 0 : 0,
        this.formfield.checkbox2 ? this.formfield.minutesSpent2 || 0 : 0,
        this.formfield.checkbox3 ? this.formfield.minutesSpent3 || 0 : 0,
        this.formfield.checkbox4 ? this.formfield.minutesSpent4 || 0 : 0,
        this.formfield.checkbox5 ? this.formfield.minutesSpent5 || 0 : 0,
        this.formfield.checkbox6 ? this.formfield.minutesSpent6 || 0 : 0,
        this.formfield.checkbox7 ? this.formfield.minutesSpent7 || 0 : 0,
        this.formfield.checkbox8 ? this.formfield.minutesSpent8 || 0 : 0,
        this.formfield.checkbox9 ? this.formfield.minutesSpent9 || 0 : 0,
        this.formfield.checkbox10 ? this.formfield.minutesSpent10 || 0 : 0,
        this.formfield.checkbox1 ? this.formfield.othersMin01 || 0 : 0,
        this.formfield.checkbox2 ? this.formfield.othersMin02 || 0 : 0,
        this.formfield.checkbox3 ? this.formfield.othersMin03 || 0 : 0,
        this.formfield.checkbox4 ? this.formfield.othersMin04 || 0 : 0,
        this.formfield.checkbox5 ? this.formfield.othersMin05 || 0 : 0,
        this.formfield.checkbox6 ? this.formfield.othersMin06 || 0 : 0,
        this.formfield.checkbox7 ? this.formfield.othersMin07 || 0 : 0,
        this.formfield.checkbox8 ? this.formfield.othersMin08 || 0 : 0,
        this.formfield.checkbox9 ? this.formfield.othersMin09 || 0 : 0,
        this.formfield.checkbox10 ? this.formfield.othersMin010 || 0 : 0,
    ];
    return this.sumUnits2(totalInputs);
}

set totalminutesvalue(value) {
    this._totalMinutesValue = value; // Optionally, you can store the value
}


//cpt1 total minutes------------------

_totalminutesvalueCPT1 = 0;

get totalminutesvalueCPT1() {
    const totalInputs1 = [
        this.formfield.minutesSpent1 || 0,
        this.formfield.othersMin01 || 0
    ];
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
}

set totalminutesvalueCPT5(value) {
    this._totalminutesvalueCPT5 = value; // Optionally, you can store the value
}

//cpt6 total minutes------------------

_totalminutesvalueCPT6 = 0;

get totalminutesvalueCPT6() {
    const totalInputs1 = [
        this.formfield.minutesSpent6 || 0,
        this.formfield.othersMin06 || 0
    ];
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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
    return this.sumUnits2(totalInputs1);
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



//------------------------total units convertr and calculator-------------------------
sumUnitscalculator(inputStrings) {
    let totalMinutes = 0;

    if (inputStrings && Array.isArray(inputStrings)) {
        inputStrings.forEach(input => {
            if (input && input.trim() !== '') {
                const exercises = input.split(';');
                exercises.forEach(exercise => {
                    const parts = exercise.split('-');
                    if (parts.length >= 2) {
                        const lastPart = parts[parts.length - 1]; // Get the final segment
                        const minutesMatch = lastPart.match(/\d+/); // Extract number from it
                        if (minutesMatch) {
                            totalMinutes += parseInt(minutesMatch[0], 10);
                        }
                    }
                });
            }
        });
    }

    return this.calculateUnitsFromMinutes(totalMinutes);
}

get totalunitsValue() {
    return this.getUnits(this.totalminutesvalue);
  }

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
    } else if (minutes >= 113) {
        return 8;
    } else {
        return 0; // Handle cases where totalMinutes is 0 or invalid
    }
    return units;
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
        return 0; // Handle cases where totalMinutes is 0 or invalid
    }
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

//------------------------submit for Approval----------------------

handleApprovalSubmit(){
    const fields = {
        Id: this.recordId, 
        Status__c: 'Provider_Review', 
        Flowsheet__c:this.flowSheetId};

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
handleNavSelection() {
   
    
}





//--------------------------------------------------------------------------
//-------------------comboboxData1--------------------------------------------------

deleteHandlerOther(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData1 = this.comboboxOtherData1.filter(item => item.id !== minSpentId);
    this.comboboxOtherData1 = this.comboboxOtherData1.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxData1);
    this.formfield.others1 =this.comboboxOtherData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
   
    console.log(this.formfield.others1);
    this.updateFormFieldsFromComboboxData1();

    }

handleAddComboboxOtherData() {
    const newId = this.comboboxOtherData1.length + 1;
    this.comboboxOtherData1.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
    
}

get hideButtonProperty() {
    // Check each entry in comboboxData1 for the conditions
   // return this.comboboxData1.every(item => item.value === '' && item.Min === '');
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


}


handleAddComboboxOtherData() {
    const newId = this.comboboxOtherData1.length + 1;
    this.comboboxOtherData1.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

handleComboboxChangeOther(event) {
     var selectedId = parseInt(event.target.id, 10);
     var selectedValue = event.target.value;

    const comboboxItem = this.comboboxOtherData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        console.log('entered');
        comboboxItem.value = selectedValue;
        console.log('updated');

    }
    const concatenatedString = this.comboboxOtherData1.map(option => option.value).join(';');
    this.formfield.others1 = concatenatedString;
    this.updateFormFieldsFromComboboxData1();

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
this.updateFormFieldsFromComboboxData1();

}

//--------------------
updateFormFieldsFromComboboxData1() {
    console.log('***Entered to updateFormFieldsFromComboboxData')
    this.formfield.others1 = this.comboboxOtherData1.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin01 = this.comboboxOtherData1.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//-------------------

handleAddCombobox(){
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
    const resultString = this.comboboxData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.minutesSpent1 = resultString;
    console.log( this.formfield.Excercise1);
    console.log( this.formfield);

}

handleChange(event){
    const selectedId = event.target.name;
    const selectedValue = event.target.value;
    const comboboxItem = this.comboboxData1.find((item) => item.id == selectedId);
    if (comboboxItem) {
        comboboxItem.Min = selectedValue;
    }
    const resultString = this.comboboxData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent1 = resultString;
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


//---------------------------comboboxData2----------------------------------------------
handleAddComboboxOtherData2() {
    const newId = this.comboboxOtherData2.length + 1;
    this.comboboxOtherData2.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther2(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData2 = this.comboboxOtherData2.filter(item => item.id !== minSpentId);
    this.comboboxOtherData2 = this.comboboxOtherData2.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData2);
    this.formfield.others2 =this.comboboxOtherData2.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData2();

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

//---------------------------------------
updateFormFieldsFromComboboxData2() {
    this.formfield.others2 = this.comboboxOtherData2.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin02 = this.comboboxOtherData2.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//------------------------------------------

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
    const resultString = this.comboboxData2.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.minutesSpent2 = resultString;
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

//-------------------------------------------------------------------------
//---------------------------comboboxData3----------------------------------------------

handleAddComboboxOtherData3() {
    const newId = this.comboboxOtherData3.length + 1;
    this.comboboxOtherData3.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}
deleteHandlerOther3(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData3 = this.comboboxOtherData3.filter(item => item.id !== minSpentId);
    this.comboboxOtherData3 = this.comboboxOtherData3.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData3);
    this.formfield.others3 =this.comboboxOtherData3.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData3();

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
    const resultString = this.comboboxOtherData3.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.othersMin03 = resultString;
this.updateFormFieldsFromComboboxData3();

}
//------------------
updateFormFieldsFromComboboxData3() {
    this.formfield.others3 = this.comboboxOtherData3.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin03 = this.comboboxOtherData3.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//------------------

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
    const resultString = this.comboboxData3.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent3 = resultString;
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

//-------------------------------------------------------------------------
//---------------------------comboboxData4----------------------------------------------

handleAddComboboxOtherData4() {
    const newId = this.comboboxOtherData4.length + 1;
    this.comboboxOtherData4.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther4(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData4 = this.comboboxOtherData4.filter(item => item.id !== minSpentId);
    this.comboboxOtherData4 = this.comboboxOtherData4.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData4);
    this.formfield.others4 =this.comboboxOtherData4.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData4();

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
//----------
updateFormFieldsFromComboboxData4() {
    this.formfield.others4 = this.comboboxOtherData4.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin04 = this.comboboxOtherData4.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//---------

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
    const resultString = this.comboboxData4.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent4 = resultString;
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
       // return this.comboboxData4.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData5----------------------------------------------
handleAddComboboxOtherData5() {
    const newId = this.comboboxOtherData5.length + 1;
    this.comboboxOtherData5.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther5(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData5 = this.comboboxOtherData5.filter(item => item.id !== minSpentId);
    this.comboboxOtherData5 = this.comboboxOtherData5.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData5);
    this.formfield.others5 =this.comboboxOtherData5.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
   
    console.log(this.formfield.others5);
    this.updateFormFieldsFromComboboxData5();

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
//---------
updateFormFieldsFromComboboxData5() {
    this.formfield.others5 = this.comboboxOtherData5.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin05 = this.comboboxOtherData5.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//--------

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
    const resultString = this.comboboxData5.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.formfield.minutesSpent5 = resultString;
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

    get hideButtonProperty5() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData5.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData6----------------------------------------------
handleAddComboboxOtherData6() {
    const newId = this.comboboxOtherData6.length + 1;
    this.comboboxOtherData6.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther6(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData6 = this.comboboxOtherData6.filter(item => item.id !== minSpentId);
    this.comboboxOtherData6 = this.comboboxOtherData6.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData6);
    this.formfield.others6 =this.comboboxOtherData6.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData6();

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
//------------
updateFormFieldsFromComboboxData6() {
    this.formfield.others6 = this.comboboxOtherData6.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin06 = this.comboboxOtherData6.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//------------
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
    const resultString = this.comboboxData6.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent6 = resultString;
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

    get hideButtonProperty6() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData6.every(item => item.value === '' && item.Min === '');
    }
//-------------------------------------------------------------------------
//---------------------------comboboxData7----------------------------------------------
handleAddComboboxOtherData7() {
    const newId = this.comboboxOtherData7.length + 1;
    this.comboboxOtherData7.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther7(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData7 = this.comboboxOtherData7.filter(item => item.id !== minSpentId);
    this.comboboxOtherData7 = this.comboboxOtherData7.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData7);
    this.formfield.others7 =this.comboboxOtherData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData7();
    console.log(this.formfield.others7);
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
//-------------
updateFormFieldsFromComboboxData7() {
    this.formfield.others7 = this.comboboxOtherData7.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin07 = this.comboboxOtherData7.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//--------------

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
    const resultString = this.comboboxData7.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent7 = resultString;
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
    
    }
    get hideButtonProperty7() {
        // Check each entry in comboboxData for the conditions
       // return this.comboboxData7.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData8----------------------------------------------
handleAddComboboxOtherData8() {
    const newId = this.comboboxOtherData8.length + 1;
    this.comboboxOtherData8.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther8(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData8 = this.comboboxOtherData8.filter(item => item.id !== minSpentId);
    this.comboboxOtherData8 = this.comboboxOtherData8.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData8);
    this.formfield.others8 =this.comboboxOtherData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
   
    console.log(this.formfield.others8);
    this.updateFormFieldsFromComboboxData8();
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
//-----
updateFormFieldsFromComboboxData8() {
    this.formfield.others8 = this.comboboxOtherData8.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin08 = this.comboboxOtherData8.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//-------
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
    const resultString = this.comboboxData8.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent8 = resultString;
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

    get hideButtonProperty8() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData8.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData9----------------------------------------------
handleAddComboboxOtherData9() {
    const newId = this.comboboxOtherData9.length + 1;
    this.comboboxOtherData9.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}

deleteHandlerOther9(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData9 = this.comboboxOtherData9.filter(item => item.id !== minSpentId);
    this.comboboxOtherData9 = this.comboboxOtherData9.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData9);
    this.formfield.others9 =this.comboboxOtherData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData9();
    console.log(this.formfield.others9);
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
//--------
updateFormFieldsFromComboboxData9() {
    this.formfield.others9 = this.comboboxOtherData9.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin09 = this.comboboxOtherData9.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}
//--------
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
    const resultString = this.comboboxData9.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent9 = resultString;
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
    get hideButtonProperty9() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData9.every(item => item.value === '' && item.Min === '');
    }
//-------------------------------------------------------------------------
//---------------------------comboboxData10----------------------------------------------
handleAddComboboxOtherData10() {
    const newId = this.comboboxOtherData10.length + 1;
    this.comboboxOtherData10.push({
        id: newId,
        label: `Other ${newId}`,
        value: '',
        Min:'',
        showDelete:true
        
    });
}
deleteHandlerOther10(event){
    const minSpentId=event.target.name;
    console.log('entered');
    this.comboboxOtherData10 = this.comboboxOtherData10.filter(item => item.id !== minSpentId);
    this.comboboxOtherData10 = this.comboboxOtherData10.map((item, index) => ({
        ...item,
        id: index + 1 // Assign new sequential ids starting from 1
    }));
    
    console.log(this.comboboxOtherData10);
    this.formfield.others10 =this.comboboxOtherData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
    .join(';');
    this.updateFormFieldsFromComboboxData10();
    console.log(this.formfield.others10);
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
//-------
updateFormFieldsFromComboboxData10() {
    this.formfield.others10 = this.comboboxOtherData10.map(
        item => item.value || ''
    ).join(';');

    this.formfield.othersMin010 = this.comboboxOtherData10.map(
        item => `${item.value || ''}-${item.Min || '0'} Minutes`
    ).join(';');

}

//-------
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
    const resultString = this.comboboxData10.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.minutesSpent10 = resultString;
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
    get hideButtonProperty10() {
        // Check each entry in comboboxData for the conditions
        //return this.comboboxData10.every(item => item.value === '' && item.Min === '');
    }
//-------------------------------------------------------------------------
}