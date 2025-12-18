@isTest
public class MorningPendingRecordsEmailSchedulerTest {

    @isTest
    static void testExecuteMethod() {
        // Create test data: RUL__c records with 'Pending' status
        List<RUL__c> rulRecords = new List<RUL__c>();
        
        // Create a test user to assign RUL__c records
        User testUser = new User(
            Username = 'testuse5658r@example.com',
            Alias = 'testusr',
            lastName ='testusr',
            EmailEncodingKey='ISO-8859-1',
            Email = 'testuser@example.com',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        Account a1= new Account(
        Lastname='Krishna'
        );
            insert a1;

        // Creating some sample RUL__c records
        for (Integer i = 0; i < 3; i++) {
            RUL__c record = new RUL__c(
                RUL_Status__c = 'Pending Assignee',
                RUL_Assigned_To__c = testUser.Id,
               // RUL_Patient_Name__r = new Patient__c(Name = 'Patient ' + i),
                RUL_Issue_Type__c = 'Insurance',
                RUL_Billed_Charges__c=5,
                RUL_Patient_Name__c=a1.Id
                
            );
            rulRecords.add(record);
        }
        insert rulRecords;

        // Create an instance of the scheduler class and invoke the execute method
        Test.startTest();
        MorningPendingRecordsEmailScheduler scheduler = new MorningPendingRecordsEmailScheduler();
         EveningAssignedRecordsEmailScheduler scheduler1 = new EveningAssignedRecordsEmailScheduler();
        scheduler.execute(null);  // Passing null for the SchedulableContext
        scheduler1.execute(null);  // Passing null for the SchedulableContext
        Test.stopTest();

    }
}