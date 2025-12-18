@isTest
public class AppointmentCleanupBatchTest {
    @TestSetup
    public static void dataSetup(){
        List<Appointment__c> appointmentList2Upsert = new List<Appointment__c>();
        Appointment__c app1 = new Appointment__c();
        app1.Care_Cloud_Appointment_Id__c  = '08314725-ba4d-476d-9da8-d1c2bdfb264a';
        app1.Status__c = 'Pending';
        app1.Patient_Chart_Number__c = '4303';
        app1.Location_Id__c = String.valueOf(30232);
        app1.Cancellation_Details_Id__c = '';
        app1.Referring_Physician_NPI__c = '';
        app1.Visit_Reason_Id__c  = String.valueOf(95620);
        String start_time = String.valueOf(Date.today().addDays(+10))+'T09:00:00-04:00';
        DateTime dt = DateTime.ValueofGmt(start_time.replace('T', ' '));
        app1.Appointment_Date_Time__c  = dt;
        app1.Provider_Id__c = '25288';
        appointmentList2Upsert.add(app1);
        
        Appointment__c app2 = new Appointment__c();
        app2.Care_Cloud_Appointment_Id__c  = '670fc26c-c68f-4c98-a3b3-c14faea8b1bb';
        app2.Status__c = 'Pending';
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

    @isTest static void testAppointmentCleanupBatch(){
        SingleRequestMock accessTokenResp = new SingleRequestMock(200, 'Complete', '{"access_token" : "1234567890"}', null);
        SingleRequestMock validAppointmentResp = new SingleRequestMock(200, 'Complete', '', null);
        SingleRequestMock invalidAppointmentResp = new SingleRequestMock(404, 'Not Found', '', null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.carecloud.com/oauth2/access_token', accessTokenResp);
        endpoint2TestResp.put('https://api.carecloud.com/v2/appointments/08314725-ba4d-476d-9da8-d1c2bdfb264a', validAppointmentResp);
        endpoint2TestResp.put('https://api.carecloud.com/v2/appointments/670fc26c-c68f-4c98-a3b3-c14faea8b1bb', invalidAppointmentResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Test.startTest();
        AppointmentCleanupBatchScheduler sch = new AppointmentCleanupBatchScheduler();
        sch.execute(null);
        Test.stopTest();
    }
}