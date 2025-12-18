@isTest
public class HorizonChargeMergeHandlerTest {

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
    static void testMergeAllCharges() {
        Test.startTest();
        HorizonChargeMergeHandler.mergeAllCharges();
        Test.stopTest();

        // Query all remaining records
        List<Hz_Horizon_Charges__c> results = [
            SELECT Id, Hz_Amount__c, Hz_Expected_Reimbursement__c, Hz_Provider_Id__c, Hz_Patient_Id__c
            FROM Hz_Horizon_Charges__c
            WHERE Hz_Provider_Id__c = 'Prov1' AND Hz_Patient_Id__c = 'Pat1'
        ];

        System.assertEquals(1, results.size(), 'Only one record should remain after merge.');

        Hz_Horizon_Charges__c kept = results[0];
        System.assertEquals(600, kept.Hz_Amount__c, 'Amount should be summed (100 + 200 + 300).');
        System.assertEquals(300, kept.Hz_Expected_Reimbursement__c, 'Reimbursement should be summed (50 + 100 + 150).');
    }

    @isTest
    static void testNoDuplicates() {
        // Create unique record with no duplicate
        Hz_Horizon_Charges__c uniqueCharge = new Hz_Horizon_Charges__c(
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = 'Prov2',
            Hz_Patient_Id__c = 'Pat2',
            Hz_Amount__c = 500,
            Hz_Expected_Reimbursement__c = 250
        );
        insert uniqueCharge;

        Test.startTest();
        HorizonChargeMergeHandler.mergeAllCharges();
        Test.stopTest();

        // Verify that record is unchanged
        Hz_Horizon_Charges__c result = [
            SELECT Hz_Amount__c, Hz_Expected_Reimbursement__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :uniqueCharge.Id
        ];
        System.assertEquals(500, result.Hz_Amount__c, 'Unique record should remain unchanged.');
        System.assertEquals(250, result.Hz_Expected_Reimbursement__c, 'Unique record should remain unchanged.');
    }
}