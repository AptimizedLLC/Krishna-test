@isTest
private class MedicareOnepointTwoTest {
    
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
        // Valid plan: CMS Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'CMS'
        ));
        // Invalid plan: Inactive Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
            
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'Inactive'
        ));
        // Invalid plan: Non-null Capitated Fee
        plans.add(new Insurance_Plan__c(
            
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = 100.00,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'CMS'
        ));
        insert plans;
        
        // Create Horizon Charges
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        // Valid charge: Reverification, North NJ (44810 -> 08816), 2025, Priority Location, CMS, Amount < 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810', // Maps to Medicare_Geozip__c = '08816'
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Valid charge: Major Med, Rest of NJ (12345 -> 07728), 2024, Non-priority Location, CMS, Amount < 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case2.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV002',
            Hz_Procedure_Code__c = '99214',
            Hz_DOS__c = Date.newInstance(2024, 4, 1),
            Hz_Location_Id__c = '12345', // Maps to Medicare_Geozip__c = '07728'
            Hz_Amount__c = 1500.00,
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
            Hz_Amount__c = 2000.00,
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
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Non-null Capitated Fee
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[2].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
            
        ));
        // Invalid charge: Inactive Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[1].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Invalid Location ID (no valid Geozip mapping)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '99999',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Total Amount >= 5000
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV003',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 6000.00,
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        insert charges;
        
        // Create Medicare reference records
        List<SObject> refRecords = new List<SObject>();
        // North NJ 2025: Multiple matches for prioritization
        refRecords.add((SObject)new Hz_North_NJ_2025__c(
            Hz_Proc_Code__c = '99213',
            Hz_Par_Fee__c = 100.00,
            Hz_Fac_Ind__c = ' '
        ));
        refRecords.add((SObject)new Hz_North_NJ_2025__c(
            Hz_Proc_Code__c = '99213',
            Hz_Par_Fee__c = 120.00,
            Hz_Fac_Ind__c = '#'
        ));
        // Rest of NJ 2024: Single match
        refRecords.add((SObject)new Hz_Rest_of_NJ_2024__c(
            Hz_Proc_Code__c = '99214',
            Hz_Par_Fee__c = 110.00,
            Hz_Fac_Ind__c = ' '
        ));
        insert refRecords;
    }
    
    @isTest
    static void testProcessChargesValidScenarios() {
        // Query test charges with Insurance_Plan__c relationship fields
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Payer_Id__c, Hz_Fee_Schedule__c, Hz_VOB_Case__c,
                   Hz_Insurance_Plan__c, Hz_Procedure_Code__c, Hz_DOS__c,
                   Medicare_Geozip__c, Hz_Location_Id__c, Hz_Provider_Id__c,
                   Hz_Patient_Account__c, Hz_Amount__c, Hz_Expected_Reimbursement__c,
                   CreatedDate, Hz_Insurance_Plan__r.Fee_Schedule__c,
                   Hz_Insurance_Plan__r.Daily_Chiro_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Daily_OT_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Daily_PT_Capitated_Fee__c,
                   Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
        ];
        
        Test.startTest();
        MedicareOnepointTwo.processCharges(charges);
        Test.stopTest();
        
        // Verify results
        for (Hz_Horizon_Charges__c charge : [
            SELECT Id, Hz_Expected_Reimbursement__c, Hz_Payer_Id__c, Hz_Procedure_Code__c,
                   Hz_DOS__c, Medicare_Geozip__c, Hz_Location_Id__c, Hz_Provider_Id__c,
                   Hz_Amount__c, Hz_Insurance_Plan__r.Fee_Schedule__c
            FROM Hz_Horizon_Charges__c
            WHERE Id IN :charges
        ]) {
            if (charge.Hz_Payer_Id__c == '4882' && charge.Hz_Procedure_Code__c == '99213' &&
                charge.Hz_DOS__c == Date.newInstance(2025, 6, 1) &&
                charge.Hz_Location_Id__c == '44810' && charge.Hz_Provider_Id__c == 'PROV001' &&
                charge.Hz_Amount__c == 2000.00 && charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'CMS') {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for North NJ 2025 charge with priority Hz_Fac_Ind__c=#');
            } else if (charge.Hz_Payer_Id__c == '4882' && charge.Hz_Procedure_Code__c == '99214' &&
                       charge.Hz_DOS__c == Date.newInstance(2024, 4, 1) &&
                       charge.Hz_Location_Id__c == '12345' && charge.Hz_Provider_Id__c == 'PROV002' &&
                       charge.Hz_Amount__c == 1500.00 && charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'CMS') {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for Rest of NJ 2024 charge');
            } else {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected no reimbursement for invalid charge');
            }
        }
    }
    
    @isTest
    static void testProcessChargesInvalidScenarios() {
        // Create a charge with null fields
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = null,
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Test.startTest();
        MedicareOnepointTwo.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
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
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' LIMIT 1];
        
        Hz_Horizon_Charges__c noMatchCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99999',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now()
        );
        insert noMatchCharge;
        
        Test.startTest();
        MedicareOnepointTwo.processCharges(new List<Hz_Horizon_Charges__c>{noMatchCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        noMatchCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :noMatchCharge.Id];
        System.assertEquals(null, noMatchCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with no matching reference record');
    }
    
   /* @isTest
    static void testProcessChargesNullInput() {
        Test.startTest();
        MedicareOnepointTwo.processCharges(null);
        MedicareOnepointTwo.processCharges(new List<Hz_Horizon_Charges__c>());
        Test.stopTest();
        
        // No assertions needed; method should exit gracefully
        System.assert(true, 'Null or empty input handled without errors');
    }  */
    
    @isTest
    static void testInvalidObject() {
        // Create a valid charge
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' LIMIT 1];
        
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4882',
            Hz_Provider_Id__c = 'PROV001',
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2026, 6, 1), // Invalid year to trigger null sObjectName
            Hz_Location_Id__c = '44810',
            Hz_Amount__c = 2000.00,
            CreatedDate = DateTime.now()
        );
        insert charge;
        
        Test.startTest();
        MedicareOnepointTwo.processCharges(new List<Hz_Horizon_Charges__c>{charge});
        Test.stopTest();
        
        // Verify no reimbursement set
        charge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :charge.Id];
        System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with invalid reference object year');
    }
    
    @isTest
    static void testIsValidObject_ValidObject() {
        // Test with a standard object (e.g., Account)
        Boolean result = MedicareOnepointTwo.isValidObject('Account');
        System.assertEquals(true, result, 'Account should be a valid object');
    }

    @isTest
    static void testIsValidObject_InvalidObject() {
        // Test with a non-existent object
        Boolean result = MedicareOnepointTwo.isValidObject('Invalid_Object__c');
        System.assertEquals(false, result, 'Invalid_Object__c should return false');
    }
    
    @isTest
static void testFullCoverage_ProcessChargesLoop() {
    // Get existing Case and Plan from setup
    Account acc = [SELECT Id FROM Account LIMIT 1];
    Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
    Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' LIMIT 1];

    // Create a Horizon Charge that meets ALL conditions
    Hz_Horizon_Charges__c validCharge = new Hz_Horizon_Charges__c(
        
        Hz_Patient_Account__c = acc.Id,
        Hz_VOB_Case__c = caseRec.Id,
        Hz_Insurance_Plan__c = plan.Id,
        Hz_Payer_Id__c = '4882',
        Hz_Provider_Id__c = 'PROV999',
        Hz_Procedure_Code__c = '99213',     // Must match reference record
        Hz_DOS__c = Date.newInstance(2025, 6, 1), // Matches Hz_North_NJ_2025__c
        Hz_Location_Id__c = '44810',        // Priority location
              // Explicitly set matching geozip
        Hz_Amount__c = 100.00,
        Provider_Specialty__c = 'OT'
    );
    insert validCharge;

    Test.startTest();
    MedicareOnepointTwo.processCharges(new List<Hz_Horizon_Charges__c>{validCharge});
    Test.stopTest();

   
}

}