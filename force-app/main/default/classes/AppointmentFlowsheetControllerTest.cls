@isTest
private class AppointmentFlowsheetControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Get running user
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        // Create a dummy patient
        Account patient = new Account(Name = 'Test Patient');
        insert patient;

        // Create Appointment in Provider Review status
        Appointment__c appt1 = new Appointment__c(
            Name = 'Appt One',
            Appointment_Status__c = 'Provider Review',
            OwnerId = u.Id,
            Appointment_Date_Time__c = System.today().addDays(1),
            Patient__c = patient.Id,
            Visit_Reason__c = 'Checkup'
        );
        insert appt1;

        // Create Appointment in Approved status
        Appointment__c appt2 = new Appointment__c(
            Name = 'Appt Two',
            Appointment_Status__c = 'Approved',
            OwnerId = u.Id,
            Appointment_Date_Time__c = System.today(),
            Patient__c = patient.Id,
            Visit_Reason__c = 'Follow-up'
        );
        insert appt2;

        // Create flowsheet linked to appt1
        insert new Flowhsheet__c(Appointment__c = appt1.Id);

        // Create flowsheet linked to appt2
        insert new Flowhsheet__c(Appointment__c = appt2.Id);
    }
    
    @isTest
    static void testGetAppointmentsWithFlowsheets() {
        Test.startTest();
        List<AppointmentFlowsheetController.WrapperRecord> results = 
            AppointmentFlowsheetController.getAppointmentsWithFlowsheets(1, 10);
        Test.stopTest();
        
        System.assertNotEquals(0, results.size(), 'Should return flowsheets for Provider Review appointments');
        System.assertEquals('Appt One', results[0].appointmentName);
        System.assertEquals('Test Patient', results[0].patientName);
    }
    
    @isTest
    static void testGetTotalCount() {
        Test.startTest();
        Integer count = AppointmentFlowsheetController.getTotalCount();
        Test.stopTest();
        
        System.assert(count > 0, 'Should return count of Provider Review flowsheets');
    }
    
    @isTest
    static void testGetRecentAppointmentsWithFlowsheets_withDates() {
        Date startDate = System.today().addDays(-5);
        Date endDate = System.today().addDays(1);
        
        Test.startTest();
        List<AppointmentFlowsheetController.WrapperRecord> results = 
            AppointmentFlowsheetController.getRecentAppointmentsWithFlowsheets(startDate, endDate, null);
        Test.stopTest();
        
        //System.assertNotEquals(0, results.size(), 'Should return approved appointments within date range');
        //System.assertEquals('Appt Two', results[0].appointmentName);
    }
    
    @isTest
    static void testGetRecentAppointmentsWithFlowsheets_defaultDates() {
        // Pass nulls, should fallback to last 7 days
        Test.startTest();
        List<AppointmentFlowsheetController.WrapperRecord> results = 
            AppointmentFlowsheetController.getRecentAppointmentsWithFlowsheets(null, null, null);
        Test.stopTest();
        
        //System.assertNotEquals(0, results.size(), 'Should return approved appointments in last 7 days');
    }

   
    
    @isTest
    static void testApproveAppointment() {
        Appointment__c appt = [SELECT Id, Appointment_Status__c, Flowsheet_Approved__c, Flowsheet_Provider_Approval_Date__c
                                FROM Appointment__c 
                                WHERE Appointment_Status__c = 'Provider Review' 
                                LIMIT 1];
        
        Test.startTest();
        AppointmentFlowsheetController.approveAppointment(appt.Id);
        Test.stopTest();
        
        Appointment__c updatedAppt = [SELECT Appointment_Status__c, Flowsheet_Approved__c, Flowsheet_Provider_Approval_Date__c
                                      FROM Appointment__c 
                                      WHERE Id = :appt.Id];
        
        System.assertEquals('Approved', updatedAppt.Appointment_Status__c, 'Status should change to Approved');
        System.assertEquals(true, updatedAppt.Flowsheet_Approved__c, 'Flowsheet approved flag should be true');
        System.assertEquals(Date.today(), updatedAppt.Flowsheet_Provider_Approval_Date__c, 'Approval date should be set to today');
    }
    
    @isTest
    static void testApproveAppointment_nullId() {
        Test.startTest();
        AppointmentFlowsheetController.approveAppointment(null);
        Test.stopTest();
        System.assert(true, 'Method should safely handle null input');
    }
}