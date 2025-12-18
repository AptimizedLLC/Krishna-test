global class PatientDocumentSyncBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        PatientDocumentSyncBatch batchObj = new PatientDocumentSyncBatch();
        Database.executeBatch(batchObj);  
    }
}