global class AppointmentCleanupBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        AppointmentCleanupBatch instance = new AppointmentCleanupBatch();
        Id batchprocessid = Database.executeBatch(instance, 100);
    }
}