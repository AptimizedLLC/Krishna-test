global class NppCareCloudBatchable implements Database.Batchable<SObject>, Database.Stateful,Database.AllowsCallouts {
    private String nppId;

    // Constructor to initialize the batch class with parameters
    global NppCareCloudBatchable(String nppId) {
        this.nppId = nppId;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query the records to be processed
        return Database.getQueryLocator([SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :nppId]);
    }
    // Execute method to process each batch of records
    global void execute(Database.BatchableContext BC, List<ContentDocumentLink> contentDocumentLinks) {
        for (ContentDocumentLink contentDocumentLink : contentDocumentLinks) {
            ContentVersion contentData = [SELECT Id, Title, FileExtension, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentLink.ContentDocumentId LIMIT 1];

            Blob fileBody = contentData.VersionData;
            String fileName = contentData.Title.replaceAll(' ', '').replaceAll('[^a-zA-Z0-9 -]', '').replaceAll('-', '');
            String formatType = contentData.FileExtension;

            Carecloud_Setup__mdt careCloudMdt = [SELECT MasterLabel, Refresh_Token__c, Breeze_ID__c FROM Carecloud_Setup__mdt LIMIT 1];
            String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(careCloudMdt.Refresh_Token__c);

            try {
                Npp__c nppRec = [SELECT Id, HQ_Patient_Id2__c FROM Npp__c WHERE Id = :nppId];
                String patientId = nppRec.HQ_Patient_Id2__c;

                if (!NppCareCloudBatchableHelper.documentExistsInBreeze(fileName, formatType, patientId, careCloudMdt, accessToken)) {
                    String metadataStr = '{"document":{"name":"' + fileName + '.' + formatType + '","description":"Uploaded from Salesforce Integration", "format":"' + formatType + '","source":"' + careCloudMdt.Breeze_ID__c + '"}}';

                    String endPoint = 'https://api.carecloud.com/v1/documents/patient/' + patientId + '/upload';

                    Blob formData = NppCareCloudBatchableHelper.build(metadataStr, EncodingUtil.base64Encode(fileBody));

                    HttpRequest req = new HttpRequest();
                    req.setHeader('Authorization', 'Bearer ' + accessToken);
                    req.setHeader('Content-Type', 'multipart/form-data; boundary=' +HttpFormDataBuilder.getBoundary());
                    req.setHeader('Content-Transfer-Encoding', 'binary');
                    req.setMethod('POST');
                    req.setEndpoint(endPoint);
                    req.setBodyAsBlob(formData);
                    req.setTimeout(120000);

                    Http http = new Http();
                    if (!Test.isRunningTest()) {
                        HTTPResponse res = http.send(req);
                    } else {
                        HTTPResponse res = new HTTPResponse();
                         }
                } else {
                    // Document already exists in Breeze folder
                    System.debug('Document ' + fileName + '.' + formatType + ' already exists in CareCloud Breeze folder.');
                }

            } catch (Exception ex) {
                System.debug('Exception in CareCloudAuthConnection - ' + ex.getMessage());
                String custMsg = 'NPP error Id - ' + nppId;
                TransactionLogHandler.doHandleCustomException(ex, custMsg, 'CareCloudAuthConnection', 'uploadPatientDocument');
            }
        }
    }
    // Finish method to perform post-processing
    global void finish(Database.BatchableContext BC) {
        // Do something with the processedCount or results if needed
        System.debug('all records processed');
    }
}