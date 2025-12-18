public class dnDenialBatch implements Database.Batchable<SObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Fetch CO-100 Underpaid records
        return Database.getQueryLocator([
            SELECT Id, dn_Patient_Account__r.dn_Name__c, dn_Provider_Id__c, dn_DOS__c
            FROM dn_Denial__c
            WHERE dn_Adjustment_Code_1__c = '100'
            AND dn_DENIED_CATEGORY_CODE__c = 'CO'
            AND dn_CO_100_Status__c = 'Underpaid'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<dn_Denial__c> scope) {
        //dn_DenialHandler.processRecords(scope);
        system.debug('Stoped batch');
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: send notification, debug log, etc.
    }
}