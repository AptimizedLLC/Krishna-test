global class DenialMissingInfoEmailScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        sendMissingInfoEmail();
    }

    public void sendMissingInfoEmail() {
        Date today = Date.today();

        // Query today's records with missing provider grouping, financial class, or inactive/null owner
        List<dn_Denial__c> invalidDenials = [
            SELECT Id, Name, CreatedDate,
                   dn_Financial_Class__c, dn_PROVIDER__c, dn_PROVIDER_GROUPING__c,
                   OwnerId, Owner.Name, Owner.IsActive
            FROM dn_Denial__c
            WHERE 
                CreatedDate = TODAY AND 
                (
                    dn_Financial_Class__c = null OR
                    dn_PROVIDER_GROUPING__c = null OR
                    OwnerId = null OR
                    Owner.IsActive = false
                )
        ];

        if (invalidDenials.isEmpty()) return;

        // Construct the base URL
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        // Build the HTML email body
        String emailBody = '<html><body>';
        emailBody += '<p>Hello Brandon,</p>';
        emailBody += '<p>The following <strong>Denial</strong> records created today are missing critical information:</p>';

        emailBody += '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;">';
        emailBody += '<tr>' +
                     '<th>Record Name</th>' +
                     '<th>Created Date</th>' +
                     '<th>Financial Class</th>' +
                     '<th>Provider</th>' +
                     '<th>Provider Grouping</th>' +
                     '<th>Owner</th>' +
                     '<th>Owner Status</th>' +
                     '</tr>';

        for (dn_Denial__c denial : invalidDenials) {
            String denialLink = baseUrl + '/lightning/r/dn_Denial__c/' + denial.Id + '/view';
            emailBody += '<tr>';
            emailBody += '<td><a href="' + denialLink + '">' + denial.Name + '</a></td>';
            emailBody += '<td>' + String.valueOf(denial.CreatedDate.date()) + '</td>';
            emailBody += '<td>' + (denial.dn_Financial_Class__c != null ? denial.dn_Financial_Class__c : 'Missing') + '</td>';
            emailBody += '<td>' + (denial.dn_PROVIDER__c != null ? denial.dn_PROVIDER__c : 'Missing') + '</td>';
            emailBody += '<td>' + (denial.dn_PROVIDER_GROUPING__c != null ? denial.dn_PROVIDER_GROUPING__c : 'Missing') + '</td>';
            emailBody += '<td>' + (denial.Owner != null ? denial.Owner.Name : 'Missing') + '</td>';
            emailBody += '<td>' + ((denial.Owner != null && denial.Owner.IsActive) ? 'Active' : 'Inactive') + '</td>';
            emailBody += '</tr>';
        }

        emailBody += '</table>';
        emailBody += '<p>Please review these records and update the necessary fields or reassign owners if needed.</p>';
        emailBody += '<p>Regards,<br/>Salesforce Team</p>';
        emailBody += '</body></html>';

        // Send email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'brandon.bart@alliancehealthsystem.com' }); // Change as needed
        email.setCcAddresses(new String[] {'AllianceFormsAlert@aptimized.com' }); // Add your CC emails here
        email.setSubject('Daily Alert: Denial Records with Missing Info');
        email.setHtmlBody(emailBody);
        email.setReplyTo('brandon.bart@alliancehealthsystem.com');
        email.setSenderDisplayName('Brandon Bart');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}