public class Batch_CreateAuthorizations implements Database.Batchable<SObject>, Database.Stateful {

    private List<String> errorMessages = new List<String>();
    private Set<Id> failedAppointmentIds = new Set<Id>();
    private Map<Id, List<String>> failureDetails = new Map<Id, List<String>>();
    private Id queueId;

    // --------------------------
    // START
    // --------------------------
    public Database.QueryLocator start(Database.BatchableContext bc) {

        queueId = [
            SELECT Id 
            FROM Group 
            WHERE DeveloperName = 'New_Authorizations' 
            LIMIT 1
        ].Id;

        return Database.getQueryLocator([
            SELECT Id, OwnerId, Patient__c, Location__c, Visit_Reason__c,
                   Appointment_Date__c, Auth_Created__c
            FROM Appointment__c
            WHERE Appointment_Date__c >= :Date.today()
            AND Appointment_Date__c <= :Date.today().addDays(7)
            AND Auth_Created__c = false
            AND Status__c != 'Cancelled'
            AND (
                Visit_Reason__c LIKE '%MD - PIP%' OR
                Visit_Reason__c LIKE '%MD - W/C%' OR
                Visit_Reason__c LIKE '%MD - EMG CONSULT%'
            )
            ORDER BY Appointment_Date__c ASC
        ]);
    }

    // --------------------------
    // EXECUTE
    // --------------------------
    public void execute(Database.BatchableContext bc, List<Appointment__c> scope) {

        if (scope.isEmpty()) return;

        if (queueId == null) {
            queueId = [
                SELECT Id 
                FROM Group 
                WHERE DeveloperName = 'New_Authorizations' 
                LIMIT 1
            ].Id;
        }

        Set<Id> ownerIds = new Set<Id>();
        Set<Id> appointmentIds = new Set<Id>();

        for (Appointment__c appt : scope) {
            ownerIds.add(appt.OwnerId);
            appointmentIds.add(appt.Id);
        }

        Map<Id, CareCloud_Information__c> providerMap = new Map<Id, CareCloud_Information__c>(
            [SELECT Id, User_Record__c FROM CareCloud_Information__c
             WHERE User_Record__c IN :ownerIds]
        );

        Map<Id, Authorization__c> existingAuthMap = new Map<Id, Authorization__c>(
            [SELECT Id, Appointment__c
             FROM Authorization__c
             WHERE Appointment__c IN :appointmentIds
             AND PIP_or_W_C_Request__c = 'Office Visit']
        );

        List<Authorization__c> newAuths = new List<Authorization__c>();
        Map<Id, Appointment__c> apptUpdateMap = new Map<Id, Appointment__c>();

        for (Appointment__c appt : scope) {
            try {

                if (existingAuthMap.containsKey(appt.Id)) continue;

                CareCloud_Information__c providerInfo = providerMap.get(appt.OwnerId);

                Authorization__c auth = new Authorization__c(
                    OwnerId = queueId,
                    Appointment__c = appt.Id,
                    Authorization_Requested_Date__c = Date.today(),
                    PIP_or_W_C_Request__c = 'Office Visit',
                    Patient__c = appt.Patient__c,
                    Treating_Office__c = appt.Location__c,
                    PIP_or_W_C_Request_Checkbox__c=true,
                    Provider__c = (providerInfo != null ? providerInfo.Id : null)
                );

                newAuths.add(auth);

                apptUpdateMap.put(appt.Id, new Appointment__c(
                    Id = appt.Id,
                    Auth_Created__c = true
                ));

            } catch (Exception e) {
                collectFailure(appt.Id, e.getMessage());
            }
        }

        // Insert Auths and get successful ones
        Set<Id> succeededApptIds = safeDmlInsert(newAuths);

        // Only update appointments whose auth succeeded
        List<Appointment__c> filteredUpdates = new List<Appointment__c>();
        for (Id apptId : apptUpdateMap.keySet()) {
            if (succeededApptIds.contains(apptId)) {
                filteredUpdates.add(apptUpdateMap.get(apptId));
            } else {
                failedAppointmentIds.add(apptId);
            }
        }

        safeDmlUpdate(filteredUpdates);
    }

    // --------------------------
    // INSERT with success tracking
    // --------------------------
    private Set<Id> safeDmlInsert(List<Authorization__c> records) {
        Set<Id> successAppointmentIds = new Set<Id>();

        if (records.isEmpty()) return successAppointmentIds;

        Database.SaveResult[] results = Database.insert(records, false);

        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                successAppointmentIds.add(records[i].Appointment__c);
            } else {
                failedAppointmentIds.add(records[i].Appointment__c);
                collectFailure(records[i].Appointment__c, results[i].getErrors()[0].getMessage());
            }
        }
        return successAppointmentIds;
    }

    // --------------------------
    // UPDATE with retry
    // --------------------------
    private void safeDmlUpdate(List<Appointment__c> records) {
        if (records.isEmpty()) return;

        Database.update(records, false);
    }

    // --------------------------
    // failure handler
    // --------------------------
    private void collectFailure(Id recordId, String message) {

        failedAppointmentIds.add(recordId);

        if (!failureDetails.containsKey(recordId)) {
            failureDetails.put(recordId, new List<String>());
        }
        failureDetails.get(recordId).add(message);

        errorMessages.add(
            'Appointment Id: ' + recordId +
            '\nError: ' + message
        );
    }

    // --------------------------
    // FINISH
    // --------------------------
  public void finish(Database.BatchableContext bc) {

    // Send email ONLY if failures exist
    if (failedAppointmentIds.isEmpty()) {
        System.debug('No failures — email will NOT be sent.');
        return;
    }

    String baseUrl = URL.getOrgDomainUrl().toExternalForm();

    String emailBody =
        'Authorization Batch Completed.\n\n' +
        'Total Failed Appointments: ' + failedAppointmentIds.size() + '\n' +
        'Total Errors Logged: ' + errorMessages.size() + '\n\n';

    emailBody += '===== FAILURE DETAILS =====\n\n';

    for (Id apptId : failureDetails.keySet()) {

        String link = baseUrl + '/lightning/r/Appointment__c/' + apptId + '/view';

        emailBody += 'Appointment: ' + link + '\n';

        for (String msg : failureDetails.get(apptId)) {
            emailBody += ' - ' + msg + '\n';
        }
        emailBody += '\n';
    }

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setToAddresses(new String[] { 'kkumar@aptimized.com' });
    email.setSubject('Authorization Batch - Failure Summary Report');
    email.setPlainTextBody(emailBody);

    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
}
}