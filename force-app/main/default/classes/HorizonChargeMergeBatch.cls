public class HorizonChargeMergeBatch implements Database.Batchable<SObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Pick today's charges for processing
        return Database.getQueryLocator([
            SELECT Id, Hz_DOS__c, Hz_Provider_Id__c, Hz_Patient_Id__c,
                   Hz_Amount__c, Hz_Expected_Reimbursement__c, CreatedDate
            FROM Hz_Horizon_Charges__c
            WHERE CreatedDate = TODAY
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Hz_Horizon_Charges__c> scope) {
        HorizonChargeMergeHandler.mergeAllCharges();
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: send email/logging
        System.debug('HorizonChargeMergeBatch finished execution.');
    }
}