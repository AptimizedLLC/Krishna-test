@isTest
public class HorizonChargeReimbursementHandlerTest {

    @isTest
    static void testProcessReimbursements_withValidData() {
        // Create Account
        Account acc = new Account(Name = 'Test Patient');
        insert acc;

        // Create Case with correct VOB Type
        Case testCase = new Case(
            AccountId = acc.Id,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
                            .get('Verification of Benefits').getRecordTypeId(),
            VOB_Type__c = 'Reverification',
            Status = 'New',
            Origin = 'Phone'
        );
        insert testCase;

        // Create Insurance Plan (omit Insurance_Carrier__c to avoid filter validation issues)
        Insurance_Plan__c plan = new Insurance_Plan__c(
            
            Daily_Chiro_Capitated_Fee__c = 120,
            Daily_OT_Capitated_Fee__c = 220,
            Daily_PT_Capitated_Fee__c = 320,
            VOB_Case__c = testCase.Id
        );
        insert plan;

        // Get one Provider Mapping (must exist in org metadata)
        Horizon_Provider_CPT_Mapping__mdt mapping = [
            SELECT Provider_Id__c, Specialty__c 
            FROM Horizon_Provider_CPT_Mapping__mdt 
            WHERE Specialty__c IN ('CHIRO','OT','PT')
            LIMIT 1
        ];

        // Create Horizon Charge
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
         
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = testCase.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Provider_Id__c = String.valueOf(mapping.Provider_Id__c),
            Hz_DOS__c = Date.today()
        );
        insert charge;

        // Requery to get system fields (CreatedDate, lookups, etc.)
        charge = [
            SELECT Id, CreatedDate, Hz_VOB_Case__c, Hz_Insurance_Plan__c, Hz_Provider_Id__c, Hz_DOS__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :charge.Id
        ];

        // Call handler
        Test.startTest();
        HorizonChargeReimbursementHandler.processReimbursements(new List<Hz_Horizon_Charges__c>{charge});
        Test.stopTest();

        // Verify Expected Reimbursement was set
        charge = [SELECT Id, Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :charge.Id];
        System.assertNotEquals(null, charge.Hz_Expected_Reimbursement__c, 'Reimbursement should be populated');
    }

    @isTest
    static void testProcessReimbursements_invalidConditions() {
        // Charge with missing Case & Plan → should be skipped
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
           
            Hz_DOS__c = Date.today(),
            Hz_Provider_Id__c = '9999'
        );
        insert charge;

        // Requery to get system fields
        charge = [
            SELECT Id, CreatedDate, Hz_VOB_Case__c, Hz_Insurance_Plan__c, Hz_Provider_Id__c, Hz_DOS__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :charge.Id
        ];

        Test.startTest();
        HorizonChargeReimbursementHandler.processReimbursements(new List<Hz_Horizon_Charges__c>{charge});
        Test.stopTest();

        // Verify nothing was updated
        charge = [SELECT Id, Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :charge.Id];
        System.assertEquals(null, charge.Hz_Expected_Reimbursement__c, 'Charge should not be updated');
    }

    @isTest
    static void testProcessReimbursements_caseWithWrongType() {
        // Create Account
        Account acc = new Account(Name = 'Another Patient');
        insert acc;

        // Create Case with wrong VOB Type
        Case testCase = new Case(
            AccountId = acc.Id,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
                            .get('Verification of Benefits').getRecordTypeId(),
            VOB_Type__c = 'PIP',
            Status = 'New',
            Origin = 'Phone'
        );
        insert testCase;

        // Create Insurance Plan
        Insurance_Plan__c plan = new Insurance_Plan__c(
            
            Daily_Chiro_Capitated_Fee__c = 150,
            VOB_Case__c = testCase.Id
        );
        insert plan;

        // Use fake provider id (handler should skip because VOB_Type__c != Reverification/Major Med)
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
            
            Hz_Patient_Account__c = acc.Id,
            Hz_VOB_Case__c = testCase.Id,
            Hz_Insurance_Plan__c = plan.Id,
            Hz_Provider_Id__c = '12345',
            Hz_DOS__c = Date.today()
        );
        insert charge;

        // Requery to get system fields
        charge = [
            SELECT Id, CreatedDate, Hz_VOB_Case__c, Hz_Insurance_Plan__c, Hz_Provider_Id__c, Hz_DOS__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :charge.Id
        ];

        Test.startTest();
        HorizonChargeReimbursementHandler.processReimbursements(new List<Hz_Horizon_Charges__c>{charge});
        Test.stopTest();

        // Verify Expected Reimbursement remains null
        charge = [SELECT Id, Hz_Expected_Reimbursement__c FROM Hz_Horizon_Charges__c WHERE Id = :charge.Id];
        System.assertEquals(null, charge.Hz_Expected_Reimbursement__c, 'Reimbursement should not be set for wrong VOB type');
    }
}