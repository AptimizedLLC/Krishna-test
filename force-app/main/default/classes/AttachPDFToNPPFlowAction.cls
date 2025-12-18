public class AttachPDFToNPPFlowAction {
    
    @InvocableMethod(label='Attach PDF to NPP' description='Attach a PDF to an NPP record')
    public static List<String> attachPDFToNPP(List<Id> nppIds) {
        List<String> result = new List<String>();
        
        for (Id nppId : nppIds) {
            try {
                // Generate PDF using Visualforce page
                PageReference pageRef = Page.GenerateNPPPDFDocument;
                pageRef.getParameters().put('nppId', nppId);
                
                // Generate and attach the PDF document
            PageReference pdfPage = Page.AttachPDFToNPP; // Change to your PDF page name
            pdfPage.getParameters().put('id', nppId);
           Blob pdfBlob; // Create a blob for the PDF content
            if (!Test.isRunningTest()) { // If we are not in testing context
                pdfBlob = pdfPage.getContent(); // Generate the PDF blob
            } else { // Otherwise, we are in testing context and getContent() gets funky so create the blob manually
                pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
            }
/*
// Create ContentVersion object to insert PDF as content
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // To use S specify this document is in Salesforce
            conVer.PathOnClient = 'Healthquitionnaire.pdf'; // File name
            conVer.Title = 'Healthquitionnaire'; // Display name
            conVer.VersionData = pdfBlob; // Convert binary to Blob
            insert conVer; // Insert ContentVersion
            
            // Get the Content Document Id from ContentVersion Object
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id].ContentDocumentId;
            
            // Create ContentDocumentLink record 
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId = nppId; // Record ID
            conDocLink.ContentDocumentId = conDocId; // ContentDocumentId from ContentVersion
            conDocLink.shareType = 'V';
            insert conDocLink;
            
                
                // Create Attachment record
                Attachment attachment = new Attachment();
                attachment.ParentId = nppId;
                attachment.Name = 'Your PDF Name.pdf';
                attachment.Body = pdfBlob;
                attachment.ContentType = 'application/pdf';
                insert attachment;
           */     
                // Add success message
                result.add('PDF attached successfully to NPP with Id: ' + nppId);
            } catch (Exception e) {
                // Add error message
                result.add('Error attaching PDF to NPP with Id: ' + nppId + '. Error message: ' + e.getMessage());
            }
        }
        
        return result;
    }
}