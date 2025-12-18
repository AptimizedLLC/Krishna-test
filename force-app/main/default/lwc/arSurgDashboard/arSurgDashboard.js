import { LightningElement, track, wire } from 'lwc';
import getDashboardData from '@salesforce/apex/AR_Surg_DashboardController.getDashboardData';

export default class ArSurgDashboard extends LightningElement {
    @track priorityColumns = [];
    @track priorityData = [];
    @track totalPriority = [];

    @track injectionColumns = [];
    @track injectionData = [];

    @wire(getDashboardData)
    wiredData({ error, data }) {
        if (data) {
            this.priorityColumns = data.priorityColumns;
            this.priorityData = data.priorityData;
            this.totalPriority = this.priorityColumns.map(col => ({
                key: col,
                count: data.totalPriority[col] || 0
            }));

            this.injectionColumns = data.injectionColumns;
            this.injectionData = data.injectionData.map(row => ({
                owner: row.owner,
                fullValues: row.values          // keep **all** values in one array
            }));
        } else if (error) {
            console.error(error);
        }
    }
}