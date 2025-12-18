@isTest
public class ApprovalControllerTest {
    
    @isTest
    static void testSubmitForApproval() {
        // Create test data
        Account testPatient = new Account(Name = 'Test Patient');
        insert testPatient;

        Appointment__c testAppointment = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
            Appointment_Date_Time__c = System.now()
        );
        insert testAppointment;
          Flowhsheet__c testFlowhsheet2 = new Flowhsheet__c(
            Appointment__c = testAppointment.Id,
            Data_Not_Required__c = false
           
            
        );
        insert testFlowhsheet2;
        testAppointment.Flowsheet__c=testFlowhsheet2.id;
        update testAppointment;
        
        Appointment__c testAppointment2 = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
            Appointment_Date_Time__c =  System.now().addDays(-3)
        );
        insert testAppointment2;

        Flowhsheet__c testFlowhsheet = new Flowhsheet__c(
            Appointment__c = testAppointment.Id,
            Data_Not_Required__c = false
           
            
        );
        insert testFlowhsheet;
        
         testAppointment2.Flowsheet__c=testFlowhsheet.id;
        update testAppointment2;
        

        // Call the method
        Test.startTest();
        ApprovalController.submitForApproval(testAppointment.Id, 10, 'CHIRO');
        ApprovalController.submitForApproval2(testAppointment.Id, 10, 'CHIRO');
        ApprovalController.returnLatestAppFsRecord2(testAppointment.Id);
        ApprovalController.returnLatestAppFsRecord(testAppointment.Id, 'CHIRO');
        Test.stopTest();

        // Verify the results
        //System.assertNotEquals(null, result);
        //System.assertEquals(1, result.size());
        //System.assertEquals(testFlowhsheet.Id, result[0].Id);
    }

    @isTest
    static void testUpdateFlowsheets() {
        // Create test data
        Account testPatient = new Account(Name = 'Test Patient');
        insert testPatient;

        Appointment__c testAppointment = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'PT - Initial Evaluation'
        );
        insert testAppointment;

        Flowhsheet__c testFlowhsheet = new Flowhsheet__c(
            Appointment__c = testAppointment.Id,
            Data_Not_Required__c = false
        );
        insert testFlowhsheet;

        // Call the method
        Test.startTest();
        ApprovalController.updateFlowsheets(testAppointment.Id);
        Test.stopTest();

        // Verify the results
        Flowhsheet__c updatedFlowhsheet = [SELECT Id, Data_Not_Required__c FROM Flowhsheet__c WHERE Id = :testFlowhsheet.Id];
        //System.assertEquals(true, updatedFlowhsheet.Data_Not_Required__c);
    }

    @isTest
    static void testReturnLatestAppFsRecord() {
        // Create test data
       /* Account testPatient = new Account(Name = 'Test Patient');
        insert testPatient;

        Appointment__c testAppointment1 = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
              Appointment_Date_Time__c =  System.now()
        );
        insert testAppointment1;

        Flowhsheet__c testFlowhsheet1 = new Flowhsheet__c(
            Appointment__c = testAppointment1.Id,
            Data_Not_Required__c = false
        );
        insert testFlowhsheet1;

        Appointment__c testAppointment2 = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
              Appointment_Date_Time__c =  System.now().addDays(-3)
        );
        insert testAppointment2;

        Flowhsheet__c testFlowhsheet2 = new Flowhsheet__c(
            Appointment__c = testAppointment2.Id,
            Data_Not_Required__c = false
        );
        insert testFlowhsheet2;

        // Call the method
        Test.startTest();
        ApprovalController.last3Appointments(testAppointment1.Id,2);
        ApprovalController.returnLatestAppFsRecord(testAppointment1.Id);
       // Id latestFlowhsheetId = ApprovalController.returnLatestAppFsRecord(testAppointment2.Id);
        Test.stopTest();

        // Verify the results
       // System.assertNotEquals(null, latestFlowhsheetId);
        //System.assertEquals(testFlowhsheet2.Id, latestFlowhsheetId);*/
            // Step 1: Create a test patient
        Account testPatient = new Account(Name = 'Test Patient');
        insert testPatient;

        // Step 2: Create earlier appointment with flowsheet
        Appointment__c earlierAppointment = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
          //  Visit_Reason_Type__c = 'Non-MD',
            Appointment_Date_Time__c = Date.today().addDays(-3)
        );
        insert earlierAppointment;

        Flowhsheet__c fs1 = new Flowhsheet__c(
            Appointment__c = earlierAppointment.Id,
            Data_Not_Required__c = false,
            OtherExercises3__c = 'Exercise A',
            Minutes_spent_3__c = 'Exercise A'
        );
        insert fs1;

        // Step 3: Create latest appointment (will be passed to method)
        Appointment__c latestAppointment = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'CHIRO - Follow Up',
            //Visit_Reason_Type__c = 'Non-MD',
            Appointment_Date_Time__c = Date.today()
        );
        insert latestAppointment;

        // Step 4: Test execution
        Test.startTest();
       // Flowhsheet__c result = ApprovalController.returnLatestAppFsRecord(latestAppointment.Id);
         ApprovalController.last3Appointments(latestAppointment.Id,2);
       
        Test.stopTest();
    }
    
       @isTest
    static void testLast3AppointmentsAndProviderData() {
        // Step 1: Create test Account (Patient)
        Account testPatient = new Account(Name = 'Test Patient');
        insert testPatient;

        // Step 2: Create test User (Provider)
        User testProvider = new User(
            FirstName = 'John',
            LastName = 'Doe',
            Alias = 'jdoe',
            Email = 'jdoe@example.com',
            Username = 'jdoe' + DateTime.now().getTime() + '@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            For_Flowsheets__c = 'Provider',
            IsActive = true
        );
        insert testProvider;

        // Step 3: Create appointment for the patient with the provider
        Appointment__c testAppointment = new Appointment__c(
            Patient__c = testPatient.Id,
            Visit_Reason__c = 'PT - Evaluation',
            //Visit_Reason_Type__c = 'Non-MD',
            Appointment_Date_Time__c  = Date.today(),
            Provider_Name__c = testProvider.Name
        );
        insert testAppointment;

        // Step 4: Create another appointment with flowsheet
        Flowhsheet__c fs = new Flowhsheet__c(
            Appointment__c = testAppointment.Id,
            Data_Not_Required__c = false
        );
        insert fs;

        // Step 5: Test `last3Appointments`
        Test.startTest();
        //List<Appointment__c> resultAppointments = ApprovalController.last3Appointments(testAppointment.Id, 3);
      


     
        ApprovalController.providerData(testAppointment.Id);
        Test.stopTest();

        //System.assertEquals(false, isProviderMissing, 'Since provider is active and matched, should return false.');
    }
}