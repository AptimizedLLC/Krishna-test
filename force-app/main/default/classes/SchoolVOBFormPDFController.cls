public without sharing class SchoolVOBFormPDFController {
    @InvocableMethod(label='School VOB Form PDF' description='School VOB Form PDF Doc And Attach to VOB' category='Insurance_Plan__c')
    public static void generateAndSendPDFDocument(List<InputWrapper> inputs) {
        generateSchoolVOBPDFDocument(inputs[0]);
    }
    public static void generateSchoolVOBPDFDocument(InputWrapper input) {
        Pagereference pdfPage = Page.SchoolVOBFormPDF;
        pdfPage.getParameters().put('id',input.planId);
        Blob pdfBlob; //create a blob for the PDF content
        if (!Test.isRunningTest()) { //if we are not in testing context
            pdfBlob = pdfPage.getContent(); //generate the pdf blob
        } else { //otherwise, we are in testing context and getContent() gets funky so create the blob manually
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
        
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'School_VOB.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'School VOB'; // Display name of the files
        conVer.VersionData = pdfBlob; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = input.planId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;  
        
        //Send Document to Care Cloud
        if(String.isNotBlank(input.patientId)) {
            System.debug('::: School VOB - Care Cloud called - '+input.patientId+' and CaseId - '+input.caseId);           
            Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Insurance_Folder_ID__c FROM Carecloud_Setup__mdt LIMIT 1];
            CareCloudDocumentServices.uploadDocumentToCC(input.patientId, input.planId, null, CareCloudMdt.Insurance_Folder_ID__c);
        } else { // Case Not having Patient Details
            //Insert a Transaction Log to Debug
            System.debug('Exception in InsurancePlanDocFlowController');
            String custMsg = 'School VOB Upload error for Patient - '+input.patientId;
            TransactionLogHandler.doHandleCustomException('', custMsg, 'SchoolVOBFormPDFController', 'generateSchoolVOBPDFDocument');
        }
    }
    
    public class InputWrapper{
        @InvocableVariable
        public Id caseId;
        @InvocableVariable
        public Id planId;
        @InvocableVariable
        public Id patientId;
    }
}