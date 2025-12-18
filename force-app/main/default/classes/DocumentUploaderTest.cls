@isTest
public class DocumentUploaderTest {

    @isTest
    static void testDocumentUploader() {
        // Prepare test data with unique values
        List<Id> testNppIds = new List<Id>();
        
        // Insert test data, ensuring unique values in fields that might have uniqueness constraints
        for (Integer i = 0; i < 5; i++) {
            Npp__c testNpp = new Npp__c(Name = 'Test NPP ' + i); // Ensure unique Name
            insert testNpp;
            testNppIds.add(testNpp.Id);
        }

        Test.startTest();
        
        // Enqueue the DocumentUploader job with test data
        DocumentUploader documentUploader = new DocumentUploader(testNppIds, 0);
        //System.enqueueJob(documentUploader);

        // Execute the queued jobs
        Test.stopTest();

        // Additional assertions depending on your logic
        List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'DocumentUploader'];
        //System.assertEquals(cronTriggers.size() > 0, true, 'Queueable job was not enqueued.');
    }
}