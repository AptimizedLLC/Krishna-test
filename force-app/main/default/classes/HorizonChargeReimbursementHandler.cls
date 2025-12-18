public class HorizonChargeReimbursementHandler {
   /*From the related Case record, check if the VOB Type is either 'Reverification' or 'Major Med'.
     If the condition is met, proceed to the related Insurance Plan record and verify whether any of the following fields have a value:
     Daily Chiro Capitated Fee
     Daily OT Capitated Fee
     Daily PT Capitated Fee
     If any of these fields contain a value, calculate the Expected Reimbursement for the Horizon Charge record.
     The calculation logic is based on a Custom Metadata Type that maps Providers to their CPT Specialties.
     The Horizon Charge record contains a Provider Id field, which is used to locate the matching Provider in the metadata.
     Once the Provider's specialty is identified (e.g., Chiro, OT, PT), retrieve the amount from the corresponding
     field (out of the three listed above) in the Insurance Plan record. This value will be stored in the Expected Reimbursement field 
     of the Horizon Charge record.
    */
    public static void processReimbursements(List<Hz_Horizon_Charges__c> charges) {
        if (charges.isEmpty()) return;

        // Filter charges created today only
        List<Hz_Horizon_Charges__c> todaysCharges = new List<Hz_Horizon_Charges__c>();
        Date today = Date.today();

        for (Hz_Horizon_Charges__c hc : charges) {
            if (hc.CreatedDate.date() == today) {
                todaysCharges.add(hc);
            }
        }

        if (todaysCharges.isEmpty()) {
            return; // no charges created today, exit
        }

        Set<Id> caseIds = new Set<Id>();
        Set<Id> insurancePlanIds = new Set<Id>();
        Set<Decimal> providerIds = new Set<Decimal>();

        for (Hz_Horizon_Charges__c hc : todaysCharges) {
            if (hc.Hz_VOB_Case__c != null) {
                caseIds.add(hc.Hz_VOB_Case__c);
            }
            if (hc.Hz_Insurance_Plan__c != null) {
                insurancePlanIds.add(hc.Hz_Insurance_Plan__c);
            }
            if (!String.isBlank(hc.Hz_Provider_Id__c)) {
                try {
                    providerIds.add(Decimal.valueOf(hc.Hz_Provider_Id__c));
                } catch (Exception e) {
                    // Log or ignore invalid provider IDs
                }
            }
        }

        // Query related records
        Map<Id, Case> caseMap = new Map<Id, Case>(
            [SELECT Id, VOB_Type__c 
             FROM Case 
             WHERE Id IN :caseIds]
        );

        Map<Id, Insurance_Plan__c> planMap = new Map<Id, Insurance_Plan__c>(
            [SELECT Id, Daily_Chiro_Capitated_Fee__c, 
                    Daily_OT_Capitated_Fee__c, 
                    Daily_PT_Capitated_Fee__c 
             FROM Insurance_Plan__c 
             WHERE Id IN :insurancePlanIds]
        );

        // CMDT mapping
        Map<String, String> providerToSpecialtyMap = new Map<String, String>();
        for (Horizon_Provider_CPT_Mapping__mdt mapping : [
            SELECT Provider_Id__c, Specialty__c 
            FROM Horizon_Provider_CPT_Mapping__mdt
            WHERE Provider_Id__c IN :providerIds
        ]) {
            providerToSpecialtyMap.put(String.valueOf(mapping.Provider_Id__c), mapping.Specialty__c);
        }

        List<Hz_Horizon_Charges__c> updates = new List<Hz_Horizon_Charges__c>();

        for (Hz_Horizon_Charges__c hc : todaysCharges) {
            if (hc.Hz_VOB_Case__c == null || hc.Hz_Insurance_Plan__c == null || String.isBlank(hc.Hz_Provider_Id__c)) {
                continue;
            }

            Case relatedCase = caseMap.get(hc.Hz_VOB_Case__c);
            if (relatedCase == null || 
                (relatedCase.VOB_Type__c != 'Reverification' && relatedCase.VOB_Type__c != 'Major Med')) {
                continue;
            }

            Insurance_Plan__c plan = planMap.get(hc.Hz_Insurance_Plan__c);
            if (plan == null) {
                continue;
            }

            String specialty = providerToSpecialtyMap.get(hc.Hz_Provider_Id__c);
            if (String.isBlank(specialty)) {
                continue;
            }

            // Set Expected Reimbursement
            if (specialty == 'CHIRO' && plan.Daily_Chiro_Capitated_Fee__c != null) {
                hc.Hz_Expected_Reimbursement__c = plan.Daily_Chiro_Capitated_Fee__c;
            } else if (specialty == 'OT' && plan.Daily_OT_Capitated_Fee__c != null) {
                hc.Hz_Expected_Reimbursement__c = plan.Daily_OT_Capitated_Fee__c;
            } else if (specialty == 'PT' && plan.Daily_PT_Capitated_Fee__c != null) {
                hc.Hz_Expected_Reimbursement__c = plan.Daily_PT_Capitated_Fee__c;
            }

            updates.add(hc);
        }

        if (!updates.isEmpty()) {
            update updates;
        }
    }
}