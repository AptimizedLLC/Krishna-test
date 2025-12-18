public class AttachPDFToNPP {
    
    private final NPP__c nppRecord; // NPP__c object
    
    // Constructor
    public AttachPDFToNPP(ApexPages.StandardController standardPageController) {
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
            
            // Generate and attach the first PDF document
            generateAndAttachPDF(Page.GenerateNPPPDFDocument, nppRecord.Id,'Health Questionnaire'+' '+System.now());
            
            // Generate and attach the second PDF document
            generateAndAttachPDF(new PageReference('/apex/InformedConsent'), nppRecord.Id,'Informed Consent'+' '+System.now());
            generateAndAttachPDF(new PageReference('/apex/TCPA'), nppRecord.Id,'Telephone Consumer Protection Act Prior Express Written Consent'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/SummaryPlanDescription'), nppRecord.Id,'Summary Plan Description Form'+' '+System.now());
generateAndAttachPDF(new PageReference('/apex/RequestForMedicalForms'), nppRecord.Id,'Request For Medical Records'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/MemberAuthorizationForm'), nppRecord.Id,'Member Authorization Form For A Designated Representative To Appeal A Determination'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/InsuranceAndBillingPolicies'), nppRecord.Id,'Insurance And Billing Policies'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/DIPSF'), nppRecord.Id,'Disclosure Of Insurance Participation Status And Fees'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/NOPP'), nppRecord.Id,'Notice Of Privacy Practices'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/CARNPP'), nppRecord.Id,'Consent And Acknowledgement Of Receipt Of Notice Of Privacy Practices'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/AgreementToForwardpayment'), nppRecord.Id,'Agreement To Forward payment'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/OpiodConsent'), nppRecord.Id,'Opiod Consent'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/XrayWaiver'), nppRecord.Id,'X-ray Waiver - Release And Indemnification Form'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/APDF'), nppRecord.Id,'Auto policy Declaration Form'+' '+System.now());
generateAndAttachPDF(new PageReference('/apex/motorVehicleAccident'), nppRecord.Id,'Motor Vehicle Accident Form'+' '+System.now());
generateAndAttachPDF(new PageReference('/apex/DryNeedlingConsent'), nppRecord.Id,'Dry Needling Consent'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/ReceiptOfPrivacyPractice'), nppRecord.Id,'Acknowledgement Of Receipt Of Notice Of Privacy Practice And Patient Policies And Procedures'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/CreditCard2'), nppRecord.Id,'Credit Card Authorization Form'+' '+System.now());
 generateAndAttachPDF(new PageReference('/apex/SocialMediaNPP'), nppRecord.Id,'Social Media and AI Scribe HIPAA Authorization'+' '+System.now());

            //Generate AssignmentOfBenefitsForm and IPPLFA Only when Motor vehicle accident relevance equals Motor vehicle accident
            If(npp.HQ_Motor_Vehiclle_Accident_Relevance__c=='Motor vehicle accident'){
                 generateAndAttachPDF(new PageReference('/apex/AssignmentOfBenefitsForm'), nppRecord.Id,'Assignment Of Benefits Form');
                generateAndAttachPDF(new PageReference('/apex/IPPLFA'), nppRecord.Id,'Irrevocable Practice Lien-patient Financial Agreement');
          } 
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
           new AttachPDFToNPP(null).generateAndAttachPDF(new PageReference('/apex/YourPDFPage'), recordId, 'YourPDFName');

    }
    }
}