import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateNewShortCaseComponent extends NavigationMixin(LightningElement) {

    handleLaunchNewCase() {
        // Replace with your actual Record Type Id for "Short Call Case"
        const recordTypeId = '012U8000002tK9qIAE';

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new'
            },
            state: {
                recordTypeId: recordTypeId
            }
        });
    }
}