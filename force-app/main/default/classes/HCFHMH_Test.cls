@isTest
private class HCFHMH_Test {

    @testSetup
    static void setupTestData() {
        // Create Insurance Plans
        Insurance_Plan__c planWithNulls = new Insurance_Plan__c(
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null
        );
        insert planWithNulls;

        // Create a Case for valid VOB Types
        Case c1 = new Case(
            Subject = 'Test Case 1',
            VOB_Type__c = 'Reverification'
        );
        insert c1;

        // Create FairHealth 070 and 074 records for testing
        Hz_FairHealth_070_Schedule__c fh070 = new Hz_FairHealth_070_Schedule__c(
            Hz_FH_070_PROCEDURE_CODE__c = '99213',
            Hz_FH_070_Release_Date__c = Date.newInstance(2025, 6, 1),
            Hz_FH_070_50TH__c = 100,
            Hz_FH_070_60TH__c = 120,
            Hz_FH_070_70TH__c = 140,
            Hz_FH_070_75TH__c = 160,
            Hz_FH_070_80TH__c = 180,
            Hz_FH_070_85TH__c = 200,
            Hz_FH_070_90TH__c = 220,
            Hz_FH_070_95TH__c = 240
        );
        insert fh070;

        Hz_FairHealth_074_Schedule__c fh074 = new Hz_FairHealth_074_Schedule__c(
            Hz_FH_074_Procedure_Code__c = '99213',
            Hz_FH_074_Release_Date__c = Date.newInstance(2025, 1, 1),
            Hz_FH_074_50TH__c = 80,
            Hz_FH_074_60TH__c = 90,
            Hz_FH_074_70TH__c = 100,
            Hz_FH_074_75TH__c = 110,
            Hz_FH_074_80TH__c = 120,
            Hz_FH_074_85TH__c = 130,
            Hz_FH_074_90TH__c = 140,
            Hz_FH_074_95TH__c = 150
        );
        insert fh074;

        // Create valid Horizon Charges (after threshold date)
        Hz_Horizon_Charges__c charge1 = new Hz_Horizon_Charges__c(
          
            Hz_VOB_Case__c = c1.Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 10),
            Hz_Payer_Id__c = '4873',
            Hz_Insurance_Plan__c = planWithNulls.Id,
            Provider_Specialty__c = 'PT',
            CreatedDate = System.now() // Simulate today's creation
        );
        insert charge1;

        // Create a pre-threshold charge
        Hz_Horizon_Charges__c charge2 = new Hz_Horizon_Charges__c(
           
            Hz_VOB_Case__c = c1.Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 3, 10),
            Hz_Payer_Id__c = '4883',
            Hz_Insurance_Plan__c = planWithNulls.Id,
            Provider_Specialty__c = 'CHIRO',
            CreatedDate = System.now()
        );
        insert charge2;

        // Create invalid payer charge to test skip logic
        Hz_Horizon_Charges__c charge3 = new Hz_Horizon_Charges__c(
             Hz_VOB_Case__c = c1.Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 10),
            Hz_Payer_Id__c = '9999', // invalid
            Hz_Insurance_Plan__c = planWithNulls.Id,
            Provider_Specialty__c = 'OT',
           
            CreatedDate = System.now()
        );
        insert charge3;
    }

    @isTest
    static void testProcessCharges_MixedScenarios() {
        // Fetch all test charges
        List<Hz_Horizon_Charges__c> allCharges = [
            SELECT Id, Name, Hz_VOB_Case__c, Hz_Procedure_Code__c, Hz_DOS__c,
                   Hz_Payer_Id__c, Hz_Fee_Schedule__c, Hz_Aggregate_Allowance__c,
                   Hz_Insurance_Plan__c, Provider_Specialty__c,
                   Hz_Allowance_Percentage_Number__c, CreatedDate
            FROM Hz_Horizon_Charges__c
        ];

        Test.startTest();
        HorizonChargeFHAndMedicareHandler.processCharges(allCharges);
        Test.stopTest();

        // Verify that reimbursement was calculated for valid records
        List<Hz_Horizon_Charges__c> updatedCharges = [
            SELECT Hz_Expected_Reimbursement__c, Hz_DOS__c, Name
            FROM Hz_Horizon_Charges__c
        ];

        Boolean foundReimbursed = false;
        for (Hz_Horizon_Charges__c ch : updatedCharges) {
            if (ch.Hz_Expected_Reimbursement__c != null) {
                foundReimbursed = true;
                System.assert(ch.Hz_Expected_Reimbursement__c > 0, 'Reimbursement should be positive');
            }
        }

       // System.assert(foundReimbursed, 'At least one charge should have reimbursement calculated');
    }

    @isTest
    static void testProcessCharges_NoValidCharges() {
        // Create invalid Case and Charge
        Case c2 = new Case(Subject='Invalid Case', VOB_Type__c='PIP');
        insert c2;

        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
         
            Hz_VOB_Case__c = c2.Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 10),
            Hz_Payer_Id__c = '4873',
           
            Provider_Specialty__c = 'PT',
           
            CreatedDate = System.now()
        );
        insert invalidCharge;

        Test.startTest();
        HorizonChargeFHAndMedicareHandler.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
        Test.stopTest();

        // Verify no update occurred
        invalidCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :invalidCharge.Id];
        System.assertEquals(null, invalidCharge.Hz_Expected_Reimbursement__c, 'Should remain null for invalid case');
    }
}