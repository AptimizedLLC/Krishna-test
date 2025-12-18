@IsTest
public class AR_AccountsReceivableArchivalHandlerTest  {

    @TestSetup
    static void setupTestData() {
        // Create a User to assign as Owner (needed for owner name lookup)
        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tusr',
            Username = 'testuser' + DateTime.now().getTime() + '@test.com',
            Email = 'testuser@test.com',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert u;

        // Create a test AR_Accounts_Receivable__c record
        AR_Accounts_Receivable__c arRecord = new AR_Accounts_Receivable__c(
            
            OwnerId = u.Id,
            Injection_Status__c = 'APP',
            AR_Patient_Id__c = 'PAT123',
            AR_Balance__c = '200',
            AR_Expected_Amount__c = '150',
            AR_Priority_Status__c = 'NEW',
            AR_Amount__c = 200
        );
        insert arRecord;
    }

    @IsTest
    static void testArchiveFromFlowMethod() {
        // Fetch the record
        AR_Accounts_Receivable__c testRecord = [SELECT Id FROM AR_Accounts_Receivable__c LIMIT 1];
        
        // Simulate a request from Flow
        AR_AccountsReceivableArchivalHandler.ArchivalRequest req = 
            new AR_AccountsReceivableArchivalHandler.ArchivalRequest();
        req.recordId = testRecord.Id;

        List<AR_AccountsReceivableArchivalHandler.ArchivalRequest> requests = new List<AR_AccountsReceivableArchivalHandler.ArchivalRequest>{ req };

        // Update status to ACC
        testRecord.Injection_Status__c = 'ACC';
        update testRecord;

        // Call the invocable method
        Test.startTest();
        AR_AccountsReceivableArchivalHandler.archiveFromFlow(requests);
        Test.stopTest(); // ensures @future method runs
        

        // Validate that archival record was created
        List<AR_Injection_Archival__c> archList = [SELECT Id, Injection_Status__c, AR_Patient_Id__c, AR_Assignment__c FROM AR_Injection_Archival__c];
        System.assertEquals(1, archList.size(), 'One archival record should be created.');
        System.assertEquals('ACC', archList[0].Injection_Status__c, 'Status should match ACC.');
        System.assertNotEquals(null, archList[0].AR_Assignment__c, 'Assignment should be populated.');

        // Validate that original record was deleted
        Integer remainingAR = [SELECT COUNT() FROM AR_Accounts_Receivable__c WHERE Id = :testRecord.Id];
        System.assertEquals(0, remainingAR, 'Original AR record should have been deleted.');
    }
}