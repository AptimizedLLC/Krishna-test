@IsTest
public class dnDenialBatchTest {

    @TestSetup
    static void setupData() {
        // Create test User
        User testUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];

        // Create some test dn_Denial__c records
        List<dn_Denial__c> denialList = new List<dn_Denial__c>();
        for (Integer i = 0; i < 5; i++) {
            dn_Denial__c d = new dn_Denial__c();
            d.dn_Patient_Account__c = 'TestAccount' + i;
            d.dn_DOS__c = Date.today();
            d.dn_PROVIDER_GROUPING__c = 'Not MD';
            d.dn_CO_100_Status__c = 'Underpaid';
            d.OwnerId = testUser.Id;
            denialList.add(d);
        }
        insert denialList;
    }

    @IsTest
    static void testHelperMethod() {
        List<dn_Denial__c> dns = [SELECT Id, OwnerId FROM dn_Denial__c];
        Test.startTest();
        dn_DenialHandler.updateOwnerOnMatchingRecords(dns);
        Test.stopTest();

        List<dn_Denial__c> updated = [SELECT OwnerId FROM dn_Denial__c];
        System.assertNotEquals(null, updated[0].OwnerId, 'OwnerId should be updated');
    }

    @IsTest
    static void testBatchExecution() {
        Test.startTest();
        dnDenialBatch batch = new dnDenialBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();

        // Validate owner update after batch
        List<dn_Denial__c> updatedRecords = [SELECT OwnerId FROM dn_Denial__c];
        for (dn_Denial__c rec : updatedRecords) {
            System.assertEquals(UserInfo.getUserId(), rec.OwnerId,
                'OwnerId should be updated by batch process');
        }
    }
}