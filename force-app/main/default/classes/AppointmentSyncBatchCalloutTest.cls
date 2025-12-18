@isTest
public class AppointmentSyncBatchCalloutTest {
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

        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            CareCloud_Patient_Id__c = '9869dcf9-67ee-4d05-bea6-a799c5dfb555'
        );        
        insert acc;
        
        List<CareCloud_Information__c> ccInfo = new List<CareCloud_Information__c>();
        ccInfo.add(new CareCloud_Information__c(CareCloud_Id__c = '30234', Name = 'OLD BRIDGE OFFICE', Email__c = 'test@test.com', RecordTypeId = Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Location').getRecordTypeId()));
        ccInfo.add(new CareCloud_Information__c(CareCloud_Id__c = '25277', Name = 'Test Provider', Business_ID__c = '12345', Specialty__c = 'test', RecordTypeId = Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Provider').getRecordTypeId()));
        ccInfo.add(new CareCloud_Information__c(CareCloud_Id__c = '81914', Name = 'Test Visit', RecordTypeId = Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Visit Reason').getRecordTypeId()));
        Insert ccInfo;
    }
    
    @isTest static  void testGetCallout() {      
        String start_date = String.valueOf(Date.today().addDays(-15)).removeEnd(' 00:00:00');
        String end_date = String.valueOf(Date.today().addDays(50)).removeEnd(' 00:00:00');

        SingleRequestMock accessTokenResp = new SingleRequestMock(200, 'Complete', '{"access_token": "test_access_token"}', null);
		SingleRequestMock appointmentsMock = new SingleRequestMock(200, 'Complete', '[{"appointment":{"id":"a92c9228-9bf2-48cf-ac69-16044adb2724","appointment_status":{"id":3,"code":"O","name":"Checked-Out"},"patient":{"id":"9869dcf9-67ee-4d05-bea6-a799c5dfb555","chart_number":"228168852","date_of_birth":"1948-01-25 12:00:00","first_name":"ANJUM","last_name":"DANISH","middle_initial":null,"gender_id":"2","email":"shabbirdanish@gmail.com","patient_status":"A","primary_phone_number":"9143109322"},"location":{"id":30234,"name":"OLD BRIDGE OFFICE"},"cancellation_details":{"id":null,"detail":null,"comments":null},"chief_complaint":null,"task_id":null,"updated_by_application":null,"appointment_cancellation_reason_id":null,"arrived_at":"2022-03-21T08:37:45-04:00","business_entity_id":5052,"comments":"test","confirmation_details":null,"departed_at":"2022-03-21T09:47:27-04:00","exam_room_id":null,"is_confirmed":false,"is_force_overbook":false,"patient_contacted":null,"recurrence_id":3871631,"recurrence_index":7,"referring_physician_npi":"1881757268","visit_reason_id":81914,"resource_id":25235,"provider_id":"25277","start_time":"2022-03-21T08:45:00-04:00","end_time":"2022-03-21T09:15:00-04:00","created_at":"2022-03-17T11:02:23-04:00","updated_at":"2022-03-21T09:47:28-04:00"}}]', new Map<String, String>{'Content-Type' => 'application/json;charset=UTF-8', 'link' => '<https://api.carecloud.com/v2/appointments?end_date=2022-06-26&start_date=2022-03-30&page=1>; rel="last", <https://api.carecloud.com/v2/appointments?end_date=2022-06-26&start_date=2022-03-30&page=1>; rel="next",'});      
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.carecloud.com/v2/appointments?end_date='+end_date+'&start_date='+start_date+'&page=1', appointmentsMock);
        endpoint2TestResp.put('https://api.carecloud.com/oauth2/access_token', accessTokenResp);

        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(endpoint2TestResp));
        
        Test.startTest();
        AppointmentSyncBatchScheduler sch = new AppointmentSyncBatchScheduler();
        sch.execute(null);
        Test.stopTest();
    }
    
    @isTest static  void testGetCalloutWithCustomOffset() {      
        String start_date = String.valueOf(Date.today().addDays(-10)).removeEnd(' 00:00:00');
        String end_date = String.valueOf(Date.today().addDays(10)).removeEnd(' 00:00:00');

        SingleRequestMock accessTokenResp = new SingleRequestMock(200, 'Complete', '{"access_token": "test_access_token"}', null);
		SingleRequestMock appointmentsMock = new SingleRequestMock(200, 'Complete', '[{"appointment":{"id":"a92c9228-9bf2-48cf-ac69-16044adb2724","appointment_status":{"id":3,"code":"O","name":"Checked-Out"},"patient":{"id":"9869dcf9-67ee-4d05-bea6-a799c5dfb555","chart_number":"228168852","date_of_birth":"1948-01-25 12:00:00","first_name":"ANJUM","last_name":"DANISH","middle_initial":null,"gender_id":"2","email":"shabbirdanish@gmail.com","patient_status":"A","primary_phone_number":"9143109322"},"location":{"id":30234,"name":"OLD BRIDGE OFFICE"},"cancellation_details":{"id":null,"detail":null,"comments":null},"chief_complaint":null,"task_id":null,"updated_by_application":null,"appointment_cancellation_reason_id":null,"arrived_at":"2022-03-21T08:37:45-04:00","business_entity_id":5052,"comments":"test","confirmation_details":null,"departed_at":"2022-03-21T09:47:27-04:00","exam_room_id":null,"is_confirmed":false,"is_force_overbook":false,"patient_contacted":null,"recurrence_id":3871631,"recurrence_index":7,"referring_physician_npi":"1881757268","visit_reason_id":81914,"resource_id":25235,"provider_id":"25277","start_time":"2022-03-21T08:45:00-04:00","end_time":"2022-03-21T09:15:00-04:00","created_at":"2022-03-17T11:02:23-04:00","updated_at":"2022-03-21T09:47:28-04:00"}}]', new Map<String, String>{'Content-Type' => 'application/json;charset=UTF-8', 'link' => '<https://api.carecloud.com/v2/appointments?end_date=2022-06-26&start_date=2022-03-30&page=1>; rel="last", <https://api.carecloud.com/v2/appointments?end_date=2022-06-26&start_date=2022-03-30&page=1>; rel="next",'});      
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.carecloud.com/v2/appointments?end_date='+end_date+'&start_date='+start_date+'&page=1', appointmentsMock);
        endpoint2TestResp.put('https://api.carecloud.com/oauth2/access_token', accessTokenResp);

        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(endpoint2TestResp));
        
        Test.startTest();
        AppointmentSyncBatchScheduler sch = new AppointmentSyncBatchScheduler(-10, 10);
        sch.execute(null);
        Test.stopTest();
    }
}