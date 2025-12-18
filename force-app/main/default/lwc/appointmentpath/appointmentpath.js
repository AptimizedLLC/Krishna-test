import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const FIELDS = [
    'Appointment__c.Id',
    'Appointment__c.Appointment_Status__c'
];

export default class CustomPathLwc extends LightningElement {
    @track selectedValue;
    @api recordId;
    @track showSpinner = false;

    objectInfo;
    appointmentStatusField;
    wiredRecordResult;

    @wire(getObjectInfo, { objectApiName: 'Appointment__c' })
    wiredObjectInfo({ error, data }) {
        if (data) {
            this.objectInfo = data;
            this.appointmentStatusField = `${data.apiName}.Appointment_Status__c`;
        } else if (error) {
            console.error('Error fetching object info:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.defaultRecordTypeId', fieldApiName: '$appointmentStatusField' })
    picklistFieldValues;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord(response) {
        this.wiredRecordResult = response;
        const { data } = response;
        if (data && data.fields.Appointment_Status__c.value) {
            this.selectedValue = data.fields.Appointment_Status__c.value + '';
        }
    }

    get picklistValues() {
        let itemsList = [];
        if (this.wiredRecordResult?.data && this.picklistFieldValues?.data?.values) {
            const currentValue = this.selectedValue;
            const picklistOptions = this.picklistFieldValues.data.values;
    
            // Find index of current selected stage
            const currentIndex = picklistOptions.findIndex(opt => opt.value === currentValue);
    
            for (let i = 0; i < picklistOptions.length; i++) {
                let classList = 'slds-path__item ';
                let isComplete = false;
    
                if (i < currentIndex) {
                    classList += 'slds-is-complete';
                    isComplete = true;
                } else if (i === currentIndex) {
                    classList += 'slds-is-current slds-is-active';
                } else {
                    classList += 'slds-is-incomplete';
                }
    
                itemsList.push({
                    pItem: picklistOptions[i],
                    classList: classList,
                    isComplete: isComplete
                });
            }
    
            return itemsList;
        }
        return null;
    }

    handleSelect(event) {
        this.selectedValue = event.currentTarget.dataset.value;
    }

    handleMarkAsSelected() {
        this.showSpinner = true;

        const fields = {};
        fields.Id = this.recordId;
        fields.Appointment_Status__c = this.selectedValue;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Appointment Status Updated!',
                        variant: 'success'
                    })
                );
                return refreshApex(this.wiredRecordResult);
            })
            .then(() => {
                this.scrollToSelected();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating appointment status!',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.showSpinner = false;
            });
    }

    scrollToSelected() {
        setTimeout(() => {
            const selectedEl = this.template.querySelector('.slds-path__item.slds-is-current');
            if (selectedEl) {
                selectedEl.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'center' });
                selectedEl.classList.add('highlight');
                setTimeout(() => {
                    selectedEl.classList.remove('highlight');
                }, 1000);
            }
        }, 300);
    }
}