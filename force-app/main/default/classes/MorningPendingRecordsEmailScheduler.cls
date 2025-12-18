global class MorningPendingRecordsEmailScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        sendMorningEmail();
    }
	public static List<Rul_Mailing_List__mdt> rulcclist=[SELECT Id,MasterLabel,DeveloperName,CCMailData__c FROM Rul_Mailing_List__mdt];

    public static void sendMorningEmail() {
        
        
        // Query all RUL__c records with status 'Pending'
        List<RUL__c> pendingRecords = [
            SELECT Id, Name, RUL_Status__c, RUL_Assigned_To__c, RUL_Assigned_To__r.Name, CreatedById, CreatedBy.Name,
                   RUL_Patient_Name__r.Name, RUL_Issue_Type__c, RUL_Task_Age__c, 
                   Owner.Email, Owner.Name // Include the Owner fields
            FROM RUL__c 
            WHERE RUL_Status__c = 'Pending Assignee' OR RUL_Status__c = 'Pending Assignor'
        ];

        Map<String, List<RUL__c>> userRecordsMap = new Map<String, List<RUL__c>>();

        // Group records by owner's email
        for (RUL__c record : pendingRecords) {
            if (record.Owner != null && record.Owner.Email != null) {
                if (!userRecordsMap.containsKey(record.Owner.Email)) {
                    userRecordsMap.put(record.Owner.Email, new List<RUL__c>());
                }
                userRecordsMap.get(record.Owner.Email).add(record);
            }
        }

        // Get the base URL of the Salesforce instance
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        // List to hold email messages
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        // Prepare email for each owner with their pending records
        for (String email : userRecordsMap.keySet()) {
            List<RUL__c> userRecords = userRecordsMap.get(email);
            String ownerName = userRecords[0].Owner.Name; // Use owner's name

            String emailBody = '<html><body>';
            emailBody += '<p>Hello ' + ownerName + ',</p>';
            emailBody += '<p>Hope you are having a wonderful start to your day! </p>';
            emailBody += '<p>This is your daily reminder to review and update the pending RUL records assigned to you in Salesforce.</p>';
    
            // Add instruction for review
            emailBody += '<p>Below is the list of records that are still pending and require your attention. Please review each record and take the necessary actions. You can click on the RUL name to view the details in Salesforce.</p>';

            // Table Header
            emailBody += '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;">';
            emailBody += '<tr>' +
                         '<th>RUL Name</th>' +
                         '<th>Patient Name</th>' +
                         '<th>Issue Type</th>' +
                         '<th>Created By</th>' +
                         '<th>Status</th>' +
                         '<th>Task Age</th>' +
                         '</tr>';

            // Table Rows
            for (RUL__c record : userRecords) {
                String recordLink = baseUrl + '/lightning/r/RUL__c/' + record.Id + '/view';
                emailBody += '<tr>';
                emailBody += '<td><a href="' + recordLink + '">' + record.Name + '</a></td>';
                emailBody += '<td>' + (record.RUL_Patient_Name__r != null ? record.RUL_Patient_Name__r.Name : 'N/A') + '</td>';
                emailBody += '<td>' + (record.RUL_Issue_Type__c != null ? record.RUL_Issue_Type__c : 'N/A') + '</td>';
                emailBody += '<td>' + (record.CreatedBy != null ? record.CreatedBy.Name : 'N/A') + '</td>';
                emailBody += '<td>' + (record.RUL_Status__c != null ? record.RUL_Status__c : 'N/A') + '</td>';
                emailBody += '<td>' + (record.RUL_Task_Age__c != null ? String.valueOf(record.RUL_Task_Age__c) : 'N/A') + '</td>';
                emailBody += '</tr>';
            }
            emailBody += '</table>';
          
            // Add closing message
            emailBody += '<p>If you have any questions or need assistance, please reach out to the Admin.</p>';
            emailBody += '<p>Thank you for your prompt attention to these records.<br/>Best Regards,<br/>Salesforce Team</p>';
            emailBody += '</body></html>';

            // Create email message
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setToAddresses(new List<String>{email});
            //-------------------
           List<String> bccList = new List<String>();

               for (Rul_Mailing_List__mdt item : rulcclist) {
                if (item.MasterLabel == email) {
                    if (item.CCMailData__c != null) {
                        List<String> emails = item.CCMailData__c.split(',');
                        for (String emailAddress : emails) {
                            // Trim and remove single quotes
                            emailAddress = emailAddress.trim().replace('\'', '');
                            bccList.add(emailAddress);
                            System.debug('***entered cc ' + emailAddress);
                        }
                    }
                }
            }
            
            if (!bccList.isEmpty()) {
                emailMessage.setCcAddresses(bccList);
                System.debug('***cc list added: ' + bccList);
            }

            //------------------
            emailMessage.setSubject('Pending RUL Records Notification');
            emailMessage.setHtmlBody(emailBody);
            
            // Set the from email address and display name
            emailMessage.setReplyTo('brandon.bart@alliancehealthsystem.com');
            emailMessage.setSenderDisplayName('Brandon Bart');

            // Add the email to the list
            emailMessages.add(emailMessage);
        }

        // Send all emails at once
        if (!emailMessages.isEmpty()) {
            Messaging.sendEmail(emailMessages);
        }
    }
}