trigger ARSurgAccountsReceivableTrigger on AR_Surg_Accounts_Receivable__c (before insert, before update) {
    // --- Financial Class Logic (unchanged) ---
    Set<String> payerKeys = new Set<String>();
    for (AR_Surg_Accounts_Receivable__c ar : Trigger.new) {
        if (!String.isBlank(ar.AR_Payer__c)) {
            payerKeys.add(ar.AR_Payer__c.trim().toUpperCase());
        }
    }

    Map<String, String> payerToClassMap = new Map<String, String>();
    if (!payerKeys.isEmpty()) {
        for (Financial_Class__c fc : [
            SELECT Payer__c, Financials_Class__c
            FROM Financial_Class__c
            WHERE Payer__c IN :payerKeys
        ]) {
            payerToClassMap.put(fc.Payer__c.trim().toUpperCase(), fc.Financials_Class__c.trim());
        }
    }

    for (AR_Surg_Accounts_Receivable__c ar : Trigger.new) {
        if (!String.isBlank(ar.AR_Payer__c)) {
            String key = ar.AR_Payer__c.trim().toUpperCase();
            if (payerToClassMap.containsKey(key)) {
                ar.AR_Financial_Class__c = payerToClassMap.get(key);
            }
        }
    }
    // --- Financial Class Logic Ends ---


    // --- Injection Status Config Lookup (unchanged) ---
    Set<String> injectionStatusValues = new Set<String>();
    for (AR_Surg_Accounts_Receivable__c ar : Trigger.new) {
        if (ar.Injection_Status__c != null) {
            injectionStatusValues.add(ar.Injection_Status__c);
        }
    }

    Map<String, AR_Injection_Status__c> statusToConfigMap = new Map<String, AR_Injection_Status__c>();
    if (!injectionStatusValues.isEmpty()) {
        for (AR_Injection_Status__c config : [
            SELECT AR_STATUS_CODES__c, AR_FOLLOW_UP_DATE_TRIGGERS__c 
            FROM AR_Injection_Status__c
            WHERE AR_STATUS_CODES__c IN :injectionStatusValues
        ]) {
            statusToConfigMap.put(config.AR_STATUS_CODES__c, config);
        }
    }

    // --- MAIN LOOP ---
    for (AR_Surg_Accounts_Receivable__c ar : Trigger.new) {
        AR_Surg_Accounts_Receivable__c oldAr = Trigger.isUpdate ? Trigger.oldMap.get(ar.Id) : null;

        // ✅ FOLLOW-UP LOGIC (runs ONLY when Injection Status exists) — unchanged
        if (ar.Injection_Status__c != null) {
            AR_Injection_Status__c config = statusToConfigMap.get(ar.Injection_Status__c);

            if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                ar.AR_Date_Worked__c = Date.today();
            }

            if (config != null && !String.isBlank(config.AR_FOLLOW_UP_DATE_TRIGGERS__c)) {
                String triggerValue = config.AR_FOLLOW_UP_DATE_TRIGGERS__c.trim().toUpperCase();

                if (Pattern.matches('^[0-9]+$', triggerValue)) {
                    if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                        Integer daysToAdd = Integer.valueOf(triggerValue);
                        ar.Follow_Up_Date__c = Date.today().addDays(daysToAdd);
                    }
                }
                // MANUAL = do nothing (unchanged)
            }
        }

               // ✅ UPDATED PRIORITY STATUS LOGIC (with HIGH $ (DOLLAR) on top)
        Integer daysFromBilled = null;
        if (!String.isBlank(ar.AR_Age_by_Last_Billed__c)) {
            try { 
                daysFromBilled = Integer.valueOf(ar.AR_Age_by_Last_Billed__c.trim()); 
            } catch (Exception e) {}
        }
        Integer daysFromDOS = ar.AR_DOS__c != null 
            ? ar.AR_DOS__c.daysBetween(Date.today()) 
            : null;

        //  HIGH $ (DOLLAR) condition — top priority
        if (ar.AR_Procedure_Code__c != null && 
            ar.AR_Procedure_Code__c.startsWith('364')) {
            ar.AR_Priority_Status__c = 'HIGH $ (DOLLAR)';
        }
        else if (ar.Injection_Status__c != null &&
                 ar.Follow_Up_Date__c != null &&
                 ar.Follow_Up_Date__c < Date.today() &&
                 (ar.AR_Denial_Date__c != null || ar.Adjustment_Code_1_Description__c != null)) {
            ar.AR_Priority_Status__c = 'DND';
        }
        else if (ar.Follow_Up_Date__c != null) {
            ar.AR_Priority_Status__c = 'F/U';
        }
        else if (daysFromBilled != null && daysFromBilled >= 0 && daysFromBilled <= 30) {
            ar.AR_Priority_Status__c = 'NEW';
        }
        else if (daysFromBilled != null && daysFromBilled >= 31 && daysFromBilled <= 90) {
            ar.AR_Priority_Status__c = 'OLD';
        }
        else if (daysFromBilled != null && daysFromBilled >= 91 && daysFromBilled <= 180) {
            ar.AR_Priority_Status__c = 'mPMTDUE';
        }
        else if (ar.AR_Age_by_First_Billed__c != null && daysFromDOS != null && daysFromDOS >= 31) {
            ar.AR_Priority_Status__c = 'AUD';
        }
        else if (daysFromBilled != null && daysFromBilled >= 181 && daysFromBilled <= 365) {
            ar.AR_Priority_Status__c = 'CRITICAL';
        }
        else if (ar.Injection_Status__c == null) {
            ar.AR_Priority_Status__c = 'DND'; // ✅ FINAL FALLBACK
        }

    }
}