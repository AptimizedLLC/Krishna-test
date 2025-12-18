import { LightningElement, wire, track, api } from 'lwc';
import getARRecords from '@salesforce/apex/ARSurgListViewController.getARRecords';
import updateARRecords from '@salesforce/apex/ARSurgListViewController.updateARRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AR_OBJECT from '@salesforce/schema/AR_Accounts_Receivable__c';
import STATUS_FIELD from '@salesforce/schema/AR_Accounts_Receivable__c.Injection_Status__c';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

export default class ArSurgListView extends LightningElement {
    @track records = [];
    @track draftValues = [];
    error;
    searchKey = '';
    selectedStatus = '';
    currentPage = 1;
    totalRecords = 0;
    totalPages = 0;
    @track picklistOptions = [];
    @track lastSavedData;
    providerSearchKey = '';
    patientSearchKey = '';
    payerSearchKey = '';
    selectedDOSOperator = '>';
    dosSearchKey = '';
    selectedDDOperator = '>';
	ddSearchKey = '';
    selectedLBDOperator = '>';
	lbdSearchKey = '';
    pageSize = 100;
    privateChildren = {};
    sortBy = 'PatientName';
    sortDirection = 'asc';
    @api viewType;

    columns = [
        { label: 'Salesforce Account Number', fieldName: 'idLink', type: 'url', editable: false,typeAttributes:{label:{fieldName: 'Name'}},initialWidth: 220 },
        { label: 'Date Assigned', fieldName: 'CreatedDate', sortable: true, type: 'date-local', editable: false,typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 140 },
        { label: 'Patient Name', fieldName: 'PatientName', type: 'text', editable: false,initialWidth: 150, sortable: true},
        { label: 'Date of Service', fieldName: 'AR_DOS__c', type: 'date-local', editable: false,typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 160, sortable: true },
        { label: 'Provider', fieldName: 'AR_Provider__c', type: 'text', editable: false,initialWidth: 130, sortable: true },
        { label: 'CPT Code', fieldName: 'AR_Procedure_Code__c', type: 'text', editable: false,initialWidth: 130, sortable: true },
        { label: 'Location Name', fieldName: 'AR_Location_Name__c', type: 'text', editable: false,initialWidth: 150, sortable: true },
        { label: 'Current Payer', fieldName: 'AR_Payer__c', type: 'text', editable: false,initialWidth: 150, sortable: true },
        { label: 'Aging Bucket', fieldName: 'AR_Age_by_Last_Billed__c', type: 'text', editable: false,initialWidth: 140, sortable: true },
        { label: 'Last Billed Date', fieldName: 'AR_Last_Billed_Date__c', type: 'date-local', sortable: true, editable: false,typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 160 },
        { label: 'Denial Date', fieldName: 'AR_Denial_Date__c', type: 'date-local', editable: false,sortable: true, typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 130 },
        { label: 'Denial Reason', fieldName: 'Adjustment_Code_1_Description__c', type: 'text',sortable: true,  editable: false,initialWidth: 300 },
        { label: 'Billed Amount', fieldName: 'AR_Amount__c', type: 'currency', editable: false,sortable: true, initialWidth: 150 },
        { label: 'Expected Amount', fieldName: 'AR_Expected_Amount__c', type: 'currency', editable: true,sortable: true, initialWidth: 160 },
        { label: 'Payment [ Variance ]', fieldName: 'AR_Payment_Variance__c', type: 'currency', editable: false,sortable: true, initialWidth: 200 },
       /* { label: 'Status Code', fieldName: 'Injection_Status__c', type: 'picklist', editable: true,typeAttributes: { 
                                                                                                                    options: { fieldName: 'picklistOptions' }, 
                                                                                                                    value: { fieldName: 'Injection_Status__c' },
                                                                                                                    context: { fieldName: 'Id' },
                                                                                                                    label: { fieldName: 'lcName' }
                                                                                                                },initialWidth: 130 }, */
         
            { 
            label: 'Status Code',
            fieldName: 'Injection_Status__c', // <-- actual API name
            type: 'picklist',
            sortable: true,
            editable: true,
            initialWidth: 130,
            typeAttributes: {
                options: { fieldName: 'picklistOptions' }, // each row will have this array
                value: { fieldName: 'Injection_Status__c' }, // current picklist value
                context: { fieldName: 'Id' },
                variant: 'label-hidden',
                label: 'Status Code',
                name: 'Status Code' // optional
            },
            cellAttributes: {
            class: { fieldName: 'stageClass' }
        }
            },
        { label: 'Date Worked', fieldName: 'AR_Date_Worked__c', type: 'date-local', editable: false,sortable: true, typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 140 },
        { label: 'Follow up Date', fieldName: 'Follow_Up_Date__c', type: 'date-local', editable: true,typeAttributes: { day: '2-digit', month: 'short', year: 'numeric' },initialWidth: 150, sortable: true },
        { label: 'Note', fieldName: 'AR_Note__c', type: 'text', editable: true,initialWidth: 120,sortable: true },
        { label: 'Priority Status', fieldName: 'AR_Priority_Status__c', type: 'text', editable: false,initialWidth: 160,sortable: true },
        { label: 'Re-Assignment', fieldName: 'OwnerName', type: 'text', editable: false,initialWidth: 170 }
    ];

