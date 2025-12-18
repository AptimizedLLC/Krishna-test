global class AppointmentSyncBatchScheduler implements Schedulable{
    private integer startOffset;
    private integer endOffset;
    
    global AppointmentSyncBatchScheduler(){
        this.startOffset = -15;
        this.endOffset = 50;
    }
    
    global AppointmentSyncBatchScheduler(Integer startOffset, Integer endOffset){
        this.startOffset = startOffset;
        this.endOffset = endOffset;
    }
    
    global void execute(SchedulableContext sc){
        AppointmentSyncBatchCallout instance = new AppointmentSyncBatchCallout(this.startOffset, this.endOffset);
        Id batchprocessid = Database.executeBatch(instance, 1);
    }
}