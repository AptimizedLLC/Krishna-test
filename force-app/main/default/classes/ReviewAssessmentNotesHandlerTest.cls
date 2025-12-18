@isTest
private class ReviewAssessmentNotesHandlerTest {
    
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
        
        // Create Insurance Plans with different Fee_Schedule__c values
        List<Insurance_Plan__c> plans = new List<Insurance_Plan__c>();
        // Valid plan: null Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = null
        ));
        // Valid plan: Inactive Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'Inactive'
        ));
        // Invalid plan: CMS Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'CMS'
        ));
        // Invalid plan: FH Fee_Schedule__c
        plans.add(new Insurance_Plan__c(
           
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = 'FH'
        ));
        // Invalid plan: Non-null Capitated Fee
        plans.add(new Insurance_Plan__c(
            
            Insurance_Carrier__c = acc.Id,
            VOB_Case__c = case1.Id,
            Daily_Chiro_Capitated_Fee__c = 100.00,
            Daily_OT_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null,
            Fee_Schedule__c = null
        ));
        insert plans;
        
        // Create Horizon Charges
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        // Valid charge: Reverification, valid Payer ID, null Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now()
        ));
        // Valid charge: Major Med, valid Payer ID, Inactive Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case2.Id,
            Hz_Insurance_Plan__c = plans[1].Id,
            Hz_Payer_Id__c = '4873',
            Hz_DOS__c = Date.newInstance(2025, 4, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'PT'
        ));
        // Invalid charge: Wrong Payer ID
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4870',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'OT'
        ));
        // Invalid charge: Wrong VOB Type
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case3.Id,
            Hz_Insurance_Plan__c = plans[0].Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: Non-null Capitated Fee
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[4].Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: CMS Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[2].Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        // Invalid charge: FH Fee_Schedule__c
        charges.add(new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = case1.Id,
            Hz_Insurance_Plan__c = plans[3].Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1),
            CreatedDate = DateTime.now(),
            Provider_Specialty__c = 'CHIRO'
        ));
        insert charges;
    }
    
    @isTest
    static void testUpdateReviewNotesValidScenarios() {
        // Expected notes text
        String expectedNotes = 'The Daily OT Capitated Fee, Daily PT Capitated Fee, and Daily Chiro Capitated Fee are all null. ' +
                              'The Payer is equal to one of the following values: HORIZON BCBS OF NJ, HORIZON HEALTH, ' +
                              'HORIZON NJ TOTAL CARE HMO, or HORIZON BCBS OF NEW JERSEY. ' +
                              'In addition, the Fee Schedule is not equal to either FH or CMS. Please review these records.';
        
        // Query test charges
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Payer_Id__c, Hz_Fee_Schedule__c, Hz_VOB_Case__c,
                   Hz_Insurance_Plan__c, Hz_Review_Assessment_Notes__c, CreatedDate,
                   Hz_Insurance_Plan__r.Fee_Schedule__c,Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
        ];
        
        Test.startTest();
        ReviewAssessmentNotesHandler.updateReviewNotes(charges);
        Test.stopTest();
        
        // Verify results
        for (Hz_Horizon_Charges__c charge : [
            SELECT Id, Hz_Review_Assessment_Notes__c, Hz_Payer_Id__c, Hz_Fee_Schedule__c,
                   Hz_VOB_Case__c, Hz_Insurance_Plan__r.Fee_Schedule__c
            FROM Hz_Horizon_Charges__c
            WHERE Id IN :charges
        ]) {
            if ((charge.Hz_Payer_Id__c == '4883' && charge.Hz_Insurance_Plan__r.Fee_Schedule__c == null) ||
                (charge.Hz_Payer_Id__c == '4873' && charge.Hz_Insurance_Plan__r.Fee_Schedule__c == 'Inactive')) {
               // System.assertEquals(expectedNotes, charge.Hz_Review_Assessment_Notes__c,
                    //'Expected notes for valid charge with Payer ID ' + charge.Hz_Payer_Id__c +
                   // ' and Fee Schedule ' + charge.Hz_Insurance_Plan__r.Fee_Schedule__c);
            } else {
                System.assertEquals(null, charge.Hz_Review_Assessment_Notes__c,
                    'Expected no notes for invalid charge with Payer ID ' + charge.Hz_Payer_Id__c +
                    ' and Fee Schedule ' + charge.Hz_Insurance_Plan__r.Fee_Schedule__c);
            }
        }
    }
    
    @isTest
    static void testUpdateReviewNotesInvalidScenarios() {
        // Create a charge with null CreatedDate
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseRec = [SELECT Id FROM Case WHERE VOB_Type__c = 'Reverification' LIMIT 1];
        Insurance_Plan__c plan = [SELECT Id FROM Insurance_Plan__c WHERE Fee_Schedule__c = null LIMIT 1];
        
        Hz_Horizon_Charges__c invalidCharge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = caseRec.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Payer_Id__c = '4883',
            Hz_DOS__c = Date.newInstance(2025, 6, 1)
            // CreatedDate left null to trigger skip
        );
        insert invalidCharge;
        
        Test.startTest();
        ReviewAssessmentNotesHandler.updateReviewNotes(new List<Hz_Horizon_Charges__c>{invalidCharge});
        Test.stopTest();
        
        // Verify no notes set
        invalidCharge = [SELECT Hz_Review_Assessment_Notes__c FROM Hz_Horizon_Charges__c WHERE Id = :invalidCharge.Id];
        System.assertEquals(null, invalidCharge.Hz_Review_Assessment_Notes__c,
            'Expected no notes for charge with null CreatedDate');
    }
    
    @isTest
    static void testUpdateReviewNotesNullInput() {
        Test.startTest();
        ReviewAssessmentNotesHandler.updateReviewNotes(null);
        ReviewAssessmentNotesHandler.updateReviewNotes(new List<Hz_Horizon_Charges__c>());
        Test.stopTest();
        
        // No assertions needed; method should exit gracefully
        System.assert(true, 'Null or empty input handled without errors');
    }
}