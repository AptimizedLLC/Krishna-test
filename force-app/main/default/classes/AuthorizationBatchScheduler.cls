public class AuthorizationBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Batch_CreateAuthorizations(), 50);
    }
}