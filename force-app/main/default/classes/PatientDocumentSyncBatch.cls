global class PatientDocumentSyncBatch extends HttpFormDataBuilder implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    global List<String> oppIds = new List<String>();
    global List<Opportunity> opportunityList2Upsert  = new List<Opportunity>();
    String query;
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        Blob fileBody;
        String fileName; // name
        String formatType; //pdf or image
        Carecloud_Setup__mdt CareCloudMdt = Carecloud_Setup__mdt.getInstance('Care_Cloud');
        String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);
        Map<Id, Opportunity> oppList = new Map<id, Opportunity>([SELECT Id, AccountId , Account.CareCloud_Patient_Id__c  FROM Opportunity where Intake_PDF_Ready__c=true AND Send_Intake_PDF_To_CareCLoud__c = false LIMIT 100]);
        System.debug('::: Opportunity List - '+oppList.size());
        if(oppList.size() > 0) {
            Map<Id, ContentDocumentLink> contentDocLinkMap = new Map<Id, ContentDocumentLink>();
            
            for (ContentDocumentLink cdl : [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :oppList.keySet() ORDER BY ContentDocument.CreatedDate DESC]) {
                if(contentDocLinkMap.containsKey(cdl.LinkedEntityId)){
                    continue;
                }
                
                contentDocLinkMap.put(cdl.LinkedEntityId, cdl);
            }
            
            for(Opportunity opp : oppList.values()) {
                System.debug('::: Opportunity Id - '+opp.Id);
                Id intakeId = opp.Id;
                
                try {            
                    String patientId = opp.Account.CareCloud_Patient_Id__c;
                    
                    if(!contentDocLinkMap.containsKey(opp.Id)){
                        continue;
                    }
                    
                    oppIds.add(intakeId);
                    
                    ContentVersion contentData = [SELECT Id, Title, FileExtension, ContentDocumentId, VersionData FROM ContentVersion where ContentDocumentId=: contentDocLinkMap.get(intakeId).ContentDocumentId LIMIT 1];
                    fileName = contentData.Title.replaceAll(' ','');
                    fileName = fileName.replaceAll('[^a-zA-Z0-9 -]', '');
                    fileName = fileName.replaceAll('-','');
                    
                    formatType = contentData.FileExtension;
                    
                    String metadataStr = '{"document":{"name":"'+fileName+'.'+formatType+'","description":"Uploaded from Salesforce Integration", "format":"'+formatType+'","source":"'+CareCloudMdt.Intake_Folder_ID__c+'"}}';
                    fileBody = contentData.VersionData;
                    
                    
                    String endPoint = 'https://api.carecloud.com/v1/documents/patient/'+patientId+'/upload';
                    
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
                    if(!Test.isRunningTest()) {
                        HTTPResponse res = http.send(req);
                    } else {
                        HTTPResponse res = new HTTPResponse();
                    } 
                    
                } catch(Exception ex) {
                    System.debug('Exception in CareCloudAuthConnection - '+ex.getMessage());
                    String custMsg = 'Intake error Id - '+intakeId ;
                    TransactionLogHandler.doHandleCustomException(ex, custMsg, 'CareCloudAuthConnection', 'uploadPatientDocument');
                } 
            }            
        }
        query = 'SELECT Id, Name, StageName, CloseDate, AccountId , Account.CareCloud_Patient_Id__c FROM Opportunity where Id IN: oppIds';
        System.debug('::: Query Result = '+Database.query(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        system.debug('::: Inside the Execute statement');
        System.debug('::: Scope Size = '+scope.size());
        for(Opportunity opp : scope)
        {
            Opportunity oppRecord = new Opportunity();
            oppRecord.Id = opp.Id;
            oppRecord.Send_Intake_PDF_To_CareCLoud__c=true;
            opportunityList2Upsert.add(oppRecord);
        }
        System.debug('::: opportunityList2Upsert in execute = '+opportunityList2Upsert.size());
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('::: Inside the Finish statement');
        System.debug('::: opportunityList2Upsert in finish = '+opportunityList2Upsert.size());   
        
        if(opportunityList2Upsert.size()>0) { 
            upsert opportunityList2Upsert;
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
}