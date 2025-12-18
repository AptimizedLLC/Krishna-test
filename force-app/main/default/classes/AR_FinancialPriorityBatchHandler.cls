public class AR_FinancialPriorityBatchHandler {

    public static void updateFinancialClassAndPriority(List<AR_Accounts_Receivable__c> records) {
        if (records == null || records.isEmpty()) return;

        Map<String, String> payerToClassMap = new Map<String, String>();
        for (Financial_Class__c fc : [
            SELECT Payer__c, Financials_Class__c
            FROM Financial_Class__c
            WHERE Payer__c != null AND Financials_Class__c != null
        ]) {
            String payerKey = fc.Payer__c != null ? fc.Payer__c.trim().toUpperCase() : null;
            String finClass = String.valueOf(fc.Financials_Class__c).trim();
            if (!String.isBlank(payerKey) && !String.isBlank(finClass)) {
                payerToClassMap.put(payerKey, finClass);
            }
        }

        List<AR_Accounts_Receivable__c> recordsToUpdate = new List<AR_Accounts_Receivable__c>();

        for (AR_Accounts_Receivable__c rec : records) {
            Boolean hasChanged = false;
            Boolean priorityChanged = false;

            // --- Financial Class Update ---
            if (!String.isBlank(rec.AR_Payer__c)) {
                String payerNormalized = rec.AR_Payer__c.trim().toUpperCase();
                if (payerToClassMap.containsKey(payerNormalized)) {
                    String mappedClass = payerToClassMap.get(payerNormalized);
                    String currentClass = rec.AR_Financial_Class__c != null ? rec.AR_Financial_Class__c.trim() : '';
                    if (currentClass != mappedClass) {
                        rec.AR_Financial_Class__c = mappedClass;
                        hasChanged = true;
                    }
                }
            }

            // --- Priority Status Logic (UPDATED) ---
            String oldPriority = rec.AR_Priority_Status__c;
            Integer daysFromBilled = rec.AR_Last_Billed_Date__c != null 
                ? rec.AR_Last_Billed_Date__c.daysBetween(Date.today()) : null;
            Integer daysFromDOS = rec.AR_DOS__c != null 
                ? rec.AR_DOS__c.daysBetween(Date.today()) : null;

            // 🔹 DND Case 2: Injection_Status__c present AND Follow_Up_Date__c passed
            //               AND (AR_Denial_Date__c OR Adjustment_Code_1_Description__c is not null)
            if (rec.Injection_Status__c != null &&
                rec.Follow_Up_Date__c != null &&
                rec.Follow_Up_Date__c < Date.today() &&
                (rec.AR_Denial_Date__c != null || rec.Adjustment_Code_1_Description__c != null)) {
                rec.AR_Priority_Status__c = 'DND';
            }
            // 🔹 F/U: If the Follow_Up_Date__c is updated (not null)
            else if (rec.Follow_Up_Date__c != null) {
                rec.AR_Priority_Status__c = 'F/U';
            }
            // 🔹 Other conditions (existing logic preserved)
            else if (daysFromBilled != null && daysFromBilled >= 31 && daysFromBilled <= 90) {
                rec.AR_Priority_Status__c = 'NEW';
            } else if (daysFromBilled != null && daysFromBilled > 365) {
                rec.AR_Priority_Status__c = 'OLD';
            } else if (daysFromBilled != null && daysFromBilled >= 91 && daysFromBilled <= 180) {
                rec.AR_Priority_Status__c = 'mPMTDUE';
            } else if (daysFromDOS != null && daysFromDOS > 31) {
                rec.AR_Priority_Status__c = 'AUD';
            } else if (daysFromBilled != null && daysFromBilled >= 181 && daysFromBilled <= 365) {
                rec.AR_Priority_Status__c = 'CRITICAL';
            } else if (rec.AR_Policy_Type__c == 'SELF PAY') {
                rec.AR_Priority_Status__c = 'PATIENT';
            }
            // 🔹 DND Case 1: Injection_Status__c is null (evaluated last)
            else if (rec.Injection_Status__c == null) {
                rec.AR_Priority_Status__c = 'DND';
            }

            // Mark if changed
            if (oldPriority != rec.AR_Priority_Status__c) {
                priorityChanged = true;
            }

            // Add to update list if either changed
            if (hasChanged || priorityChanged) {
                recordsToUpdate.add(rec);
            }
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
            System.debug('✅ Records updated: ' + recordsToUpdate.size());
        } else {
            System.debug('ℹ️ No updates required.');
        }
    }
}