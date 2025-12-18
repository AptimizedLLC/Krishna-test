@isTest
private class ScheduleDenialOwnerReassignmentTest {

    @isTest
    static void testScheduleDenialOwnerReassignment() {
        // STEP 1: Insert test records required by DenialOwnerReassignmentBatchclass
        List<dn_Denial__c> testDenials = new List<dn_Denial__c>();
        for (Integer i = 0; i < 5; i++) {
            testDenials.add(new dn_Denial__c(
            dn_Adjustment_Code_1__c = '200',
            dn_PROVIDER_GROUPING__c = 'MD',
            dn_DOS__c = Date.today(),
            dn_PROVIDER__c = 'TestProvider'
            ));
        }
        insert testDenials;

        // STEP 2: Schedule the job
        ScheduleDenialOwnerReassignment scheduler = new ScheduleDenialOwnerReassignment();
        String jobName = 'Test_DenialOwner_Scheduler';
        String cronExp = '0 0 0 1 1 ? 2026'; // Jan 1, 2026 at midnight

        Test.startTest();
        String jobId = System.schedule(jobName, cronExp, scheduler);
        Test.stopTest();

        // STEP 3: Assert job was scheduled
        System.assertNotEquals(null, jobId, 'Scheduled job ID should not be null');

        // Optional: Validate that the records were updated, if your batch logic modifies them
        // You can query and assert on the records if needed
    }
}