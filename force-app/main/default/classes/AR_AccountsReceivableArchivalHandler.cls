/*public class AR_AccountsReceivableArchivalHandler {

    // === EXISTING HANDLER LOGIC ===
    public static void handleArchival(List<AR_Accounts_Receivable__c> newList, Map<Id, AR_Accounts_Receivable__c> oldMap) {
        if (newList == null || newList.isEmpty()) return;

        List<AR_Injection_Archival__c> archivalRecords = new List<AR_Injection_Archival__c>();
        List<Id> recordsToDeleteIds = new List<Id>();
        Set<Id> ownerIds = new Set<Id>();

        // Collect owner IDs
        for (AR_Accounts_Receivable__c newRec : newList) {
            AR_Accounts_Receivable__c oldRec = (oldMap != null) ? oldMap.get(newRec.Id) : null;
            if (newRec.Injection_Status__c == 'ACC' && (oldRec == null || oldRec.Injection_Status__c != 'ACC')) {
                if (newRec.OwnerId != null) ownerIds.add(newRec.OwnerId);
            }
        }

        Map<Id, User> ownerMap = new Map<Id, User>();
        if (!ownerIds.isEmpty()) {
            ownerMap = new Map<Id, User>([
                SELECT Id, Name FROM User WHERE Id IN :ownerIds
            ]);
        }

        // Build archival records
        for (AR_Accounts_Receivable__c newRec : newList) {
            AR_Accounts_Receivable__c oldRec = (oldMap != null) ? oldMap.get(newRec.Id) : null;

            if (newRec.Injection_Status__c == 'ACC' && (oldRec == null || oldRec.Injection_Status__c != 'ACC')) {
                AR_Injection_Archival__c arch = new AR_Injection_Archival__c();

                // === Field mappings ===
                arch.AR_Debit_Id__c = newRec.AR_Debit_Id__c;
                arch.AR_Business_Entity_Id__c = newRec.AR_Business_Entity_Id__c;
                arch.AR_Patient_Id__c = newRec.AR_Patient_Id__c;
                arch.AR_Age_by_First_Billed__c = newRec.AR_Age_by_First_Billed__c;
                arch.AR_Age_by_Last_Billed__c = newRec.AR_Age_by_Last_Billed__c;
                arch.AR_Age_by_DOS__c = newRec.AR_Age_by_DOS__c;
                arch.AR_Balance__c = newRec.AR_Balance__c;
                arch.AR_Un_Applied__c = newRec.AR_Un_Applied__c;
                arch.AR_Responsibility__c = newRec.AR_Responsibility__c;
                arch.AR_Responsibility_Type__c = newRec.AR_Responsibility_Type__c;
                arch.AR_Location_Id__c = newRec.AR_Location_Id__c;
                arch.AR_Provider_Id__c = newRec.AR_Provider_Id__c;
                arch.AR_Payer_Id__c = newRec.AR_Payer_Id__c;
                arch.AR_Attending_Provider_Id__c = newRec.AR_Attending_Provider_Id__c;
                arch.AR_Policy_Type__c = newRec.AR_Policy_Type__c;
                arch.AR_Insurance_Profile__c = newRec.AR_Insurance_Profile__c;
                arch.AR_Effective_Date__c = newRec.AR_Effective_Date__c;
                arch.AR_Entered_Date__c = newRec.AR_Entered_Date__c;
                arch.AR_Procedure_Code__c = newRec.AR_Procedure_Code__c;
                arch.AR_Procedure_Description__c = newRec.AR_Procedure_Description__c;
                arch.AR_Modifier1_Code__c = newRec.AR_Modifier1_Code__c;
                arch.AR_Diagnosis1_Code__c = newRec.AR_Diagnosis1_Code__c;
                arch.AR_Units__c = newRec.AR_Units__c;
                arch.AR_Value_Balance__c = newRec.AR_Value_Balance__c;
                arch.AR_Insurance_Payments__c = newRec.AR_Insurance_Payments__c;
                arch.AR_Patient_Payments__c = newRec.AR_Patient_Payments__c;
                arch.AR_Insurance_Adjustments__c = newRec.AR_Insurance_Adjustments__c;
                arch.AR_Patient_Adjustments__c = newRec.AR_Patient_Adjustments__c;
                arch.AR_Amount__c = newRec.AR_Amount__c;
                arch.AR_Transaction_Status__c = newRec.AR_Transaction_Status__c;
                arch.AR_Transaction_Type__c = newRec.AR_Transaction_Type__c;
                arch.AR_Charge_Status__c = newRec.AR_Charge_Status__c;
                arch.AR_Responsibile_Party_Name__c = newRec.AR_Responsibile_Party_Name__c;
                arch.AR_Responsibile_Party_Relationship__c = newRec.AR_Responsibile_Party_Relationship__c;
                arch.AR_Last_Claim_Id__c = newRec.AR_Last_Claim_Id__c;
                arch.AR_Last_Billed_Date__c = newRec.AR_Last_Billed_Date__c;
                arch.AR_DOS__c = newRec.AR_DOS__c;
                arch.AR_Metadata_Time_Stamp__c = newRec.AR_Metadata_Time_Stamp__c;
                arch.AR_Patient_Account__c = newRec.AR_Patient_Account__c;
                arch.AR_Payer__c = newRec.AR_Payer__c;
                arch.AR_Provider__c = newRec.AR_Provider__c;
                arch.AR_Financial_Class__c = newRec.AR_Financial_Class__c;
                arch.AR_Location_Name__c = newRec.AR_Location_Name__c;
                arch.AR_Date_Worked__c = newRec.AR_Date_Worked__c;
                arch.Follow_Up_Date__c = newRec.Follow_Up_Date__c;
                arch.AR_Note__c = newRec.AR_Note__c;
                arch.AR_Denial_Date__c = newRec.AR_Denial_Date__c;
                arch.AR_Expected_Amount__c = newRec.AR_Expected_Amount__c;
                arch.Adjustment_Code_1_Description__c = newRec.Adjustment_Code_1_Description__c;
                arch.AR_External_Id__c = newRec.AR_External_Id__c;
                arch.AR_Credit_Id__c = newRec.AR_Credit_Id__c;
                arch.AR_Patient_Guid__c = newRec.AR_Patient_Guid__c;
                arch.Injection_Status__c = String.valueOf(newRec.Injection_Status__c);
                arch.AR_Priority_Status__c = String.valueOf(newRec.AR_Priority_Status__c);
                arch.AR_Team_Name__c = newRec.AR_Team_Name__c;
                arch.AR_Payment_Variance__c = String.valueOf(newRec.AR_Payment_Variance__c);

                // Owner Name
                User ownerRec = ownerMap.get(newRec.OwnerId);
                arch.AR_Assignment__c = (ownerRec != null) ? ownerRec.Name : null;

                archivalRecords.add(arch);
                recordsToDeleteIds.add(newRec.Id);
            }
        }

        if (!archivalRecords.isEmpty()) {
            insert archivalRecords;
            deleteRecordsAsync(recordsToDeleteIds);
        }
    }

    // === FUTURE METHOD for async delete ===
    @future
    public static void deleteRecordsAsync(List<Id> recordIds) {
        try {
            if (recordIds == null || recordIds.isEmpty()) return;
            List<AR_Accounts_Receivable__c> toDelete = [
                SELECT Id FROM AR_Accounts_Receivable__c WHERE Id IN :recordIds
            ];
            if (!toDelete.isEmpty()) {
                delete toDelete;
            }
        } catch (Exception e) {
            System.debug('Async delete failed: ' + e.getMessage());
        }
    }

    // === INVOCABLE WRAPPER (for Flow) ===
    public class ArchivalRequest {
        @InvocableVariable(required=true)
        public Id recordId;
    }

    @InvocableMethod(
        
        description='Archives AR_Accounts_Receivable__c records where Injection_Status__c = ACC'
    )
    public static void archiveFromFlow(List<ArchivalRequest> requests) {
        if (requests == null || requests.isEmpty()) return;

        // Extract Ids from requests
        List<Id> recordIds = new List<Id>();
        for (ArchivalRequest req : requests) {
            if (req != null && req.recordId != null) {
                recordIds.add(req.recordId);
            }
        }

        if (recordIds.isEmpty()) return;

        // Query records and reuse handler
        List<AR_Accounts_Receivable__c> accList = [
            SELECT Id, OwnerId, Injection_Status__c, AR_Priority_Status__c,
                   AR_Debit_Id__c, AR_Business_Entity_Id__c, AR_Patient_Id__c,
                   AR_Age_by_First_Billed__c, AR_Age_by_Last_Billed__c, AR_Age_by_DOS__c,
                   AR_Balance__c, AR_Un_Applied__c, AR_Responsibility__c, AR_Responsibility_Type__c,
                   AR_Location_Id__c, AR_Provider_Id__c, AR_Payer_Id__c, AR_Attending_Provider_Id__c,
                   AR_Policy_Type__c, AR_Insurance_Profile__c, AR_Effective_Date__c, AR_Entered_Date__c,
                   AR_Procedure_Code__c, AR_Procedure_Description__c, AR_Modifier1_Code__c,
                   AR_Diagnosis1_Code__c, AR_Units__c, AR_Value_Balance__c, AR_Insurance_Payments__c,
                   AR_Patient_Payments__c, AR_Insurance_Adjustments__c, AR_Patient_Adjustments__c,
                   AR_Amount__c, AR_Transaction_Status__c, AR_Transaction_Type__c, AR_Charge_Status__c,
                   AR_Responsibile_Party_Name__c, AR_Responsibile_Party_Relationship__c,
                   AR_Last_Claim_Id__c, AR_Last_Billed_Date__c, AR_DOS__c,
                   AR_Metadata_Time_Stamp__c, AR_Patient_Account__c, AR_Payer__c, AR_Provider__c,
                   AR_Financial_Class__c, AR_Location_Name__c, AR_Date_Worked__c,
                   Follow_Up_Date__c, AR_Note__c, AR_Denial_Date__c, AR_Expected_Amount__c,
                   Adjustment_Code_1_Description__c, AR_External_Id__c, AR_Credit_Id__c, AR_Patient_Guid__c,
                   AR_Team_Name__c, AR_Payment_Variance__c
            FROM AR_Accounts_Receivable__c
            WHERE Id IN :recordIds
        ];

        // Call existing archival logic
        handleArchival(accList, new Map<Id, AR_Accounts_Receivable__c>());
    }
}*/
public class AR_AccountsReceivableArchivalHandler {

