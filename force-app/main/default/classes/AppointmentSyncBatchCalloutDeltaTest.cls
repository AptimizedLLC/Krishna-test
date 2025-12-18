@isTest
public class AppointmentSyncBatchCalloutDeltaTest {
    @TestSetup
    public static void dataSetup(){
        List<Appointment__c> appointmentList2Upsert = new List<Appointment__c>();
        Appointment__c app1 = new Appointment__c();
        app1.Care_Cloud_Appointment_Id__c  = '08314725-ba4d-476d-9da8-d1c2bdfb264a';
        app1.Status__c = 'Checked-Out';
        app1.Patient_Chart_Number__c = '4303';
        app1.Location_Id__c = String.valueOf(30232);
        app1.Cancellation_Details_Id__c = '';
        app1.Referring_Physician_NPI__c = '';
        app1.Visit_Reason_Id__c  = String.valueOf(95620);
        String start_time = '2022-03-21T09:00:00-04:00';
        DateTime dt = DateTime.ValueofGmt(start_time.replace('T', ' '));
        app1.Appointment_Date_Time__c  = dt;
        app1.Provider_Id__c = '25288';
        appointmentList2Upsert.add(app1);
        
        Appointment__c app2 = new Appointment__c();
        app2.Care_Cloud_Appointment_Id__c  = '670fc26c-c68f-4c98-a3b3-c14faea8b1bb';
        app2.Status__c = 'Checked-Out';
        app2.Patient_Chart_Number__c = '228167925';
        app2.Location_Id__c = String.valueOf(30232);
        app2.Cancellation_Details_Id__c = '';
        app2.Referring_Physician_NPI__c = '1265569255';
        app2.Visit_Reason_Id__c  = String.valueOf(95620);
        app2.Appointment_Date_Time__c  = dt;
        app2.Provider_Id__c = '25284';        
        appointmentList2Upsert.add(app2);
        
        insert appointmentList2Upsert;
        
    }
    
    @isTest static  void testGetCallout() {       
        Test.startTest();
         List<Appointment__c> appointmentList = [SELECT Id, Care_Cloud_Appointment_Id__c FROM Appointment__c];
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAppointmentResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mock.setHeader('Link', '<https://api.carecloud.com/v2/appointments?end_date=2022-06-26&page=45&start_date=2022-03-30>; rel="last", <https://api.carecloud.com/v2/appointments?end_date=2022-06-26&page=2&start_date=2022-03-30>; rel="next",');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        AppointmentSyncBatchCalloutDelta instance = new AppointmentSyncBatchCalloutDelta();
        Id batchprocessid = Database.executeBatch(instance);
        Test.stopTest();
    }
}