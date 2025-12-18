public class AppointmentClass {
 public String startDate { get; set; }
    public String endDate { get; set; }
    public String pageNo { get; set; }
    public String StringccId { get; set; }
    public List<AppointmentJSONResponse> appointments { get; set; }
    public List<AppointmentJSONResponse> responseList { get; set; }

    public AppointmentClass() {
        // Default values (last 2 days)
        startDate = String.valueOf(Date.today().addDays(-9));
        endDate = String.valueOf(Date.today().addDays(-8));
        pageNo = '1';
        appointments = new List<AppointmentJSONResponse>();
        responseList=new  List<AppointmentJSONResponse>();
    }

    public void fetchAppointments() {
        appointments.clear();
        String END_POINT = 'https://api.carecloud.com';

        try {
            Carecloud_Setup__mdt careCloudMdt = [
                SELECT MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1
            ];
            String accessToken = careCloudMdt != null ? 
                CareCloudAuthConnection.fetchRefreshAccessToken(careCloudMdt.Refresh_Token__c) : null;

            HttpResponse apptResp = CalloutUtility.doCallout(
                END_POINT + '/v2/appointments?end_date=' + endDate +
                '&start_date=' + startDate + '&page=' + pageNo,
                'GET',
                new Map<String, String>{ 'Authorization' => 'Bearer ' + accessToken },
                '',
                20000
            );

            responseList = AppointmentJSONResponse.parse(apptResp.getBody());
			system.debug('**responseList**'+responseList);
            for (AppointmentJSONResponse resp : responseList) {
                if (resp != null && resp.appointment != null) {
                    //appointments.add(resp);
                }
                if(resp.appointment.id == StringccId){
                    appointments.add(resp);
                    
                }                
                
            }
            //-------------------------
            //
 
            List<Appointment__c> appts = new List<Appointment__c>();
Map<String, CareCloud_Information__c> providerMap = new Map<String, CareCloud_Information__c>();
Map<String, CareCloud_Information__c> locationMap = new Map<String, CareCloud_Information__c>();
Map<String, CareCloud_Information__c> visitReasonMap = new Map<String, CareCloud_Information__c>();
Set<String> ccPatientIds = new Set<String>();
List<String> noPatientAppointmentId = new List<String>();

// Replace with actual response or mock response for testing
List<AppointmentJSONResponse> respAppointments = new List<AppointmentJSONResponse>();

// Populate metadata maps
for(CareCloud_Information__c ccInfo : [
    SELECT Id, Name, CareCloud_Id__c, RecordType.Name, Email__c, Business_ID__c, Specialty__c, User_Record__c 
    FROM CareCloud_Information__c
]){
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

// Collect patient ids
for(AppointmentJSONResponse appointment : appointments) {
    if (String.isBlank(appointment.Appointment.patient.id)) {
        noPatientAppointmentId.add(appointment.Appointment.id);
    } else {
        ccPatientIds.add(appointment.Appointment.patient.id);
    }
}

Map<String, Account> patientIdToAccountMap = new Map<String, Account>();

if(!ccPatientIds.isEmpty()){
    for(Account acc : [
        SELECT Id, Name, CareCloud_Patient_Id__c 
        FROM Account 
        WHERE CareCloud_Patient_Id__c IN :ccPatientIds
    ]){
        patientIdToAccountMap.put(acc.CareCloud_Patient_Id__c, acc);
    }
}

// Create Appointment records
for(AppointmentJSONResponse appointment : appointments){
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
    DateTime dt = DateTime.valueOfGmt(start_time.replace('T', ' '));
    Integer timezoneDiff = Integer.valueOf(appointment.Appointment.start_time.split('-')[appointment.Appointment.start_time.split('-').size() - 1].split(':')[0]);
    appRecord.Appointment_Date_Time__c  = dt.addHours(timezoneDiff);
    appRecord.Provider_Id__c = appointment.Appointment.provider_id;

    if(String.isNotBlank(appRecord.Location_Id__c) && locationMap.containsKey(appRecord.Location_Id__c)){
        appRecord.Location_Email__c = locationMap.get(appRecord.Location_Id__c).Email__c;
        appRecord.Location_Name__c = locationMap.get(appRecord.Location_Id__c).Name;
    }
    if(String.isNotBlank(appRecord.Provider_Id__c) && providerMap.containsKey(appRecord.Provider_Id__c)){
        appRecord.Provider_Name__c = providerMap.get(appRecord.Provider_Id__c).Name;
        appRecord.Provider_Reviews_Business_ID__c = providerMap.get(appRecord.Provider_Id__c).Business_ID__c;
        appRecord.Provider_Specialty__c = providerMap.get(appRecord.Provider_Id__c).Specialty__c;
        if(String.isNotBlank(providerMap.get(appRecord.Provider_Id__c).User_Record__c)){
            appRecord.OwnerId = providerMap.get(appRecord.Provider_Id__c).User_Record__c;
        }
    }
    appRecord.Visit_Reason__c = String.isNotBlank(appRecord.Visit_Reason_Id__c) && visitReasonMap.containsKey(appRecord.Visit_Reason_Id__c) 
        ? visitReasonMap.get(appRecord.Visit_Reason_Id__c).Name : null;

    if(String.isNotBlank(appointment.Appointment?.patient?.id) && patientIdToAccountMap.containsKey(appointment.Appointment.patient.id)){
        appRecord.Patient__c = patientIdToAccountMap.get(appointment.Appointment.patient.id).Id;
        appRecord.Name = patientIdToAccountMap.get(appointment.Appointment.patient.id).Name + ' - ' + appRecord.Visit_Reason__c;
    }

    appts.add(appRecord);
}

// Optional: insert records if needed
 insert appts;
System.debug('Prepared ' + appts.size() + ' Appointment__c records.');

            //--------------------------
            
            
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
    }
}