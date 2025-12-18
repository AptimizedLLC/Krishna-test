public class WorkerCompVerificationFlowController {

    @InvocableMethod(label='Generate WC Verification Form PDF' description='Generate WorkerComp Verification Form  PDF Doc And Attach to VOB' category='Insurance_Plan__c')
    public static void generateAndSendPDFDocument(List<Id> caseIds) {
        generateWCVerificationPDFDocument(caseIds[0]);
    }
    
    public static void generateWCVerificationPDFDocument(Id caseId) {
        if(caseId != null) {
            Case csRec = [SELECT Id, CaseNumber, Patient_VOB__c FROM Case WHERE Id=: caseId LIMIT 1];
            Pagereference pdfPage = Page.WorkerCompVerificationFormPDF;
            pdfPage.getParameters().put('id',csRec.Id);
            Blob pdfBlob; //create a blob for the PDF content
            if (!Test.isRunningTest()) { //if we are not in testing context
                pdfBlob = pdfPage.getContent(); //generate the pdf blob
            } else { //otherwise, we are in testing context and getContent() gets funky so create the blob manually
                pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
            }
            
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = csRec.CaseNumber + '.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = csRec.CaseNumber; // Display name of the files
            conVer.VersionData = pdfBlob; // converting your binary string to Blog
            insert conVer;    //Insert ContentVersion

             // First get the Content Document Id from ContentVersion Object
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = csRec.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'V';
            insert conDocLink;  
            
             //Send Document to Care Cloud
            if(csRec.Patient_VOB__c != null) {
                String patientId = csRec.Patient_VOB__c;
                System.debug('::: Insurance Plan - Care Cloud called - '+patientId+' and CaseId - '+caseId);
                Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c, Insurance_Folder_ID__c FROM Carecloud_Setup__mdt LIMIT 1];
                CareCloudDocumentServices.uploadDocumentToCC(patientId, caseId, null, CareCloudMdt.Insurance_Folder_ID__c);
            } else { // Case Not having Patient Details
                //Insert a Transaction Log to Debug
                System.debug('Exception in InsurancePlanDocFlowController');
                String custMsg = 'Insurance Plan Upload error for Patient - '+csRec.Patient_VOB__c;
                TransactionLogHandler.doHandleCustomException('', custMsg, 'WorkerCompVerificationFlowController', 'generateWCVerificationPDFDocument');
            }

        }
    }
}