     connectedCallback() {
        const savedWidths = JSON.parse(localStorage.getItem('arListViewColumnWidths'));
        if (savedWidths) {
            this.columns = this.columns.map(col => ({
                ...col,
                initialWidth: savedWidths[col.fieldName] || col.initialWidth
            }));
        } 
        //this.fetchRecords();
    }
    
    @wire(getObjectInfo, { objectApiName: AR_OBJECT })
    objectInfo;
    
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    wiredPicklist({ data }) {
        if (data) {
            //this.picklistOptions = data.values.map(v => ({ label: v.label, value: v.value }));
            this.picklistOptions = [
            { label: '--None--', value: '' }, // 👈 Add this line first
            ...data.values.map(v => ({ label: v.label, value: v.value }))
            ];
        }
        //console.log('this.picklistOptions ',JSON.stringify(this.picklistOptions));
        this.fetchRecords();
    }

    debounceFetchRecords() {
        // Clear previous timeout if user is still typing
        window.clearTimeout(this.delayTimeout);

        // Set new timeout
        this.delayTimeout = setTimeout(() => {
            this.currentPage = 1;
            this.fetchRecords();
        }, 400); // 500 ms = half second delay
    }

    handleProviderSearchChange(event) {
        this.providerSearchKey = event.target.value;
        this.debounceFetchRecords();
    }

    handlePatientNameSearchChange(event) {
        this.patientSearchKey = event.target.value;
        this.debounceFetchRecords();
    }

    handlePayerSearchChange(event) {
        this.payerSearchKey = event.target.value;
        this.debounceFetchRecords();
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
        this.debounceFetchRecords();
    }

    handleDOSOperatorChange(event) {
        this.selectedDOSOperator = event.target.value;
        //console.log('dosSearchKey ',this.dosSearchKey);
        //console.log(typeof this.dosSearchKey);
        if(this.dosSearchKey){
            //console.log('dosSearchKey 22 ',this.dosSearchKey);
            this.debounceFetchRecords();
        }
    } 

    handleDOSSearchChange(event) {
        this.dosSearchKey = event.target.value;
        //console.log('this.dosSearchKey ',this.dosSearchKey);
        this.debounceFetchRecords();
    }

    handleDDOperatorChange(event) {
        this.selectedDDOperator = event.target.value;
        if(this.ddSearchKey){
            console.log('ddSearchKey 22 ',this.ddSearchKey);
            this.debounceFetchRecords();
        }
    } 
	
	handleDDSearchChange(event) {
        this.ddSearchKey = event.target.value;
        //console.log('this.ddSearchKey ',this.ddSearchKey);
        this.debounceFetchRecords();
    }

    handleLBDOperatorChange(event) {
        this.selectedLBDOperator = event.target.value;
        if(this.lbdSearchKey){
            //console.log('lbdSearchKey 22 ',this.lbdSearchKey);
            this.debounceFetchRecords();
        }
    } 
	
	handleLBDSearchChange(event) {
        this.lbdSearchKey = event.target.value;
        //console.log('this.lbdSearchKey ',this.lbdSearchKey);
        this.debounceFetchRecords();
    }

    handleSort(event){
            this.sortBy = event.detail.fieldName;
        /*    let bySortBy = event.detail.fieldName;
            if(bySortBy === 'PatientName'){
                this.sortBy = 'AR_Patient_Account__r.Name';
            } else {
                this.sortBy = bySortBy;
            } */
            this.sortDirection = event.detail.sortDirection;
            //console.log('Sort by ',this.sortBy);
            //console.log('sortDirection ',this.sortDirection);
            this.debounceFetchRecords();
    }

