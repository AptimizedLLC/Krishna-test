public class medicarepdf {

    private final NPP__c nppRecord; // NPP__c object
    
    // Constructor
    public medicarepdf(ApexPages.StandardController standardPageController) {
       nppRecord = (NPP__c)standardPageController.getRecord(); 
    }

    
    // Method called from the Visualforce's action attribute
    public PageReference attachPDF() {
        system.debug('nppRecord.Id--->' + nppRecord.Id);
        
        try {
            // Query the NPP record
            NPP__c npp = [SELECT Id,HQ_Sign_Id__c,HQ_Motor_Vehiclle_Accident_Relevance__c// Add other fields as needed
                          FROM NPP__c 
                          WHERE Id = :nppRecord.Id];
            

 generateAndAttachPDF(new PageReference('/apex/MemberAuthorizationForm'), nppRecord.Id,'Member Authorization Form For A Designated Representative To Appeal A Determination'+' '+System.now());

            // Redirect the user
            PageReference redirectToRecord = new ApexPages.StandardController(npp).view();
            redirectToRecord.setRedirect(true); // Indicate that the redirect should be performed on the client side
            return redirectToRecord; // Send the User on their way
        } catch(Exception e) {
            // Handle any exceptions
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error attaching PDF: ' + e.getMessage()));
            return null;
        }
    }
    
    // Method to generate and attach PDF
    private void generateAndAttachPDF(PageReference pdfPage, Id recordId,String pdfName) {
        pdfPage.getParameters().put('id', recordId); // Pass any necessary parameters
        Blob pdfBlob;
        if (!Test.isRunningTest()) { 
            pdfBlob = pdfPage.getContent(); // Generate the PDF blob
        } else { 
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
        
        // Create ContentVersion object to insert PDF as content
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'Healthquitionnaire.pdf'; 
        conVer.Title = pdfName; 
        conVer.VersionData = pdfBlob; 
        insert conVer; 
        
        // Get the Content Document Id from ContentVersion Object
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id].ContentDocumentId;
        
        // Create ContentDocumentLink record 
        ContentDocumentLink conDocLink = new ContentDocumentLink();
        conDocLink.LinkedEntityId = recordId; 
        conDocLink.ContentDocumentId = conDocId; 
        conDocLink.shareType = 'V';
        insert conDocLink;
    }
@InvocableMethod(label='2Attach PDF to NPP Record')
    public static void attachPDF(List<String> recordIds) {
        // Iterate through each record ID passed from the flow
        for(String recordId : recordIds) {
            // Call the method to generate and attach PDFs
           new medicarepdf(null).generateAndAttachPDF(new PageReference('/apex/YourPDFPage'), recordId, 'YourPDFName');

    }
    }
}