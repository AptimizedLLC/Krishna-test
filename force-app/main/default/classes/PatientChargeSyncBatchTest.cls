@IsTest
class PatientChargeSyncBatchTest {

    @IsTest
    static void syncCharges() {
        // create account
        Account acc = new Account(Name ='Test Acc', CareCloud_Patient_Id__c = '572253a3-4963-4d55-81f0-5082b422c96e');
        insert acc;

		// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CareCloudChargeAndPaymentMock());        
        
        Test.startTest();
        
	        Database.executeBatch(new PatientChargeSyncBatch(), 50);
        
        Test.stopTest();
        
		List<CareCloud_Charge__c> payments = [select Id, Transaction_Status__c from CareCloud_Charge__c where account__c = :acc.Id];
        System.assertEquals(4, payments.size());
        System.assertEquals('posted', payments[0].Transaction_Status__c?.toLowerCase());
    }    
    
    @IsTest
    static void syncChargesFailure() {
        // create account
        Account acc = new Account(Name ='Test Acc', CareCloud_Patient_Id__c = '572253a3-4963-4d55-81f0-5082b422c96e');
        insert acc;

		// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CareCloudChargeAndPaymentMock.CareCloudChargeAndPaymentFailureMock());        
        
        Test.startTest();
            Database.executeBatch(new PatientChargeSyncBatch(), 50);
        try {
        	Test.stopTest();
        } catch (Exception e) {
            system.debug('erroroed out');
        }
        
		List<CareCloud_Charge__c> payments = [select Id, Transaction_Status__c from CareCloud_Charge__c where account__c = :acc.Id];
        System.assertEquals(0, payments.size());
    }  
}