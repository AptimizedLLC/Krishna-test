public class OpportunityTriggerHandler {
    public static void sendDocumentToCareCloud(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        System.debug('::: OpportunityTriggerHandler.sendDocumentToCareCloud start');
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : newList) {
            System.debug('::: Opportunity - '+opp.Send_Intake_PDF_To_CareCLoud__c);
            if(opp.Send_Intake_PDF_To_CareCLoud__c && opp.Send_Intake_PDF_To_CareCLoud__c != oldMap.get(opp.Id).Send_Intake_PDF_To_CareCLoud__c)
            {
                oppIds.add(opp.Id);
            }
        }
        System.debug('::: OppIds Size = '+oppIds.size()+' , and OppIds = '+oppIds);
        if(oppIds.size() > 0 && oppIds.size() < 10) {
            for(Id oppId : oppIds) {
                try {
                    if(System.isBatch() || System.isFuture()){
                        CareCloudAuthConnection.uploadPatientDocument(oppId);
                    }else{
                    	CareCloudAuthConnection.uploadPatientDocumentAsync(oppId);
                    }
                } catch(Exception ex) {
                    System.debug('Exception in OpportunityTriggerHandler - '+ex.getMessage());
                    TransactionLogHandler.doHandleException(ex, 'OpportunityTriggerHandler', 'sendDocumentToCareCloud');
                }                
            }
        }
    }
}