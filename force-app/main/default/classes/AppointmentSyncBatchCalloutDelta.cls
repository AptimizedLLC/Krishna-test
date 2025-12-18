global with sharing class AppointmentSyncBatchCalloutDelta implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    global Map<String,  AppointmentJSONResponse> appointIdMap = new Map<String,  AppointmentJSONResponse>();
    global List<AppointmentJSONResponse> appointmentList = new List<AppointmentJSONResponse>();
    global List<Appointment__c> appointmentList2Upsert  = new List<Appointment__c>();
    global List<String> appointExistIdList = new List<String>();
    global List<String> ExternalIDs = new List<String>();
    private Set<String> noPatientAppointmentId = new Set<String>();
    String query;

    global Database.queryLocator start(Database.BatchableContext BC) {
        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);

        CareCloud_Appointment_Sync__mdt appSyncRec = [SELECT Id, Start_Date__c, End_Date__c FROM CareCloud_Appointment_Sync__mdt];


        String start_date = String.valueOf(appSyncRec.Start_Date__c);
        String end_date = String.valueOf(appSyncRec.End_Date__c);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(120000);
        request.setEndpoint('https://api.carecloud.com/v2/appointments?end_date='+end_date+'&start_date='+start_date);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + accessToken);

        HttpResponse response = http.send(request);
        while(response.getStatusCode() == 302) {
            request.setEndpoint(response.getHeader('Location'));
            response = new Http().send(request);
        }
        //If Request is Successful, parse the response JSON
        System.debug('::: Response Body = '+response.getBody());
        //System.debug('::: Header Key = '+response.getHeaderKeys());
        System.debug('::: Header Key = '+response.getHeader('Link'));
        String headerKeys = response.getHeader('Link');
        String[] hks = headerKeys.split(',');
        String lastUrl = hks[0].split(';')[0];
        System.debug('::: Last URL = '+lastUrl);
        String s2 = lastUrl.substringAfter('page=').substringBefore('&');
        Integer totalPage = Integer.valueOf(s2);
        System.debug('::: Total Page  = '+totalPage);
        
        appointmentList = AppointmentJSONResponse.parse(response.getBody());
        for(Integer i=1; i<totalPage; i++) {
            Integer currentPage = i+1;
            Http http1 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setTimeout(120000);
            request1.setEndpoint('https://api.carecloud.com/v2/appointments?end_date='+end_date+'&page='+currentPage+'&start_date='+start_date);
            request1.setMethod('GET');
            request1.setHeader('Authorization', 'Bearer ' + accessToken);
            
            HttpResponse response1 = http1.send(request1);
            while(response1.getStatusCode() == 302) {
                request1.setEndpoint(response1.getHeader('Location'));
                response1 = new Http().send(request1);
            }
            
            appointmentList.addAll(AppointmentJSONResponse.parse(response1.getBody()));
        }
        System.debug('::: appointmentList = '+appointmentList.size());
        for(AppointmentJSONResponse appointment : appointmentList) {
            appointIdMap.put(appointment.Appointment.id, appointment);
            if (String.isBlank(appointment.Appointment.patient.id)) {
                noPatientAppointmentId.add(appointment.Appointment.id);
            }
        }

        System.debug('::: Start method begins');
        ExternalIDs.addAll(appointIdMap.keySet()); 
        System.debug('::: ExternalIDs Size = '+ExternalIDs.size());
        query = 'SELECT Id, Care_Cloud_Appointment_Id__c FROM Appointment__c where Care_Cloud_Appointment_Id__c IN: ExternalIDs';
        System.debug('::: Query Result = '+Database.query(query));
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Appointment__c> scope){
        system.debug('::: Inside the Execute statement');
        System.debug('::: appointmentList in execute = '+appointmentList);
        //List<AppointmentJSONResponse> appointmentList = AppointmentJSONResponse.parse(response.getBody());
        System.debug('::: Scope Size = '+scope.size());
        for(Appointment__c appointment : scope)
        {
            Appointment__c appRecord = new Appointment__c();
            if(appointIdMap.containsKey(appointment.Care_Cloud_Appointment_Id__c)) { 
                AppointmentJSONResponse  appointmentRec =   appointIdMap.get(appointment.Care_Cloud_Appointment_Id__c);             
                appRecord.Id = appointment.Id;
                appRecord.Care_Cloud_Appointment_Id__c  = appointmentRec.Appointment.id;
                appRecord.Status__c = appointmentRec.Appointment.appointment_status.Name;
                appRecord.Patient_Chart_Number__c = appointmentRec.Appointment.patient.chart_number;
                appRecord.Location_Id__c = String.valueOf(appointmentRec.Appointment.location.id);
                appRecord.Cancellation_Details_Id__c = appointmentRec.Appointment.cancellation_details.id;
                appRecord.Care_Cloud_Comments__c = appointmentRec.Appointment.comments;
                appRecord.Referring_Physician_NPI__c = appointmentRec.Appointment.referring_physician_npi;
                appRecord.Visit_Reason_Id__c  = String.valueOf(appointmentRec.Appointment.visit_reason_id);
                appRecord.Care_Cloud_Patient_Id__c = appointmentRec.Appointment.patient.id;
                String start_time = appointmentRec.Appointment.start_time;
                DateTime dt = DateTime.ValueofGmt(start_time.replace('T', ' '));
                appRecord.Appointment_Date_Time__c  = dt.addHours(4);
                appRecord.Provider_Id__c = appointmentRec.Appointment.provider_id;
                appointExistIdList.add(appointmentRec.Appointment.id);
                appointmentList2Upsert.add(appRecord);
            } 
        }
		System.debug('::: AppointmentList2Upsert in execute = '+appointmentList2Upsert.size());
    }

    global void finish(Database.BatchableContext BC){
        
        System.debug('::: Inside the Finish statement');
        for(AppointmentJSONResponse appointment : appointmentList) {    
            if(!appointExistIdList.contains(appointment.Appointment.id)) {
                Appointment__c appRecord = new Appointment__c();
                appRecord.Care_Cloud_Appointment_Id__c  = appointment.Appointment.id;
                appRecord.Status__c = appointment.Appointment.appointment_status.Name;
                appRecord.Patient_Chart_Number__c = appointment.Appointment.patient.chart_number;
                appRecord.Location_Id__c = String.valueOf(appointment.Appointment.location.id);
                appRecord.Cancellation_Details_Id__c = appointment.Appointment.cancellation_details.id;
                appRecord.Care_Cloud_Comments__c = appointment.Appointment.comments;
                appRecord.Referring_Physician_NPI__c = appointment.Appointment.referring_physician_npi;
                appRecord.Visit_Reason_Id__c  = String.valueOf(appointment.Appointment.visit_reason_id);
                appRecord.Care_Cloud_Patient_Id__c = appointment.Appointment.patient.id;
                String start_time = appointment.Appointment.start_time;
                DateTime dt = DateTime.ValueofGmt(start_time.replace('T', ' '));
                appRecord.Appointment_Date_Time__c  = dt.addHours(4);
                appRecord.Provider_Id__c = appointment.Appointment.provider_id;
                appointmentList2Upsert.add(appRecord);  
            }                      
        }
        System.debug('::: AppointmentList2Upsert in finish = '+appointmentList2Upsert.size());   
        
        if(appointmentList2Upsert.size()>0) { 
            upsert appointmentList2Upsert;
        }
        
        // create log for appointments with no patient Id
        if (noPatientAppointmentId.size() > 0) {
            TransactionLogHandler.doHandleCustomException(
            	'No patient id found for few Appointments',
                String.join(new List<String>(noPatientAppointmentId), ','),
                'AppointmentSyncBatchCalloutDelta',
                'finish'
            );
        }
    }
}