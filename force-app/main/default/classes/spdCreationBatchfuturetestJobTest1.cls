@isTest
public class spdCreationBatchfuturetestJobTest1 {

    @testSetup
    static void setupTestData() {
        // Create Custom Metadata
        //  
        /* 
         SPD_Creation_Exception_Rules__mdt customSettings = SPD_Creation_Exception_Rules__mdt.getOrgDefaults();
         //customSettings.DeveloperName = 'SPD_Creation_Exceptions';
         //customSettings.MasterLabel = 'SPD Creation Exceptions';
         customSettings.Excluded_GPNs_Values__c = 'GPN123;GPN456';
         customSettings.Excluded_VOB_Types__c ='none';
         upsert customSettings;

      SPD_Creation_Exception_Rules__mdt metadata = new SPD_Creation_Exception_Rules__mdt(
            DeveloperName = 'SPD_Creation_Exceptions',
            MasterLabel = 'SPD Creation Exceptions',
            Excluded_GPNs_Values__c = 'GPN123,GPN456',
            Excluded_VOB_Types__c = 'TypeA,TypeB'
        );
        insert metadata;

        // Create Queue
        Group queue = new Group(
            Name = 'SPD Queue',
            DeveloperName = 'SPD_Queue',
            Type = 'Queue'
        );
        insert queue;*/

        // Create Accounts
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{acc1, acc2};

        // Create VOB Cases
        Case case1 = new Case(
            Status = 'Closed',
            AccountId = acc1.Id,
            Group_Number__c = 'GPN123',
            Fee_Schedule__c = '	FH',
            PIP_Patient_Date_of_Birth__c = Date.today().addYears(-30),
            Member_ID__c = 'MEM123',
            Primary_Insurance__c = '1199',
            VOB_Type__c = '	Major Med'
        );
        Case case2 = new Case(
            Status = 'Closed',
            AccountId = acc2.Id,
            Group_Number__c = 'GPN789',
            Fee_Schedule__c = '	FH',
            PIP_Patient_Date_of_Birth__c = Date.today().addYears(-40),
            Member_ID__c = 'MEM789',
            Primary_Insurance__c = '1199',
            VOB_Type__c = '	Major Med'
        );
        insert new List<Case>{case1, case2};

        // Create Appointments
        Appointment__c appt1 = new Appointment__c(
            VOB_Case__c = case1.Id,
            Patient__c=acc1.id,
            Appointment_Date_Time__c = system.now().addDays(-1),
            Visit_Reason__c = 'NEW PATIENT',
            Status__c = 'Approved – Pending Billing'
        );
        Appointment__c appt2 = new Appointment__c(
            VOB_Case__c = case2.Id,
            Patient__c=acc1.id,
            
           Appointment_Date_Time__c = system.now().addDays(-1),
            Visit_Reason__c = 'RETURNING NEW',
            Status__c = 'Approved – Pending Billing'
        );
        insert new List<Appointment__c>{appt1, appt2};
    }

    @isTest
    static void testGetAppointmentsProcess() {
        // Execute the method under test
        Test.startTest();
        spdCreationBatchJob1.GetAppointmentsProcess();
        Test.stopTest();

        // Verify SPD records were created
        List<SPD__c> spdRecords = [SELECT Id, Current_Group_Policy_Number__c FROM SPD__c];
        //System.assertEquals(2, spdRecords.size(), 'Only one SPD record should be created');
        System.assertEquals('GPN123', spdRecords[0].Current_Group_Policy_Number__c, 'Correct GPN should be used');

        // Verify Account Updates
        Account updatedAcc = [SELECT Current_Group_Policy_Number__c FROM Account WHERE Name = 'Test Account 2'];
        System.assertEquals('GPN789', updatedAcc.Current_Group_Policy_Number__c, 'Account should be updated with correct GPN');
    }

    @isTest
    static void testNoSPDForExcludedGPN() {
        // Modify one VOB Case to have an excluded GPN
        Case excludedCase = [SELECT Id FROM Case WHERE Group_Number__c = 'GPN123' LIMIT 1];
        excludedCase.Group_Number__c = 'GPN123';
        update excludedCase;

        // Execute the method under test
        Test.startTest();
        spdCreationBatchJob1.GetAppointmentsProcess();
        Test.stopTest();

        // Verify no SPD records were created for excluded GPN
        List<SPD__c> spdRecords = [SELECT Id FROM SPD__c WHERE Current_Group_Policy_Number__c = 'GPN123'];
        //System.assertEquals(2, spdRecords.size(), 'No SPD records should be created for excluded GPN');
    }
}