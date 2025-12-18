global class ClearCareCloudAppointmentBatch implements Database.Batchable<sObject> {
    
    // Query to fetch records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Care_Cloud_Appointment_Id__c FROM Appointment__c WHERE Care_Cloud_Appointment_Id__c != null'
        );
    }

    // Process logic for clearing field values
    global void execute(Database.BatchableContext bc, List<Appointment__c> scope) {
        for (Appointment__c appt : scope) {
            appt.Care_Cloud_Appointment_Id__c = null;
        }
        update scope;
    }

    // Optional finish method for post-execution logic
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed successfully.');
    }
}