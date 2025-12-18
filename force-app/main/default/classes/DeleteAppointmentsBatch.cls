public class DeleteAppointmentsBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all Appointment__c records
        return Database.getQueryLocator(
    'SELECT Id, Status__c, Provider_Name__c, Owner.Name, LastModifiedDate, Owner.Email, Care_Cloud_Appointment_Id__c ' +
    'FROM Appointment__c ' +
    'WHERE Visit_Reason_Type__c = \'MD\''
        ); }

    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        // Cast to the correct type
        List<Appointment__c> appointmentsToDelete = (List<Appointment__c>) scope;

        // Perform the delete
        delete appointmentsToDelete;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Finished deleting appointment records.');
    }
}