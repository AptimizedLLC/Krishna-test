public class AR_FinancialPriorityBatchProcessor implements Database.Batchable<SObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('⚙️ Batch start initialized');

        // Fetch records where Payer is present (you can adjust the filter later)
        return Database.getQueryLocator([
            SELECT Id, AR_Payer__c, AR_Financial_Class__c, 
                   AR_Last_Billed_Date__c, AR_DOS__c,
                   AR_Age_by_Last_Billed__c, AR_Charge_Status__c, 
                   Injection_Status__c, AR_Policy_Type__c,  AR_Accounts_Receivable__c.AR_Priority_Status__c	, Follow_Up_Date__c
            FROM AR_Accounts_Receivable__c  Where CreatedDate = Today
           
        ]);
    }

    public void execute(Database.BatchableContext bc, List<AR_Accounts_Receivable__c> scope) {
        System.debug('⚙️ Batch execute started. Scope size: ' + scope.size());
        AR_FinancialPriorityBatchHandler.updateFinancialClassAndPriority(scope);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('✅ Batch finished successfully.');
    }
}