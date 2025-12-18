public with sharing class CareCloudAppointmentService {
    @InvocableMethod( label='Fetch Appointment Details' description='Fetch Appointment Details from CareCloud' category='Callout' )
    public static void getAppointment(List<InvocableParameters> requests) {
        System.debug('::: requests - '+requests);
        List<InvocableParameters> params = requests;
        Id accId = params[0].accId;
        Id intakeId = params[0].intakeId;
        
        getAppointmentDetailsFromCareCloud(accId, intakeId);        
    }

    @future( callout=true )
    public static void getAppointmentDetailsFromCareCloud(Id accId, Id intakeId) {
        try {
        List<Appointment__c> appointmentList2Insert  = new List<Appointment__c>();
        List<AppointmentJSONResponse> appointmentList = new List<AppointmentJSONResponse>();

        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);
        String patientId;
        
        String start_date = String.valueOf(Date.today()).removeEnd(' 00:00:00');
        String end_date = String.valueOf(Date.today().addDays(90)).removeEnd(' 00:00:00');
        
        //Get the Patient Id
        Account accRec = [SELECT Id, CareCloud_Patient_Id__c FROM Account where Id=: accId LIMIT 1];
        if(accRec!=null) patientId = accRec.CareCloud_Patient_Id__c;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(120000);
        //request.setEndpoint('https://api.carecloud.com/v2/appointments?patient_ids='+patientId);
        request.setEndpoint('https://api.carecloud.com/v2/appointments?start_date='+start_date+'&end_date='+end_date+'&patient_ids='+patientId);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + accessToken);

        HttpResponse response = http.send(request);
        while(response.getStatusCode() == 302) {
            request.setEndpoint(response.getHeader('Location'));
            response = new Http().send(request);
        }
        //If Request is Successful, parse the response JSON
        System.debug('::: Response Body = '+response.getBody());
        
        appointmentList = AppointmentJSONResponse.parse(response.getBody());
        
        System.debug('::: appointmentList = '+appointmentList.size());
		Set<String> noPatientAppointmentId = new Set<String>();
        for(AppointmentJSONResponse appointment : appointmentList) {   
            Appointment__c appRecord = new Appointment__c();
            appRecord.Care_Cloud_Appointment_Id__c  = appointment.Appointment.id;
            appRecord.Status__c = appointment.Appointment.appointment_status.Name;
            appRecord.Patient_Chart_Number__c = appointment.Appointment.patient.chart_number;
            appRecord.Location_Id__c = String.valueOf(appointment.Appointment.location.id);
            appRecord.Cancellation_Details_Id__c = appointment.Appointment.cancellation_details.id;
            appRecord.Care_Cloud_Comments__c = appointment.Appointment.comments;
            appRecord.Referring_Physician_NPI__c = appointment.Appointment.referring_physician_npi;
            appRecord.Visit_Reason_Id__c  = String.valueOf(appointment.Appointment.visit_reason_id);
            appRecord.Patient__c = accRec.Id;
            appRecord.Intake__c = intakeId;
            appRecord.Care_Cloud_Patient_Id__c = appointment.Appointment.patient.id;
            String start_time = appointment.Appointment.start_time;
            DateTime dt = DateTime.ValueofGmt(start_time.replace('T', ' '));
            Integer timezoneDiff = Integer.valueOf(appointment.Appointment.start_time.split('-')[appointment.Appointment.start_time.split('-').size() - 1].split(':')[0]);
            appRecord.Appointment_Date_Time__c  = dt.addHours(timezoneDiff);
            appRecord.Provider_Id__c = appointment.Appointment.provider_id;
            
            if (String.isBlank(appointment.Appointment.patient.id)){
                noPatientAppointmentId.add(appointment.Appointment.id);
            }
            
            appointmentList2Insert.add(appRecord);                   
        }
        System.debug('::: appointmentList2Insert = '+appointmentList2Insert);
        if(appointmentList2Insert.size()>0) { 
            upsert appointmentList2Insert;
        }
        if (noPatientAppointmentId.size() > 0) {
            TransactionLogHandler.doHandleCustomException(
            	'No patient id found for few Appointments',
                String.join(new List<String>(noPatientAppointmentId), ','),
                'CareCloudAppointmentService',
                'getAppointmentDetailsFromCareCloud'
            );
        }
        }
        catch(Exception e){
            System.debug('Execetion : ' + e.getMessage());
        }
    }
    
    public class PatientResponse {
        public String patient;
    }

    public class InvocableParameters {
        @InvocableVariable(required = true)
        public Id accId;

        @InvocableVariable(required = true)
        public Id intakeId;
    } 
}