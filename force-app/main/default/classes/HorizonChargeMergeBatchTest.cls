@isTest
public class HorizonChargeMergeBatchTest {

    @testSetup
    static void setupTestData() {
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();

        // First record (oldest)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = 'Prov1',
            Hz_Patient_Id__c = 'Pat1',
            Hz_Amount__c = 100,
            Hz_Expected_Reimbursement__c = 50
        ));

        // Second record (middle)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = 'Prov1',
            Hz_Patient_Id__c = 'Pat1',
            Hz_Amount__c = 200,
            Hz_Expected_Reimbursement__c = 100
        ));

        // Third record (latest)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = 'Prov1',
            Hz_Patient_Id__c = 'Pat1',
            Hz_Amount__c = 300,
            Hz_Expected_Reimbursement__c = 150
        ));

        insert charges;
    }

    @isTest
    static void testBatchMergesCharges() {
        Test.startTest();
        Database.executeBatch(new HorizonChargeMergeBatch(), 200);
        Test.stopTest();

        // Query the remaining records
        List<Hz_Horizon_Charges__c> results = [
            SELECT Hz_Amount__c, Hz_Expected_Reimbursement__c, Hz_Provider_Id__c, Hz_Patient_Id__c
            FROM Hz_Horizon_Charges__c
            WHERE Hz_Provider_Id__c = 'Prov1' AND Hz_Patient_Id__c = 'Pat1'
        ];

        System.assertEquals(1, results.size(), 'Only one record should remain after merge.');
        System.assertEquals(600, results[0].Hz_Amount__c, 'Amount should be summed (100 + 200 + 300).');
        System.assertEquals(300, results[0].Hz_Expected_Reimbursement__c, 'Reimbursement should be summed (50 + 100 + 150).');
    }

    @isTest
    static void testBatchWithUniqueCharge() {
        // Create a record with no duplicates
        Hz_Horizon_Charges__c uniqueCharge = new Hz_Horizon_Charges__c(
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = 'Prov2',
            Hz_Patient_Id__c = 'Pat2',
            Hz_Amount__c = 500,
            Hz_Expected_Reimbursement__c = 250
        );
        insert uniqueCharge;

        Test.startTest();
        Database.executeBatch(new HorizonChargeMergeBatch(), 200);
        Test.stopTest();

        // Verify record is unchanged
        Hz_Horizon_Charges__c result = [
            SELECT Hz_Amount__c, Hz_Expected_Reimbursement__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :uniqueCharge.Id
        ];
        System.assertEquals(500, result.Hz_Amount__c, 'Unique record should remain unchanged.');
        System.assertEquals(250, result.Hz_Expected_Reimbursement__c, 'Unique record should remain unchanged.');
    }
}