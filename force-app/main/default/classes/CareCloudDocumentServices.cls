public class CareCloudDocumentServices extends HttpFormDataBuilder{
@InvocableMethod( label='Send Document to CareCloud' description='Send Document to CareCloud System' category='DocumentToCareCloud' )
    public static void sendDocsToCareCloud(List<Id> oppIds) {
        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Insurance_Folder_ID__c FROM Carecloud_Setup__mdt LIMIT 1];
        for(Opportunity opp : [SELECT Id, AccountId , Account.CareCloud_Patient_Id__c  FROM Opportunity where Id IN: oppIds]) {
            uploadDocumentToCC(opp.AccountId, opp.Id, null, CareCloudMdt.Insurance_Folder_ID__c);     
        }      
    }
    
    @future (callout=true)
    public static void uploadDocumentToCC(Id patientId, Id parentId, Id contentVersionId, String ccFolderId){
        Blob fileBody;
        String fileName; // name
        String formatType; //pdf or image
        String accessToken = CareCloudAPIHelper.accessToken;
        
        Account accRec = [SELECT Id, CareCloud_Patient_Id__c  FROM Account where Id=: patientId];
        String careCloudPatientId = accRec.CareCloud_Patient_Id__c;

        try {
            ContentVersion contentData;
            
            if(String.isNotBlank(parentId)){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: parentId]; 
            	contentData = [SELECT Id, Title, FileExtension, ContentDocumentId, VersionData FROM ContentVersion where ContentDocumentId=: ContentDocumentLinks[0].ContentDocumentId LIMIT 1];
            }else if(String.isNotBlank(contentVersionId)){
                contentData = [SELECT Id, Title, FileExtension, ContentDocumentId, VersionData FROM ContentVersion where Id=: contentVersionId];
            }else{
                return;
            }
            
            fileName = contentData.Title.replaceAll(' ','');
            fileName = fileName.replaceAll('[^a-zA-Z0-9 -]', '');
            fileName = fileName.replaceAll('-','');
            System.debug('::: Document Details - '+fileName);
            formatType = contentData.FileExtension;
            
            String metadataStr = '{"document":{"name":"'+fileName+'.'+formatType+'","description":"Uploaded from Salesforce Integration", "format":"'+formatType+'","source":"'+ccFolderId+'"}}';
            fileBody = contentData.VersionData;
            
            String endPoint = 'https://api.carecloud.com/v1/documents/patient/'+careCloudPatientId+'/upload';
            
            Blob formData = build(metadataStr, EncodingUtil.base64Encode(fileBody));
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization','Bearer ' + accessToken);
            req.setHeader('Content-Type','multipart/form-data; boundary='+getBoundary());
            req.setHeader('Content-Transfer-Encoding','binary');
            req.setMethod('POST');
            req.setEndpoint(endPoint);
            req.setBodyAsBlob(formData);
            req.setTimeout(120000);
            
            Http http = new Http();
            HTTPResponse res;
            if(!Test.isRunningTest()) {
                res = http.send(req);
            } else {
                res = new HTTPResponse();
            }
            System.debug(':::Response - '+res);
        } catch(Exception ex) {
            System.debug('Exception in uploadDocumentToCC - '+ex.getMessage());
            String custMsg = 'Document upload error ParentId - '+parentId+' and Patient Id - '+ patientId;
            TransactionLogHandler.doHandleCustomException(ex, custMsg, 'CareCloudDocumentServices', 'uploadDocumentToCC');
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
    
    public class RefreshTokenResponse {
        public String access_token{get;set;}
        public String expires_in{get;set;}
        public String type{get;set;}
    }
        
    public class PatientResponse {
        public String patient;
    }
}