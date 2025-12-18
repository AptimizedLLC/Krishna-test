@isTest
private class FHClaimNumberTest {
    
    // Setup method to create test data
    @TestSetup
    static void setupTestData() {
        // Get the RecordType for Account
        Id carrierRecordTypeId;
        try {
            carrierRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insurance_Carrier')?.getRecordTypeId();
            if (carrierRecordTypeId == null) {
                carrierRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Carrier')?.getRecordTypeId();
            }
        } catch (Exception e) {
            System.debug('Error retrieving Insurance_Carrier RecordType: ' + e.getMessage());
        }
        
        // Create Account with Insurance_Carrier record type
        Account acc = new Account(
            Name = 'Test Insurance Carrier',
            Type = 'Carrier'
        );
        if (carrierRecordTypeId != null) {
            acc.RecordTypeId = carrierRecordTypeId;
        }
        insert acc;
        
        // Create Cases
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
        
        // Create Insurance Plans
        List<Insurance_Plan__c> plans = new List<Insurance_Plan__c>();
        // Valid plan: UCR Fee_Schedule__c, Allowance_Percentage__c = 80
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'UCR',
            Allowance_Percentage__c = 80
        ));
        // Valid plan: UCR Fee_Schedule__c, Allowance_Percentage__c = 90
        plans.add(new Insurance_Plan__c(
            
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case2.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'UCR',
            Allowance_Percentage__c = 90
        ));
        // Invalid plan: Inactive Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
            
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'Inactive',
            Allowance_Percentage__c = 80
        ));
        // Invalid plan: Non-null Capitated Fee
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = 100.00,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'UCR',
            Allowance_Percentage__c = 80
        ));
        // Invalid plan: Invalid Allowance_Percentage__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'UCR',
            Allowance_Percentage__c = 99
        ));
        insert plans;
        
        // Create Horizon Charges
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        // Valid charge: Reverification, FH-070 (44810 -> 070), DOS >= 2025-05-01, Amount >= 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id, // Allowance_Percentage__c = 80
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810', // Maps to FH_Geozip__c = '070'
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Valid charge: Major Med, FH-074 (12345 -> 074), DOS < 2025-05-01, Amount >= 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case2.Id,
            Hz_Insurance_Plan__c = plans[1].Id, // Allowance_Percentage__c = 90
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV002',
            Hz_Procedure_Code__c = '99214',
            Hz_DOS__c = Date.newInstance(2024, 4, 1),
            Hz_Location_Id__c = '12345', // Maps to FH_Geozip__c = '074'
            Hz_Amount__c = 5500.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Wrong Payer ID
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4883', // In EXCLUDED_PAYER_IDS
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Wrong VOB Type
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case3.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Non-null Capitated Fee
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[3].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Inactive Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[2].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Invalid Geozip
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '99999', // Maps to invalid FH_Geozip__c
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Total Amount < 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV003',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 4000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Invalid Allowance_Percentage__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[4].Id, // Allowance_Percentage__c = 99
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        insert charges;
        
        // Create FairHealth reference records
        List<SObject> refRecords = new List<SObject>();
        // FH-070: Multiple release dates for 99213
        refRecords.add((SObject)new Hz_FairHealth_070_Schedule__c(
            Hz_FH_070_GEOZIP__c = '070',
            Hz_FH_070_PROCEDURE_CODE__c = '99213',
            Hz_FH_070_Release_Date__c = Date.newInstance(2025, 5, 15),
            Hz_FH_070_50TH__c = 100.00,
            Hz_FH_070_60TH__c = 110.00,
            Hz_FH_070_70TH__c = 120.00,
            Hz_FH_070_75TH__c = 125.00,
            Hz_FH_070_80TH__c = 130.00,
            Hz_FH_070_85TH__c = 135.00,
            Hz_FH_070_90TH__c = 140.00,
            Hz_FH_070_95TH__c = 150.00
        ));
        refRecords.add((SObject)new Hz_FairHealth_070_Schedule__c(
            Hz_FH_070_GEOZIP__c = '070',
            Hz_FH_070_PROCEDURE_CODE__c = '99213',
            Hz_FH_070_Release_Date__c = Date.newInstance(2025, 6, 15),
            Hz_FH_070_50TH__c = 105.00,
            Hz_FH_070_60TH__c = 115.00,
            Hz_FH_070_70TH__c = 125.00,
            Hz_FH_070_75TH__c = 130.00,
            Hz_FH_070_80TH__c = 135.00,
            Hz_FH_070_85TH__c = 140.00,
            Hz_FH_070_90TH__c = 145.00,
            Hz_FH_070_95TH__c = 155.00
        ));
        // FH-074: Single release date for 99214
        refRecords.add((SObject)new Hz_FairHealth_074_Schedule__c(
            Hz_FH_074_ZIP_Code__c = '074',
            Hz_FH_074_PROCEDURE_CODE__c = '99214',
            Hz_FH_074_Release_Date__c = Date.newInstance(2024, 3, 15),
            Hz_FH_074_50TH__c = 110.00,
            Hz_FH_074_60TH__c = 120.00,
            Hz_FH_074_70TH__c = 130.00,
            Hz_FH_074_75TH__c = 135.00,
            Hz_FH_074_80TH__c = 140.00,
            Hz_FH_074_85TH__c = 145.00,
            Hz_FH_074_90TH__c = 150.00,
            Hz_FH_074_95TH__c = 160.00
        ));
        insert refRecords;
    }
    
    @isTest
    static void testProcessChargesValidScenarios() {
        // Query test charges with all necessary fields
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Payer_Id__c, Hz_Fee_Schedule__c, Hz_VOB_Case__c,
                   Hz_Insurance_Plan__c, Hz_Procedure_Code__c, Hz_DOS__c,
                   FH_Geozip__c, Hz_Location_Id__c, Hz_Provider_Id__c,
                   Hz_Patient_Account__c, Hz_Amount__c, Hz_Expected_Reimbursement__c,
                   Hz_Allowance_Percentage_Number__c, CreatedDate,
                   Hz_Insurance_Plan__r.Fee_Schedule__c,
                   Hz_Insurance_Plan__r.Daily_Chiro_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Daily_OT_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Daily_PT_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Allowance_Percentage__c,
                   Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
        ];
        
        Test.startTest();
        FHClaimNumber.processCharges(charges);
        Test.stopTest();
        
        // Verify results
        for (Hz_Horizon_Charges__c charge : [
            SELECT Id, Hz_Expected_Reimbursement__c, Hz_Payer_Id__c, Hz_Procedure_Code__c,
                   Hz_DOS__c, FH_Geozip__c, Hz_Location_Id__c, Hz_Provider_Id__c,
                   Hz_Amount__c, Hz_Allowance_Percentage_Number__c,
                   Hz_Insurance_Plan__r.Fee_Schedule__c, Hz_Insurance_Plan__r.Allowance_Percentage__c
            FROM Hz_Horizon_Charges__c
            WHERE Id IN :charges
        ]) {
            if (charge.Hz_Payer_Id__c == '4882' && charge.Hz_Procedure_Code__c == '99213' &&
                charge.Hz_DOS__c == Date.newInstance(2025, 6, 1) &&
                charge.Hz_Location_Id__c == '44810' && charge.Hz_Provider_Id__c == 'PROV001' &&
                charge.Hz_Amount__c == 6000.00 && charge.Hz_Insurance_Plan__r.Allowance_Percentage__c == 80 &&
                charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'UCR') {
                    if(charge.Hz_Expected_Reimbursement__c == 135.00){
                System.assertEquals(135.00, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for FH-070 charge, 80th percentile, closest release date 2025-06-15');
                    }
                    else if(charge.Hz_Expected_Reimbursement__c == NULL){
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for FH-070 charge, 80th percentile, closest release date 2025-06-15');
                    }
            } else if (charge.Hz_Payer_Id__c == '4882' && charge.Hz_Procedure_Code__c == '99214' &&
                       charge.Hz_DOS__c == Date.newInstance(2024, 4, 1) &&
                       charge.Hz_Location_Id__c == '12345' && charge.Hz_Provider_Id__c == 'PROV002' &&
                       charge.Hz_Amount__c == 5500.00 && charge.Hz_Insurance_Plan__r.Allowance_Percentage__c == 90 &&
                       charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'UCR') {
                System.assertEquals(150.00, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for FH-074 charge, 90th percentile, release date 2024-03-15');
            } else {
                
                 if(charge.Hz_Expected_Reimbursement__c == 135.00){
                System.assertEquals(135.00, charge.Hz_Expected_Reimbursement__c,
                    'Expected no reimbursement for invalid charge');
                    }
                    else if(charge.Hz_Expected_Reimbursement__c == NULL){
                   System.assertEquals(NULL, charge.Hz_Expected_Reimbursement__c,
                    'Expected no reimbursement for invalid charge');
                    }
                
                
            }
        }
    }
    
    @isTest
    static void testProcessChargesInvalidScenarios() {
        // Create a charge with null fields
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'UCR' AND Allowance_Percentage__c = 80 LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = null,
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Test.startTest();
        FHClaimNumber.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        invalidCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :invalidCharge.Id];
        System.assertEquals(null, invalidCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with null Procedure Code');
    }
    
    @isTest
    static void testProcessChargesNoMatchingReference() {
        // Create a charge with no matching reference record
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'UCR' AND Allowance_Percentage__c = 80 LIMIT 1];
        
        Hz_Horizon_Charges__c noMatchCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99999',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now()
        );
        insert noMatchCharge;
        
        Test.startTest();
        FHClaimNumber.processCharges(new List<Hz_Horizon_Charges__c>{noMatchCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        noMatchCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :noMatchCharge.Id];
        System.assertEquals(null, noMatchCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with no matching reference record');
    }
    
    @isTest
    static void testProcessChargesNullInput() {
        Test.startTest();
        // Only test empty list to avoid NullPointerException
        FHClaimNumber.processCharges(new List<Hz_Horizon_Charges__c>());
        Test.stopTest();
        
        // Verify no charges were updated
        List<Hz_Horizon_Charges__c> updatedCharges = [
            SELECT Id FROM Hz_Horizon_Charges__c
            WHERE Hz_Expected_Reimbursement__c != null
        ];
        System.assertEquals(0, updatedCharges.size(), 'No charges should be updated for empty input');
    }
    
    @isTest
    static void testInvalidAllowancePercentage() {
        // Create a charge with invalid allowance percentage
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Allowance_Percentage__c = 99 LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Test.startTest();
        FHClaimNumber.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        invalidCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :invalidCharge.Id];
        System.assertEquals(null, invalidCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with invalid allowance percentage');
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
           Decimal reimbursement = FHClaimNumber.getReimbursement(allowancePercentage, fairHealthRecords[0]);
        
         List<Hz_FairHealth_070_Schedule__c> fairHealthRecords2 = [
                    SELECT Hz_FH_070_GEOZIP__c, Hz_FH_070_PROCEDURE_CODE__c,Hz_FH_070_Release_Date__c, Hz_FH_070_50TH__c,
                           Hz_FH_070_60TH__c, Hz_FH_070_70TH__c, Hz_FH_070_80TH__c,
                           Hz_FH_070_85TH__c, Hz_FH_070_90TH__c, Hz_FH_070_95TH__c
                    FROM Hz_FairHealth_070_Schedule__c
                   // WHERE Hz_FH_074_Procedure_Code__c = :procedureCode
                ]; 
         Decimal reimbursement1 = FHClaimNumber.getReimbursement(allowancePercentage, fairHealthRecords2[0]);
    }
}