public with sharing class AR_DashboardUserController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardData(String viewType) {

        Map<String, Object> result = new Map<String, Object>();

        //  Fetch only the logged-in user’s records
        List<AR_Accounts_Receivable__c> records = new List<AR_Accounts_Receivable__c>();
        if(String.isNotBlank(viewType)){
        records = [
            SELECT Id, OwnerId, Owner.Name, AR_Priority_Status__c, Injection_Status__c, CreatedDate, AR_Date_Worked__c
            FROM AR_Accounts_Receivable__c
            WHERE OwnerId = :UserInfo.getUserId() AND Workbook_Category__c = :viewType
        ];
        }
        // ---------- SECTION 1 : PRIORITY STATUS ----------
        List<String> priorityColumns = new List<String>{'NEW','F/U','DND','OLD','mPMTDUE','AUD','CRITICAL','PATIENT'};
        Map<String, Map<String, Integer>> ownerToPriorityMap = new Map<String, Map<String, Integer>>();
        Map<String, Integer> totalPriorityMap = new Map<String, Integer>();

        for(String col : priorityColumns) totalPriorityMap.put(col, 0);

        for (AR_Accounts_Receivable__c rec : records) {
            String owner = rec.Owner.Name;
            String status = rec.AR_Priority_Status__c;
            if (String.isBlank(owner) || String.isBlank(status)) continue;

            if (!ownerToPriorityMap.containsKey(owner))
                ownerToPriorityMap.put(owner, new Map<String, Integer>());

            Map<String, Integer> subMap = ownerToPriorityMap.get(owner);
            subMap.put(status, subMap.containsKey(status) ? subMap.get(status) + 1 : 1);

            totalPriorityMap.put(status, totalPriorityMap.get(status) + 1);
        }

        List<Map<String, Object>> priorityData = new List<Map<String, Object>>();
        for (String owner : ownerToPriorityMap.keySet()) {
            Map<String, Object> row = new Map<String, Object>();
            row.put('owner', owner);

            List<Map<String, Object>> values = new List<Map<String, Object>>();
            Map<String, Integer> subMap = ownerToPriorityMap.get(owner);
            for (String col : priorityColumns) {
                values.add(new Map<String, Object>{
                    'key' => col,
                    'count' => subMap.containsKey(col) ? subMap.get(col) : 0
                });
            }
            row.put('values', values);
            priorityData.add(row);
        }

        // ---------- SECTION 2 : INJECTION STATUS (ONLY TODAY’S RECORDS) ----------
        Set<String> injectionColumnsSet = new Set<String>();
        Map<String, Map<String, Integer>> ownerToInjectionMap = new Map<String, Map<String, Integer>>();

        Date today = Date.today();

        for (AR_Accounts_Receivable__c rec : records) {
            // Only include records created today
            if (rec.AR_Date_Worked__c == null || rec.AR_Date_Worked__c != today) continue;


            String owner = rec.Owner.Name;
            String inj = rec.Injection_Status__c;
            if (String.isBlank(owner) || String.isBlank(inj)) continue;

            injectionColumnsSet.add(inj);

            if (!ownerToInjectionMap.containsKey(owner))
                ownerToInjectionMap.put(owner, new Map<String, Integer>());

            Map<String, Integer> subMap = ownerToInjectionMap.get(owner);
            subMap.put(inj, subMap.containsKey(inj) ? subMap.get(inj) + 1 : 1);
        }

        List<Map<String, Object>> injectionData = new List<Map<String, Object>>();
        for (String owner : ownerToInjectionMap.keySet()) {
            Map<String, Object> row = new Map<String, Object>();
            row.put('owner', owner);

            List<Map<String, Object>> values = new List<Map<String, Object>>();
            Map<String, Integer> subMap = ownerToInjectionMap.get(owner);
            for (String inj : injectionColumnsSet) {
                values.add(new Map<String, Object>{
                    'key' => inj,
                    'count' => subMap.containsKey(inj) ? subMap.get(inj) : 0
                });
            }
            row.put('values', values);
            injectionData.add(row);
        }

        // ---------- FINAL RESPONSE ----------
        result.put('priorityData', priorityData);
        result.put('totalPriority', totalPriorityMap);
        result.put('priorityColumns', priorityColumns);
        result.put('injectionColumns', new List<String>(injectionColumnsSet));
        result.put('injectionData', injectionData);

        return result;
    }
}