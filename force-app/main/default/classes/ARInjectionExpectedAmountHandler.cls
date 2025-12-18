public class ARInjectionExpectedAmountHandler {

    // ====== CONFIGURATION SETS (easy to maintain) ======
    private static final Set<String> NORTH_NJ_ZIPS = new Set<String>{
        '08816','08857','07410','07003','07869','07083','07054',
        '07424','07065','07666','07094','07109','07042'
    };
    
    private static final Set<String> REST_NJ_ZIPS = new Set<String>{
        '07728','07701','07753','07747','07751','08701'
    };
    
    private static final Set<String> PRIORITY_LOCATION_IDS = new Set<String>{
        '44810','48721','48722','51009','51834','51835','44808','44813',
        '48503','48502','48874','44814','44815','50056','50057','44816',
        '44702','53513','53514','55097','55096','53754','55567'
    };

    // ====== MAIN METHOD – CALLED FROM BATCH ======
    public static void processCharges(List<AR_Accounts_Receivable__c> charges) {
        if (charges == null || charges.isEmpty()) return;
        
        List<AR_Accounts_Receivable__c> chargesToUpdate = new List<AR_Accounts_Receivable__c>();
        
        // Group charges by Region_Year (e.g., North_NJ_2024)
        Map<String, List<AR_Accounts_Receivable__c>> chargeMap = new Map<String, List<AR_Accounts_Receivable__c>>();
        
        for (AR_Accounts_Receivable__c charge : charges) {
            Integer dosYear = charge.AR_DOS__c.year();
            String region = getRegion(charge.AR_Medicare_Geozip__c);
            
            if (region == null || dosYear < 2023 || dosYear > 2025) {
                continue; // Skip if no matching region or unsupported year
            }
            
            String key = region + '_' + dosYear;
            if (!chargeMap.containsKey(key)) {
                chargeMap.put(key, new List<AR_Accounts_Receivable__c>());
            }
            chargeMap.get(key).add(charge);
        }
        
        // Process each group (North_NJ_2023, Rest_of_NJ_2024, etc.)
        for (String key : chargeMap.keySet()) {
            List<AR_Accounts_Receivable__c> chargeGroup = chargeMap.get(key);
            
            // Collect all procedure codes in this group
            Set<String> procCodes = new Set<String>();
            for (AR_Accounts_Receivable__c c : chargeGroup) {
                if (c.AR_Procedure_Code__c != null) {
                    procCodes.add(c.AR_Procedure_Code__c);
                }
            }
            if (procCodes.isEmpty()) continue;
            
            // Build dynamic object name: Hz_North_NJ_2024__c
            String[] parts = key.split('_');
            String regionPart = parts[0] + '_' + parts[1]; // North_NJ or Rest_of_NJ
            Integer year = Integer.valueOf(parts[2]);
            String refObjectName = 'Hz_' + regionPart + '_' + year + '__c';
            
            // Dynamic query to get matching reference records
            String query = 'SELECT Hz_Proc_Code__c, Hz_Par_Fee__c, Hz_Fac_Ind__c ' +
                           'FROM ' + refObjectName + ' ' +
                           'WHERE Hz_Proc_Code__c IN :procCodes';
            
            List<SObject> refRecords = Database.query(query);
            
            // Map: Proc Code → List of reference records (for duplicate handling)
            Map<String, List<SObject>> procToRefs = new Map<String, List<SObject>>();
            for (SObject ref : refRecords) {
                String proc = (String)ref.get('Hz_Proc_Code__c');
                if (!procToRefs.containsKey(proc)) {
                    procToRefs.put(proc, new List<SObject>());
                }
                procToRefs.get(proc).add(ref);
            }
            
            // Match each charge
            for (AR_Accounts_Receivable__c charge : chargeGroup) {
                if (charge.AR_Procedure_Code__c == null) continue;
                
                List<SObject> candidates = procToRefs.get(charge.AR_Procedure_Code__c);
                if (candidates == null || candidates.isEmpty()) continue;
                
                // Critical Fix: Convert Location Id to String (it is Text field!)
                String locationIdStr = String.valueOf(charge.AR_Location_Id__c);
                if (String.isBlank(locationIdStr)) locationIdStr = '';
                
                SObject bestMatch = selectBestMatch(candidates, locationIdStr);
                if (bestMatch == null) continue;
                
                Decimal parFee = (Decimal)bestMatch.get('Hz_Par_Fee__c');
                if (parFee == null) continue;
                
                // AR_Expected_Amount__c is Text → convert Decimal to String with 2 decimals
                String newExpectedAmount = String.valueOf(parFee.setScale(2));
                
                if (charge.AR_Expected_Amount__c != newExpectedAmount) {
                    charge.AR_Expected_Amount__c = newExpectedAmount;
                    chargesToUpdate.add(charge);
                }
            }
        }
        
        // Final update
        if (!chargesToUpdate.isEmpty()) {
            try {
                update chargesToUpdate;
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, 
                    'ARInjectionExpectedAmountHandler: Update failed → ' + e.getMessage() + 
                    '\nStack: ' + e.getStackTraceString());
            }
        }
    }
    
    // ====== HELPER: Determine region from ZIP ======
    private static String getRegion(String geozip) {
        if (String.isBlank(geozip)) return null;
        String zip5 = geozip.left(5);
        if (NORTH_NJ_ZIPS.contains(zip5)) return 'North_NJ';
        if (REST_NJ_ZIPS.contains(zip5)) return 'Rest_of_NJ';
        return null;
    }
    
    // ====== HELPER: Choose best reference record (facility priority logic) ======
    private static SObject selectBestMatch(List<SObject> candidates, String locationIdStr) {
        if (candidates.isEmpty()) return null;
        if (candidates.size() == 1) return candidates[0];
        
        Boolean useFacilityPriority = PRIORITY_LOCATION_IDS.contains(locationIdStr);
        SObject facilityCandidate = null;
        SObject fallback = candidates[0];
        
        for (SObject cand : candidates) {
            String facInd = (String)cand.get('Hz_Fac_Ind__c');
            facInd = (facInd == null) ? '' : facInd.trim();
            
            if (useFacilityPriority && facInd == '#') {
                return cand; // Immediate win
            }
            if (facInd == '#') {
                facilityCandidate = cand;
            }
        }
        
        return (facilityCandidate != null) ? facilityCandidate : fallback;
    }
}