global class PaymentBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){  
        PatientPaymentSyncBatch instance = new PatientPaymentSyncBatch();
        Id batchprocessid = Database.executeBatch(instance, 100);
    }
}