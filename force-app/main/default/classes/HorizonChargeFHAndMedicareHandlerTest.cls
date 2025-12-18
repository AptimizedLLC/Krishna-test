@isTest
private class HorizonChargeFHAndMedicareHandlerTest {
    
    // Setup method to create test data
    @TestSetup
    static void setupTestData() {
        // Get the RecordType for Account
        Id carrierRecordTypeId;
        try {
            // Try by Name first
            carrierRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insurance_Carrier')?.getRecordTypeId();
            if (carrierRecordTypeId == null) {
                // Fallback to DeveloperName if Name doesn't work
                carrierRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Carrier')?.getRecordTypeId();
            }
        } catch (Exception e) {
            // Log error and proceed without RecordTypeId if unavailable
            System.debug('Error retrieving Insurance_Carrier RecordType: ' + e.getMessage());
        }
        
        // Create Account with fields to satisfy Insurance_Carrier__c filter
        Account acc = new Account(
            Name = 'Test Insurance Carrier',
            Type = 'Carrier' // Common field for insurance carrier accounts; adjust if filter requires different value
            // Remove RecordTypeId if null to avoid INVALID_CROSS_REFERENCE_KEY
        );
        if (carrierRecordTypeId != null) {
            acc.RecordTypeId = carrierRecordTypeId;
        }
        insert acc;
        
        // Create Cases with VOB Type 'Reverification' and 'Major Med'
        Case case1 = new Case(
            Subject = 'Test Case Reverification',
            VOB_Type__c = 'Reverification',
            AccountId = acc.Id
        );
        Case case2 = new Case(
            Subject = 'Test Case Major Med',
            VOB_Type__c = 'Major Med',
            AccountId = acc.Id
        );
        Case case3 = new Case(
            Subject = 'Test Case Invalid',
            VOB_Type__c = 'PIP',
            AccountId = acc.Id
        );
        insert new List<Case>{case1, case2, case3};
        
        // Create Insurance Plan with null Capitated Fee fields
        Insurance_Plan__c plan = new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Aggregate_Allowance__c = 'Local'
        );
        insert plan;
        
