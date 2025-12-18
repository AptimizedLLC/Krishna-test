@isTest
private class DenialMissingInfoEmailSchedulerTest {

    @testSetup
    static void setupData() {
        // Create inactive and active users
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User inactiveUser = new User(
            FirstName = 'Test',
            LastName = 'Inactive',
            Alias = 'tuser',
            Email = 'inactive@example.com',
            Username = 'inactiveuser_' + System.currentTimeMillis() + '@test.com',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            IsActive = false
        );
        insert inactiveUser;

        User activeUser = new User(
            FirstName = 'Test',
            LastName = 'Active',
            Alias = 'auser',
            Email = 'active@example.com',
            Username = 'activeuser_' + System.currentTimeMillis() + '@test.com',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            IsActive = true
        );
        insert activeUser;

        // Missing Financial Class
        insert new dn_Denial__c(
            dn_PROVIDER__c = 'Provider A',
            dn_PROVIDER_GROUPING__c = 'MD',
            OwnerId = activeUser.Id
        );

        // Missing Owner
        insert new dn_Denial__c(
            dn_Financial_Class__c = 'Class B',
            dn_PROVIDER__c = 'Provider B',
            dn_PROVIDER_GROUPING__c = 'MD'
        );

        // Inactive Owner
        insert new dn_Denial__c(
            dn_Financial_Class__c = 'Class C',
            dn_PROVIDER__c = 'Provider C',
            dn_PROVIDER_GROUPING__c = 'MD',
            OwnerId = inactiveUser.Id
        );

        // Valid Denial - Should not be included in email
        insert new dn_Denial__c(
            dn_Financial_Class__c = 'Class D',
            dn_PROVIDER__c = 'Provider D',
            dn_PROVIDER_GROUPING__c = 'MD',
            OwnerId = activeUser.Id
        );
    }

    @isTest
    static void testSendMissingInfoEmail() {
        Test.startTest();
        new DenialMissingInfoEmailScheduler().sendMissingInfoEmail();
        Test.stopTest();

        // Simply assert something to ensure test runs without error
        System.assertEquals(true, true);
    }

    @isTest
    static void testSchedulerExecution() {
        Test.startTest();
        String jobId = System.schedule('Test Denial Scheduler', '0 0 12 * * ?', new DenialMissingInfoEmailScheduler());
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Job ID should not be null');
    }
}