trigger DenialTrigger on dn_Denial__c (after insert) {
 if(Trigger.isUpdate == true && Trigger.isAfter){
    //dn_DenialHandler.updateOwnerOnMatchingRecords(Trigger.New);
    }
}