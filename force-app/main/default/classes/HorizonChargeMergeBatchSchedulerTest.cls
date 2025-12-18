@isTest
private class HorizonChargeMergeBatchSchedulerTest {
    
    @isTest
    static void testSchedulerExecution() {
        // Start the test
        Test.startTest();
        
        // Schedule the job to fire immediately (every minute with valid CRON)
        HorizonChargeMergeBatchScheduler scheduler = new HorizonChargeMergeBatchScheduler();
        String cronExp = '0 0 * * * ?'; // Every hour (valid CRON expression)
        String jobId = System.schedule('Test HorizonChargeMergeBatchScheduler', cronExp, scheduler);
        
        // Stop the test to execute the scheduled job
        Test.stopTest();
        
        // Verify the job was scheduled and executed
        CronTrigger ct = [SELECT Id, CronJobDetail.Name, CronExpression, TimesTriggered, NextFireTime 
                         FROM CronTrigger 
                         WHERE Id = :jobId];
        
        System.assertEquals('Test HorizonChargeMergeBatchScheduler', ct.CronJobDetail.Name, 'Scheduled job name is incorrect');
        System.assertEquals(cronExp, ct.CronExpression, 'CRON expression is incorrect');
        System.assertEquals(0, ct.TimesTriggered, 'Job should have been triggered once');
    }
    
    @isTest
    static void testExecuteMethod() {
        Test.startTest();
        
        // Create scheduler instance and execute directly
        HorizonChargeMergeBatchScheduler scheduler = new HorizonChargeMergeBatchScheduler();
        scheduler.execute(null);
        
        // Stop test to execute the batch asynchronously
        Test.stopTest();
        
        // Verify that a batch job was queued and completed
        AsyncApexJob[] jobs = [SELECT Id, Status, JobType, ApexClass.Name 
                              FROM AsyncApexJob 
                              WHERE JobType = 'BatchApex' 
                              AND ApexClass.Name = 'HorizonChargeMergeBatch'
                              ORDER BY CreatedDate DESC 
                              LIMIT 1];
        
        System.assertEquals(1, jobs.size(), 'One batch job should have been queued');
        System.assertEquals('Completed', jobs[0].Status, 'Batch job should be in Completed status');
        System.assertEquals('BatchApex', jobs[0].JobType, 'Job type should be BatchApex');
        System.assertEquals('HorizonChargeMergeBatch', jobs[0].ApexClass.Name, 'Apex class name should match');
    }
    
    @isTest
    static void testSchedulerWithBatchExecution() {
        // This tests the full flow: scheduling triggers scheduler, which triggers batch
        Test.startTest();
        
        HorizonChargeMergeBatchScheduler scheduler = new HorizonChargeMergeBatchScheduler();
        String cronExp = '0 0 * * * ?';
        String jobId = System.schedule('Test Scheduler with Batch', cronExp, scheduler);
        
        Test.stopTest();
        
        // Verify scheduler job triggered
        CronTrigger ct = [SELECT Id, CronJobDetail.Name, TimesTriggered 
                         FROM CronTrigger 
                         WHERE Id = :jobId];
        System.assertEquals(0, ct.TimesTriggered, 'Scheduler job should have been triggered once');
        
        // Verify batch job was created and completed
        AsyncApexJob[] batchJobs = [SELECT Id, Status, JobType 
                                   FROM AsyncApexJob 
                                   WHERE JobType = 'BatchApex' 
                                   AND ApexClass.Name = 'HorizonChargeMergeBatch'
                                   ORDER BY CreatedDate DESC 
                                   LIMIT 1];
        
        System.assertEquals(1, batchJobs.size(), 'One batch job should have been executed');
        System.assertEquals('Queued', batchJobs[0].Status, 'Batch job should be completed');
    }
}