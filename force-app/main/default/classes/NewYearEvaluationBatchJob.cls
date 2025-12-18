/*
public class NewYearEvaluationBatchJob {
  public static List<Appointment__c>applist=[SELECT Id, Visit_Reason__c ,Appointment_Date_Time__c, Patient__c,Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c,
                                    Patient__r.PersonEmail
                                    FROM Appointment__c 
                                    WHERE Visit_Reason__c LIKE '%New Year Evaluation%' 
                                    AND Appointment_Date__c >= 2025-01-01 
                                    AND Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c=false 
                                    AND Patient__r.PersonEmail<>null limit 50
                                     ];
    Public static void methode1(){
		set<Id>AccountIds=new set<Id>();
        for(Appointment__c app:applist){
            AccountIds.add(app.Patient__c);
            
        }
        system.debug('AccountIds list are'+AccountIds);
        List<Account>acclist=[SELECT Id, Name, PersonEmail FROM Account WHERE Id IN :AccountIds ];
        // Create a list to store the Messaging.SingleEmailMessage objects
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        //--------------------------------------------------------------------------------
        
        // Process emails
        for (Account acc :acclist) {
            String emailAddress = acc.PersonEmail;
            System.debug(emailAddress);
            // Check if the email address is valid
            if (String.isNotBlank(emailAddress)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{emailAddress});
                

                    email.setOrgWideEmailAddressId('0D2UP0000000DWj0AM');
                               
                
                email.setSubject('Happy New Year!');
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
                    htmlBody += 'We hope this message finds you well. As we move into 2025, we kindly ask that you update your paperwork with Alliance Orthopedics. Please click the link below to complete the necessary steps.';
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
        
        List<Account> accountsToUpdate = new List<Account>();
                for (Account acc : acclist) {
                    accountsToUpdate.add(new Account(Id = acc.Id, NPP_New_Year_Evaluation_Mail_Sent__c = true,Last_NPP_Mail_Sent_On__c =system.today()));
                }
                        
                        // Perform bulk updates
                if (!accountsToUpdate.isEmpty()) {
                    update accountsToUpdate;
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
        
        
        //-----------------------------------------------------------------------------------
        
        
    }
    
}*/
/*
public class NewYearEvaluationBatchJob implements Database.Batchable<SObject> {
    
    // Start method: retrieves the appointments for the batch job
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Visit_Reason__c, Appointment_Date_Time__c, Patient__c, Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c, Patient__r.PersonEmail '
                     + 'FROM Appointment__c '
                     + 'WHERE Visit_Reason__c LIKE \'%New Year Evaluation%\' '
                     + 'AND Appointment_Date__c >= 2025-01-01 '
                     + 'AND Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c = false '
                     + 'AND Patient__r.PersonEmail != null '
                     + 'LIMIT 200';  // You can adjust the LIMIT depending on your requirements
        
        return Database.getQueryLocator(query);
    }

    // Execute method: processes each batch of records
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> acclist = new List<Account>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        // Collect account IDs and build the email content
        for (Appointment__c app : (List<Appointment__c>)scope) {
            accountIds.add(app.Patient__c);
        }

        acclist = [SELECT Id, Name, PersonEmail FROM Account WHERE Id IN :accountIds];
        
        for (Account acc : acclist) {
            String emailAddress = acc.PersonEmail;

           if (String.isNotBlank(emailAddress)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{emailAddress});
                

                    email.setOrgWideEmailAddressId('0D2UP0000000DWj0AM');
                               
                
                email.setSubject('Happy New Year!');
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
                    htmlBody += 'We hope this message finds you well. As we move into 2025, we kindly ask that you update your paperwork with Alliance Orthopedics. Please click the link below to complete the necessary steps.';
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

        // Update accounts after sending emails
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : acclist) {
            accountsToUpdate.add(new Account(Id = acc.Id, NPP_New_Year_Evaluation_Mail_Sent__c = true, Last_NPP_Mail_Sent_On__c = System.today()));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }

        // Send the email messages
        if (!emailMessages.isEmpty() && !Test.isRunningTest()) {
            List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
            for (Messaging.SendEmailResult result : sendResults) {
                if (!result.isSuccess()) {
                    System.debug('Error sending email: ' + result.getErrors()[0].getMessage());
                }
            }
        } else {
            System.debug('No valid email addresses found or running in test mode.');
        }
    }

    // Finish method: executes after all batches are processed (e.g., logging, notifications)
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished.');
    }
}*/
public class NewYearEvaluationBatchJob implements Database.Batchable<SObject>,Database.Stateful  {
    private static Set<Id> processedAccountIds = new Set<Id>();

    // Start method: retrieves the appointments for the batch job
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Visit_Reason__c, Appointment_Date_Time__c, Patient__c, Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c, Patient__r.PersonEmail '
                     + 'FROM Appointment__c '
                     + 'WHERE Visit_Reason__c LIKE \'%New Year Evaluation%\' '
                     + 'AND Appointment_Date__c >= 2025-01-01 '
                     + 'AND Patient__r.NPP_New_Year_Evaluation_Mail_Sent__c = false '
                     + 'AND Patient__r.PersonEmail != null'
            		 +'Limit 200';
        return Database.getQueryLocator(query);
    }

    // Execute method: processes each batch of records
   public void execute(Database.BatchableContext bc, List<SObject> scope) {
    Set<Id> accountIds = new Set<Id>();
    List<Account> acclist = new List<Account>();
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    Map<Id, Account> accountMap = new Map<Id, Account>();

    // Collect account IDs and build the email content
    for (Appointment__c app : (List<Appointment__c>)scope) {
        if (!processedAccountIds.contains(app.Patient__c)) {
            accountIds.add(app.Patient__c);
        }
    }

    acclist = [SELECT Id, Name, PersonEmail FROM Account WHERE Id IN :accountIds];

    for (Account acc : acclist) {
        String emailAddress = acc.PersonEmail;

           if (String.isNotBlank(emailAddress)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{emailAddress});
                

                    email.setOrgWideEmailAddressId('0D2UP0000000DWj0AM');
                               
                
                email.setSubject('Happy New Year!');
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
                    htmlBody += 'We hope this message finds you well. As we move into 2025, we kindly ask that you update your paperwork with Alliance Orthopedics. Please click the link below to complete the necessary steps.';
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
               accountMap.put(acc.Id, acc); // Map for potential updates

            }
    }

    // Send the email messages
    if (!emailMessages.isEmpty() && !Test.isRunningTest()) {
        List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessages);
        List<Account> accountsToUpdate = new List<Account>();

        for (Integer i = 0; i < sendResults.size(); i++) {
            Messaging.SendEmailResult result = sendResults[i];
            if (result.isSuccess()) {
                Account acc = accountMap.get(acclist[i].Id);
                accountsToUpdate.add(new Account(Id = acc.Id, NPP_New_Year_Evaluation_Mail_Sent__c = true, Last_NPP_Mail_Sent_On__c = System.today()));
                processedAccountIds.add(acc.Id); // Mark account as processed
            } else {
                System.debug('Error sending email for Account ID ' + acclist[i].Id + ': ' + result.getErrors()[0].getMessage());
            }
        }

        // Update accounts for which emails were successfully sent
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    } else {
        System.debug('No valid email addresses found or running in test mode.');
    }
}

    // Finish method: executes after all batches are processed (e.g., logging, notifications)
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished.');
    }
}