    // === EXISTING HANDLER LOGIC ===
    public static void handleArchival(List<AR_Accounts_Receivable__c> newList, Map<Id, AR_Accounts_Receivable__c> oldMap) {
        if (newList == null || newList.isEmpty()) return;

        // ✅ New: Define archival statuses
        Set<String> archivalStatuses = new Set<String>{ 'ACC', 'A-PRJ', 'PLN', 'SPB', 'SPR', 'P-NAP' };

        List<AR_Injection_Archival__c> archivalRecords = new List<AR_Injection_Archival__c>();
        List<Id> recordsToDeleteIds = new List<Id>();
        Set<Id> ownerIds = new Set<Id>();

        // === Collect owner IDs ===
        for (AR_Accounts_Receivable__c newRec : newList) {
            AR_Accounts_Receivable__c oldRec = (oldMap != null) ? oldMap.get(newRec.Id) : null;

            // ✅ Updated condition
            if (archivalStatuses.contains(newRec.Injection_Status__c) &&
                (oldRec == null || !archivalStatuses.contains(oldRec.Injection_Status__c))) {
                if (newRec.OwnerId != null) ownerIds.add(newRec.OwnerId);
            }
        }

        Map<Id, User> ownerMap = new Map<Id, User>();
        if (!ownerIds.isEmpty()) {
            ownerMap = new Map<Id, User>([
                SELECT Id, Name FROM User WHERE Id IN :ownerIds
            ]);
        }

        // === Build archival records ===
        for (AR_Accounts_Receivable__c newRec : newList) {
            AR_Accounts_Receivable__c oldRec = (oldMap != null) ? oldMap.get(newRec.Id) : null;

            // ✅ Updated condition again
            if (archivalStatuses.contains(newRec.Injection_Status__c) &&
                (oldRec == null || !archivalStatuses.contains(oldRec.Injection_Status__c))) {

                AR_Injection_Archival__c arch = new AR_Injection_Archival__c();

                // === Field mappings ===
                arch.AR_Debit_Id__c = newRec.AR_Debit_Id__c;
                arch.AR_Business_Entity_Id__c = newRec.AR_Business_Entity_Id__c;
                arch.AR_Patient_Id__c = newRec.AR_Patient_Id__c;
                arch.AR_Age_by_First_Billed__c = newRec.AR_Age_by_First_Billed__c;
                arch.AR_Age_by_Last_Billed__c = newRec.AR_Age_by_Last_Billed__c;
                arch.AR_Age_by_DOS__c = newRec.AR_Age_by_DOS__c;
                arch.AR_Balance__c = newRec.AR_Balance__c;
                arch.AR_Un_Applied__c = newRec.AR_Un_Applied__c;
                arch.AR_Responsibility__c = newRec.AR_Responsibility__c;
                arch.AR_Responsibility_Type__c = newRec.AR_Responsibility_Type__c;
                arch.AR_Location_Id__c = newRec.AR_Location_Id__c;
                arch.AR_Provider_Id__c = newRec.AR_Provider_Id__c;
                arch.AR_Payer_Id__c = newRec.AR_Payer_Id__c;
                arch.AR_Attending_Provider_Id__c = newRec.AR_Attending_Provider_Id__c;
                arch.AR_Policy_Type__c = newRec.AR_Policy_Type__c;
                arch.AR_Insurance_Profile__c = newRec.AR_Insurance_Profile__c;
                arch.AR_Effective_Date__c = newRec.AR_Effective_Date__c;
                arch.AR_Entered_Date__c = newRec.AR_Entered_Date__c;
                arch.AR_Procedure_Code__c = newRec.AR_Procedure_Code__c;
                arch.AR_Procedure_Description__c = newRec.AR_Procedure_Description__c;
                arch.AR_Modifier1_Code__c = newRec.AR_Modifier1_Code__c;
                arch.AR_Diagnosis1_Code__c = newRec.AR_Diagnosis1_Code__c;
                arch.AR_Units__c = newRec.AR_Units__c;
                arch.AR_Value_Balance__c = newRec.AR_Value_Balance__c;
                arch.AR_Insurance_Payments__c = newRec.AR_Insurance_Payments__c;
                arch.AR_Patient_Payments__c = newRec.AR_Patient_Payments__c;
                arch.AR_Insurance_Adjustments__c = newRec.AR_Insurance_Adjustments__c;
                arch.AR_Patient_Adjustments__c = newRec.AR_Patient_Adjustments__c;
                arch.AR_Amount__c = newRec.AR_Amount__c;
                arch.AR_Transaction_Status__c = newRec.AR_Transaction_Status__c;
                arch.AR_Transaction_Type__c = newRec.AR_Transaction_Type__c;
                arch.AR_Charge_Status__c = newRec.AR_Charge_Status__c;
                arch.AR_Responsibile_Party_Name__c = newRec.AR_Responsibile_Party_Name__c;
                arch.AR_Responsibile_Party_Relationship__c = newRec.AR_Responsibile_Party_Relationship__c;
                arch.AR_Last_Claim_Id__c = newRec.AR_Last_Claim_Id__c;
                arch.AR_Last_Billed_Date__c = newRec.AR_Last_Billed_Date__c;
                arch.AR_DOS__c = newRec.AR_DOS__c;
                arch.AR_Metadata_Time_Stamp__c = newRec.AR_Metadata_Time_Stamp__c;
                arch.AR_Patient_Account__c = newRec.AR_Patient_Account__c;
                arch.AR_Payer__c = newRec.AR_Payer__c;
                arch.AR_Provider__c = newRec.AR_Provider__c;
                arch.AR_Financial_Class__c = newRec.AR_Financial_Class__c;
                arch.AR_Location_Name__c = newRec.AR_Location_Name__c;
                arch.AR_Date_Worked__c = newRec.AR_Date_Worked__c;
                arch.Follow_Up_Date__c = newRec.Follow_Up_Date__c;
                arch.AR_Note__c = newRec.AR_Note__c;
                arch.AR_Denial_Date__c = newRec.AR_Denial_Date__c;
                arch.AR_Expected_Amount__c = newRec.AR_Expected_Amount__c;
                arch.Adjustment_Code_1_Description__c = newRec.Adjustment_Code_1_Description__c;
                arch.AR_External_Id__c = newRec.AR_External_Id__c;
                arch.AR_Credit_Id__c = newRec.AR_Credit_Id__c;
                arch.AR_Patient_Guid__c = newRec.AR_Patient_Guid__c;
                arch.Injection_Status__c = String.valueOf(newRec.Injection_Status__c);
                arch.AR_Priority_Status__c = String.valueOf(newRec.AR_Priority_Status__c);
                arch.AR_Team_Name__c = newRec.AR_Team_Name__c;
                arch.AR_Payment_Variance__c = String.valueOf(newRec.AR_Payment_Variance__c);

                // === Owner Name ===
                User ownerRec = ownerMap.get(newRec.OwnerId);
                arch.AR_Assignment__c = (ownerRec != null) ? ownerRec.Name : null;

                archivalRecords.add(arch);
                recordsToDeleteIds.add(newRec.Id);
            }
        }

        if (!archivalRecords.isEmpty()) {
            insert archivalRecords;
            deleteRecordsAsync(recordsToDeleteIds);
        }
    }

