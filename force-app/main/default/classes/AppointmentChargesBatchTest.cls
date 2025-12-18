@IsTest
private class AppointmentChargesBatchTest 
{
    
    @TestSetup
    static void setupData()
    {
        
         List<Account> patients = new List<Account>();
        for (Integer i = 0; i < 3; i++)
        {
            patients.add(new Account(Name = 'Patient' + i, CareCloud_Patient_Id__c = 'GUID' + i));
        }
        insert patients;
        
        List<Appointment__c> appointments = new List<Appointment__c>();
        for (Integer i = 0; i < 5; i++)
        {
            Appointment__c app = new Appointment__c(
                Name = 'Test Appointment ' + i,
                Patient__c = patients[0].Id,
                Appointment_Status__c = 'Approved'
            );
            appointments.add(app);
        }
        insert appointments;
    }
    
    @IsTest
    static void testBatchExecution() 
    {
        Test.startTest();
        
        AppointmentChargesBatch batchInstance = new AppointmentChargesBatch();

        Database.executeBatch(batchInstance, 50);
        
        Test.stopTest();
    }
    
    @TestVisible
    private static Map<String, List<Object>> mockSnowflakeQueryResults()
    {
        Map<String, List<Object>> snowflakeResults = new Map<String, List<Object>>();
        
        for (Integer i = 0; i < 5; i++) 
        {
            List<Object> snowflakeList = new List<Object>();
            
            SnowFlakeResponse response = new SnowFlakeResponse();
            response.patientId='GUID-' + i;
            response.totalUnits='10';
            response.procedureCodeDesc='GUID-' + i;
            
            snowflakeList.add(response);
            snowflakeResults.put('GUID-' + i, snowflakeList);
        }
        
        return snowflakeResults;
    }
    
    @IsTest
    static void testExecuteMethod() 
    {
        Test.startTest();

        AppointmentChargesBatch batchInstance = new AppointmentChargesBatch();
        
        SnowflakeIntegrationMock mock = new SnowflakeIntegrationMock();
        Test.setMock(HttpCalloutMock.class, mock);

        AppointmentChargesBatch batch = new AppointmentChargesBatch();
        Database.executeBatch(batch);

        batchInstance.execute(null, [SELECT Id, Name, Patient__c, Patient__r.CareCloud_Patient_Id__c, Flowsheet_Total_Units__c FROM Appointment__c]);
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendErrorReport() 
    {
        AppointmentChargesBatch instance = new AppointmentChargesBatch();

        instance.errorMessages = new List<String> {
            'Error 1: Something went wrong',
            'Error 2: Another issue occurred'
        };
        
        Test.startTest();
        instance.sendErrorReport();
        Test.stopTest();

    }
    
    public class SnowflakeIntegrationMock implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
			res.setHeader('Content-Type', 'application/json');
            res.setBody('{"data": [["GUID0", "6", "Test-12-3;Test-12-3"], ["GUID2", "5","Test-12-3;Test-12-3"]]}');
            return res;
        }
    }
    
 @isTest
    static void testSchedulableExecution() {
        // Start test context
        Test.startTest();

        // Schedule the AppointmentChargesBatchSchedulable class
        String jobId = System.schedule('Test AppointmentChargesBatch Job', '0 0 12 * * ?', new AppointmentChargesBatchSchedulable());

        // Stop test context
        Test.stopTest();

        // Verify the job is scheduled
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                           FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 12 * * ?', ct.CronExpression, 'Cron expression should match');
        System.assert(ct.NextFireTime != null, 'Next fire time should be set');
    }
}