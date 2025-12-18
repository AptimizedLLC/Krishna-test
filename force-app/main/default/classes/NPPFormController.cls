public with sharing class NPPFormController {

    @AuraEnabled
    public static String saveNPP(String issuesValue, String signatureData) {

        // Guest user permission validation
        if (UserInfo.getUserType() == 'Guest') {
            if (!Schema.sObjectType.NPP__c.isCreateable()) {
                throw new AuraHandledException('Guest user does not have permission to create NPP records.');
            }
            if (!Schema.sObjectType.ContentVersion.isCreateable()) {
                throw new AuraHandledException('Guest user does not have permission to upload files.');
            }
        }

        if (String.isBlank(issuesValue)) {
            throw new AuraHandledException('Issues value missing.');
        }

        if (String.isBlank(signatureData)) {
            throw new AuraHandledException('Signature data missing.');
        }

        // Create the NPP record
        NPP__c npp = new NPP__c(
            HQ_Any_issues_or_concerns_with_immune__c = issuesValue
        );
        insert npp;

        // Convert signature to Blob
        String base64Data = signatureData.split(',')[1];
        Blob fileBlob = EncodingUtil.base64Decode(base64Data);

        // Upload signature
        ContentVersion cv = new ContentVersion(
            Title = 'Signature',
            PathOnClient = 'signature.png',
            VersionData = fileBlob,
            FirstPublishLocationId = npp.Id
        );
        insert cv;

        return npp.Id;
    }
}