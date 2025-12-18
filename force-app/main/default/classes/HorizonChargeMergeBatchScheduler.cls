global class HorizonChargeMergeBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        
        HorizonChargeMergeBatch batch = new HorizonChargeMergeBatch();
        Database.executeBatch(batch, 1); 
    }
}