public with sharing class RequestDashboardController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getRequestCounts() {
        Id userId = UserInfo.getUserId();
        Map<String, Integer> counts = new Map<String, Integer>();

        // New Requests: CreatedDate = TODAY, assigned to me
        Integer newRequests = [
            SELECT COUNT() FROM AR_Accounts_Receivable__c 
            WHERE OwnerId = :userId AND CreatedDate = TODAY
        ];

        // Previous Requests: Assigned to me, CreatedDate < TODAY, Injection_Status__c = null
        Integer previousRequests = [
            SELECT COUNT() FROM AR_Accounts_Receivable__c 
            WHERE OwnerId = :userId 
            AND CreatedDate < TODAY 
            AND Injection_Status__c = NULL
        ];

        // Inventory = New + Previous
        Integer inventory = newRequests + previousRequests;

        // Completed Requests: Assigned to me, Injection_Status__c = 'ACC'
        Integer completedRequests = [
            SELECT COUNT() 
         FROM AR_Accounts_Receivable__c 
          WHERE OwnerId = :userId 
              AND (
          Injection_Status__c = 'ACC' 
           OR Injection_Status__c = 'SPB' 
          OR Injection_Status__c = 'PLN' 
             OR Injection_Status__c = 'SPR' 
             OR Injection_Status__c = 'A-PRJ' 
            OR Injection_Status__c = 'P-NAP'
                   )

        ];

        // Put results in map
        counts.put('inventory', inventory);
        counts.put('newRequests', newRequests);
        counts.put('previousRequests', previousRequests);
        counts.put('completedRequests', completedRequests);

        return counts;
    }
}