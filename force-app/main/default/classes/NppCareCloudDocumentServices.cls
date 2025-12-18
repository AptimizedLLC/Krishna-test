public class NppCareCloudDocumentServices  extends HttpFormDataBuilder {
/*
    @InvocableMethod(label='Send Document to CareCloud' description='Send Document to CareCloud System' category='DocumentToCareCloud')
    public static void sendDocsToCareCloud(List<Id> nppIds) {
        for (Id nppId : nppIds) {
            //uploadPatientDocuments(nppId);
			BatchableClass batch =new BatchableClass(nppId);
			Database.executeBatch(batch, 40, true);
        }
    }
*/
     @InvocableMethod(label='Send Document to CareCloud' description='Send Document to CareCloud System' category='DocumentToCareCloud')
    public static void sendDocsToCareCloud(List<Id> nppIds) {
        // Start the processing with the first index
        if (!nppIds.isEmpty()) {
        System.enqueueJob(new DocumentUploader(nppIds, 0));
    }
    }

    public static void sendDocToCareClouds(List<Id> nppIds) {
        //uploadPatientDocuments(nppId);
        for (Id nppId : nppIds) {
        NppCareCloudBatchable batch =new NppCareCloudBatchable(nppId);
		Database.executeBatch(batch,1);
        }
        
    }

    @future(callout=true)
    public static void uploadPatientDocuments(Id nppId) {
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :nppId];
        
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

                if (!documentExistsInBreeze(fileName, formatType, patientId, careCloudMdt, accessToken)) {
                    String metadataStr = '{"document":{"name":"' + fileName + '.' + formatType + '","description":"Uploaded from Salesforce Integration", "format":"' + formatType + '","source":"' + careCloudMdt.Breeze_ID__c + '"}}';
                    String endPoint = 'https://api.carecloud.com/v1/documents/patient/' + patientId + '/upload';

                    Blob formData = build(metadataStr, EncodingUtil.base64Encode(fileBody));

                    HttpRequest req = new HttpRequest();
                    req.setHeader('Authorization', 'Bearer ' + accessToken);
                    req.setHeader('Content-Type', 'multipart/form-data; boundary=' + getBoundary());
                    req.setHeader('Content-Transfer-Encoding', 'binary');
                    req.setMethod('POST');
                    req.setEndpoint(endPoint);
                    req.setBodyAsBlob(formData);
                    req.setTimeout(120000);

                    Http http = new Http();
                    if (!Test.isRunningTest()) {
                        HTTPResponse res = http.send(req);
                        if (res.getStatusCode() <> 200) {
                        // Parse the response properly
                       system.debug('failure response'+res);
                    }
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

    public static Blob build(String mdata, String data) {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('metadata', mdata);
        body += WriteBoundary();
        body += WriteBlobBodyParameter('payload', data, 'Patient_doc.pdf');
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }

    public static Boolean documentExistsInBreeze(String fileName, String formatType, String patientId, Carecloud_Setup__mdt careCloudMdt, String accessToken) {
    String query = 'SELECT Id FROM Document WHERE Patient__c = \'' + patientId + '\' AND Format__c = \'' + formatType + '\' AND Name = \'' + fileName + '\'';
    String endpoint = 'https://api.carecloud.com/v1/documents/query';
    
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + accessToken);
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');
    req.setEndpoint(endpoint);
    req.setBody(query);
    
    Http http = new Http();
    HTTPResponse res = http.send(req);
    if (res.getStatusCode() == 200) {
        // Parse the response properly
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Boolean documentExists = (Boolean)jsonResponse.get('success');
        return documentExists != null && documentExists;
    }
    return false;
}

    public class RefreshTokenResponse {
        public String access_token{get;set;}
        public String expires_in{get;set;}
        public String type{get;set;}
    }

    public class PatientResponse {
        public String patient;
    }
}