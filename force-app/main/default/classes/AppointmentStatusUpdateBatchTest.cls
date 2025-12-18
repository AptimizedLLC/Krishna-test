@isTest
public class AppointmentStatusUpdateBatchTest {

    @isTest
    static void testBatchUpdateAppointments() {
        // Create test data - 5 matching appointments
        List<Appointment__c> appointments = new List<Appointment__c>();
        for (Integer i = 0; i < 5; i++) {
            appointments.add(new Appointment__c(
                Appointment_Status__c = null,
                FlowSheet_Generated__c = false,
                Appointment_Date_Time__c   = Date.today().addDays(10),
                Flowsheet__c = null
            ));
        }

        // Add 2 non-matching appointments (should NOT be updated)
        appointments.add(new Appointment__c(
            Appointment_Status__c = 'Pending Flowsheet Entry',
            FlowSheet_Generated__c = false,
            Appointment_Date_Time__c   = Date.today().addDays(10),
            Flowsheet__c = null
        ));
        appointments.add(new Appointment__c(
            Appointment_Status__c = null,
            FlowSheet_Generated__c = true,
            Appointment_Date_Time__c   = Date.today().addDays(10),
            Flowsheet__c = null
        ));

        insert appointments;

        Test.startTest();
        AppointmentStatusUpdateBatch batch = new AppointmentStatusUpdateBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Query the updated records
        List<Appointment__c> updated = [
            SELECT Id, Appointment_Status__c 
            FROM Appointment__c 
            WHERE Appointment_Status__c = 'Pending Flowsheet Entry'
        ];

        System.assertEquals(6, updated.size(), 'Only matching records should be updated.');
    }
}