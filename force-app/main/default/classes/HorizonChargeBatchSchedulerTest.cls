@isTest
public class HorizonChargeBatchSchedulerTest 
{ 
    @testSetup
    static void setupData() 
    {
        // Insert minimal required test data
        List<Hz_Horizon_Charges__c> charges = new List<Hz_Horizon_Charges__c>();
        for (Integer i = 0; i < 5; i++) {
            charges.add(new Hz_Horizon_Charges__c(
               // Hz_Patient_Account__c = '001000000000001AAA', // fake Id for testing
                Hz_DOS__c = Date.today(),
                Hz_Insurance_Plan__c = null,
                Hz_Amount__c = 100,
                Hz_Expected_Reimbursement__c = 0
            ));
        }
        insert charges;
    }
    
    @isTest
    static void testSchedulerRunsBatch() {
        Test.startTest();
        
        // Schedule the batch via the scheduler
        String cronExp = '0 0 * * * ?'; // run once at a known time (Sep 15, 2025 midnight)
        System.schedule('Test HorizonChargeBatch Job', cronExp, new HorizonChargeBatchScheduler());
        
        Test.stopTest(); // Executes the scheduled job & batch
        
        // Assert that AsyncApexJob got created
        List<AsyncApexJob> jobs = [
            SELECT Id, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex' OR JobType = 'ScheduledApex'
        ];
        
        System.assert(!jobs.isEmpty(), 'Expected at least one scheduled/batch job to run.');
    }
}