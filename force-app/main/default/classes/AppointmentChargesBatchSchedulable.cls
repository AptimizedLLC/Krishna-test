global class AppointmentChargesBatchSchedulable implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        AppointmentChargesBatch batch = new AppointmentChargesBatch();
        Database.executeBatch(batch);
    }
}