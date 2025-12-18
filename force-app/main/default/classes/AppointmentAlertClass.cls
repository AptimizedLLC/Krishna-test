public class AppointmentAlertClass {
    public static void sendEmailAlert() {
        // Get today's date
        Date today = Date.today();
        Date onedayprior = today.addDays(1);
        Date threedaysprior = today.addDays(3);
        Datetime dt = Datetime.newInstance(2024, 7, 11, 0, 0, 0);
        
        // Create sets to store Patient Ids
        Set<Id> day3patientIds = new Set<Id>();
        Set<Id> day1patientIds = new Set<Id>();
        
        // Query Appointment records for day 3
        List<Appointment__c> day3Appointments = [
            SELECT Patient__c
            FROM Appointment__c
            WHERE Appointment_Date__c = :threedaysprior
            AND HQ_NPP_Completed__c = False
            AND HQ_Last_NPP_Mail_sent_On__c != :today
            AND Status__c = 'Pending'
            AND HQ_NPP_mail_sent__c = True
            AND CreatedDate >= :dt
        ];
        
        for (Appointment__c day3 : day3Appointments) {
           day3patientIds.add(day3.Patient__c);
        }
        
        
        // Query Appointment records for day 1
        List<Appointment__c> day1Appointments = [
            SELECT Patient__c
            FROM Appointment__c
            WHERE Appointment_Date__c = :onedayprior
            AND HQ_NPP_Completed__c = False
            AND HQ_Last_NPP_Mail_sent_On__c != :today
            AND Status__c = 'Pending'
            AND HQ_NPP_mail_sent__c = True
            AND CreatedDate >= :dt
        ];
        
        for (Appointment__c day1 : day1Appointments) {
            day1patientIds.add(day1.Patient__c);
        }
        
        // Query Accounts related to the patient Ids for day 3
        Map<Id, Account> day3AccountsMap = new Map<Id, Account>([
            SELECT Id, Name, PersonEmail
            FROM Account
            WHERE Id IN :day3patientIds
        ]);
        
        // Query Accounts related to the patient Ids for day 1
        Map<Id, Account> day1AccountsMap = new Map<Id, Account>([
            SELECT Id, Name, PersonEmail
            FROM Account
            WHERE Id IN :day1patientIds
        ]);
        
        // Create a list to store the Messaging.SingleEmailMessage objects
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        // Process day 3 emails
        for (Account acc : day3AccountsMap.values()) {
            String emailAddress = acc.PersonEmail;
            System.debug(emailAddress);
            // Check if the email address is valid
            if (String.isNotBlank(emailAddress)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{emailAddress});
                
               // OrgWideEmailAddress orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Paperwork Mail' LIMIT 1];
                //OrgWideEmailAddress orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Alliance Orthopedics Paperwork Mail' LIMIT 1];
                //if (orgEmail != null) {
                    email.setOrgWideEmailAddressId('0D2UP0000000DWj0AM');
                //email.setOrgWideEmailAddressId('0D2U80000000luzKAA');
                
                
                email.setSubject('Reminder To Fill out Mandatory Paperwork For Alliance Orthopedics');
                 String htmlBody = '<html>';
htmlBody += '<head>';
htmlBody += '<meta content="text/html; charset=UTF-8" http-equiv="content-type" />';
htmlBody += '<style type="text/css">';
htmlBody += '@import url(https://themes.googleusercontent.com/fonts/css?kit=3qINvnjb346LubKDfLRn69t6G6Z1RrRfgULZ1AHo7mPOfsfM6rvuuu7h1pY3r_-A);';
htmlBody += '@import url();'; // Add your additional CSS imports here if any

// Append your inline styles
htmlBody += '.image-container { position: relative; text-align: center; z-index: 1; }';
htmlBody += '.image-container img { width: 100%; display: block; margin: auto; }';
htmlBody += '.image-container2 { position: relative; text-align: center; z-index: 1; }';
htmlBody += '.image-container2 img { width: 87%; display: block; margin: auto; }';
htmlBody += '.ycpa { text-align: center; padding: 20px; font-weight: bold; font-size: 22px; }';
htmlBody += 'a.clk-btn:hover { background: #2b3278; }';
htmlBody += '.hlo-cname { padding: 10px; font-size: 20px; }';
htmlBody += '.pad { padding: 5px; margin: 5px; display: flex; justify-self: center; align-items: center; }';
htmlBody += '.ycmcm { padding: 10px; }';
htmlBody += '.size { font-size: 18px; }';
htmlBody += '.click { text-align: center; padding: 5px; }';
htmlBody += 'strong { padding-bottom: 4px; }';
htmlBody += 'body { width: 15cm; height: 29.7cm; margin: 0 auto; display: flex; flex-direction: column; }';
htmlBody += '.registration-box { border: 3px solid #2b3278; border-radius: 30px; padding: 20px; margin: 20px; background-color: white; flex-direction: column; }';
htmlBody += '.left-image { float: left; margin-right: 10px; max-height: 50%; width: 100%; max-width: 65px; }';
htmlBody += '.btn { display: inline-block; padding: 10px 20px; background: #2b3278; color: #fff!important; font-size: 20px; text-decoration: none; border-radius: 5px; }';
htmlBody += '.btn:hover { background-color: #5e768d; }';
htmlBody += '</style>';
htmlBody += '</head>';
htmlBody += '<body>';

// Add your email content
htmlBody += '<div class="image-container">';
htmlBody += '<a href="https://allianceortho.com">';
htmlBody += '<img src="https://allianceortho.file.force.com/servlet/servlet.ImageServer?id=015UP000003pD1W&oid=00Df2000001HEGJ&lastMod=1715319046000" />';
htmlBody += '</a>';
htmlBody += '</div>';
htmlBody += '<div>';
htmlBody += '<div class="ycpa">YOUR COMPELLING FUTURE AWAITS</div>';
htmlBody += '<div class="hlo-cname">Hello ' + acc.Name + ',</div>';
htmlBody += '<div class="ycmcm size">';
htmlBody += 'You&rsquo;re in the right place. Your condition may be new to you, but trust that conditions like yours are not new to us. This is the first step in your journey towards becoming #BetterEveryday. The image below will guide you through the three easy steps to complete. Here&rsquo;s how easy it is to get started:';
htmlBody += '</div>';
htmlBody += '</div>';

// Boxed Section
htmlBody += '<div class="registration-box">';
htmlBody += '<div class="image-container2">';
htmlBody += '<a href="https://allianceortho.com">';
htmlBody += '<img src="https://allianceortho.file.force.com/servlet/servlet.ImageServer?id=015UP000003pCmz&oid=00Df2000001HEGJ&lastMod=1715319054000" />';
htmlBody += '</a>';
htmlBody += '</div>';
htmlBody += '</div>';
htmlBody += '<div style="text-align: center; padding: 5px; color: #000000;">';
htmlBody += '<a href="https://allianceorthoonline.com/User/'+acc.Id+'" class="btn">LET\'S GET STARTED!</a>';
htmlBody += '<p style="font-size: 18px;">If the above button does not work, please copy and paste the link in the address bar: <br> URL link to form</p>';
htmlBody += '</div>';

htmlBody += '</body>';
htmlBody += '</html>';
                    email.setHtmlBody(htmlBody);
                emailMessages.add(email);

            }
        }
        
        // Process day 1 emails
        for (Account acc : day1AccountsMap.values()) {
            String emailAddress = acc.PersonEmail;
            System.debug(emailAddress);
            // Check if the email address is valid
            if (String.isNotBlank(emailAddress)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{emailAddress});
                
               // OrgWideEmailAddress orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Paperwork Mail' LIMIT 1];
                //OrgWideEmailAddress orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Alliance Orthopedics Paperwork Mail' LIMIT 1];
                //if (orgEmail != null) {
                    email.setOrgWideEmailAddressId('0D2UP0000000DWj0AM');
               // email.setOrgWideEmailAddressId('0D2U80000000luzKAA');
                
                email.setSubject('Reminder To Fill out Mandatory Paperwork For Alliance Orthopedics');
                 String htmlBody = '<html>';
htmlBody += '<head>';
htmlBody += '<meta content="text/html; charset=UTF-8" http-equiv="content-type" />';
htmlBody += '<style type="text/css">';
htmlBody += '@import url(https://themes.googleusercontent.com/fonts/css?kit=3qINvnjb346LubKDfLRn69t6G6Z1RrRfgULZ1AHo7mPOfsfM6rvuuu7h1pY3r_-A);';
htmlBody += '@import url();'; // Add your additional CSS imports here if any

// Append your inline styles
htmlBody += '.image-container { position: relative; text-align: center; z-index: 1; }';
htmlBody += '.image-container img { width: 100%; display: block; margin: auto; }';
htmlBody += '.image-container2 { position: relative; text-align: center; z-index: 1; }';
htmlBody += '.image-container2 img { width: 87%; display: block; margin: auto; }';
htmlBody += '.ycpa { text-align: center; padding: 20px; font-weight: bold; font-size: 22px; }';
htmlBody += 'a.clk-btn:hover { background: #2b3278; }';
htmlBody += '.hlo-cname { padding: 10px; font-size: 20px; }';
htmlBody += '.pad { padding: 5px; margin: 5px; display: flex; justify-self: center; align-items: center; }';
htmlBody += '.ycmcm { padding: 10px; }';
htmlBody += '.size { font-size: 18px; }';
htmlBody += '.click { text-align: center; padding: 5px; }';
htmlBody += 'strong { padding-bottom: 4px; }';
htmlBody += 'body { width: 15cm; height: 29.7cm; margin: 0 auto; display: flex; flex-direction: column; }';
htmlBody += '.registration-box { border: 3px solid #2b3278; border-radius: 30px; padding: 20px; margin: 20px; background-color: white; flex-direction: column; }';
htmlBody += '.left-image { float: left; margin-right: 10px; max-height: 50%; width: 100%; max-width: 65px; }';
htmlBody += '.btn { display: inline-block; padding: 10px 20px; background: #2b3278; color: #fff!important; font-size: 20px; text-decoration: none; border-radius: 5px; }';
htmlBody += '.btn:hover { background-color: #5e768d; }';
htmlBody += '</style>';
htmlBody += '</head>';
htmlBody += '<body>';

// Add your email content
htmlBody += '<div class="image-container">';
htmlBody += '<a href="https://allianceortho.com">';
htmlBody += '<img src="https://allianceortho.file.force.com/servlet/servlet.ImageServer?id=015UP000003pD1W&oid=00Df2000001HEGJ&lastMod=1715319046000" />';
htmlBody += '</a>';
htmlBody += '</div>';
htmlBody += '<div>';
htmlBody += '<div class="ycpa">YOUR COMPELLING FUTURE AWAITS</div>';
htmlBody += '<div class="hlo-cname">Hello ' + acc.Name + ',</div>';
htmlBody += '<div class="ycmcm size">';
htmlBody += 'You&rsquo;re in the right place. Your condition may be new to you, but trust that conditions like yours are not new to us. This is the first step in your journey towards becoming #BetterEveryday. The image below will guide you through the three easy steps to complete. Here&rsquo;s how easy it is to get started:';
htmlBody += '</div>';
htmlBody += '</div>';

// Boxed Section
htmlBody += '<div class="registration-box">';
htmlBody += '<div class="image-container2">';
htmlBody += '<a href="https://allianceortho.com">';
htmlBody += '<img src="https://allianceortho.file.force.com/servlet/servlet.ImageServer?id=015UP000003pCmz&oid=00Df2000001HEGJ&lastMod=1715319054000" />';
htmlBody += '</a>';
htmlBody += '</div>';
htmlBody += '</div>';
htmlBody += '<div style="text-align: center; padding: 5px; color: #000000;">';
htmlBody += '<a href="https://allianceorthoonline.com/User/'+acc.Id+'" class="btn">LET\'S GET STARTED!</a>';
htmlBody += '<p style="font-size: 18px;">If the above button does not work, please copy and paste the link in the address bar: <br> URL link to form</p>';
htmlBody += '</div>';

htmlBody += '</body>';
htmlBody += '</html>';
                    email.setHtmlBody(htmlBody);
                emailMessages.add(email);
                System.debug(email);
            }
        }


 List<Account> accountsToUpdateDay3 = new List<Account>();
for (Account acc : day3AccountsMap.values()) {
    acc.Last_NPP_Mail_Sent_On__c = today;
    accountsToUpdateDay3.add(new Account(Id = acc.Id, Last_NPP_Mail_Sent_On__c = today));
}

// Update day 1 accounts
List<Account> accountsToUpdateDay1 = new List<Account>();
for (Account acc : day1AccountsMap.values()) {
    acc.Last_NPP_Mail_Sent_On__c = today;
    accountsToUpdateDay1.add(new Account(Id = acc.Id, Last_NPP_Mail_Sent_On__c = today));
}

// Perform bulk updates
if (!accountsToUpdateDay3.isEmpty()) {
    update accountsToUpdateDay3;
}

if (!accountsToUpdateDay1.isEmpty()) {
    update accountsToUpdateDay1;
}
        // Send the email messages in bulk
        if (!emailMessages.isEmpty() && !Test.isRunningTest()) {
            List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
            // Handle the send results if needed
            for (Messaging.SendEmailResult result : sendResults) {
                if (!result.isSuccess()) {
                    System.debug('Error sending email: ' + result.getErrors()[0].getMessage());
                }
            }
        } else {
            System.debug('No valid email addresses found or running in test mode.');
        }  
    }
}