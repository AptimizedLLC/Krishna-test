import { LightningElement, wire, track } from 'lwc';
import getRequestCounts from '@salesforce/apex/ARSurgRequestDashboardController.getRequestCounts';

export default class ArSurgDashboardTable extends LightningElement {
    @track inventoryCount = 0;
    @track newRequestCount = 0;
    @track previousRequestCount = 0;
    @track completedRequestCount = 0;

    @wire(getRequestCounts)
    wiredCounts({ error, data }) {
        if (data) {
            this.inventoryCount = data.inventory || 0;
            this.newRequestCount = data.newRequests || 0;
            this.previousRequestCount = data.previousRequests || 0;
            this.completedRequestCount = data.completedRequests || 0;
        } else if (error) {
            console.error('Error fetching counts:', error);
        }
    }
}