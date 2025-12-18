public with sharing class SignatureUploadController {

    /**
     * Upload a signature image and attach it to an Account.
     * @param accountId Id of the Account
     * @param fileName Name of uploaded file
     * @param base64Data Base64 encoded image content
     * @param mimeType MIME type (image/png, image/jpeg)
     * @return URL of the uploaded ContentVersion for preview
     */
    @AuraEnabled
    public static String uploadSignature(Id accountId, String fileName, String base64Data, String mimeType) {
        if(accountId == null) {
            throw new AuraHandledException('Account Id is required.');
        }
        if(String.isBlank(base64Data)) {
            throw new AuraHandledException('Signature image is required.');
        }

        // 1️⃣ Create ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName != null ? fileName : 'Signature';
        cv.PathOnClient = (fileName != null ? fileName : 'Signature') + '.png';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        insert cv;

        // 2️⃣ Link ContentDocument to Account
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = accountId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;

        // 3️⃣ Return URL for preview
        return '/sfc/servlet.shepherd/version/download/' + cv.Id;
    }

    /**
     * Get latest signature ContentVersion Id for an Account
     */
    @AuraEnabled
    public static Id getLatestSignature(Id accountId) {
        ContentDocumentLink cdl = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :accountId
            LIMIT 1
        ];
        ContentVersion cv = [
            SELECT Id
            FROM ContentVersion
            WHERE ContentDocumentId = :cdl.ContentDocumentId
            ORDER BY VersionNumber DESC
            LIMIT 1
        ];
        return cv.Id;
    }
}