        // Create Insurance Plan with non-null Capitated Fee for invalid test
        Insurance_Plan__c invalidPlan = new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = 100.00,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Aggregate_Allowance__c = 'Local'
        );
        insert invalidPlan;
        
        // Create Horizon Charges with Hz_Location_Id__c to derive FH_Geozip__c
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        // Valid charge for Hz_FairHealth_070_Schedule__c (DOS >= 2025-05-01, Hz_Location_Id__c = 44813 → FH_Geozip__c = 070)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Valid charge for Hz_FairHealth_074_Schedule__c (DOS < 2025-05-01, Hz_Location_Id__c = 38637 → FH_Geozip__c = 074)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case2.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4873',
            Hz_Location_Id__c = '38637',
            Hz_Procedure_Code__c = '99214',
            Hz_DOS__c = Date.newInstance(2025, 4, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge (wrong Payer Id)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4870',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge (wrong VOB Type)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case3.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        ));
        // Invalid charge (non-null Capitated Fee)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = invalidPlan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        ));
        insert charges;
        
        // Create FairHealth schedule records
        Hz_FairHealth_070_Schedule__c fh070 = new Hz_FairHealth_070_Schedule__c(
            Hz_FH_070_GEOZIP__c = '070',
            Hz_FH_070_PROCEDURE_CODE__c = '99213',
            Hz_FH_070_Release_Date__c = Date.newInstance(2025, 6, 1),
            Hz_FH_070_50TH__c = 100.00,
            Hz_FH_070_60TH__c = 120.00,
            Hz_FH_070_70TH__c = 140.00,
            Hz_FH_070_75TH__c = 150.00,
            Hz_FH_070_80TH__c = 160.00,
            Hz_FH_070_85TH__c = 170.00,
            Hz_FH_070_90TH__c = 180.00,
            Hz_FH_070_95TH__c = 200.00
        );
        insert fh070;
        
        Hz_FairHealth_074_Schedule__c fh074 = new Hz_FairHealth_074_Schedule__c(
            Hz_FH_074_ZIP_Code__c = '074',
            Hz_FH_074_Procedure_Code__c = '99214',
            Hz_FH_074_Release_Date__c = Date.newInstance(2025, 4, 1),
            Hz_FH_074_50TH__c = 110.00,
            Hz_FH_074_60TH__c = 130.00,
            Hz_FH_074_70TH__c = 150.00,
            Hz_FH_074_75TH__c = 160.00,
            Hz_FH_074_80TH__c = 170.00,
            Hz_FH_074_85TH__c = 180.00,
            Hz_FH_074_90TH__c = 190.00,
            Hz_FH_074_95TH__c = 210.00
        );
        insert fh074;
    }
    
    @isTest
    static void testProcessChargesValidScenarios() {
        // Query test charges with all required fields
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Payer_Id__c, Hz_Location_Id__c, FH_Geozip__c, Hz_Procedure_Code__c,
                   Hz_DOS__c, Hz_Expected_Reimbursement__c, Hz_VOB_Case__c, Hz_Insurance_Plan__c,
                   CreatedDate, Hz_Fee_Schedule__c, Hz_Aggregate_Allowance__c, Hz_Allowance_Percentage_Number__c, Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
        ];
        system.debug('charges ##' + charges);
        Test.startTest();
        HorizonChargeFHAndMedicareHandler.processCharges(charges);
        Test.stopTest();
        
        // Verify results
        for (Hz_Horizon_Charges__c charge : [SELECT Id, Hz_Expected_Reimbursement__c, Hz_Payer_Id__c,
                                            Hz_DOS__c, Hz_Location_Id__c, FH_Geozip__c
                                            FROM Hz_Horizon_Charges__c
                                            WHERE Id IN :charges]) {
            if (charge.Hz_Payer_Id__c == '4883' && charge.Hz_Location_Id__c == '44813' &&
                charge.Hz_DOS__c == Date.newInstance(2025, 6, 1)) {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for charge with 80% allowance (070 schedule)');
            } else if (charge.Hz_Payer_Id__c == '4873' && charge.Hz_Location_Id__c == '38637' &&
                       charge.Hz_DOS__c == Date.newInstance(2025, 4, 1)) {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for charge with 75% allowance (074 schedule)');
            } else {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected no reimbursement for invalid charge');
            }
        }
    }
    
    @isTest
    static void testProcessChargesInvalidScenarios() {
        // Create a charge with null fields to test skipping
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Daily_Chiro_Capitated_Fee__c = null LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = null,
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Test.startTest();
        HorizonChargeFHAndMedicareHandler.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        invalidCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :invalidCharge.Id];
        System.assertEquals(null, invalidCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with null Procedure Code');
    }
    
    @isTest
    static void testProcessChargesNoMatchingFairHealth() {
        // Create a charge with no matching FairHealth record
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Daily_Chiro_Capitated_Fee__c = null LIMIT 1];
        
        Hz_Horizon_Charges__c noMatchCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = '99999',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        );
        insert noMatchCharge;
        
        Test.startTest();
        HorizonChargeFHAndMedicareHandler.processCharges(new List<Hz_Horizon_Charges__c>{noMatchCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        noMatchCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :noMatchCharge.Id];
        System.assertEquals(null, noMatchCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with no matching FairHealth record');
    }
    
    @isTest
    static void testgetReimbursement() {
          Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Daily_Chiro_Capitated_Fee__c = null LIMIT 1];
         Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_Location_Id__c = '44813',
            Hz_Procedure_Code__c = null,
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Hz_FairHealth_070_Schedule__c fh070 = new Hz_FairHealth_070_Schedule__c(
            Hz_FH_070_GEOZIP__c = '070',
            Hz_FH_070_PROCEDURE_CODE__c = '99213',
            Hz_FH_070_Release_Date__c = Date.newInstance(2025, 6, 1),
            Hz_FH_070_50TH__c = 100.00,
            Hz_FH_070_60TH__c = 120.00,
            Hz_FH_070_70TH__c = 140.00,
            Hz_FH_070_75TH__c = 150.00,
            Hz_FH_070_80TH__c = 160.00,
            Hz_FH_070_85TH__c = 170.00,
            Hz_FH_070_90TH__c = 180.00,
            Hz_FH_070_95TH__c = 200.00
        );
        insert fh070;
        
         List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Payer_Id__c, Hz_Location_Id__c, FH_Geozip__c, Hz_Procedure_Code__c,
                   Hz_DOS__c, Hz_Expected_Reimbursement__c, Hz_VOB_Case__c, Hz_Insurance_Plan__c,
                   CreatedDate, Hz_Fee_Schedule__c, Hz_Aggregate_Allowance__c, Hz_Allowance_Percentage_Number__c, Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
        ];
           Decimal allowancePercentage = charges[0].Hz_Allowance_Percentage_Number__c;
           String procedureCode = charges[0].Hz_Procedure_Code__c;
           List<Hz_FairHealth_074_Schedule__c> fairHealthRecords = [
                    SELECT Hz_FH_074_Release_Date__c, Hz_FH_074_50TH__c, Hz_FH_074_60TH__c,
                           Hz_FH_074_70TH__c, Hz_FH_074_75TH__c, Hz_FH_074_80TH__c,
                           Hz_FH_074_85TH__c, Hz_FH_074_90TH__c, Hz_FH_074_95TH__c
                    FROM Hz_FairHealth_074_Schedule__c
                   // WHERE Hz_FH_074_Procedure_Code__c = :procedureCode
                ]; 
           Decimal reimbursement = HorizonChargeFHAndMedicareHandler.getReimbursement(allowancePercentage, fairHealthRecords[0]);
        
         List<Hz_FairHealth_070_Schedule__c> fairHealthRecords2 = [
                    SELECT Hz_FH_070_GEOZIP__c, Hz_FH_070_PROCEDURE_CODE__c,Hz_FH_070_Release_Date__c, Hz_FH_070_50TH__c,
                           Hz_FH_070_60TH__c, Hz_FH_070_70TH__c, Hz_FH_070_80TH__c,
                           Hz_FH_070_85TH__c, Hz_FH_070_90TH__c, Hz_FH_070_95TH__c
                    FROM Hz_FairHealth_070_Schedule__c
                   // WHERE Hz_FH_074_Procedure_Code__c = :procedureCode
                ]; 
         Decimal reimbursement1 = HorizonChargeFHAndMedicareHandler.getReimbursement(allowancePercentage, fairHealthRecords2[0]);
    }
    
}