trigger ARAccountsReceivableTrigger on AR_Accounts_Receivable__c (before insert, before update) {

    // --- FINANCIAL CLASS LOGIC ---
    Set<String> payerKeys = new Set<String>();
    for (AR_Accounts_Receivable__c ar : Trigger.new) {
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

    for (AR_Accounts_Receivable__c ar : Trigger.new) {
        if (!String.isBlank(ar.AR_Payer__c)) {
            String key = ar.AR_Payer__c.trim().toUpperCase();
            if (payerToClassMap.containsKey(key)) {
                ar.AR_Financial_Class__c = payerToClassMap.get(key);
            }
        }
    }
    // --- FINANCIAL CLASS LOGIC ENDS ---


    // --- INJECTION STATUS CONFIG LOOKUP ---
    Set<String> injectionStatusValues = new Set<String>();
    for (AR_Accounts_Receivable__c ar : Trigger.new) {
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

    // --- MAIN LOGIC LOOP ---
    for (AR_Accounts_Receivable__c ar : Trigger.new) {
        AR_Accounts_Receivable__c oldAr = Trigger.isUpdate ? Trigger.oldMap.get(ar.Id) : null;

        // --- FOLLOW-UP DATE LOGIC ---
        if (ar.Injection_Status__c != null) {
            AR_Injection_Status__c config = statusToConfigMap.get(ar.Injection_Status__c);

            // Always update Date Worked when Injection Status changes or record is new
            if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                ar.AR_Date_Worked__c = Date.today();
            }

            if (config != null && !String.isBlank(config.AR_FOLLOW_UP_DATE_TRIGGERS__c)) {
                String triggerValue = config.AR_FOLLOW_UP_DATE_TRIGGERS__c.trim().toUpperCase();

                // --- CASE 1: Numeric Value (e.g., 7, 14, 30)
                if (Pattern.matches('^[0-9]+$', triggerValue)) {
                    if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                        Integer daysToAdd = Integer.valueOf(triggerValue);
                        ar.Follow_Up_Date__c = Date.today().addDays(daysToAdd);
                    }
                }
              else if (
              triggerValue.equalsIgnoreCase('MANUAL FILL IN') ||
             triggerValue.equalsIgnoreCase('null') ||
             triggerValue.equalsIgnoreCase('--None--')
                   ) {
                       // Only clear date when status is newly applied
                  if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                 ar.Follow_Up_Date__c = null;
              }
                      }

                // --- CASE 3: Other (non-numeric and not Manual/None)
                else {
                    if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                        ar.Follow_Up_Date__c = null;
                    }
                    
                }
            } else {
                // --- CASE 4: Missing config → treat like Manual Fill In
                if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c != oldAr.Injection_Status__c)) {
                    ar.Follow_Up_Date__c = null;
                }
            }
            
        }
         if (Trigger.isInsert || (Trigger.isUpdate && ar.Injection_Status__c ==null || ar.Injection_Status__c =='' )) {
                        ar.Follow_Up_Date__c = null;
                    }

        // --- PRIORITY STATUS LOGIC (unchanged) ---
        Integer daysFromBilled = null;
        if (!String.isBlank(ar.AR_Age_by_Last_Billed__c)) {
            try { 
                daysFromBilled = Integer.valueOf(ar.AR_Age_by_Last_Billed__c.trim()); 
            } catch (Exception e) {}
        }

        Integer daysFromDOS = (ar.AR_DOS__c != null) ? ar.AR_DOS__c.daysBetween(Date.today()) : null;

        if (ar.Injection_Status__c != null &&
            ar.Follow_Up_Date__c != null &&
            ar.Follow_Up_Date__c < Date.today() &&
            (ar.AR_Denial_Date__c != null || ar.Adjustment_Code_1_Description__c != null)) {
            ar.AR_Priority_Status__c = 'DND';
        }
                  else if (
                    ar.Injection_Status__c == null &&
                    ar.Follow_Up_Date__c == null &&
                     (ar.AR_Denial_Date__c != null || ar.Adjustment_Code_1_Description__c != null)
                     ) {
                      ar.AR_Priority_Status__c = 'DND';
                      }
        
        else if (ar.Follow_Up_Date__c != null) {
            ar.AR_Priority_Status__c = 'F/U';
        }
        else if (daysFromBilled != null && daysFromBilled >= 31 && daysFromBilled <= 90) {
            ar.AR_Priority_Status__c = 'NEW';
        }
        else if (daysFromBilled != null && daysFromBilled > 365) {
            ar.AR_Priority_Status__c = 'OLD';
        }
        else if (daysFromBilled != null && daysFromBilled >= 91 && daysFromBilled <= 180) {
            ar.AR_Priority_Status__c = 'mPMTDUE';
        }
        else if (ar.AR_Age_by_First_Billed__c == null && daysFromDOS != null && daysFromDOS >= 31) {
            ar.AR_Priority_Status__c = 'AUD';
        }
        else if (daysFromBilled != null && daysFromBilled >= 181 && daysFromBilled <= 365) {
            ar.AR_Priority_Status__c = 'CRITICAL';
        }
        else if (ar.AR_Policy_Type__c == 'SELF PAY') {
            ar.AR_Priority_Status__c = 'PATIENT';
        }
        else if (ar.Injection_Status__c == null  && ar.AR_Denial_Date__c == null && ar.Adjustment_Code_1_Description__c == null) {
            ar.AR_Priority_Status__c = 'NEW'; // Final fallback
        }
    }
    
        // --- LOCATION → GEOZIP LOGIC (New Requirement) ---
    Set<String> locationIds = new Set<String>();
    for (AR_Accounts_Receivable__c ar : Trigger.new) {
        if (!String.isBlank(ar.AR_Location_Id__c)) {
            locationIds.add(ar.AR_Location_Id__c.trim());
        }
    }

    Map<String, Horizon_Location_Zip_Codes__mdt> locationToZipMap = new Map<String, Horizon_Location_Zip_Codes__mdt>();
    if (!locationIds.isEmpty()) {
        for (Horizon_Location_Zip_Codes__mdt mdtRec : [
            SELECT Location__c, Zip_Code__c
            FROM Horizon_Location_Zip_Codes__mdt
            WHERE Location__c IN :locationIds
        ]) {
            locationToZipMap.put(mdtRec.Location__c, mdtRec);
        }
    }

    for (AR_Accounts_Receivable__c ar : Trigger.new) {
        if (!String.isBlank(ar.AR_Location_Id__c)) {
            Horizon_Location_Zip_Codes__mdt matched = 
                locationToZipMap.get(ar.AR_Location_Id__c.trim());

            if (matched != null) {
                ar.AR_Geozip__c = matched.Zip_Code__c;
            }
        }
    }

}