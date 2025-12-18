public class AppliedPaymentsHelper {
    // Static variable to prevent recursion
    private static Boolean isRecursive = false;

    public static void updateFeeScheduleAudit(List<Applied_Payments__c> appliedPaymentsList) {
        // Check if the trigger is already running to prevent recursion
        if (isRecursive) {
            return;
        }
        isRecursive = true;

        // Create a map to store VOB_Case__c and the corresponding Fee_Schedule_Audit__c value
        Map<Id, String> vobCaseToFeeScheduleAuditMap = new Map<Id, String>();

        // Iterate through the updated records and populate the map
        for (Applied_Payments__c ap : appliedPaymentsList) {
            if (ap.VOB_Case__c != null && ap.Fee_Schedule_Audit__c != null) {
                vobCaseToFeeScheduleAuditMap.put(ap.VOB_Case__c, ap.Fee_Schedule_Audit__c);
            }
        }

        // Query all Applied_Payments__c records with the same VOB_Case__c
        List<Applied_Payments__c> recordsToUpdate = [SELECT Id, VOB_Case__c, Fee_Schedule_Audit__c
                                                      FROM Applied_Payments__c
                                                      WHERE VOB_Case__c IN :vobCaseToFeeScheduleAuditMap.keySet()];

        // Update the Fee_Schedule_Audit__c field for the queried records
        for (Applied_Payments__c record : recordsToUpdate) {
            if (vobCaseToFeeScheduleAuditMap.containsKey(record.VOB_Case__c)) {
                record.Fee_Schedule_Audit__c = vobCaseToFeeScheduleAuditMap.get(record.VOB_Case__c);
            }
        }

        // Perform the update
        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }

        // Reset the recursion flag
        isRecursive = false;
    }
}