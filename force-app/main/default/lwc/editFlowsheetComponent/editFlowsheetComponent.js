import { LightningElement ,track,api,wire} from 'lwc';

import { getObjectInfo, getPicklistValues} from 'lightning/uiObjectInfoApi';
import { createRecord,updateRecord ,getRecord} from 'lightning/uiRecordApi';
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


const FlowsheetFIELDS = ['Appointment__c.Flowsheet__c'];



import submitForApproval from '@salesforce/apex/ApprovalController.submitForApproval';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

const FIELDS = [
'Flowhsheet__c.Exercise_1__c','Flowhsheet__c.Exercise_2__c','Flowhsheet__c.Exercise_3__c','Flowhsheet__c.Exercise_4__c','Flowhsheet__c.Exercise_5__c',
'Flowhsheet__c.Exercise_6__c','Flowhsheet__c.Exercise_7__c','Flowhsheet__c.Exercise_8__c','Flowhsheet__c.Exercise_9__c','Flowhsheet__c.Exercise_10__c',
 
'Flowhsheet__c.Code_1__c','Flowhsheet__c.Code_2__c','Flowhsheet__c.Code_3__c','Flowhsheet__c.Code_4__c','Flowhsheet__c.Code_5__c',
'Flowhsheet__c.Code_6__c','Flowhsheet__c.Code_7__c','Flowhsheet__c.Code_8__c','Flowhsheet__c.Code_9__c','Flowhsheet__c.Code_10__c',

'Flowhsheet__c.Minutes_spent_1__c','Flowhsheet__c.Minutes_spent_2__c','Flowhsheet__c.Minutes_spent_3__c','Flowhsheet__c.Minutes_spent_4__c','Flowhsheet__c.Minutes_spent_5__c',
'Flowhsheet__c.Minutes_spent_6__c','Flowhsheet__c.Minutes_spent_7__c','Flowhsheet__c.Minutes_spent_8__c','Flowhsheet__c.Minutes_spent_9__c','Flowhsheet__c.Minutes_spent_10__c'
];

export default class EditFlowsheetComponent extends LightningElement {
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
        minutesSpent2:'',
        minutesSpent3:'',
        minutesSpent4:'',
        minutesSpent5:'',
        minutesSpent6:'',
        minutesSpent7:'',
        minutesSpent8:'',
        minutesSpent9:'',
        minutesSpent10:'',
        totalUnits:''         
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

        console.log(this.formfield);

