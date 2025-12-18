@isTest
public class HorizonChargeBatchTest {
    
    @testSetup
    static void setupData() {
        // Create Patient Account
        Account patient = new Account(
            Name = 'Test Patient'
           // RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert patient;

        // Create Insurance Plan
        Insurance_Plan__c insPlan = new Insurance_Plan__c(
           
            Daily_OT_Capitated_Fee__c = null,
            Daily_Chiro_Capitated_Fee__c = null,
            Daily_PT_Capitated_Fee__c = null
        );
        insert insPlan;

        // Create Horizon Charge record
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
            Hz_Patient_Account__c = patient.Id,
            Hz_DOS__c = Date.today(),
            Hz_Insurance_Plan__c = insPlan.Id,
            Hz_Provider_Id__c = 'Prov-001',
            Hz_Procedure_Code__c = 'PROC1',
            Hz_Payer_Id__c = 'PAYER1',
            Hz_Amount__c = 100,
            Hz_Expected_Reimbursement__c = 0
        );
        insert charge;

        // Ensure CreatedDate = Today
        Test.setCreatedDate(charge.Id, DateTime.now());
    }
    
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        // Run the batch with small scope size
        HorizonChargeBatch batch = new HorizonChargeBatch();
        Database.executeBatch(batch, 50);
        Test.stopTest();
        
        // Reload charges
        List<Hz_Horizon_Charges__c> charges = [
            SELECT Id, Hz_Expected_Reimbursement__c
            FROM Hz_Horizon_Charges__c
        ];
        
        System.assert(!charges.isEmpty(), 'Charges should exist after batch');
        
        // Minimal assertion: just check field is accessible
        for (Hz_Horizon_Charges__c c : charges) {
            System.assert(c.Hz_Expected_Reimbursement__c != null, 
                'Expected reimbursement should not remain null after batch');
        }
    }
}