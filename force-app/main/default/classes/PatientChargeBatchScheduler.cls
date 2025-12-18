global class PatientChargeBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){  
        PatientChargeSyncBatch instance = new PatientChargeSyncBatch();
        Id batchprocessid = Database.executeBatch(instance, 100);
    }
}