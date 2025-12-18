/*public class AppointmentStatusUpdateBatch {
    public static void updateAppointmentStatusMethode(){
	list<Appointment__c>scope=[SELECT Id,Appointment_Status__c  FROM Appointment__c WHERE Appointment_Status__c =null AND FlowSheet_Generated__c =false AND Appointment_Date__c >2025-03-01 AND Flowsheet__c =null];
    List<Appointment__c>UpdatingAppointMents=new List<Appointment__c>();
        for(Appointment__c app:scope){
		UpdatingAppointMents.add(new Appointment__c(Id=app.id,Appointment_Status__c='Pending Flowsheet Entry'));
    }
        If(UpdatingAppointMents.size()>0){
            system.debug('UpdatingAppointMents are +'+UpdatingAppointMents);
          Update UpdatingAppointMents;
        }
    
    }
    
    
}
*/
global class AppointmentStatusUpdateBatch implements Database.Batchable<SObject> {

    // Query to fetch appointments
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Appointment_Status__c 
            FROM Appointment__c 
            WHERE Appointment_Status__c = NULL 
            AND FlowSheet_Generated__c = FALSE 
            AND Appointment_Date__c > 2024-01-01 
            AND Flowsheet__c = NULL
            AND Visit_Reason_Type__c ='Not MD'
        ]);
    }

    // Processing logic
    global void execute(Database.BatchableContext BC, List<Appointment__c> scope) {
        List<Appointment__c> appointmentsToUpdate = new List<Appointment__c>();

        for (Appointment__c app : scope) {
            appointmentsToUpdate.add(new Appointment__c(
                Id = app.Id,
                Appointment_Status__c = 'Pending Flowsheet Entry'
            ));
        }

        if (!appointmentsToUpdate.isEmpty()) {
            update appointmentsToUpdate;
        }
    }

    // Finish logic (optional)
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch finished processing Appointment__c records.');
    }
}