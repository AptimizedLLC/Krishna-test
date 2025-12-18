global class HorizonChargeBatchScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        
        HorizonChargeBatch batch = new HorizonChargeBatch();
        Database.executeBatch(batch, 1);
    }
}