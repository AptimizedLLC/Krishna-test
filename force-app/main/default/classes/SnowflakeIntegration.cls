/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-30-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class SnowflakeIntegration
{    
    private static final String NAMED_CREDENTIAL = 'SnowFlake_Named_Credentials';
    
    public static Map<String, List<SnowFlakeResponse>> executeSnowflakeQuery(String sqlQuery) 
    {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res;
        
        try 
        {            
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept','application/json');
            
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('statement', sqlQuery);
            //requestBody.put('database', 'CARECLOUD_ODS');
            //requestBody.put('schema', 'SHARE');
            //requestBody.put('warehouse', 'PUBLIC_WH');
            //requestBody.put('role', 'SYSADMIN');
            requestBody.put('database', System.label.Flowsheet_SnwFlk_Integ_Database);
            requestBody.put('schema', System.label.Flowsheet_SnwFlk_Integ_Schema);
            requestBody.put('warehouse', System.label.Flowsheet_SnwFlk_Integ_WareHouse);
            
            String body = JSON.serialize(requestBody);
            req.setBody(body);
            req.setEndpoint('callout:' + NAMED_CREDENTIAL+'?async=false');
            req.setTimeout(120000);
            
            res = http.send(req);
            System.debug('res: ' + res);
            if (res.getStatusCode() == 200)
            {                
                return parseResponse(res.getBody());
            } 
            else if (res.getStatusCode() == 202)
            {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String statementHandle = (String) responseMap.get('statementHandle');
                String statementStatusUrl = (String) responseMap.get('statementStatusUrl');
                System.debug('statementStatusUrl: ' + statementStatusUrl);
                String statusUrl =statementStatusUrl.Replace('/api/v2/statements','');
                System.debug('statusUrl: ' + statusUrl);
                System.debug('statementHandle: ' + statementHandle);
                return fetchQueryResultsUsingNamedCredential(statementHandle);
            }
            else 
            {
                System.debug('Error: ' + res.getStatus());
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String errorMessage = (String) responseMap.get('message');
                sendErrorReport(res.getStatus()+'-'+errorMessage);
            }
        }
        catch (Exception e) 
        {
            System.debug('Exception: ' + e.getMessage());
            throw e;
        }
        
        return null;
    }
    
    public static void sendErrorReport(String errorMessage) {
                
        String emailBody = 'Snowflake Batch job encountered the following errors: \n' + errorMessage;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> emailString = System.label.Flowsheet_SnwFlk_Integ_Error_Email.Split(', ');
        String[] toAddresses = emailString;
        mail.setToAddresses(toAddresses);
        mail.setSubject(System.label.Flowsheet_SnwFlk_Integ_Email_Subject);
        mail.setPlainTextBody(emailBody);
        if (!Test.isRunningTest())
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    @TestVisible
    public static Map<String, List<SnowFlakeResponse>> fetchQueryResultsUsingNamedCredential(String statementHandle)
    {
        try 
        {
            Boolean isCompleted = false;
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:'+ NAMED_CREDENTIAL +'/'+ statementHandle);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept','application/json');
            Http http = new Http();
            while (!isCompleted)
            {
                HttpResponse res = http.send(req);
                
                if (res.getStatusCode() == 200) 
                {
                    isCompleted = true;
                    return parseResponse(res.getBody());
                }
                else if(res.getStatusCode() == 202)
                {
                    System.debug('Query still running_res.getStatusCode(): ' + res.getStatusCode());
                    System.debug('Query still running_res.getBody(): ' + res.getBody());
                    if (!Test.isRunningTest())
                    {
                        sleep(30000);
                    }
                    else
                    {
                        isCompleted = true;
                    }
                }
                else 
                {
                    isCompleted = true;
                    System.debug('res.getStatusCode(): ' + res.getStatusCode());
                    System.debug('Error fetching query result: ' + res.getBody());
                }
            }
        } 
        catch (Exception e)
        {
            System.debug('Exception in fetching results: ' + e.getMessage());
        }
        return null;
    }
    
    public static Map<String, List<SnowFlakeResponse>> parseResponse(string responseBody)
    {
        Map<String, List<SnowFlakeResponse>> snFlkResponseMap = new  Map<String, List<SnowFlakeResponse>>();
        List<SnowFlakeResponse> snFlkResponseList = new  List<SnowFlakeResponse>();
        Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.debug('res.getBody(): ' + responseBody);
        if (parsedResponse.containsKey('data')) 
        {
            List<Object> dataList = (List<Object>) parsedResponse.get('data');
            
            for (Object rowObj : dataList)
            {
                SnowFlakeResponse snFlkResponse = new SnowFlakeResponse();
                List<Object> row = (List<Object>) rowObj;
                System.debug('patientId: ' + (String)row[0]);
                System.debug('totalUnits: ' + (String)row[2]);
                System.debug('procedureCodeDesc: ' + (String)row[3]);
                System.debug('provider: ' + (String)row[1]);
                System.debug('ChargeId: ' + (String)row[4]);

                
                
                snFlkResponse.patientId = (String)row[0];
                snFlkResponse.totalUnits = (String)row[2];
                snFlkResponse.procedureCodeDesc = (String)row[3];
                snFlkResponse.chargeId = (String)row[4];
                snFlkResponse.PROVIDERID = (String)row[1];
                snFlkResponseList.Add(snFlkResponse);
                snFlkResponseMap.put((String)row[0],snFlkResponseList);
                System.debug('snFlkResponseMap: ' + snFlkResponseMap);
            }
        }
        
        return snFlkResponseMap;
    }
    
    public static void sleep(Long milliSeconds)
    {
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do
        {
            timeDiff = System.now().getTime() - firstTime.getTime();
        }
        while(timeDiff <= milliSeconds);
    }
}