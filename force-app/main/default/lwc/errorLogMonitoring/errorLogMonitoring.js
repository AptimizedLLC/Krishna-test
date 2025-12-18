import { LightningElement,api,track} from 'lwc';
import findLogs from '@salesforce/apex/ErrorLogMonitoringController.findLogs';


export default class ErrorLogMonitoring extends LightningElement {
	searchdate = '';
	classname = '';
	@track logsList = [];
	pickVal = '' ;
	@track selectedStatus;
    // @track value = "--Select--";

	@track showdiv = false;

	@track loader = false;
    @track error = null;
    // @track pageSize = 10;
	 @track pageSize = 20;
    @track pageNumber = 1;
    @track totalRecords = 0;
    @track totalPages = 0;
    @track recordEnd = 0;
    @track recordStart = 0;
    @track isPrev = true;
    @track isNext = true;
  


	handleDateChange(event){
        this.searchdate = event.target.value;
		console.log('::: searchdate -'+ this.searchdate);
    }

	handleClassNameChange(event){
		this.classname = event.target.value;
		console.log('::: searchclass -'+ this.classname);

	}

	onStatusSelection(event) {
		this.selectedStatus = event.detail;
		console.log('::: Event Details - '+JSON.stringify(event.detail));
		console.log('::: Selected Status = '+this.selectedStatus);
	}

	handleSearch(event){
		this.showdiv = true;
		console.log('::: handleSearch called ');
		this.getTranslog();
	}

	handleNext(){
		this.pageNumber = this.pageNumber+1;
		this.getTranslog();
	}

	handlePrev(){
		this.pageNumber = this.pageNumber-1;
		this.getTranslog();
	}

	getTranslog(){
		this.loader = true;
		 
		findLogs({
			searchDate: this.searchdate,
			searchClassName: this. classname,
			searchStatus : this.selectedStatus,
			pageSize: this.pageSize,
			pageNumber : this.pageNumber
		})
		.then(result => {
			this.loader = false;
			 
			if(result){
				var resultData = JSON.parse(result);
				console.log('::: result ='+resultData);
				this.logsList = resultData.dataListlimit;
				console.log('::: Result = '+JSON.stringify(this.logsList));
				this.pageNumber = resultData.pageNumber;
				this.totalRecords = resultData.totalRecords;
				this.recordStart = resultData.recordStart;
				this.recordEnd = resultData.recordEnd;
				this.totalPages = Math.ceil(resultData.totalRecords / this.pageSize);
				this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
				this.isPrev = (this.pageNumber == 1 || this.totalRecords < this.pageSize);
			}
		})
		.catch(error => {
			this.loader = false;
			this.error = error;
		})
	
	}

	//display no records
	get isDisplayNoRecords() {
		var isDisplay = true;
		if(this.logsList){
			if(this.logsList.length == 0){
				isDisplay = true;
			}else{
				isDisplay = false;
			}
		}
		return isDisplay;
	}

	handleReset(event) {

		// this.value = "--Select--";

		const lwcInputFields = this.template.querySelectorAll(
            'lightning-input'
        );
        if (lwcInputFields) {
            lwcInputFields.forEach(input => {
				input.value = ''; 
            });
        }
		 this.template.querySelector('c-generic-picklist').changePick();
	}

}