trigger HorizonChargeTrigger on Hz_Horizon_Charges__c (before insert, before update) {
   
    // When Hz_Location_Id__c is entered on Hz_Horizon_Charges__c,
   // populate Geozip__c by matching the location in Horizon_Location_Zip_Codes__mdt.

    
    // Step 1: Collect all unique Location Ids from incoming records
    Set<String> locationIds = new Set<String>();
    for (Hz_Horizon_Charges__c charge : Trigger.new) {
        if (String.isNotBlank(charge.Hz_Location_Id__c)) {
            locationIds.add(charge.Hz_Location_Id__c);
        }
    }

    if (!locationIds.isEmpty()) {
        // Step 2: Query custom metadata for matching Location__c values
        Map<String, String> locationToZipMap = new Map<String, String>();
        for (Horizon_Location_Zip_Codes__mdt metaRec : [
            SELECT Location__c, Zip_Code__c
            FROM Horizon_Location_Zip_Codes__mdt
            WHERE Location__c IN :locationIds
        ]) {
            locationToZipMap.put(metaRec.Location__c, metaRec.Zip_Code__c);
        }

        // Step 3: Update Geozip__c for each record
        for (Hz_Horizon_Charges__c charge : Trigger.new) {
            if (String.isNotBlank(charge.Hz_Location_Id__c) &&
                locationToZipMap.containsKey(charge.Hz_Location_Id__c)) {

                charge.Geozip__c = locationToZipMap.get(charge.Hz_Location_Id__c);
            }
        }
    }
    
    // Populate Provider_Specialty__c from Horizon_Provider_CPT_Mapping__mdt
    // based on matching Hz_Provider_Id__c = Provider_Id__c
    
    Set<Decimal> providerIdsDecimal = new Set<Decimal>();

    for (Hz_Horizon_Charges__c charge : Trigger.new) {
        if (String.isNotBlank(charge.Hz_Provider_Id__c)) {
            try {
                providerIdsDecimal.add(Decimal.valueOf(charge.Hz_Provider_Id__c.trim()));
            } catch (Exception e) {
                // Skip non-numeric provider IDs
            }
        }
    }

    // Step 2: Query custom metadata for those provider IDs
    if (!providerIdsDecimal.isEmpty()) {
        Map<Decimal, String> providerToSpecialtyMap = new Map<Decimal, String>();
        for (Horizon_Provider_CPT_Mapping__mdt metaRec : [
            SELECT Provider_Id__c, Specialty__c
            FROM Horizon_Provider_CPT_Mapping__mdt
            WHERE Provider_Id__c IN :providerIdsDecimal
        ]) {
            providerToSpecialtyMap.put(metaRec.Provider_Id__c, metaRec.Specialty__c);
        }

        // Step 3: Assign specialty to matching charges
        for (Hz_Horizon_Charges__c charge : Trigger.new) {
            if (String.isNotBlank(charge.Hz_Provider_Id__c)) {
                try {
                    Decimal providerId = Decimal.valueOf(charge.Hz_Provider_Id__c.trim());
                    if (providerToSpecialtyMap.containsKey(providerId)) {
                        charge.Provider_Specialty__c = providerToSpecialtyMap.get(providerId);
                    }
                } catch (Exception e) {
                    // Ignore invalid numeric conversion
                }
            }
        }
    }

}