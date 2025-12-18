import { LightningElement,track ,api, wire } from 'lwc';
import { CloseActionScreenEvent } from "lightning/actions";
import modal from "@salesforce/resourceUrl/custommodalcss";
import { loadStyle } from "lightning/platformResourceLoader";
export default class FlowsheetQAComponent1 extends LightningElement {
    @api recordId;

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
               console.log('Hi all entered');
      }
      connectedCallback() {
        loadStyle(this, modal);
        console.log('Record ID in Child Component:', this.recordId); // Use this recordId as needed
    }
  
}