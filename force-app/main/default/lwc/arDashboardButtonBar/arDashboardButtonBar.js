import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ArDashboardButtonBar extends NavigationMixin(LightningElement) {

    handlePendingInventory() {
        this.navigateToListView('Pending_Inventory');
    }

    handleNewRequest() {
        this.navigateToListView('New_Request');
    }

    handlePreviousRequest() {
        this.navigateToListView('Previous_Request');
    }

    handleCompletedRequest() {
        this.navigateToListView('Completed_Request');
    }

    navigateToListView(apiName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'AR_Accounts_Receivable__c', // 👈 Replace with the correct object API Name
                actionName: 'list'
            },
            state: {
                filterName: apiName // 👈 List View API Name
            }
        });
    }
}