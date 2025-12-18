global class AppointmentCleanupBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    String accessToken;
    Boolean isAllAppointments;
    Integer startOffset;
    Integer endOffset;

    public AppointmentCleanupBatch(){
        isAllAppointments = false;
        accessToken = CareCloudAPIHelper.accessToken;
    }

    public AppointmentCleanupBatch(Boolean isAllAppointments){
        this.isAllAppointments = isAllAppointments;
        accessToken = CareCloudAPIHelper.accessToken;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Appointment_Date__c, Care_Cloud_Appointment_Id__c FROM Appointment__c WHERE Care_Cloud_Appointment_Id__c != NULL AND '+(isAllAppointments ? '' : 'Appointment_Date__c >= LAST_WEEK AND Appointment_Date__c <= NEXT_WEEK AND')+' Status__c = \'Pending\' ORDER BY Appointment_Date__c DESC';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Appointment__c> appointments) {
        if(String.isNotBlank(accessToken)){
            List<Id> invalidAppointments = new List<Id>();
            for(Appointment__c appointment : appointments){
                if(!CareCloudAPIHelper.isValidAppointment(appointment.Care_Cloud_Appointment_Id__c, accessToken)){
                    invalidAppointments.add(appointment.Id);
                }
            }

            if(!invalidAppointments.isEmpty()){
                //delete appointments
                Database.DeleteResult[] deleteResults = Database.delete(invalidAppointments, false);
            }
        }
    } 
    
    global void finish(Database.BatchableContext BC){ 
        if(!Test.isRunningTest()){
            system.enqueueJob(new CareCloudProvidersAndLocationsHelper(false));
        }
    }
}