trigger DenialOwnerAssignment on dn_Denial__c (before insert, before update) {
    DenialOwnerController.assignOwners(Trigger.new);
}