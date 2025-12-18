@isTest
private class DenialOwnerReassignmentBatchclassTest {

    // Setup method to create test data
    @TestSetup
    static void setupTestData() {
        // Query existing users
        User testUser1, testUser2;
        try {
            testUser1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
            testUser2 = [SELECT Id FROM User WHERE IsActive = true AND Id != :testUser1.Id LIMIT 1];
            System.debug('TestUser1 ID: ' + testUser1.Id);
            System.debug('TestUser2 ID: ' + testUser2.Id);
        } catch (QueryException e) {
            System.debug('Error querying users: ' + e.getMessage());
            //throw new TestSetupException('Failed to find active users: ' + e.getMessage());
        }

        // Create test Account with dn_Name__c
        Account patientAccount = new Account(
            Name = 'Test Patient'
            
        );
        insert patientAccount;
        System.debug('Patient Account ID: ' + patientAccount.Id);

        // Create a matching denial record (CO-100, Not MD)
        dn_Denial__c matchingDenial = new dn_Denial__c(
            dn_Adjustment_Code_1__c = '100',
            dn_DENIED_CATEGORY_CODE__c = 'CO',
            dn_PROVIDER_GROUPING__c = 'Not MD',
            dn_Patient_Account__c = patientAccount.Id,
            dn_DOS__c = Date.today(),
            dn_PROVIDER__c = 'TestProvider',
            OwnerId = testUser1.Id
        );
        insert matchingDenial;
        Test.setCreatedDate(matchingDenial.Id, DateTime.now());
        System.debug('Matching Denial ID: ' + matchingDenial.Id);

        // Create a non-matching denial record (for negative test)
        dn_Denial__c nonMatchingDenial = new dn_Denial__c(
            dn_Adjustment_Code_1__c = '200',
            dn_PROVIDER_GROUPING__c = 'MD',
            dn_Patient_Account__c = patientAccount.Id,
            dn_DOS__c = Date.today(),
            dn_PROVIDER__c = 'TestProvider',
            OwnerId = testUser2.Id
        );
        insert nonMatchingDenial;
        Test.setCreatedDate(nonMatchingDenial.Id, DateTime.now());
        System.debug('Non-Matching Denial ID: ' + nonMatchingDenial.Id);
    }

    // Test method for positive scenario (owner reassignment)
    @isTest
    static void testBatchOwnerReassignment() {
        // Get test user and patient account
        User testUser1 = [SELECT Id FROM User WHERE Id IN (SELECT OwnerId FROM dn_Denial__c WHERE dn_Adjustment_Code_1__c = '100') LIMIT 1];
        Account patientAccount = [SELECT Id, dn_Name__c FROM Account WHERE Name = 'Test Patient' LIMIT 1];

        // Create a new denial record to be processed by the batch
        dn_Denial__c newDenial = new dn_Denial__c(
            dn_Adjustment_Code_1__c = '200',
            dn_PROVIDER_GROUPING__c = 'Not MD',
            dn_Patient_Account__c = patientAccount.Id,
            dn_DOS__c = Date.today(),
            dn_PROVIDER__c = 'TestProvider',
            OwnerId = [SELECT Id FROM User WHERE Id != :testUser1.Id AND IsActive = true LIMIT 1].Id
        );
        insert newDenial;
        Test.setCreatedDate(newDenial.Id, DateTime.now());
        System.debug('New Denial ID: ' + newDenial.Id + ', Initial OwnerId: ' + newDenial.OwnerId);

        // Run the batch
        Test.startTest();
        DenialOwnerReassignmentBatchclass batch = new DenialOwnerReassignmentBatchclass();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify the owner was reassigned
        dn_Denial__c updatedDenial = [SELECT OwnerId FROM dn_Denial__c WHERE Id = :newDenial.Id];
        System.debug('Updated Denial OwnerId: ' + updatedDenial.OwnerId + ', Expected: ' + testUser1.Id);
        System.assertEquals(testUser1.Id, updatedDenial.OwnerId, 'OwnerId should be reassigned to the owner of the matching CO-100 Not MD record.');
    }

    // Test method for negative scenario (no matching record)
    @isTest
    static void testBatchNoMatchingRecord() {
        // Get test user and patient account
        User testUser2 = [SELECT Id FROM User WHERE Id IN (SELECT OwnerId FROM dn_Denial__c WHERE dn_Adjustment_Code_1__c = '200') LIMIT 1];
        Account patientAccount = [SELECT Id, dn_Name__c FROM Account WHERE Name = 'Test Patient' LIMIT 1];

        // Create a new denial record with no matching CO-100/Not MD record
        dn_Denial__c newDenial = new dn_Denial__c(
            dn_Adjustment_Code_1__c = '200',
            dn_PROVIDER_GROUPING__c = 'Not MD',
            dn_Patient_Account__c = patientAccount.Id,
            dn_DOS__c = Date.today().addDays(1), // Different DOS to avoid matching
            dn_PROVIDER__c = 'DifferentProvider', // Different provider to avoid matching
            OwnerId = testUser2.Id
        );
        insert newDenial;
        Test.setCreatedDate(newDenial.Id, DateTime.now());
        System.debug('New Denial (No Match) ID: ' + newDenial.Id + ', Initial OwnerId: ' + newDenial.OwnerId);

        // Run the batch
        Test.startTest();
        DenialOwnerReassignmentBatchclass batch = new DenialOwnerReassignmentBatchclass();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify the owner was not changed
        dn_Denial__c updatedDenial = [SELECT OwnerId, dn_DOS__c, dn_PROVIDER__c FROM dn_Denial__c WHERE Id = :newDenial.Id];
        System.debug('Updated Denial OwnerId: ' + updatedDenial.OwnerId + ', Expected: ' + testUser2.Id);
        System.debug('Updated Denial DOS: ' + updatedDenial.dn_DOS__c + ', Provider: ' + updatedDenial.dn_PROVIDER__c);
        System.assertEquals(testUser2.Id, updatedDenial.OwnerId, 'OwnerId should not change when no matching record is found.');
    }

}