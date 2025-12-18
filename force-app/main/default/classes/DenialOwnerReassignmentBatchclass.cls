global class DenialOwnerReassignmentBatchclass implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query today's records with adjustment code NOT 100 AND grouping equals "Not MD"
        return Database.getQueryLocator([
            SELECT Id, OwnerId, dn_Adjustment_Code_1__c, dn_PROVIDER_GROUPING__c,
                   dn_Patient_Account__r.dn_Name__c, dn_DOS__c, dn_PROVIDER__c, dn_DENIED_CATEGORY_CODE__c
            FROM dn_Denial__c
            WHERE CreatedDate = TODAY
              AND dn_Adjustment_Code_1__c != '100'
               AND dn_PROVIDER_GROUPING__c = 'Not MD'
              AND dn_Patient_Account__r.dn_Name__c != null
              AND dn_DOS__c != null
              AND dn_PROVIDER__c != null
        ]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<dn_Denial__c> toUpdate = new List<dn_Denial__c>();

        for (dn_Denial__c newRec : (List<dn_Denial__c>)scope) {
            // Query for matching most recent record with CO-100 and Grouping "Not MD"
            List<dn_Denial__c> matchedList = [
                SELECT Id, OwnerId
                FROM dn_Denial__c
                WHERE dn_Adjustment_Code_1__c = '100'
                  AND dn_DENIED_CATEGORY_CODE__c = 'CO'
                  AND dn_PROVIDER_GROUPING__c = 'Not MD'
                  AND dn_Patient_Account__r.dn_Name__c = :newRec.dn_Patient_Account__r.dn_Name__c
                  AND dn_DOS__c = :newRec.dn_DOS__c
                  AND dn_PROVIDER__c = :newRec.dn_PROVIDER__c
                 AND CreatedDate = TODAY                  
                ORDER BY LastModifiedDate DESC
                LIMIT 1
            ];

            if (!matchedList.isEmpty()) {
                dn_Denial__c matched = matchedList[0];
                newRec.OwnerId = matched.OwnerId;
                toUpdate.add(newRec);
            }
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Optional: logging or notification
    }
}