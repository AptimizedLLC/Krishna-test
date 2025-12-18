@isTest
public class CareCloudPatientServiceTest {
    @testSetup
    public static void dataSetup(){
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            CareCloud_Patient_Id__c = '931ac90a-37c5-4f5a-b9f9-e6df35d3719e'
        );        
        insert acc;
    }
    
    @isTest 
    static void testPatientPostCallout() {
        Test.startTest();
        List<Id> accIds = new List<Id>();
       	Account acc = [Select Id, CareCloud_Patient_Id__c FROM Account LIMIT 1];
        
        accIds.add(acc.Id);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetPatientHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CareCloudPatientService.getPatient(accIds);
        Test.stopTest();
    }
}