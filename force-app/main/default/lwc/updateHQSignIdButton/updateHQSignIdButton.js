import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateHQSignId from '@salesforce/apex/NPPFileHandler.updateHQSignId';

export default class UpdateHQSignIdButton extends LightningElement {
    @api recordId;

    async handleClick() {
        try {
            await updateHQSignId({ nppId: this.recordId });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'HQ Sign Id updated successfully!',
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );
        }
    }
}