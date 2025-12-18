global class AppointmentSyncBatchCallout implements Database.Batchable<String>, Database.AllowsCallouts, Database.Stateful {
    private Set<String> noPatientAppointmentId = new Set<String>();
    
    Map<String, CareCloud_Information__c> providerMap = new Map<String, CareCloud_Information__c>();
    Map<String, CareCloud_Information__c> locationMap = new Map<String, CareCloud_Information__c>();
    Map<String, CareCloud_Information__c> visitReasonMap = new Map<String, CareCloud_Information__c>();
    
    String query;
    String start_date;
    String end_date;
    
    global AppointmentSyncBatchCallout(){
        this.start_date = String.valueOf(Date.today().addDays(-10)).removeEnd(' 00:00:00');
        this.end_date = String.valueOf(Date.today().addDays(10)).removeEnd(' 00:00:00');
    }
    
    global AppointmentSyncBatchCallout(Integer startOffset, Integer endOffset){        
        this.start_date = String.valueOf(Date.today().addDays(startOffset)).removeEnd(' 00:00:00');
        this.end_date = String.valueOf(Date.today().addDays(endOffset)).removeEnd(' 00:00:00');
    }
    
    global Iterable<String> start(Database.BatchableContext BC) {
        for(CareCloud_Information__c ccInfo : [SELECT Id, Name, CareCloud_Id__c, RecordType.Name, Email__c, Business_ID__c, Specialty__c, User_Record__c FROM CareCloud_Information__c]){
            switch on ccInfo.RecordType.Name {
                when 'Provider' {
                    providerMap.put(ccInfo.CareCloud_Id__c.replace('P-', ''), ccInfo);
                }
                when 'Location' {
                    locationMap.put(ccInfo.CareCloud_Id__c.replace('L-', ''), ccInfo);
                }
                when 'Visit Reason' {
                    visitReasonMap.put(ccInfo.CareCloud_Id__c.replace('VR-', ''), ccInfo);
                }
            }
        }
        
        HttpResponse apptResp;
        Integer retryCount = 1;
        do{
            apptResp = CareCloudAPIHelper.fetchApointments(this.start_date, this.end_date, '1');
            retryCount++;
        }while(apptResp.getStatusCode() != 200 && retryCount <= 5);
        
        if(apptResp.getStatusCode() != 200){
            return new List<String>();
        }
        
        String headerKeys = apptResp.getHeader('link');
        
        if(headerKeys == null){
            return new List<String>();
        }
        
        Integer totalPages = CareCloudAPIHelper.getTotalPages(headerKeys);
        
        System.debug('Total pages :'+totalPages);
        
        List<String> iterations = new List<String>();
        for(Integer i = 1; i <= totalPages; i++ ){
            iterations.add(String.valueOf(i));
        }
        
        return iterations;
    }

    global void execute(Database.BatchableContext BC, List<String> scope){
        List<Appointment__c> appts = new List<Appointment__c>();
        
        for(String pageNo : scope){
            System.debug('Current Page Number :'+ pageNo);
            
            HttpResponse apptResp = CareCloudAPIHelper.fetchApointments(this.start_date, this.end_date, pageNo);
            
            if(apptResp.getStatusCode() != 200){
                continue;
            }
            
            Set<String> ccPatientIds = new Set<String>();
            List<AppointmentJSONResponse> respAppointments = AppointmentJSONResponse.parse(apptResp.getBody());
            
            System.debug('Number of appointments :'+ respAppointments.size());
            
            for(AppointmentJSONResponse appointment : respAppointments) {
                if (String.isBlank(appointment.Appointment.patient.id)) {
                    noPatientAppointmentId.add(appointment.Appointment.id);
                }else{
                    ccPatientIds.add(appointment.Appointment.patient.id);
                }
            }
            
            Map<String, Account> patientIdToAccountMap = new Map<String, Account>();
            
            if(!ccPatientIds.isEmpty()){
                for(Account acc : [SELECT Id,Name,CareCloud_Patient_Id__c FROM Account WHERE CareCloud_Patient_Id__c in: ccPatientIds]){
                    patientIdToAccountMap.put(acc.CareCloud_Patient_Id__c, acc);
                }
            }
            
            for(AppointmentJSONResponse appointment : respAppointments){
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
                Integer timezoneDiff = Integer.valueOf(appointment.Appointment.start_time.split('-')[appointment.Appointment.start_time.split('-').size() - 1].split(':')[0]);
                appRecord.Appointment_Date_Time__c  = dt.addHours(timezoneDiff);
                appRecord.Provider_Id__c = appointment.Appointment.provider_id;
                //Populate UI fields based on metadata values
                if(String.isNotBlank(appRecord.Location_Id__c) && locationMap.containsKey(appRecord.Location_Id__c)){
                    appRecord.Location_Email__c = locationMap.get(appRecord.Location_Id__c).Email__c;
                    appRecord.Location_Name__c = locationMap.get(appRecord.Location_Id__c).Name;
                }
                if(String.isNotBlank(appRecord.Provider_Id__c) && providerMap.containsKey(appRecord.Provider_Id__c)){
                    appRecord.Provider_Name__c = providerMap.get(appRecord.Provider_Id__c).name;
                    appRecord.Provider_Reviews_Business_ID__c = providerMap.get(appRecord.Provider_Id__c).Business_ID__c;
                    appRecord.Provider_Specialty__c = providerMap.get(appRecord.Provider_Id__c).Specialty__c;
                    if(String.isNotBlank(providerMap.get(appRecord.Provider_Id__c).User_Record__c)){
                        appRecord.OwnerId = providerMap.get(appRecord.Provider_Id__c).User_Record__c;
                    }
                }
                appRecord.Visit_Reason__c = String.isNotBlank(appRecord.Visit_Reason_Id__c) && visitReasonMap.containsKey(appRecord.Visit_Reason_Id__c) ? visitReasonMap.get(appRecord.Visit_Reason_Id__c).name : null;
                
                if(String.isNotBlank(appointment.Appointment?.patient?.id) && patientIdToAccountMap.containsKey(appointment.Appointment.patient.id)){
                    appRecord.Patient__c = patientIdToAccountMap.get(appointment.Appointment.patient.id).Id;
                    appRecord.Name = patientIdToAccountMap.get(appointment.Appointment.patient.id).Name + ' - '+appRecord.Visit_Reason__c;
                }
                appts.add(appRecord);
            }
        }
        
        List<Database.upsertResult> apptsUpsertResults = Database.upsert(appts, Appointment__c.Fields.Care_Cloud_Appointment_Id__c, false);
        
        for(Database.upsertResult result : apptsUpsertResults) {
            if(!result.isSuccess()){
                for(Database.Error error : result.getErrors()) {
                    System.debug(error.getMessage());
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC){
        if(!noPatientAppointmentId.isEmpty()) {
            TransactionLogHandler.doHandleCustomException(
            	'No patient id found for few Appointments',
                String.join(new List<String>(noPatientAppointmentId), ','),
                'AppointmentSyncBatchCallout',
                'finish'
            );
        }
    }
}