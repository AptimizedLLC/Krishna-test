public class PatientChargeSyncBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {

    private String cAccessToken;
    private static List<CareCloud_Charge__c> UncommittedCharges = new List<CareCloud_Charge__c>();
    private Integer retriedConnection = 0;
    private static final Integer MAX_AUTH_RETRY = 3;
    private static final String CHARGE_ENDPOINT = 'https://api.carecloud.com/v2/patients/{0}/charges?start_date={1}&end_date={2}';
    private List<String> errorMessages = new List<String>();

    public class CareCloudConnectionException extends Exception{}
        
    private void refreshAccessToken() {
		Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
    	String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        if (String.isBlank(accessToken)){
            throw new CareCloudConnectionException('Care cloud: Error refreshing access token');
        }
        this.cAccessToken = accessToken;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        this.refreshAccessToken();
        return Database.getQueryLocator([
            SELECT Id, CareCloud_Patient_Id__c FROM Account where CareCloud_Patient_Id__c != null
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> patients) {
        try{
                if (patients.size() == 0) {
                    return;
                }
                
                UncommittedCharges = new List<CareCloud_Charge__c>();
                
                for (Account patient: patients) {
                    this.fetchAndCreateCharges(patient.Id, patient.CareCloud_Patient_Id__c, null);
                }
                
                system.debug(UncommittedCharges.size());
                
                if (UncommittedCharges.size() > 0) {
                    PatientChargeDAO.commitCharges(UncommittedCharges);
                }
        }
        catch(Exception e)
        {
            collectError(null,e);
        }
    }
    
    private void fetchAndCreateCharges(String accountId, String patientId, String next) {
        try{
     	String endpoint = this.constructEndpoint(patientId);
        
        if (next != null) {
            endpoint = next;
        }
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setHeader('Authorization','Bearer ' + this.cAccessToken);
        httpReq.setHeader('accept','application/json');
		httpReq.setMethod('GET');
        httpReq.setEndpoint(endpoint);   
        Http http = new Http();
        HttpResponse res = http.send(httpReq);
        
        if(res.getStatusCode() == 404){
            return;
        }
        
		// make call
        this.handleResponse(accountId, patientId, res);
        }
        catch(Exception e)
        {
            collectError(accountId,e);
        }
        
    }
    
    private void handleResponse(String accountId, String patientId, HttpResponse responseObj) {
        if (responseObj.getStatusCode() == 401) {
            if (this.retriedConnection >= MAX_AUTH_RETRY) {
                throw new CareCloudConnectionException('Error authorizing to care cloud. Cannot fetch charges for patient: ' + patientId);
            }
            this.refreshAccessToken();
            this.retriedConnection++;
            this.fetchAndCreateCharges(accountId, patientId, null);
        } else if (responseObj.getStatusCode() == 429) {
            throw new CareCloudConnectionException('Error fetching response. Reached Rate Limit.');
        }
        this.retriedConnection = 0;
        String strCharge = responseObj.getBody();
		List<Object> charges = (List<Object>) JSON.deserializeUntyped(strCharge);
        // create charges
        if (charges.size() > 0) {
            List<CareCloud_Charge__c> chargesUncommitted = PatientChargeDAO.createCharges(accountId, charges);
            UncommittedCharges.addAll(chargesUncommitted);
        }
        // handle pagination
        if (responseObj.getHeader('Link') != null) {
            Map<String, String> links = this.parseLinkHeader(responseObj.getHeader('Link'));
            if (links.get('next') != null) {
                this.fetchAndCreateCharges(accountId, patientId, links.get('next'));
            }
        }
    }
    
    private String constructEndpoint(String patientId) {
        CCPaymentAndChargeSyncSetting__mdt setting = PatientChargeDAO.getSyncSetting();
        Datetime startDate, endDate;
        if (setting != null && setting.Is_Active__c == true) {
         	startDate = setting.Start_Date__c;
            endDate = setting.End_Date__c;
        }
        
        if (startDate == null) {
			startDate = Datetime.now() - 1;           
        }
        
        if (endDate == null) {
            endDate = Datetime.now();
        }
        
        return String.format(
            CHARGE_ENDPOINT, 
            new List<String>{patientId, startDate.format('yyyy-MM-dd'), endDate.format('yyyy-MM-dd')}
       	);
    }
    
    private Map<String, String> parseLinkHeader(String header) {
    	if (header == null) {
        	return new Map<String, String>();
        }
        // Split parts by comma
        List<String> parts = header.split(',');
        Map<String, String> links = new Map<String, String>();
        // Parse each part into a named link
        for (String p: parts) {
            List<String> section = p.split(';');
            if (section.size() != 2) {
                throw new CareCloudConnectionException('Error parsing link header');
            }
            String url = section[0].replace('<', '').replace('>', '');
            String name = section[1].replace('rel="', '').replace('"', '');
            links.put(name, url);
        }
    
        return links;
	}
    
    public void finish(Database.BatchableContext bc) {}


    // --------------------------
    // ERROR HANDLER
    // --------------------------
    private void collectError(Id recordId, Exception e) {

        System.debug('ERROR for record ' + recordId + ' => ' + e.getMessage());

        // Collect for batch email
        errorMessages.add(
            'Record Id: ' + (recordId == null ? 'N/A' : recordId) +
            '\nError: ' + e.getMessage() +
            '\nStack:\n' + e.getStackTraceString()
        );

        // Centralized Transaction Log Handler
        try {
            TransactionLogHandler.doHandleCustomException(
                e,
                'Appointment Record: ' + String.valueOf(recordId),
                'PatientChargeSyncBatch',
                'collectError'
            );
        }
        catch (Exception logEx) {
            System.debug('Failed to log Transaction_Log__c: ' + logEx.getMessage());
        }
    }

}