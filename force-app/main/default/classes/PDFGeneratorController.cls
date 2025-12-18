public with sharing class PDFGeneratorController {

    /**
     * Generate a PDF for an Account using the latest signature.
     * @param accountId Id of the Account
     * @return ContentVersion Id of the generated PDF
     */
    @AuraEnabled
    public static Id generatePdf(Id accountId) {
        if(accountId == null) {
            throw new AuraHandledException('Account Id is required.');
        }

        // 1️⃣ Get latest signature ContentVersion Id
        Id signatureId = SignatureUploadController.getLatestSignature(accountId);

        // 2️⃣ Generate PDF from VF page (replace your VF page name here)
        PageReference pdfPage = Page.generatememberauthorizationform;
        pdfPage.getParameters().put('accountId', accountId);
        pdfPage.getParameters().put('patientSignatureId', signatureId);

        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch(Exception e) {
            throw new AuraHandledException('PDF generation failed: ' + e.getMessage());
        }

        // 3️⃣ Save PDF as ContentVersion and attach to Account
        ContentVersion pdfCv = new ContentVersion();
        pdfCv.Title = 'AccountSummary_' + DateTime.now().getTime();
        pdfCv.PathOnClient = 'AccountSummary.pdf';
        pdfCv.VersionData = pdfBlob;
        pdfCv.IsMajorVersion = true;
        insert pdfCv;

        pdfCv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :pdfCv.Id LIMIT 1];
        ContentDocumentLink pdfCdl = new ContentDocumentLink(
            ContentDocumentId = pdfCv.ContentDocumentId,
            LinkedEntityId = accountId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert pdfCdl;

        return pdfCv.Id;
    }

    /**
     * Get download URL for generated PDF
     */
    @AuraEnabled
    public static String getPdfDownloadUrl(Id contentVersionId) {
        return '/sfc/servlet.shepherd/version/download/' + contentVersionId;
    }
}