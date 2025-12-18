import { LightningElement, api, track } from 'lwc';
import getPickListValues from '@salesforce/apex/PicklistController.getPickListValues';
import getFieldLabel from '@salesforce/apex/PicklistController.getFieldLabel';
export default class GenericPicklist extends LightningElement {
    @track options;
	@track selectedOption;
	@track isAttributeRequired = false;
	@api fieldName;
	@api objectName;
	@track fieldLabelName;

	// @api getFromParent;
	@track option ;
	// @track  getFromParent = "--Select--";
	 @track item;

	ittem;

	connectedCallback() {
        console.log('::: Object Name - '+this.objectName);
        console.log('::: Field Name - '+this.fieldName);
		getPickListValues({
				objApiName: this.objectName,
				fieldName: this.fieldName
			})
			.then(data => {
				this.options = data;
				this.ittem = data;
			})
			.catch(error => {
				this.displayError(error);
			});

		getFieldLabel({
				objName: this.objectName,
				fieldName: this.fieldName
			})
			.then(data => {
				this.fieldLabelName = data;
			})
			.catch(error => {
				this.displayError(error);
			});
	}
 @api changePick(){
	 console.log('::: Child Called :::');
	this.option.item = this.options[0];

 }
	
	selectionChangeHandler(event) {
		console.log('::: ittem --'+this.ittem);
		this.options = this.ittem ;

		this.dispatchEvent(new CustomEvent('selected', {
			detail: event.target.value
		}));
	}

	displayError(error) {
		this.error = 'Unknown error';
		if (Array.isArray(error.body)) {
			this.error = error.body.map(e => e.message).join(', ');
		} else if (typeof error.body.message === 'string') {
			this.error = error.body.message;
		}
	}

	get isPicklistDisabled() {
		return (this.options &&
			this.contrFieldValue !== 'Select') ? false : true;
	}
}