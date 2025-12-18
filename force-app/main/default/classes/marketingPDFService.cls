public class marketingPDFService {
    
     public static final Map<String, String> locationToRegionMap = new Map<String, String>{
        'Old Bridge'    => 'South',
        'Middletown'    => 'South',
        'Freehold'      => 'South',
        'East Brunswick'=> 'South',
        'Union'         => 'North',
        'Fairlawn'      => 'North',
        'Bloomfield'    => 'North',
        'Randolph'      => 'North',
        'Company Wide'  => 'Company Wide'
    };
    
 	public static List<Rul_Mailing_List__mdt> rulcclist=[SELECT Id,MasterLabel,DeveloperName,CCMailData__c,CCMailData2__c FROM Rul_Mailing_List__mdt WHERE Type__c='Marketing'];
// Wrapper class for input from Flow
    public class FlowInput {
        @InvocableVariable(required=true)
        public Id flowSheetId;
    }

    // Wrapper method to be called from Flow
    @InvocableMethod(label='Generate PDF and Send Email' description='Generates a PDF, attaches it, and sends via email')
    public static void generateAndSend(List<FlowInput> inputs) {
        for (FlowInput input : inputs) {
            generateAndAttachPDF(input.flowSheetId);
        }
    }    
    
public static void generateAndAttachPDF(Id flowSheetId) {
    try {
     // Get the Flow Sheet record
        Marketing_Campaign__c fs = [SELECT Id, Name,Initiative_Region__c FROM Marketing_Campaign__c WHERE Id = :flowSheetId LIMIT 1];

        // Render the PDF from the Visualforce page
        PageReference pdfPage = Page.MarketigPDFPage;
        pdfPage.getParameters().put('id', flowSheetId);
        Blob pdfBlob = pdfPage.getContent();

        // Create an Attachment and relate to Flow Sheet or Parent
        Attachment attach = new Attachment();
        attach.ParentId = flowSheetId; // Or fs.Appointment__c if attaching to parent
        attach.Name = 'Marketing event' + fs.Name + '.pdf';
        attach.ContentType = 'application/pdf';
        attach.Body = pdfBlob;

        insert attach;
    	string name='Marketing event' + fs.Name + '.pdf';
        //---------------
         List<String> ToList = new List<String>();

               for (Rul_Mailing_List__mdt item : rulcclist) {
                if (locationToRegionMap.get(fs.Initiative_Region__c).contains(item.MasterLabel)) {
                    if (item.CCMailData2__c != null) {
                        List<String> emails = item.CCMailData2__c.split(',');
                        for (String emailAddress : emails) {
                            // Trim and remove single quotes
                            emailAddress = emailAddress.trim().replace('\'', '');
                            ToList.add(emailAddress);
                            System.debug('***entered cc ' + emailAddress);
                        }
                    }
                }
            }
        
        String emailBody = '<html><body>';
            emailBody += '<p>Hello  Marketing Team ,</p>';
            emailBody += '<p>I hope you\'re doing well. </p>';
            emailBody += '<p>As part of our  marketing initiatives, We are sharing an overview of our planned campaigns.</p>';
            emailBody += '<p>Please refer to the attached PDF for the full details.<br/>Best Regards,<br/>Salesforce Team</p>';
            emailBody += '</body></html>';
        //---------------
        
        
    	sendEmailWithAttachment(ToList,'Marketing Campaigns – Key Details ',emailBody,pdfBlob,name);
        } catch (Exception e) {
            System.debug('Failed to retrieve object: ' + e.getMessage());
            throw new VisualforceException('Error retrieving object: ' + e.getMessage());
        }
       
    }
public static void sendEmailWithAttachment(List<String> recipientEmail, String subject, String bodyText, Blob attachmentBody, String attachmentFileName) {
        // Create a new email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Set recipient
        email.setToAddresses( recipientEmail );
        
        // Set email subject and body
        email.setSubject(subject);
        email.setHtmlBody(bodyText);
        
        // Create an attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(attachmentFileName);
        attachment.setBody(attachmentBody);
        attachment.setContentType('application/pdf'); // Change as needed

        // Attach the file
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        // Optional: handle result
        if (!results[0].isSuccess()) {
            System.debug('Failed to send email: ' + results[0].getErrors()[0].getMessage());
        } else {
            System.debug('Email sent successfully.');
        }
    }
    


}