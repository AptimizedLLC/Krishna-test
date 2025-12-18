trigger AR_AccountsReceivableArchivalTrigger on AR_Accounts_Receivable__c (after update) {
    // Archival should run only when status changes to ACC
   // AR_AccountsReceivableArchivalHandler.handleArchival(Trigger.new, Trigger.oldMap);
}