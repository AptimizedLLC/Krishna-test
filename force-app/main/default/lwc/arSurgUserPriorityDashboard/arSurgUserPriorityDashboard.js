import { LightningElement, track, wire } from 'lwc';
import getDashboardData from '@salesforce/apex/AR_DashboardUserController.getDashboardData';

export default class ArSurgUserPriorityDashboard extends LightningElement {
    @track priorityColumns = [];
    @track priorityData = [];
    @track totalPriority = [];

    @track injectionColumns = [];
    @track injectionData = []; // will hold { owner, fullValues }

    @wire(getDashboardData)
    wiredData({ error, data }) {
        if (data) {
            // === Priority Section (unchanged) ===
            this.priorityColumns = data.priorityColumns;
            this.priorityData = data.priorityData;
            this.totalPriority = this.priorityColumns.map(col => ({
                key: col,
                count: data.totalPriority[col] || 0
            }));

            // === Injection Section (full array preserved) ===
            this.injectionColumns = data.injectionColumns;
            this.injectionData = data.injectionData.map(row => ({
                owner: row.owner,
                fullValues: row.values  // keep all values in one array
            }));
        } else if (error) {
            console.error('Error loading dashboard data:', error);
        }
    }
}