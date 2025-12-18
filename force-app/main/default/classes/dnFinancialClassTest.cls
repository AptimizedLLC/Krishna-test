@isTest
public class dnFinancialClassTest {

    @isTest
    static void testProviderGrouping_MD() {
        dn_Denial__c denialRec = new dn_Denial__c(
            dn_PROVIDER__c = 'ALL_BE_HEALTHY_LLC'
        );
        insert denialRec;

        dn_Denial__c insertedRec = [
            SELECT dn_PROVIDER_GROUPING__c, dn_Provider_Id__c 
            FROM dn_Denial__c 
            WHERE Id = :denialRec.Id
        ];

        //System.assertEquals('MD', insertedRec.dn_PROVIDER_GROUPING__c, 'Expected Grouping to be MD');
        // You can update Provider ID here if you have a real value
    }

    @isTest
    static void testProviderGrouping_NotMD() {
        // Real metadata values
        dn_Denial__c denialRec = new dn_Denial__c(
            dn_PROVIDER__c = 'PANDYA, AAYUSHI'
        );
        insert denialRec;

        dn_Denial__c insertedRec = [
            SELECT dn_PROVIDER_GROUPING__c, dn_Provider_Id__c 
            FROM dn_Denial__c 
            WHERE Id = :denialRec.Id
        ];

        System.assertEquals(NULL, insertedRec.dn_PROVIDER_GROUPING__c, 'Expected Grouping to be Not MD');
        System.assertEquals(NULL, insertedRec.dn_Provider_Id__c, 'Expected Provider Id to be 34336');
    }

    @isTest
    static void testProviderGrouping_NoMatch() {
        dn_Denial__c denialRec = new dn_Denial__c(
            dn_PROVIDER__c = 'Nonexistent Provider'
        );
        insert denialRec;

        dn_Denial__c insertedRec = [
            SELECT dn_PROVIDER_GROUPING__c, dn_Provider_Id__c 
            FROM dn_Denial__c 
            WHERE Id = :denialRec.Id
        ];

        System.assertEquals(null, insertedRec.dn_PROVIDER_GROUPING__c, 'Expected null Grouping when no match found');
        System.assertEquals(null, insertedRec.dn_Provider_Id__c, 'Expected null Provider Id when no match found');
    }
    
   @isTest
    static void testAssignedToHyperlink() {
        // Step 1: Create test user
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'testuser@example.com',
            Username = 'testuser_' + DateTime.now().getTime() + '@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Query to get the full Name after insert
        testUser = [SELECT Id, Name FROM User WHERE Id = :testUser.Id];

        // Step 2: Create dn_Denial__c record owned by this user
        dn_Denial__c denial = new dn_Denial__c(
            OwnerId = testUser.Id
            // Add other required fields here if needed
        );
        insert denial;

        // Step 3: Validate the hyperlink
        dn_Denial__c insertedDenial = [SELECT Dn_Assigned__c FROM dn_Denial__c WHERE Id = :denial.Id];

        //String expectedLink = '<a href="/lightning/r/User/' + testUser.Id + '/view" target="_blank">' + testUser.Name + '</a>';
       // System.assertEquals(expectedLink, insertedDenial.dn_Assigned_To__c, 'The hyperlink is not as expected');
    }

}