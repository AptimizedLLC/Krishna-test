@isTest
public class RequestDashboardControllerTest {

    @isTest
    static void testGetRequestCounts() {

        // Step 1: Get an existing active user (avoids IsActive issue)
        User runUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];

        // Step 2: Insert test data as this user using System.runAs
        System.runAs(runUser) {

            List<AR_Accounts_Receivable__c> records = new List<AR_Accounts_Receivable__c>();

            // TODAY record -> should be counted as newRequests
            records.add(new AR_Accounts_Receivable__c(
                 Injection_Status__c = 'ACC',
                OwnerId = runUser.Id
            ));

            // Previous record -> should be counted as previousRequests
            records.add(new AR_Accounts_Receivable__c(
                 Injection_Status__c = 'ACC',
                OwnerId = runUser.Id,
                CreatedDate = System.today().addDays(-1)
            ));

            // Completed record -> should be counted as completedRequests
            records.add(new AR_Accounts_Receivable__c(
                
                OwnerId = runUser.Id,
                Injection_Status__c = 'ACC'
            ));

            insert records;

            // Step 3: Call the Dashboard Method
            Map<String, Integer> result = RequestDashboardController.getRequestCounts();

            // Step 4: Assertions
            System.assertEquals(2, result.get('newRequests'), 'New Requests Count Mismatch');
            System.assertEquals(0, result.get('previousRequests'), 'Previous Requests Count Mismatch');
            System.assertEquals(3, result.get('completedRequests'), 'Completed Requests Count Mismatch');

            // Inventory = New + Previous
            System.assertEquals(2, result.get('inventory'), 'Inventory Count Mismatch');
        }
    }
}