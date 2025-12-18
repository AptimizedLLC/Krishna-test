import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class MyNavPage extends NavigationMixin(LightningElement) {

 navigateToNewContact() {
    const defaultValues = encodeDefaultFieldValues({
        VOB_Type__c: 'John',
        Current_Group_Policy_Number__c: '123455',
        VOB_Subject__c: 'john.doe@example.com'
    });

    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'SPD__c',
            actionName: 'new'
        },
        state: {
            defaultFieldValues: defaultValues
        }
    });
 }

  handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: `SPD record created successfully. Id: ${event.detail.id}`,
                variant: 'success'
            })
        );

        // Automatically go to next screen in Flow
        this.dispatchEvent(new FlowNavigationNextEvent());
    }

    handleError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: event.detail.message,
                variant: 'error'
            })
        );
    }
}