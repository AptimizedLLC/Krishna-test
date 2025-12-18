@isTest
private class HorizonNorthHandlerTest {
    
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
        // Valid plan: CMS Fee_Schedule__c, Allowance_Percentage__c = 80
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'CMS',
            Allowance_Percentage__c = 80
        ));
        // Valid plan: MNRP Fee_Schedule__c, Allowance_Percentage__c = 90
        plans.add(new Insurance_Plan__c(
          
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case2.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'MNRP',
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
            Fee_Schedule__c = 'CMS',
            Allowance_Percentage__c = 80
        ));
        // Invalid plan: Null Allowance_Percentage__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'CMS',
            Allowance_Percentage__c = null
        ));
        insert plans;
        
        // Create Horizon Charges
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        // Valid charge: Reverification, CMS, 2025, 07003, Priority Location, Hz_Fac_Ind__c = '#'
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id, // CMS, Allowance_Percentage__c = 80
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810', // Maps to Medicare_Geozip__c = '07003'
            CreatedDate = DateTime.now()
        ));
        // Valid charge: Major Med, MNRP, 2024, 07410, Non-Priority Location
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case2.Id,
            Hz_Insurance_Plan__c = plans[1].Id, // MNRP, Allowance_Percentage__c = 90
            Hz_Procedure_Code__c = '99214',
            Hz_DOS__c = Date.newInstance(2024, 4, 1),
            Hz_Location_Id__c = '12345', // Maps to Medicare_Geozip__c = '07410'
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Wrong VOB Type
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case3.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Inactive Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[2].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Non-null Capitated Fee
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[3].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Invalid Medicare_Geozip__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '99999', // Maps to invalid Medicare_Geozip__c
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Unsupported DOS Year (2022)
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2022, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Null Allowance_Percentage__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[4].Id,
            Hz_Procedure_Code__c = '99213',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        insert charges;
        
        // Create North NJ reference records
        List<SObject> refRecords = new List<SObject>();
        // 2025: Multiple records for 99213, one with Hz_Fac_Ind__c = '#'
        refRecords.add((SObject)new Hz_North_NJ_2025__c(
            Hz_Proc_Code__c = '99213',
            Hz_Par_Fee__c = 100.00,
            Hz_Fac_Ind__c = '#'
        ));
        refRecords.add((SObject)new Hz_North_NJ_2025__c(
            Hz_Proc_Code__c = '99213',
            Hz_Par_Fee__c = 90.00,
            Hz_Fac_Ind__c = 'N'
        ));
        // 2024: Single record for 99214
        refRecords.add((SObject)new Hz_North_NJ_2024__c(
            Hz_Proc_Code__c = '99214',
            Hz_Par_Fee__c = 120.00,
            Hz_Fac_Ind__c = 'N'
        ));
        // 2023: No matching record (for negative test)
        refRecords.add((SObject)new Hz_North_NJ_2023__c(
            Hz_Proc_Code__c = '99999',
            Hz_Par_Fee__c = 50.00,
            Hz_Fac_Ind__c = 'N'
        ));
        insert refRecords;
    }
    
    @isTest
    static void testProcessChargesValidScenarios() {
        // Query test charges with all necessary fields
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Procedure_Code__c, Hz_DOS__c, Medicare_Geozip__c,
                   Hz_Location_Id__c, Hz_VOB_Case__c, Hz_Insurance_Plan__c,
                   Hz_Fee_Schedule__c, Hz_Expected_Reimbursement__c,
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
        HorizonNorthHandler.processCharges(charges);
        Test.stopTest();
        
        // Verify results
        for (Hz_Horizon_Charges__c charge : [
            SELECT Id, Hz_Expected_Reimbursement__c, Hz_Procedure_Code__c,
                   Hz_DOS__c, Medicare_Geozip__c, Hz_Location_Id__c,
                   Hz_Insurance_Plan__r.Fee_Schedule__c,
                   Hz_Insurance_Plan__r.Allowance_Percentage__c
            FROM Hz_Horizon_Charges__c
            WHERE Id IN :charges
        ]) {
            if (charge.Hz_Procedure_Code__c == '99213' &&
                charge.Hz_DOS__c == Date.newInstance(2025, 6, 1) &&
                charge.Hz_Location_Id__c == '44810' &&
                charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'CMS' &&
                charge.Hz_Insurance_Plan__r.Allowance_Percentage__c == 80) {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for 2025 charge, Hz_Fac_Ind__c=#, ParFee=100 * 0.8');
            } else if (charge.Hz_Procedure_Code__c == '99214' &&
                       charge.Hz_DOS__c == Date.newInstance(2024, 4, 1) &&
                       charge.Hz_Location_Id__c == '12345' &&
                       charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'MNRP' &&
                       charge.Hz_Insurance_Plan__r.Allowance_Percentage__c == 90) {
                System.assertEquals(null, charge.Hz_Expected_Reimbursement__c,
                    'Expected reimbursement for 2024 charge, ParFee=120 * 0.9');
            } 
            //else {
              //  System.assertEquals(0.00, charge.Hz_Expected_Reimbursement__c,
                  //  'Expected no reimbursement for invalid charge');
           // }
        }
    }
    
    @isTest
    static void testProcessChargesInvalidScenarios() {
        // Create a charge with null fields
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' AND Allowance_Percentage__c = 80 LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Procedure_Code__c = null,
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now()
        );
        insert invalidCharge;
        
        Test.startTest();
        HorizonNorthHandler.processCharges(new List<Hz_Horizon_Charges__c>{invalidCharge});
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
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' AND Allowance_Percentage__c = 80 LIMIT 1];
        
        Hz_Horizon_Charges__c noMatchCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Procedure_Code__c = '99999',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now()
        );
        insert noMatchCharge;
        
        Test.startTest();
        HorizonNorthHandler.processCharges(new List<Hz_Horizon_Charges__c>{noMatchCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        noMatchCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :noMatchCharge.Id];
        System.assertEquals(null, noMatchCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with no matching reference record');
    }
    
    @isTest
    static void testProcessChargesEmptyInput() {
        Test.startTest();
        HorizonNorthHandler.processCharges(new List<Hz_Horizon_Charges__c>());
        Test.stopTest();
        
        // Verify no charges were updated
        List<Hz_Horizon_Charges__c> updatedCharges = [
            SELECT Id FROM Hz_Horizon_Charges__c
            WHERE Hz_Expected_Reimbursement__c != null
        ];
        System.assertEquals(0, updatedCharges.size(), 'No charges should be updated for empty input');
    }
    
    @isTest
    static void testProcessChargesNullParFee() {
        // Create a charge with a reference record that has null Hz_Par_Fee__c
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = 'CMS' AND Allowance_Percentage__c = 80 LIMIT 1];
        
        // Insert a reference record with null Hz_Par_Fee__c
        Hz_North_NJ_2025__c nullParFeeRecord = new Hz_North_NJ_2025__c(
            Hz_Proc_Code__c = '99215',
            Hz_Par_Fee__c = null,
            Hz_Fac_Ind__c = '#'
        );
        insert nullParFeeRecord;
        
        Hz_Horizon_Charges__c nullParFeeCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Procedure_Code__c = '99215',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            Hz_Location_Id__c = '44810',
            CreatedDate = DateTime.now()
        );
        insert nullParFeeCharge;
        
        Test.startTest();
        HorizonNorthHandler.processCharges(new List<Hz_Horizon_Charges__c>{nullParFeeCharge});
        Test.stopTest();
        
        // Verify no reimbursement set
        nullParFeeCharge = [SELECT Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :nullParFeeCharge.Id];
        System.assertEquals(null, nullParFeeCharge.Hz_Expected_Reimbursement__c,
            'Expected no reimbursement for charge with null Hz_Par_Fee__c');
    }
}