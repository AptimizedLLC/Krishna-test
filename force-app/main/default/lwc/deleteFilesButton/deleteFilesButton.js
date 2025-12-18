import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import deleteAllFiles from '@salesforce/apex/NPPFileHandler.deleteAllFiles';
import updateHQSignId from '@salesforce/apex/NPPFileHandler.updateHQSignId';
import generatePdf from '@salesforce/apex/PDFGeneratorController.generatePdf';
import getPdfDownloadUrl from '@salesforce/apex/PDFGeneratorController.getPdfDownloadUrl';

export default class UploadAndGeneratePdf extends LightningElement {
    @api recordId;
    @track showUploader = false;
    @track showSpinner = false;
    @track isDisabled = false;
    acceptedFormats = '.pdf,.jpg,.jpeg,.png';
    isMultiple = false;

    async handleClick() {
        this.isDisabled = true;
        this.showSpinner = true;
        try {
            // Step 1: Delete existing files
            await deleteAllFiles({ nppId: this.recordId });

            // Step 2: Show upload section
            this.showUploader = true;
            this.showSpinner = false; // hide spinner for file selection

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Ready',
                    message: 'Old files deleted. Please upload the new signature.',
                    variant: 'info'
                })
            );
        } catch (error) {
            this.showSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Deleting Files',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );
            this.isDisabled = false;
        }
    }

    async handleUploadFinished() {
        this.showSpinner = true;
        try {
            // Step 3: Update HQ_Sign_Id__c
            await updateHQSignId({ nppId: this.recordId });

            // Step 4: Generate PDF and get ContentVersion Id
            const pdfId = await generatePdf({ accountId: this.recordId });

            // Step 5: Get download URL and open PDF
            const pdfUrl = await getPdfDownloadUrl({ contentVersionId: pdfId });
            window.open(pdfUrl, '_blank');

            // Step 6: Success toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Signature uploaded and PDF generated successfully!',
                    variant: 'success'
                })
            );

            // Step 7: Close modal and reload browser after short delay
            this.dispatchEvent(new CloseActionScreenEvent());
            setTimeout(() => window.top.location.reload(), 2500);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Generating PDF',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );
        } finally {
            this.showSpinner = false;
            this.showUploader = false;
            this.isDisabled = false;
        }
    }
}