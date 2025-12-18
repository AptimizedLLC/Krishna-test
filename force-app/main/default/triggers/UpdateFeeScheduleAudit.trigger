trigger UpdateFeeScheduleAudit on Applied_Payments__c (after update) {
    // Call the helper class to handle the update logic
    AppliedPaymentsHelper.updateFeeScheduleAudit(Trigger.new);
}