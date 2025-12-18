import { LightningElement, track, wire, api } from 'lwc';
import getDashboardData from '@salesforce/apex/AR_DashboardUserController.getDashboardData';

export default class ArDashboard extends LightningElement {
    @track priorityColumns = [];
    @track priorityData = [];
    @track totalPriority = [];
    @api viewType;
    @track injectionColumns = [];
    @track injectionData = []; // will hold { owner, fullValues }

    get injectionHeading(){
        return this.viewType === 'Injection Workbook' ? true : false;
    }

    get surgicalHeading(){
        return this.viewType?.includes('Surgical') ? true : false;
    }

    @wire(getDashboardData, {viewType:'$viewType'})
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