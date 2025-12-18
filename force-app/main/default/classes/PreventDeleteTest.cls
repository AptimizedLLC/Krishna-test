@isTest
private class PreventDeleteTest {

    @isTest
    static void testPreventDelete() {
        // Generate a unique username for Standard User
        String standardUserUsername = 'standarduser' + System.currentTimeMillis() + '@example.com';

        // Create a Standard User
        User standardUser = new User(
            Alias = 'stduser',
            Email = 'standarduser@example.com',
            Username = standardUserUsername,
            LastName = 'Standard User', 
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        insert standardUser;

        // Generate a unique username for System Administrator
        String sysAdminUsername = 'sysadmin' + System.currentTimeMillis() + '@example.com';

        // Create a System Administrator User
        User sysAdminUser = new User(
            Alias = 'sysadmin',
            Email = 'sysadmin@example.com',
            Username = sysAdminUsername,
            LastName = 'System Admin', 
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        insert sysAdminUser;

        // Test for Standard User (Deletion should be blocked)
        System.runAs(standardUser) {
            Appointment__c testRecord = new Appointment__c(Name = 'Test Appointment');
            insert testRecord;

            Test.startTest();
            try {
                delete testRecord;
                System.assert(false, 'Expected exception not thrown');
            } catch (DmlException e) {
                System.assert(e.getMessage().contains('You do not have permission to delete Appointment records.'), 
                              'Unexpected error message: ' + e.getMessage());
            }
            Test.stopTest();
        }

        // Test for System Administrator (Deletion should be allowed)
        System.runAs(sysAdminUser) {
            Appointment__c adminTestRecord = new Appointment__c(Name = 'Admin Test Appointment');
            insert adminTestRecord;

          
        }
    }
}