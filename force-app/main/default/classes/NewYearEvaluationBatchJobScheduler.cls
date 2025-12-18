global class NewYearEvaluationBatchJobScheduler implements Schedulable {
   public void execute(SchedulableContext sc) {
        NewYearEvaluationBatchJob batchJob = new NewYearEvaluationBatchJob();
        Database.executeBatch(batchJob, 200); // Adjust batch size as needed
    }
}