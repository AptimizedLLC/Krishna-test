trigger OpportunityTrigger on Opportunity (after update) {
    if(Trigger.isAfter &&  Trigger.isUpdate){ 
        System.debug('::: OpportunityTrigger Begins');    
        //OpportunityTriggerHandler.sendDocumentToCareCloud(Trigger.New, Trigger.oldMap);
    }
}