        if(this.formfield !== null) {
            this.setcomboboxData();
        }
        
        


}else if (error) {
    console.error('Error fetching record data:');
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
        if(event.target.name=='Cancel'){
            this.formfield={};
        }
        if(event.target.name=='Next'){
            this.cptFlag=false;
            this.ExcerciseFlag=true;
            this.ApprovalFlag=false;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_brand";
            this.SubmitClass="slds-button slds-button_neutral";
            
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
            this.cptFlag=false;
            this.ExcerciseFlag=false;
            this.ApprovalFlag=true;
            this.CptClass="slds-button slds-button_neutral";
            this.ExcerciseClass="slds-button slds-button_neutral";
            this.SubmitClass="slds-button slds-button_brand";
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
    recordTypeId: '012U80000015vZlIAI'
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

SubmitHandler(){
    
    //
    
    const fields = {};
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
        fields[UnitsSpentcalucation3.fieldApiName]=(this.formfield.minutesSpent3 != '')? this.calculateUnits(this.formfield.MinutesSpent3) : '';
        fields[UnitsSpentcalucation4.fieldApiName]=(this.formfield.minutesSpent4 != '')? this.calculateUnits(this.formfield.minutesSpent4) : '';
        fields[UnitsSpentcalucation5.fieldApiName]=(this.formfield.minutesSpent5 != '')? this.calculateUnits(this.formfield.minutesSpent5) : '';
        fields[UnitsSpentcalucation6.fieldApiName]=(this.formfield.minutesSpent6 != '')? this.calculateUnits(this.formfield.minutesSpent6) : '';
        fields[UnitsSpentcalucation7.fieldApiName]=(this.formfield.minutesSpent7 != '')? this.calculateUnits(this.formfield.minutesSpent7) : '';
        fields[UnitsSpentcalucation8.fieldApiName]=(this.formfield.minutesSpent8 != '')? this.calculateUnits(this.formfield.minutesSpent8) : '';
        fields[UnitsSpentcalucation9.fieldApiName]=(this.formfield.minutesSpent9 != '')? this.calculateUnits(this.formfield.minutesSpent9) : '';
        fields[UnitsSpentcalucation10.fieldApiName]=(this.formfield.minutesSpent10 != '')? this.calculateUnits(this.formfield.minutesSpent10) : '';
    
        const inputs = [(this.formfield.minutesSpent1 != '')? this.calculateUnits(this.formfield.minutesSpent1) : '',
            (this.formfield.minutesSpent2 != '')? this.calculateUnits(this.formfield.minutesSpent2) : '',
            (this.formfield.minutesSpent3 != '')? this.calculateUnits(this.formfield.minutesSpent3) : '',
            (this.formfield.minutesSpent4 != '')? this.calculateUnits(this.formfield.minutesSpent4) : '',
            (this.formfield.minutesSpent5 != '')? this.calculateUnits(this.formfield.minutesSpent5) : '',
            (this.formfield.minutesSpent6 != '')? this.calculateUnits(this.formfield.minutesSpent6) : '',
            (this.formfield.minutesSpent7 != '')? this.calculateUnits(this.formfield.minutesSpent7) : '',
            (this.formfield.minutesSpent8 != '')? this.calculateUnits(this.formfield.minutesSpent8) : '',
            (this.formfield.minutesSpent9 != '')? this.calculateUnits(this.formfield.minutesSpent9) : '',
            (this.formfield.minutesSpent10 != '')? this.calculateUnits(this.formfield.minutesSpent10) : ''
        ];
        fields[Total_Units.fieldApiName]=this.sumUnits(inputs);


        let recordInput={fields}
        updateRecord(recordInput).then(() => {
            // Handle success, show success toast or message
            this.showToast('Success', 'Record Updated  successfully', 'success');
            this.status='Aproval sucess'
        })
        .catch(error => {
            // Handle error, show error toast or message
            this.status='Aproval failed'
            this.showToast('Error', error.body.message, 'error');
        });
    }
    //--------------------------------units calculator----------------c/editFlowsheetComponent
 calculateUnits(input) {
    const exercises = input.split(';');
  
    const output = exercises
      .map(exercise => {
        const [name, minutesStr] = exercise.split('-');
        const minutes = parseInt(minutesStr);
  
        // Determine units based on minutes
        let units;
        if (minutes >= 8 && minutes <= 22) {
          units = 1;
        } else if (minutes > 23 && minutes <= 37) {
          units = 2;
        } else if (minutes > 38 && minutes <= 52) {
          units = 3;
        }else if (minutes > 53 && minutes <= 67) {
            units = 4;
          } else if (minutes > 68 && minutes <= 82) {
            units = 5;
          } else if (minutes > 83 && minutes <= 97) {
            units = 6;
          } else if (minutes > 98 && minutes <= 112) {
            units = 7;
          } else if (minutes > 113 && minutes <= 127) {
            units = 8;
          }         
        else {
          units = 8; // For cases where minutes are outside expected ranges
        }
  
        return `${name}-${units} unit${units !== 1 ? 's' : ''}`; // Handle pluralization
      })
      .join(';');
  
    return output;
  }
//------------------------total units caluculator-----------------c/editFlowsheetComponent

sumUnits(inputStrings) {
    let totalSum = 0;

    inputStrings.forEach(input => {
        // Check if the input string is not empty
        if (input.trim() !== '') {
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

    return totalSum;
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

@track comboboxArray;
/*
// Dynamically populate comboboxData arrays
setcomboboxData() {
    // Loop through 5 sets of exercises and minutes (adjust if necessary)
    for (let i = 1; i <= 10; i++) {
        // Check if the exercise and minutes fields are not null or undefined
        const exerciseField = this.formfield[`Excercise${i}`];
        const minutesField = this.formfield[`minutesSpent${i}`];
    
        if (exerciseField && minutesField) {
            // If the fields are not null, split the values
            const exercises = exerciseField.split(';');
            const minutes = minutesField.split(';');
    
             this.comboboxArray = this[`comboboxData${i}`];
            this.comboboxArray.length = 0; // Clear previous data
    
            exercises.forEach((exercise, index) => {
                let exerciseData = exercise.trim();
                let minuteData = minutes[index] ? minutes[index].match(/(\d+)/)[0] : ''; // Extract minutes
    
                this.comboboxArray.push({
                    id: index + 1,
                    label: `Exercise ${index + 1}`,
                    value: exerciseData,
                    Min: minuteData,
                    showDelete: true
                });
            });
        }
    }
    console.log('Check Array'+this.comboboxArray);
}
*/
setcomboboxData() {
    // Loop through 10 sets of exercises and minutes
    for (let i = 1; i <= 10; i++) {
        // Access the exercise and minutes fields using bracket notation and template literals
        const exerciseField = this.formfield[`Excercise${i}`];
        const minutesField = this.formfield[`minutesSpent${i}`];
    
        if (exerciseField && minutesField) {
            // If the fields are not null, split the values
            //const exercises = exerciseField.split(';');
            const minutes = minutesField.split(';');
            const exercises = minutes.map(item => item.split('-')[0].trim());    
            // Dynamically access comboboxData arrays like comboboxData1, comboboxData2, etc.
            const comboboxArray = this[`comboboxData${i}`];
            comboboxArray.length = 0; // Clear previous data
    
            exercises.forEach((exercise, index) => {
                let exerciseData = exercise.trim();
                let minuteData = minutes[index] ? minutes[index].match(/(\d+)/)[1] : ''; // Extract minutes
    
                comboboxArray.push({
                    id: index + 1,
                    label: `Exercise ${index + 1}`,
                    value: exerciseData,
                    Min: minuteData,
                    showDelete: index !== 0 // Allow delete for all except the first item
                });
            });

            // Update the corresponding comboboxData property
            this[`comboboxData${i}`] = [...comboboxArray];
        } else {
            // If either exerciseField or minutesField is null, reset comboboxData to default
            this[`comboboxData${i}`] = [{
                id: 1,
                label: 'Exercise 1',
                value: '',
                Min: '',
                showDelete: true
            }];
        }
    }
    console.log(this.comboboxData1);
    console.log(this.comboboxData2);
    console.log(this.comboboxData3);
}

//-------------------------------------------------------------------------------------------








//--------------------------------------------------------------------------
//-------------------comboboxData1--------------------------------------------------

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

this.comboboxData = this.comboboxData1.filter(item => item.id !== minSpentId);
this.comboboxData = this.comboboxData1.map((item, index) => ({
    ...item,
    id: index + 1 // Assign new sequential ids starting from 1
}));

console.log(this.comboboxData1);
this.formfield.minutesSpent1 =this.comboboxData1.map(item => `${item.value}-${item.Min || '0'} Minutes`) // Default to '0' if Min is empty
.join(';');
this.formfield.Excercise1 = this.comboboxData1.map(option => option.value).join(';');
console.log(this.formfield);

}
get hideButtonProperty() {
    // Check each entry in comboboxData for the conditions
    return this.comboboxData1.every(item => item.value === '' && item.Min === '');
}

//---------------------------comboboxData2----------------------------------------------

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
    return this.comboboxData2.every(item => item.value === '' && item.Min === '');
}

//-------------------------------------------------------------------------
//---------------------------comboboxData3----------------------------------------------

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
        return this.comboboxData3.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData4----------------------------------------------

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
        return this.comboboxData4.every(item => item.value === '' && item.Min === '');
    }

//-------------------------------------------------------------------------
//---------------------------comboboxData5----------------------------------------------

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

//-------------------------------------------------------------------------
//---------------------------comboboxData6----------------------------------------------

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


//-------------------------------------------------------------------------
//---------------------------comboboxData7----------------------------------------------

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

//-------------------------------------------------------------------------
//---------------------------comboboxData8----------------------------------------------

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

//-------------------------------------------------------------------------
//---------------------------comboboxData9----------------------------------------------

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

//-------------------------------------------------------------------------
//---------------------------comboboxData10----------------------------------------------

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
//-------------------------------------------------------------------------
}