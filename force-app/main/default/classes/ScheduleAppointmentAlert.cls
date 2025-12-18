global class ScheduleAppointmentAlert implements Schedulable {
    global void execute(SchedulableContext sc) {
        AppointmentAlertClass.sendEmailAlert();
    }
}