global class HorizonChargeBatchClass implements Database.Batchable<SObject> {
 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Hz_DOS__c, Hz_Patient_Name__c, Hz_Provider_Id__c, 
                   Hz_Expected_Reimbursement__c, Hz_Total_Expected_Reimbursement__c
            FROM Hz_Horizon_Charges__c
            WHERE CreatedDate = LAST_N_DAYS:30 // Optional filter
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Hz_Horizon_Charges__c> records) {
        Map<String, List<Hz_Horizon_Charges__c>> groupedRecords = new Map<String, List<Hz_Horizon_Charges__c>>();

        for (Hz_Horizon_Charges__c rec : records) {
            String key = String.valueOf(rec.Hz_DOS__c) + '-' + rec.Hz_Patient_Name__c + '-' + rec.Hz_Provider_Id__c;
            if (!groupedRecords.containsKey(key)) {
                groupedRecords.put(key, new List<Hz_Horizon_Charges__c>());
            }
            groupedRecords.get(key).add(rec);
        }

        List<Hz_Horizon_Charges__c> toUpdate = new List<Hz_Horizon_Charges__c>();
        List<Hz_Horizon_Charges__c> toDelete = new List<Hz_Horizon_Charges__c>();

        for (String key : groupedRecords.keySet()) {
            List<Hz_Horizon_Charges__c> recordGroup = groupedRecords.get(key);
            if (recordGroup.size() > 1) {
                Decimal totalReimbursement = 0;
                for (Hz_Horizon_Charges__c rec : recordGroup) {
                    totalReimbursement += rec.Hz_Expected_Reimbursement__c != null ? rec.Hz_Expected_Reimbursement__c : 0;
                }

                // Keep the first record and update its Total field
                Hz_Horizon_Charges__c master = recordGroup[0];
                master.Hz_Total_Expected_Reimbursement__c = totalReimbursement;
                toUpdate.add(master);

                // Mark others for deletion
                for (Integer i = 1; i < recordGroup.size(); i++) {
                    toDelete.add(recordGroup[i]);
                }
            }
        }

        if (!toUpdate.isEmpty()) update toUpdate;
        if (!toDelete.isEmpty()) delete toDelete;
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Horizon Charge Merge Completed');
    }  
}