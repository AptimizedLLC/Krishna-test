global class ScheduleDenialOwnerReassignment implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Schedule the batch job with scope size 200
        Database.executeBatch(new DenialOwnerReassignmentBatchclass(), 1);
    }
}