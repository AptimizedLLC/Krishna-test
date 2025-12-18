@isTest
public class PatientPaymentnChargeBatchSchedulerTest {
    @TestSetup
    public static void dataSetup(){
        // create account
        Account acc = new Account(Name ='Test Acc', CareCloud_Patient_Id__c = '572253a3-4963-4d55-81f0-5082b422c96e');
        insert acc;

		
    }
    
    @isTest static  void testPayment() {
        Test.startTest();
        List<Account> accList = [Select Id, Name, CareCloud_Patient_Id__c FROM Account];
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CareCloudChargeAndPaymentMock()); 
        PaymentBatchScheduler sch = new PaymentBatchScheduler();
        sch.execute(null);
        Test.stopTest();
    }
    
    @isTest static  void testCharge() {
        Test.startTest();
        List<Account> accList = [Select Id, Name, CareCloud_Patient_Id__c FROM Account];
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CareCloudChargeAndPaymentMock());
        PatientChargeBatchScheduler sch = new PatientChargeBatchScheduler();
        sch.execute(null);
        Test.stopTest();
    }
}