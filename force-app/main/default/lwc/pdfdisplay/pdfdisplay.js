import { LightningElement, api } from 'lwc';
import getVFHtml from '@salesforce/apex/VFExtractorController.getVFHtml';

export default class ShowVfContent extends LightningElement {
    htmlContent;

    connectedCallback() {
        getVFHtml()
            .then(result => {
                this.htmlContent = result;
                this.renderToDom();
            })
            .catch(error => {
                console.error(error);
            });
    }

    renderToDom() {
        if (this.htmlContent) {
            const container = this.template.querySelector('.vf-container');
            if (container) {
                container.innerHTML = this.htmlContent;
            }
        }
    }
}