       fetchRecords() {
        getARRecords({
            searchKey: this.searchKey,
            status: this.selectedStatus,
            pageNumber: this.currentPage,
            pageSize: this.pageSize,
            providerSearchKey: this.providerSearchKey, 
            patientSearchKey: this.patientSearchKey,
            payerSearchKey: this.payerSearchKey,
            sortBy: this.sortBy,
            sortDirection: this.sortDirection,
            selectedDOSOperator: this.selectedDOSOperator,
            dosSearchKey: this.dosSearchKey,
            selectedDDOperator: this.selectedDDOperator,
			ddSearchKey: this.ddSearchKey,
            selectedLBDOperator: this.selectedLBDOperator,
			lbdSearchKey: this.lbdSearchKey,
            viewType: this.viewType
        })
            .then(result => {
                this.totalRecords = result.totalRecords;
                //console.log('this total records '+JSON.stringify(this.totalRecords));
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
                this.records = result.records.map(rec => ({
                    ...rec,
                    OwnerName: rec.Owner?.Name,
                    PatientName: rec.AR_Patient_Account__r?.Name || '',
                   // AR_Date_Worked__c: rec.AR_Date_Worked__c ? rec.AR_Date_Worked__c.split('T')[0] : null,
                    picklistOptions: this.picklistOptions,
                    idLink: '/'+rec.Id
                  /*  CreatedDate: rec.CreatedDate ? rec.CreatedDate.split('T')[0] : null,
                    AR_DOS__c: rec.AR_DOS__c ? rec.AR_DOS__c.split('T')[0] : null,
                    AR_Last_Billed_Date__c: rec.AR_Last_Billed_Date__c ? rec.AR_Last_Billed_Date__c.split('T')[0] : null,
                    AR_Denials_Date__c: rec.AR_Denials_Date__c ? rec.AR_Denials_Date__c.split('T')[0] : null,
                    Follow_Up_Date__c: rec.Follow_Up_Date__c ? rec.Follow_Up_Date__c.split('T')[0] : null */
                }));
                this.lastSavedData = this.records;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body?.message || error.message;
                this.records = [];
            });
    }

    handleFilter(event) {
        const selected = event.target.dataset.status;
        this.selectedStatus = this.selectedStatus === selected ? '' : selected;
        this.currentPage = 1;
        this.fetchRecords();
    }

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        try {
            await updateARRecords({ updatedRecords: updatedFields });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Records updated successfully!',
                variant: 'success'
            }));
            //await new Promise(resolve => setTimeout(resolve,1000));
            this.fetchRecords();
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error updating records',
                message: error.body?.message || error.message,
                variant: 'error'
            }));
        } finally {
            this.draftValues = [];
        }
    }

    handleColumnResize(event) {
        const { columnWidths } = event.detail;
        localStorage.setItem('arListViewColumnWidths', JSON.stringify(columnWidths));
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.fetchRecords();
            //this.debounceFetchRecords();
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.fetchRecords();
            //this.debounceFetchRecords();
        }
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return (this.currentPage >= this.totalPages || this.currentPage >= 20);
    }

    get pageInfo() {
        return `Page ${this.currentPage} of ${this.totalPages}`;
    }

    // Dynamic Button Variants
    get newVariant() { return this.selectedStatus === 'NEW' ? 'brand' : 'neutral'; }
    get fuVariant() { return this.selectedStatus === 'F/U' ? 'brand' : 'neutral'; }
    get dndVariant() { return this.selectedStatus === 'DND' ? 'brand' : 'neutral'; }
    get oldVariant() { return this.selectedStatus === 'OLD' ? 'brand' : 'neutral'; }
    get mpmtVariant() { return this.selectedStatus === 'mPMTDUE' ? 'brand' : 'neutral'; }
    get audVariant() { return this.selectedStatus === 'AUD' ? 'brand' : 'neutral'; }
    get criticalVariant() { return this.selectedStatus === 'CRITICAL' ? 'brand' : 'neutral'; }
    get patientVariant() { return this.selectedStatus === 'PATIENT' ? 'brand' : 'neutral'; }
    get patientVariant() { return this.selectedStatus === 'HIGH $ (DOLLAR)' ? 'brand' : 'neutral'; }
}