import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAppointmentsWithFlowsheets from '@salesforce/apex/AppointmentFlowsheetController.getAppointmentsWithFlowsheets';
import getTotalCount from '@salesforce/apex/AppointmentFlowsheetController.getTotalCount';
import approveAppointment from '@salesforce/apex/AppointmentFlowsheetController.approveAppointment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecentAppointmentsWithFlowsheets from '@salesforce/apex/AppointmentFlowsheetController.getRecentAppointmentsWithFlowsheets';

export default class AppointmentFlowsheetTable extends NavigationMixin(LightningElement) {
    @track data = [];
     @track recentData = [];
    @track searchKey = '';   
    @track startDate;
    @track recentSearchKey = '';
@track filteredRecentData = [];
@track endDate;
    @track columns = [
    {
        label: 'Appointment Name',
        fieldName: 'appointmentUrl',
        type: 'url',
        typeAttributes: { label: { fieldName: 'appointmentName' }, target: '_blank' }
    },
    { label: 'Patient', fieldName: 'patientName', type: 'text' },
    { label: 'Visit Reason', fieldName: 'editFlowSheetLink', type: 'text' },
    { label: 'Appointment Date', fieldName: 'appointmentDate', type: 'date' },
    { label: 'TE', fieldName: 'te', type: 'text' },
    { label: 'TA', fieldName: 'ta', type: 'text' },
    { label: 'MT', fieldName: 'mt', type: 'text' },
    { label: 'PPT', fieldName: 'rom', type: 'text' },
    { label: 'ROM', fieldName: 'ppt', type: 'text' },
    { label: 'TR', fieldName: 'tr', type: 'text' },
    {
        type: 'button',
        typeAttributes: {
            label: 'Approve',
            name: 'approve',
            variant: 'brand',
            disabled: { fieldName: 'isApproving' }
        }
    }
];

// for read-only recent appointments (no approve column)
@track recentColumns = [
    {
        label: 'Appointment Name',
        fieldName: 'appointmentUrl',
        type: 'url',
        typeAttributes: { label: { fieldName: 'appointmentName' }, target: '_blank' }
    },
    { label: 'Patient', fieldName: 'patientName', type: 'text' },
    { label: 'Visit Reason', fieldName: 'editFlowSheetLink', type: 'text' },
    { label: 'Appointment Date', fieldName: 'appointmentDate', type: 'date' },
     { label: 'TE', fieldName: 'te', type: 'text' },
    { label: 'TA', fieldName: 'ta', type: 'text' },
    { label: 'MT', fieldName: 'mt', type: 'text' },
    { label: 'PPT', fieldName: 'rom', type: 'text' },
    { label: 'ROM', fieldName: 'ppt', type: 'text' },
    { label: 'TR', fieldName: 'tr', type: 'text' }
];

    @track pageNumber = 1;
    @track pageSize = 10;
    @track totalRecords = 0;
    @track totalPages = 0;

    // store IDs of appointments currently being approved
    approvingIds = new Set();

    connectedCallback() {
        this.loadData();
        this.loadTotalCount();
         // prefill startDate = 7 days ago, endDate = today
        const today = new Date();
        const sevenDaysAgo = new Date();
        sevenDaysAgo.setDate(today.getDate() - 6);

        this.startDate = sevenDaysAgo.toISOString().split('T')[0];
        this.endDate = today.toISOString().split('T')[0];

        this.loadRecentData();
    }
loadRecentData() {
    getRecentAppointmentsWithFlowsheets({ startDate: this.startDate, endDate: this.endDate })
        .then(result => {
            this.recentData = result.map(row => ({
                ...row,
                appointmentUrl: '/' + row.appointmentId,
                editFlowSheetLink: row.editFlowSheetLink
            }));
            this.filteredRecentData = [...this.recentData]; // default copy
        })
        .catch(error => {
            console.error('Error loading recent appointments:', error);
        });
}

handleRecentSearch(event) {
    this.recentSearchKey = event.target.value;
    if (this.recentSearchKey) {
        this.filteredRecentData = this.recentData.filter(r =>
            r.patientName?.toLowerCase().includes(this.recentSearchKey.toLowerCase())
        );
    } else {
        this.filteredRecentData = [...this.recentData];
    }
}

handleDateChange(event) {
    const field = event.target.name;
    if (field === 'start') {
        this.startDate = event.target.value;
    } else if (field === 'end') {
        this.endDate = event.target.value;
    }
    this.loadRecentData(); // reload on change
}

    loadData() {
        getAppointmentsWithFlowsheets({ pageNumber: this.pageNumber, pageSize: this.pageSize })
            .then(result => {
                let allRows = result.map(row => {
                    return {
                        ...row,
                        appointmentUrl: '/' + row.appointmentId,
                        editFlowSheetLink: row.editFlowSheetLink,
                        isApproving: this.approvingIds.has(row.appointmentId) // disable if in progress
                    };
                });

                if (this.searchKey) {
                    this.data = allRows.filter(r =>
                        r.patientName?.toLowerCase().includes(this.searchKey.toLowerCase())
                    );
                } else {
                    this.data = allRows;
                }
            })
            .catch(error => {
                console.error('Error loading data:', error);
            });
    }

    loadTotalCount() {
        getTotalCount()
            .then(count => {
                this.totalRecords = count;
                this.totalPages = Math.ceil(count / this.pageSize);
            })
            .catch(error => {
                console.error('Error loading total count:', error);
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'approve') {
            // mark as approving
            this.approvingIds.add(row.appointmentId);
            this.data = this.data.map(r =>
                r.appointmentId === row.appointmentId ? { ...r, isApproving: true } : r
            );

            approveAppointment({ appointmentId: row.appointmentId })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Appointment approved',
                            variant: 'success'
                        })
                    );

                    // remove approved row
                    this.data = this.data.filter(item => item.appointmentId !== row.appointmentId);
                    this.loadTotalCount();
                })
                .catch(error => {
                    console.error(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Failed to approve appointment',
                            variant: 'error'
                        })
                    );

                    // re-enable button on failure
                    this.approvingIds.delete(row.appointmentId);
                    this.data = this.data.map(r =>
                        r.appointmentId === row.appointmentId ? { ...r, isApproving: false } : r
                    );
                });
        }

        if (actionName === 'openFlowsheet') {
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: row.editFlowSheetLink
                }
            }).then(generatedUrl => {
                window.open(generatedUrl, '_blank');
            });
        }
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.loadData();
        }
    }

    handlePrev() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.loadData();
        }
    }

    get isPrevDisabled() {
        return this.pageNumber === 1;
    }

    get isNextDisabled() {
        return this.pageNumber === this.totalPages;
    }

    handleSearch(event) {
        this.searchKey = event.target.value;
        this.loadData();
    }
}