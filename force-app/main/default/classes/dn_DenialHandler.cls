public class dn_DenialHandler {

    public static void setBypassOnBeforeUpdate(List<dn_Denial__c> newList, List<dn_Denial__c> oldList) {
        if (newList == null || newList.isEmpty()) return;
        if (oldList == null || oldList.isEmpty()) return;
         Map<Id, dn_Denial__c> oldlistMap = new Map<Id, dn_Denial__c>();
        for (dn_Denial__c d : oldList){
                oldlistMap.put(d.Id, d);
        }
    
        for (dn_Denial__c d : newList) {
            // Unconditionally set the checkbox before update
            System.debug('dn_Adjustment_Code_1__c : ' + d.dn_Adjustment_Code_1__c + ' dn_DENIED_CATEGORY_CODE__c : ' + d.dn_DENIED_CATEGORY_CODE__c);
            dn_Denial__c od =  oldlistMap.get(d.Id);
           if(d.dn_Adjustment_Code_1__c == '100' && d.dn_DENIED_CATEGORY_CODE__c == 'CO' 
              && d.dn_CO_100_Status__c == 'Underpaid' && oldList.size() > 0 && od.dn_CO_100_Status__c != 'Underpaid' ){
              d.bypass_CO_100__c = true;
              System.debug('ID  : ' + d.Id);
           }
        }
    }

	/**
     * Updates OwnerId on dn_Denial__c records that share the same
     * DOS, Patient, and Provider Grouping as the input list, 
     * but have CO-100_Status__c != 'Underpaid'.
     */

    @InvocableMethod (label='Update denial related records' description='Updates the denial Status field')
    public static void updateOwnerOnMatchingRecords(List<String> recordIds) {
        if (recordIds == null) return;
        if (recordIds.isEmpty()) return;
        List<dn_Denial__c> co100List = [SELECT Id,dn_Patient_Account__r.dn_Name__c, dn_DOS__c, dn_Patient_Account__c, dn_Provider_Id__c, OwnerId, dn_CO_100_Status__c, Denial_Re_Routing__c
        FROM dn_Denial__c WHERE Id = :recordIds[0]];
        if (co100List.isEmpty()) return;
        List<dn_Denial__c> dn_Idlists = new List<dn_Denial__c>();
        // Create unique key combinations for lookup
        Set<String> matchKeys = new Set<String>();
        for (dn_Denial__c co100 : co100List) {
            if (co100.dn_Patient_Account__r.dn_Name__c != null &&
                co100.dn_Provider_Id__c != null &&
                co100.dn_DOS__c != null) {

                String key = co100.dn_Patient_Account__r.dn_Name__c + '|' +
                             co100.dn_Provider_Id__c + '|' +
                             co100.dn_DOS__c.format();
                matchKeys.add(key);
                 dn_Idlists.add(co100);
                
            }
        }

        if (matchKeys.isEmpty()) return;

        // --- Break the keys into smaller chunks (<= 100) manually ---
        List<String> allKeys = new List<String>(matchKeys);
        List<List<String>> chunkedKeys = new List<List<String>>();
        Integer chunkSize = 100;
        List<String> currentChunk = new List<String>();

        for (Integer i = 0; i < allKeys.size(); i++) {
            currentChunk.add(allKeys[i]);
            if (currentChunk.size() == chunkSize || i == allKeys.size() - 1) {
                chunkedKeys.add(new List<String>(currentChunk));
                currentChunk.clear();
            }
        }

        List<dn_Denial__c> toUpdate = new List<dn_Denial__c>();

        // Process each chunk separately to avoid large SOQL queries
        for (List<String> keyChunk : chunkedKeys) {
            Set<String> patientNames = new Set<String>();
            Set<String> providerIds = new Set<String>();
            Set<Date> dosDates = new Set<Date>();
           for (String k : keyChunk) {
                List<String> parts = k.split('\\|');
                if (parts.size() == 3) {
                    patientNames.add(parts[0]);
                    providerIds.add(parts[1]);
                    //dosDates.add(Date.valueOf(parts[2]));
                    List<String> parts1 = parts[2].split('/');
                     // Convert to YYYY-MM-DD
                      dosDates.add(Date.valueOf(parts1[2] + '-' + parts1[0] + '-' + parts1[1]));
                }
            }
            system.debug('patientNames :' + patientNames);
            system.debug('providerIds :' + providerIds);
            system.debug('dosDates :' + dosDates);
            // Query only relevant non–CO-100 records
            List<dn_Denial__c> nonCoList = [
                SELECT Id, dn_Patient_Account__r.dn_Name__c, dn_Provider_Id__c, dn_DOS__c
                FROM dn_Denial__c
                WHERE dn_Adjustment_Code_1__c != '100'
                
                AND dn_Patient_Account__r.dn_Name__c IN :patientNames
                AND dn_Provider_Id__c IN :providerIds
                AND dn_DOS__c IN :dosDates
            ];
               
            for (dn_Denial__c nonCo : nonCoList) {
                String key = nonCo.dn_Patient_Account__r.dn_Name__c + '|' +
                             nonCo.dn_Provider_Id__c + '|' +
                             nonCo.dn_DOS__c.format();
                if (matchKeys.contains(key)) {
                    nonCo.Denial_Re_Routing__c = true;
                    toUpdate.add(nonCo);
                }
            }
        }

        if (!toUpdate.isEmpty()) {
            system.debug('toUpdate ###' + toUpdate);
            update toUpdate;
        }

        List<dn_Denial__c> dn_update = new  List<dn_Denial__c>();
        for(dn_Denial__c drecord : dn_Idlists){
            drecord.bypass_CO_100__c = false;
            dn_update.add(drecord);
        }
         if (!dn_update.isEmpty()){
              system.debug('dn_update ###' + dn_update);
              update dn_update;
              
         }
       
    }

}