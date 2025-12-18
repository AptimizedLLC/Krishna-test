public with sharing class CareCloudPatientService {
    @InvocableMethod( label='Fetch Patient Chartnumber' description='Fetch Patient Details from CareCloud' category='Callout' )
    public static void getPatient(List<Id> accIds) {
        getPatientDetailsFromCareCloud(accIds[0]);        
    }

    //@future( callout=true )
    public static void getPatientDetailsFromCareCloud(Id accId) { 
        List<Account> patients2Update = new List<Account>();
        List<PatientJSONResponse> patientList = new List<PatientJSONResponse>();

        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);
        String patientId;
        //Get the Patient Id
        Account accRec = [SELECT Id, CareCloud_Patient_Id__c, Chart_Number__c FROM Account where Id=: accId LIMIT 1];
        if(accRec!=null) patientId = accRec.CareCloud_Patient_Id__c;    
        
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setTimeout(120000);
            request.setEndpoint('https://api.carecloud.com/v2/patients/'+patientId);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            HttpResponse response = http.send(request);
            //If Request is Successful, parse the response JSON
            System.debug('::: Response Body = '+response.getBody());
            
            PatientJSONResponse patientResponse = PatientJSONResponse.parse(response.getBody());
            System.debug('::: Patient Response = '+patientResponse.Patient.chart_number);
            
            if(patientResponse.Patient.chart_number != null) {
                accRec.Chart_Number__c = patientResponse.Patient.chart_number;
                update accRec;
            }
        } catch(Exception ex) {
            System.debug('::: Exception = '+ex.getMessage());
        }            
    }
    
}