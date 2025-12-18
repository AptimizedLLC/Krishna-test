/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-29-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class SnowflakeIntegrationTest {
    
    @IsTest
    static void testExecuteSnowflakeQuerySuccess() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"data": [["customer1", "1234 A Avenue","Test","Test2"], ["customer2", "987 B Street","Test","Test3"]]}');
        
        Test.setMock(HttpCalloutMock.class, new SnowflakeIntegrationMock(mockResponse));
        
        Test.startTest();
        Map<String, Object> result = SnowflakeIntegration.executeSnowflakeQuery(
            'SELECT ' +
    'P.PATIENT_GUID, ' + 'C.PROVIDER_ID,' +
    'SUM(C.UNITS) AS TOTAL_UNITS, ' +
    'LISTAGG( ' +
        'CONCAT(C.PROCEDURE_CODE, \'-\', C.PROCEDURE_DESCRIPTION, \'-\', C.UNITS), ' +
        '\' Units ;\' ' +
    ') WITHIN GROUP (ORDER BY C.PROCEDURE_CODE) || \' Units\' AS PROCEDURE_DETAILS ' +
    'FROM CARECLOUD_ODS.SHARE.CHARGES C ' +
    'INNER JOIN CARECLOUD_ODS.SHARE.PATIENTS P ' +
    'ON P.PATIENT_ID = C.PATIENT_ID ' 
    
        );
        Test.stopTest();
    }
    
    @IsTest
    static void testExecuteSnowflakeQueryAsync() {
        HttpResponse mockAsyncResponse = new HttpResponse();
        mockAsyncResponse.setHeader('Content-Type', 'application/json');
        mockAsyncResponse.setStatusCode(200);
        mockAsyncResponse.setBody(
            '{"data": [["customer1", "1234 A Avenue","Test","Test1"], ["customer2", "987 B Street","Test","Test2"]]}'
        );

        Test.setMock(HttpCalloutMock.class, new SnowflakeIntegrationMock(mockAsyncResponse));

        Test.startTest();
        Map<String, Object> result = SnowflakeIntegration.executeSnowflakeQuery(
           'SELECT ' +
    'P.PATIENT_GUID, ' + 'C.PROVIDER_ID,' +
    'SUM(C.UNITS) AS TOTAL_UNITS, ' +
    'LISTAGG( ' +
        'CONCAT(C.PROCEDURE_CODE, \'-\', C.PROCEDURE_DESCRIPTION, \'-\', C.UNITS), ' +
        '\' Units ;\' ' +
    ') WITHIN GROUP (ORDER BY C.PROCEDURE_CODE) || \' Units\' AS PROCEDURE_DETAILS ' +
    'FROM CARECLOUD_ODS.SHARE.CHARGES C ' +
    'INNER JOIN CARECLOUD_ODS.SHARE.PATIENTS P ' +
    'ON P.PATIENT_ID = C.PATIENT_ID LIMIT 1 ' 
        );
        Test.stopTest();
    }
    
    @IsTest
    static void testExecuteSnowflakeQueryAsync1() {
        HttpResponse mockAsyncResponse = new HttpResponse();
        mockAsyncResponse.setHeader('Content-Type', 'application/json');
        mockAsyncResponse.setStatusCode(202);
        mockAsyncResponse.setBody(
            '{"statementHandle": "123456", "statementStatusUrl": "/api/v2/statements/123456"}'
        );

        Test.setMock(HttpCalloutMock.class, new SnowflakeIntegrationMock(mockAsyncResponse));

        Test.startTest();
        Map<String, Object> result = SnowflakeIntegration.executeSnowflakeQuery(
            'SELECT P.PATIENT_GUID, C.PROVIDER_ID, SUM(C.UNITS) AS TOTAL_UNITS, ' +
            'LISTAGG(CONCAT(C.PROCEDURE_CODE, \'-\', C.PROCEDURE_DESCRIPTION, \'-\', C.UNITS), ' +
            '\' Units ;\') WITHIN GROUP (ORDER BY C.PROCEDURE_CODE) || \' Units\' AS PROCEDURE_DETAILS ' +
            'FROM CARECLOUD_ODS.SHARE.CHARGES C ' +
            'INNER JOIN CARECLOUD_ODS.SHARE.PATIENTS P ON P.PATIENT_ID = C.PATIENT_ID LIMIT 1'
        );
        Test.stopTest();
    }

    private class SnowflakeIntegrationMock implements HttpCalloutMock {
        private HttpResponse response;

        public SnowflakeIntegrationMock(HttpResponse response) {
            this.response = response;
        }

        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}