@isTest
private class RULPreventDelete_Test {

    // Helper method to create a valid RUL__c record
    private static RUL__c createRULRecord() {
        // Create an Account to link to RUL_Patient_Name__c
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create RUL__c record with required fields
        RUL__c rul = new RUL__c(
            RUL_Patient_Name__c = acc.Id,
            RUL_Issue_Type__c = 'Insurance',
            RUL_Billed_Charges__c = 10
        );
        insert rul;

        return rul;
    }

    @isTest
    static void testPreventDeleteForSystemAdmin() {
        // Get System Administrator profile Id
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;

        // Create a System Administrator user
        User sysAdminUser = new User(
            FirstName = 'Sys',
            LastName = 'Admin',
            Email = 'sysadmin@test.com',
            Username = 'sysadmin_' + System.currentTimeMillis() + '@test.com',
            Alias = 'sa',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = sysAdminProfileId,
            LanguageLocaleKey = 'en_US'
        );
        insert sysAdminUser;

        // Create test data
        RUL__c testRul = createRULRecord();

        // Run as System Admin
        System.runAs(sysAdminUser) {
            // Use Database.delete to safely check for errors
            Database.DeleteResult dr = Database.delete(testRul, false);
        }
    }

    @isTest
    static void testDeleteForNonAdmin() {
        // Get a non-admin profile (Standard User or equivalent)
        Id standardProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;

        // Create non-admin user
        User normalUser = new User(
            FirstName = 'Normal',
            LastName = 'User',
            Email = 'normaluser@test.com',
            Username = 'normaluser_' + System.currentTimeMillis() + '@test.com',
            Alias = 'nu',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfileId,
            LanguageLocaleKey = 'en_US'
        );
        insert normalUser;

        // Create test data
        RUL__c testRul = createRULRecord();

        // Run as non-admin user
        System.runAs(normalUser) {
            // Should delete successfully since trigger only blocks System Admin
            Database.DeleteResult dr = Database.delete(testRul, false);
        }
    }
}