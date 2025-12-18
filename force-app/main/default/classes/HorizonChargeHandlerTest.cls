@isTest
public class HorizonChargeHandlerTest {
    
    @testSetup
    static void setupData() {
        // 1. Create Patient Account
        Account patient = new Account(
            Name = 'Test Patient'
           // RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
               // .get('Person Account').getRecordTypeId()
        );
        insert patient;

        // 2. Create Insurance Plan
        Insurance_Plan__c insPlan = new Insurance_Plan__c(
            Daily_OT_Capitated_Fee__c = 15
        );
        insert insPlan;

        // 3. Create RecordType for Case (Verification of Benefits) if not available
        Id vobRecordTypeId;
        if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey('Verification of Benefits')) {
            vobRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
                .get('Verification of Benefits').getRecordTypeId();
        } else {
            // Fallback for test orgs without that record type
           // vobRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfos().values()[0].getRecordTypeId();
        }

        // 4. Create Case
        Case vobCase = new Case(
            AccountId = patient.Id,
            RecordTypeId = vobRecordTypeId,
            Subject = 'VOB Test Case',
            Status = 'New'
        );
        insert vobCase;

        // 5. Create Case → Insurance Plan relationship
        Insurance_Plan__c insPlan2 = new Insurance_Plan__c(
           
            VOB_Case__c = vobCase.Id
        );
        insert insPlan2;

        // 6. Create Horizon Charge record
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = patient.Id,
            Hz_DOS__c = Date.today(),
            Hz_Procedure_Code__c = 'PROC-001',
            Hz_Payer_Id__c = 'PAYER-001',
            Hz_Provider_Id__c = 'PROV-001',
            Hz_Amount__c = 100,
            Hz_Expected_Reimbursement__c = 0
        );
        insert charge;

        // Ensure CreatedDate = Today
        Test.setCreatedDate(charge.Id, DateTime.now());
    }
    
    @isTest
    static void testProcessCharges() {
        // Get inserted Charge
        Hz_Horizon_Charges__c charge = [
            SELECT Id, Hz_Patient_Account__c, Hz_DOS__c, CreatedDate,
                   Hz_VOB_Case__c, Hz_Insurance_Plan__c
            FROM Hz_Horizon_Charges__c
            LIMIT 1
        ];
        
        // Run handler
        Test.startTest();
        HorizonChargeHandler.processCharges(new List<Hz_Horizon_Charges__c>{ charge });
        Test.stopTest();
        
        // Reload updated charge
        charge = [
            SELECT Id, Hz_VOB_Case__c, Hz_Insurance_Plan__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :charge.Id
        ];
        
        System.assertNotEquals(null, charge.Hz_VOB_Case__c, 'Charge should be linked to a VOB Case');
        System.assertNotEquals(null, charge.Hz_Insurance_Plan__c, 'Charge should be linked to an Insurance Plan');
    }
}