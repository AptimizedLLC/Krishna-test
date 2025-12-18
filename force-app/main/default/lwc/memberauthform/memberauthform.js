import { LightningElement, track } from 'lwc';
import uploadSignature from '@salesforce/apex/SignatureUploadController.uploadSignature';
import generatePdf from '@salesforce/apex/PDFGeneratorController.generatePdf';
import getPdfDownloadUrl from '@salesforce/apex/PDFGeneratorController.getPdfDownloadUrl';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MemberAuthForm extends LightningElement {
    @track accountId = '';
    @track fileData;
    @track fileName = '';
    @track fileType = '';
    @track imagePreviewUrl = '';
    @track signatureUrl = '';
    @track countdown = 10;
    @track isStep1 = true;
    @track isStep2 = false;
    @track isStep3 = false;
    @track isStep4 = false;
    @track isUploading = false;
    @track error = '';
    pdfContentVersionId;

    handleAccountChange(event) {
        this.accountId = event.target.value?.trim();
    }

    handleFileChange(event) {
        this.error = '';
        const file = event.target.files[0];
        if (!file) return;

        const maxBytes = 5 * 1024 * 1024;
        if (file.size > maxBytes) {
            this.error = 'File too large. Maximum allowed size is 5 MB.';
            return;
        }

        if (!/image\/(png|jpeg|jpg)/.test(file.type)) {
            this.error = 'Unsupported file type. Use PNG or JPEG.';
            return;
        }

        this.fileName = file.name;
        this.fileType = file.type;
        const reader = new FileReader();
        reader.onload = () => {
            const result = reader.result;
            const base64Idx = result.indexOf('base64,') + 'base64,'.length;
            this.fileData = result.substring(base64Idx);
            this.imagePreviewUrl = result;
        };
        reader.readAsDataURL(file);
    }

    // STEP 1 → Upload
    async handleUpload() {
        this.error = '';
        if (!this.accountId) {
            this.error = 'Please enter Account Id.';
            return;
        }
        if (!this.fileData) {
            this.error = 'Please upload a signature first.';
            return;
        }

        this.isUploading = true;
        this.isStep1 = false;
        this.isStep2 = true;
        this.countdown = 10;

        // Start countdown before proceeding
        let interval = setInterval(() => {
            this.countdown -= 1;
            if (this.countdown <= 0) {
                clearInterval(interval);
                this.finishUpload();
            }
        }, 1000);
    }

    async finishUpload() {
        try {
            this.signatureUrl = await uploadSignature({
                accountId: this.accountId,
                fileName: this.fileName,
                base64Data: this.fileData,
                mimeType: this.fileType
            });
            this.isStep2 = false;
            this.isStep3 = true;
        } catch (err) {
            let msg = 'Error uploading signature.';
            if (err?.body?.message) msg = err.body.message;
            else if (err?.message) msg = err.message;
            this.error = msg;
            this.isStep1 = true;
            this.isStep2 = false;
        } finally {
            this.isUploading = false;
        }
    }

    // STEP 3 → Generate PDF
    async handleGeneratePdf() {
        this.error = '';
        if (!this.accountId) {
            this.error = 'Account Id missing.';
            return;
        }

        try {
            this.pdfContentVersionId = await generatePdf({ accountId: this.accountId });
            this.isStep3 = false;
            this.isStep4 = true;
        } catch (err) {
            let msg = 'Error generating PDF.';
            if (err?.body?.message) msg = err.body.message;
            else if (err?.message) msg = err.message;
            this.error = msg;
        }
    }

    // STEP 4 → Download PDF
    async handleDownloadPdf() {
        if (!this.pdfContentVersionId) {
            this.error = 'PDF not available.';
            return;
        }
        try {
            const url = await getPdfDownloadUrl({ contentVersionId: this.pdfContentVersionId });
            window.open(url, '_blank');
        } catch (err) {
            let msg = 'Error fetching PDF download URL.';
            if (err?.body?.message) msg = err.body.message;
            else if (err?.message) msg = err.message;
            this.error = msg;
        }
    }
}