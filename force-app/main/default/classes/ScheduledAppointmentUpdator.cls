global class ScheduledAppointmentUpdator implements Schedulable{
    global void execute(SchedulableContext sc){
        Id batchprocessid = Test.isRunningTest() ? null :Database.executeBatch(new AppointmentSyncBatchCallout(0, 0));
    }
}