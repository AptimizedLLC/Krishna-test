public class SpdCreationfutureJob3 implements Schedulable{

    // The execute method is required for Schedulable interface
    public void execute(SchedulableContext sc) {
        // Call the processing method
        spdCreationBatchJob1.GetAppointmentsProcess();
    }
}