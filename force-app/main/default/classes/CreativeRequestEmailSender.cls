public with sharing class CreativeRequestEmailSender {

    public class Input {
        @InvocableVariable(required=true)
        public Id recordId;
    }

    public class Output {
        @InvocableVariable
        public Boolean success;
        @InvocableVariable
        public String message;
    }

    private static final String MAILING_LIST_NAME = 'Creative Request Team';
    private static final String ADMIN_EMAIL = 'kkumar@aptimized.com';

    @InvocableMethod(label='Send Creative Request Email (Static List)')
    public static List<Output> sendEmail(List<Input> requests) {
        List<Output> results = new List<Output>();
        if (requests == null || requests.isEmpty()) {
            Output out = new Output();
            out.success = false;
            out.message = 'No input requests provided.';
            results.add(out);
            return results;
        }

        Set<Id> recIds = new Set<Id>();
        for (Input req : requests) {
            if (req.recordId != null) recIds.add(req.recordId);
        }

        Map<Id, Creative_Request__c> crMap = new Map<Id, Creative_Request__c>();
        try {
            if (!recIds.isEmpty()) {
                crMap = new Map<Id, Creative_Request__c>([
                    SELECT Id, Name, CreatedBy.Name, Type_of_Request__c, Due_Date__c
                    FROM Creative_Request__c
                    WHERE Id IN :recIds
                ]);
                System.debug('Queried ' + crMap.size() + ' Creative Request record(s).');
            }
        } catch (Exception ex) {
            System.debug('FATAL: Failed to query Creative_Request__c: ' + ex.getMessage());
            for (Input req : requests) {
                Output out = new Output();
                out.success = false;
                out.message = 'System error: Failed to load Creative Request.';
                results.add(out);
            }
            sendAdminAlert('Creative Request Query Failed', ex);
            return results;
        }

        RUL_Mailing_List__mdt mdt = null;
        try {
            List<RUL_Mailing_List__mdt> devList = [
                SELECT CCMailData__c
                FROM RUL_Mailing_List__mdt
                WHERE DeveloperName = :MAILING_LIST_NAME
                LIMIT 1
            ];
            if (!devList.isEmpty()) {
                mdt = devList[0];
                System.debug('Metadata found via DeveloperName: ' + MAILING_LIST_NAME);
            } else {
                List<RUL_Mailing_List__mdt> labelList = [
                    SELECT CCMailData__c
                    FROM RUL_Mailing_List__mdt
                    WHERE Label = :MAILING_LIST_NAME
                    LIMIT 1
                ];
                if (!labelList.isEmpty()) {
                    mdt = labelList[0];
                    System.debug('Metadata found via Label: ' + MAILING_LIST_NAME);
                } else {
                    System.debug('Metadata not found for: ' + MAILING_LIST_NAME);
                }
            }
        } catch (Exception ex) {
            System.debug('FATAL: Failed to query RUL_Mailing_List__mdt: ' + ex.getMessage());
            sendAdminAlert('Metadata Query Failed', ex);
        }

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Input req : requests) {
            Output out = new Output();
            out.success = false;
            out.message = 'Processing failed';

            try {
                if (req.recordId == null || !crMap.containsKey(req.recordId)) {
                    out.message = 'Creative Request not found: ' + req.recordId;
                    results.add(out);
                    continue;
                }
                Creative_Request__c cr = crMap.get(req.recordId);

                if (mdt == null || String.isBlank(mdt.CCMailData__c)) {
                    out.message = 'Mailing list metadata missing or empty.';
                    results.add(out);
                    continue;
                }

                List<String> toAddresses = new List<String>();
                String rawList = mdt.CCMailData__c.replaceAll('[\'"]', '').trim();
                System.debug('Raw CCMailData__c (cleaned): ' + rawList);

                for (String email : rawList.split(',', -1)) {
                    String addr = email.trim();
                    if (String.isNotBlank(addr) && addr.contains('@') && addr.contains('.')) {
                        toAddresses.add(addr);
                        System.debug('Valid recipient: ' + addr);
                    } else if (String.isNotBlank(addr)) {
                        System.debug('Skipped invalid email: ' + addr);
                    }
                }

                if (toAddresses.isEmpty()) {
                    out.message = 'No valid recipients in CCMailData__c.';
                    results.add(out);
                    continue;
                }

                String orgDomain = URL.getOrgDomainUrl().toExternalForm();
                String recordUrl = orgDomain + '/lightning/r/Creative_Request__c/' + cr.Id + '/view';
                String dueDateStr = cr.Due_Date__c != null ? String.valueOf(cr.Due_Date__c) : '--';

                String body = '<p>Hello Creative Request Team,</p>'
                    + '<p>A new Creative Request has been created. Details below:</p>'
                    + '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; width:100%; max-width:600px;">'
                    + '<tr style="background-color:#f2f2f2;">'
                    + '<th align="left" style="padding:8px;">Creative Request</th>'
                    + '<th align="left" style="padding:8px;">Requested By</th>'
                    + '<th align="left" style="padding:8px;">Type</th>'
                    + '<th align="left" style="padding:8px;">Due Date</th>'
                    + '</tr>'
                    + '<tr>'
                    + '<td style="padding:8px;"><a href="' + recordUrl + '">' + cr.Name.escapeHtml4() + '</a></td>'
                    + '<td style="padding:8px;">' + (cr.CreatedBy != null ? cr.CreatedBy.Name.escapeHtml4() : '--') + '</td>'
                    + '<td style="padding:8px;">' + String.valueOf(cr.Type_of_Request__c).escapeHtml4() + '</td>'
                    + '<td style="padding:8px;">' + dueDateStr.escapeHtml4() + '</td>'
                    + '</tr>'
                    + '</table>'
                    + '<br/><p>Thank You</p>';

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSubject('New Creative Request: ' + cr.Name);
                mail.setHtmlBody(body);
                mail.setSaveAsActivity(false);
                mail.setReplyTo('no-reply@salesforce.com');
                mail.setSenderDisplayName('Salesforce Creative Requests');
                emailsToSend.add(mail);

                out.success = true;
                out.message = 'Email queued to ' + toAddresses.size() + ' recipient(s).';
                System.debug('Email prepared for: ' + String.join(toAddresses, ', '));

            } catch (Exception ex) {
                out.success = false;
                out.message = 'Processing error: ' + ex.getMessage();
                System.debug('Error processing record ' + req.recordId + ': ' + ex.getMessage() + ' | Line: ' + ex.getLineNumber());
            }
            results.add(out);
        }

        if (!emailsToSend.isEmpty()) {
            try {
                Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(emailsToSend);
                Integer successCount = 0;
                for (Messaging.SendEmailResult res : sendResults) {
                    if (res.isSuccess()) successCount++;
                    else {
                        for (Messaging.SendEmailError err : res.getErrors()) {
                            System.debug('Email send error: ' + err.getMessage());
                        }
                    }
                }
                System.debug('Email send complete. Success: ' + successCount + '/' + sendResults.size());
            } catch (Exception ex) {
                System.debug('CRITICAL: Email send failed globally: ' + ex.getMessage());
                for (Output res : results) {
                    if (res.success) {
                        res.success = false;
                        res.message = 'Send failed: ' + ex.getMessage();
                    }
                }
                sendAdminAlert('Email Send Failed', ex);
            }
        }

        return results;
    }

    private static void sendAdminAlert(String subject, Exception ex) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ ADMIN_EMAIL });
            mail.setSubject('[URGENT] Creative Request Email Error: ' + subject);
            mail.setPlainTextBody(
                'An error occurred in CreativeRequestEmailSender:\n\n' +
                'Error: ' + ex.getMessage() + '\n' +
                'Stack Trace:\n' + ex.getStackTraceString() + '\n\n' +
                'Time: ' + System.now()
            );
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            System.debug('Admin alert sent to: ' + ADMIN_EMAIL);
        } catch (Exception sendEx) {
            System.debug('Failed to send admin alert: ' + sendEx.getMessage());
        }
    }
}