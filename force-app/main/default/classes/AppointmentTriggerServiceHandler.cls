public without sharing class AppointmentTriggerServiceHandler {
    
    private static Id TEMPLATEID = [SELECT Id FROM EmailTemplate WHERE Name = 'New Appointment Today'].Id;

    @Future(callout=true)
    public static void generateAndSendPDFDocument(String jsonStringList, String jsonStringMap) {
        
        List<Appointment__c> newList = (List<Appointment__c>)Json.deserialize(jsonStringList,List<Appointment__c>.class);
        Map<Id, Appointment__c> oldMap = (Map<Id, Appointment__c>)Json.deserialize(jsonStringMap,Map<Id, Appointment__c>.class);
        
        Map<Id, Appointment__c> mapOfAcctIdAndAppnt = new Map<Id, Appointment__c>();
        Map<Id, Opportunity> mapOfAcctAndOpp = new Map<Id, Opportunity>();
        for(Appointment__c ap : newList){
            
            if((oldMap == null && ap.Appointment_Date_Time__c.Date() == Date.today()) || (oldMap != null && oldMap.get(ap.Id).Appointment_Date_Time__c.Date() != ap.Appointment_Date_Time__c.Date() && ap.Appointment_Date_Time__c.Date() == Date.today() )){
                mapOfAcctIdAndAppnt.put(ap.Patient__c, ap);     
            }
            
        }
        
        if(!mapOfAcctIdAndAppnt.keyset().isEmpty()){
            List<Opportunity> oppList = [SELECT Id, Name, AccountId,Patient_Name__c FROM Opportunity WHERE AccountId IN : mapOfAcctIdAndAppnt.keyset() AND CreatedDate = TODAY AND StageName = 'Initial Appointment'];
            if(!oppList.isEmpty()){
                for(Opportunity opp : oppList){
                    mapOfAcctAndOpp.put(opp.AccountId, opp);                    
                }           
            }
            
        }
        
        if(mapOfAcctAndOpp.size() > 0){
            for(Appointment__c apt : mapOfAcctIdAndAppnt.values()){
                Opportunity op = mapOfAcctAndOpp.get(apt.Patient__c);
                if(op != null){
                    ContentDocumentLink cd = generateContentFilesForIntakes(op);
                    sendEmailWithAttachment(cd, apt, op);
                }
            }
        }
    }
    
    public static void sendEmailWithAttachment(ContentDocumentLink contDoc, Appointment__c appt, Opportunity opt) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        String messageBody = '';

        ContentDocumentLink cdl = [Select Id, ContentDocument.LatestPublishedVersion.VersionData from ContentDocumentLink where Id =: contDoc.Id];
        Blob b = cdl.ContentDocument.LatestPublishedVersion.VersionData;
        //system.debug('ContentDocument.Title---->' + ContentDocument.LatestPublishedVersion.Title);
        attach.setFileName(opt.Patient_Name__c + '.pdf');
        attach.setBody(b);
        
        messageBody = '<html>\n'+
                        '\n'+
                        '<head>\n'+
                        '    <title></title>\n'+
                        '</head>\n'+
                        '\n'+
                        '<body>\n'+
                        '    <p><span style="font-family: Verdana, Geneva, sans-serif;">The following patient has been booked for an appointment today:</span></p><br/>\n'+
                        '    <p><span style="font-family: Verdana, Geneva, sans-serif;">&nbsp; &nbsp;Patient Chart Number :' +appt.Patient_Chart_Number__c+'<br>&nbsp; &nbsp;Provider Name :' +appt.Provider_Name__c+'<br>&nbsp; &nbsp;Appointment Date&Time :' +appt.Appointment_Date_Time__c+'<br><br>Please find Intake attached.&nbsp;</span></p>\n'+
                        '</body>\n'+
                        '\n'+
                        '</html>';
        
        system.debug('attach---->' + attach);
        system.debug('attachwwefefrg---->' + contDoc);
        email.setSubject('URGENT: Same Day Appointment Notification');
        email.setHtmlBody(messageBody);
        email.setToAddresses(new String[]{appt.Location_Email__c});

        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        
    }
    
    // DESC : To generate the file
    public static ContentDocumentLink generateContentFilesForIntakes(Opportunity opp) {
        
        
        //generate and attach the PDF document
        PageReference pdfPage = Page.GenerateIntakePDFDocument; 
        pdfPage.getParameters().put('id',opp.Id);
        Blob pdfBlob; //create a blob for the PDF content
        if (!Test.isRunningTest()) { //if we are not in testing context
            pdfBlob = pdfPage.getContent(); //generate the pdf blob
        } else { //otherwise, we are in testing context and getContent() gets funky so create the blob manually
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
            
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = opp.Patient_Name__c + '.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = opp.Patient_Name__c; // Display name of the files
        conVer.VersionData = pdfBlob; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        
            
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = opp.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;  
            
        return conDocLink;
        
    }


}