    // === FUTURE METHOD for async delete ===
    @future
    public static void deleteRecordsAsync(List<Id> recordIds) {
        try {
            if (recordIds == null || recordIds.isEmpty()) return;
            List<AR_Accounts_Receivable__c> toDelete = [
                SELECT Id FROM AR_Accounts_Receivable__c WHERE Id IN :recordIds
            ];
            if (!toDelete.isEmpty()) {
                delete toDelete;
            }
        } catch (Exception e) {
            System.debug('Async delete failed: ' + e.getMessage());
        }
    }

    // === INVOCABLE WRAPPER (for Flow) ===
    public class ArchivalRequest {
        @InvocableVariable(required=true)
        public Id recordId;
    }

    @InvocableMethod(
        description='Archives AR_Accounts_Receivable__c records where Injection_Status__c in (ACC, A-PRJ, PLN, SPB, SPR, P-NAP)'
    )
    public static void archiveFromFlow(List<ArchivalRequest> requests) {
        if (requests == null || requests.isEmpty()) return;

        List<Id> recordIds = new List<Id>();
        for (ArchivalRequest req : requests) {
            if (req != null && req.recordId != null) {
                recordIds.add(req.recordId);
            }
        }

        if (recordIds.isEmpty()) return;

        List<AR_Accounts_Receivable__c> accList = [
            SELECT Id, OwnerId, Injection_Status__c, AR_Priority_Status__c,
                   AR_Debit_Id__c, AR_Business_Entity_Id__c, AR_Patient_Id__c,
                   AR_Age_by_First_Billed__c, AR_Age_by_Last_Billed__c, AR_Age_by_DOS__c,
                   AR_Balance__c, AR_Un_Applied__c, AR_Responsibility__c, AR_Responsibility_Type__c,
                   AR_Location_Id__c, AR_Provider_Id__c, AR_Payer_Id__c, AR_Attending_Provider_Id__c,
                   AR_Policy_Type__c, AR_Insurance_Profile__c, AR_Effective_Date__c, AR_Entered_Date__c,
                   AR_Procedure_Code__c, AR_Procedure_Description__c, AR_Modifier1_Code__c,
                   AR_Diagnosis1_Code__c, AR_Units__c, AR_Value_Balance__c, AR_Insurance_Payments__c,
                   AR_Patient_Payments__c, AR_Insurance_Adjustments__c, AR_Patient_Adjustments__c,
                   AR_Amount__c, AR_Transaction_Status__c, AR_Transaction_Type__c, AR_Charge_Status__c,
                   AR_Responsibile_Party_Name__c, AR_Responsibile_Party_Relationship__c,
                   AR_Last_Claim_Id__c, AR_Last_Billed_Date__c, AR_DOS__c,
                   AR_Metadata_Time_Stamp__c, AR_Patient_Account__c, AR_Payer__c, AR_Provider__c,
                   AR_Financial_Class__c, AR_Location_Name__c, AR_Date_Worked__c,
                   Follow_Up_Date__c, AR_Note__c, AR_Denial_Date__c, AR_Expected_Amount__c,
                   Adjustment_Code_1_Description__c, AR_External_Id__c, AR_Credit_Id__c, AR_Patient_Guid__c,
                   AR_Team_Name__c, AR_Payment_Variance__c
            FROM AR_Accounts_Receivable__c
            WHERE Id IN :recordIds
        ];

        handleArchival(accList, new Map<Id, AR_Accounts_Receivable__c>());
    }
}