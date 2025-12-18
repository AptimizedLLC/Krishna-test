@isTest
public class CareCloudAppointmentServiceTest {
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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate= Date.today();
        opp.StageName= 'Initial Appointment';
        opp.Mid_Back_Pain__c = true;
        opp.Neck_Pain__c = true;
        opp.Lower_Back_Pain_Sciatica__c = true;
        opp.Leg_Pain__c = true;
        opp.Knee_Pain__c = true;
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        insert opp;
    }
    @isTest 
    static void testPatientPostCallout() {
        Test.startTest();
       	Account acc = [Select Id, CareCloud_Patient_Id__c FROM Account LIMIT 1];
        Opportunity opp = [Select Id FROM Opportunity LIMIT 1];
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AppointmentHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        //CareCloudAppointmentService.getAppointment(accIds);
        CareCloudAppointmentService.InvocableParameters param = new CareCloudAppointmentService.InvocableParameters();
        param.accId = acc.Id;
        param.intakeId = opp.Id;
        List<CareCloudAppointmentService.InvocableParameters> requests = new List<CareCloudAppointmentService.InvocableParameters>();
        requests.add(param);
        CareCloudAppointmentService.getAppointment(requests);
        Test.stopTest();
    }
}