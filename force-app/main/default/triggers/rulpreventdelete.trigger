trigger rulpreventdelete on RUL__c (before delete) {

    // Get the System Administrator profile ID
    String sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;

    for (RUL__c record : Trigger.old) {
        // Prevent deletion if the user's profile is NOT System Administrator
        if (UserInfo.getProfileId() == sysAdminProfileId) {
            record.addError('You do not have permission to delete RUL records.');
        }
    }


}