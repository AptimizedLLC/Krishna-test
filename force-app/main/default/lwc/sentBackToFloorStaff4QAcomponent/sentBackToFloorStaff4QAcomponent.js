import { LightningElement, api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Assigned_FIELD from '@salesforce/schema/Appointment__c.Patient_s_Currently_Assigned_Staff__c';
import Note_FIELD from '@salesforce/schema/Appointment__c.Note__c';
import Status_FIELD from '@salesforce/schema/Appointment__c.Appointment_Status__c';
import Flowsheet_Updated	 from '@salesforce/schema/Appointment__c.Flowsheet_Updated__c';

import { CloseActionScreenEvent } from "lightning/actions";
//import { NavigationMixin } from 'lightning/navigation';
const FIELDS = [Assigned_FIELD, Note_FIELD];


export default class SentBackToFloorStaff4QAcomponent extends  LightningElement {

    assignedField = Assigned_FIELD;
    note = Note_FIELD;
    status=Status_FIELD;
    FlowsheetUpdated=Flowsheet_Updated;

    @api recordId;
    @api objectApiName;
    assigned;
   
    handleSuccess(e){
        // Close the modal window and display a success toast
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Record updated!",
            variant: "success",
          }),
        );
      }

    handleError(event) {
        console.log('update failed'+event.detail.message);
        /*const toastEvent = new ShowToastEvent({
            title: "Error",
            message: event.detail.message || "There was an error updating the record",
            variant: "error"
        });
        this.dispatchEvent(toastEvent);*/
    }

    
    }