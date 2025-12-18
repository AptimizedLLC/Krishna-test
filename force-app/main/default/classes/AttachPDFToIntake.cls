public class AttachPDFToIntake {
    
    private final Opportunity op; //Account object
    
    //constructor
    public AttachPDFToIntake(ApexPages.StandardController standardPageController) {
       op = (Opportunity)standardPageController.getRecord(); 
    }
    
    //method called from the Visualforce's action attribute
    public PageReference attachPDF() {
        system.debug('op.Id--->' + op.Id);
        Opportunity oppty = [SELECT Id, Patient_Name__c FROM Opportunity WHERE Id =: op.Id];
        //generate and attach the PDF document
        PageReference pdfPage = Page.GenerateIntakePDFDocument; 
        pdfPage.getParameters().put('id',op.Id);
        Blob pdfBlob; //create a blob for the PDF content
        if (!Test.isRunningTest()) { //if we are not in testing context
            pdfBlob = pdfPage.getContent(); //generate the pdf blob
        } else { //otherwise, we are in testing context and getContent() gets funky so create the blob manually
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
        //Attachment attach = new Attachment(parentId = a.Id, Name = 'pdfAttachmentDemo.pdf', body = pdfBlob); //create the attachment object
        //insert attach; //insert the attachment
        
        //String yourFilesContent = 'TheBlogReaders.com File upload content';
 
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = oppty.Patient_Name__c + '.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = oppty.Patient_Name__c; // Display name of the files
        conVer.VersionData = pdfBlob; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = op.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        //redirect the user
        PageReference pageWhereWeWantToGo = new ApexPages.StandardController(op).view();
        pageWhereWeWantToGo.setRedirect(true); //indicate that the redirect should be performed on the client side
        return pageWhereWeWantToGo; //send the User on their way
    }

}