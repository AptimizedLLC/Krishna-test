global class ARInjectionExpectedAmountBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        
        String query = 'SELECT Id, AR_Procedure_Code__c, AR_Medicare_Geozip__c, AR_DOS__c, ' +
                       'AR_Location_Id__c, AR_Payer_Id__c, AR_Expected_Amount__c ' +
                       'FROM AR_Accounts_Receivable__c ' +
                       'WHERE CreatedDate = TODAY ' +
                       'AND AR_Payer_Id__c IN (\'7058\', \'4903\') ' +
                       'AND AR_Procedure_Code__c != null ' +
                       'AND AR_Medicare_Geozip__c != null ' +
                       'AND AR_DOS__c != null';
                       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<AR_Accounts_Receivable__c> scope) {
        // Fixed: pass the list directly – handler method now accepts List<AR_Accounts_Receivable__c>
        ARInjectionExpectedAmountHandler.processCharges(scope);
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('ARInjectionExpectedAmountBatch completed successfully.');
    }
}