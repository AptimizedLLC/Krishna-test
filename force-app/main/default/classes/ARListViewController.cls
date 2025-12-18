public with sharing class ARListViewController {
    
    @AuraEnabled
    public static ARPaginationWrapper getARRecords(String searchKey, 
                                                    String status, 
                                                    Integer pageNumber, 
                                                    Integer pageSize, 
                                                    String providerSearchKey, 
                                                    String patientSearchKey, 
                                                    String payerSearchKey, 
                                                    String sortBy, 
                                                    String sortDirection,
                                                    String selectedDOSOperator, 
                                                    String dosSearchKey,
                                                    String selectedDDOperator, 
                                                    String ddSearchKey,
                                                    String selectedLBDOperator,
                                                    String lbdSearchKey,
                                                    String viewType) {
        Id currentUserId = UserInfo.getUserId();
        Integer offsetSize = (pageNumber - 1) * pageSize;
        
        String baseQuery =
            'SELECT Id, Name, CreatedDate, AR_Patient_Account__r.Name, AR_DOS__c, AR_Provider__c,AR_Payment_Variance__c, ' +
            'AR_Procedure_Code__c, AR_Location_Name__c, AR_Payer__c, AR_Age_by_Last_Billed__c, AR_Last_Billed_Date__c, ' +
            'AR_Denial_Date__c, AR_Amount__c, AR_Expected_Amount__c, Injection_Status__c,  AR_Date_Worked__c, Follow_Up_Date__c, AR_Note__c, ' +
            'AR_Priority_Status__c,Adjustment_Code_1_Description__c, Owner.Name, Workbook_Category__c ' +
            'FROM AR_Accounts_Receivable__c WHERE Id != null ';
        
        String countQuery = 'SELECT COUNT() FROM AR_Accounts_Receivable__c WHERE Id != null ';

        if(String.isNotBlank(viewType)){
            baseQuery += ' AND Workbook_Category__c = :viewType ';
            countQuery += ' AND Workbook_Category__c = :viewType ';
        }
        
        if (String.isNotBlank(searchKey)) {
            baseQuery += ' AND (Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Patient_Account__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Provider__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Location_Name__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Payer__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Age_by_Last_Billed__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR Adjustment_Code_1_Description__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Expected_Amount__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Priority_Status__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR Owner.Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ';
            
            countQuery += ' AND (Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Patient_Account__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Provider__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Location_Name__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Payer__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Age_by_Last_Billed__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR Adjustment_Code_1_Description__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Expected_Amount__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR AR_Priority_Status__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ' +
                'OR Owner.Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\' ';
            
            if (searchKey.isNumeric()) {
                baseQuery += 'OR AR_Amount__c = ' + searchKey +
                    ' OR AR_Payment_Variance__c = ' + searchKey + ' ';
                countQuery += 'OR AR_Amount__c = ' + searchKey +
                    ' OR AR_Payment_Variance__c = ' + searchKey + ' ';
            }
            
            baseQuery += 'OR AR_Procedure_Code__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\')';
            countQuery += 'OR AR_Procedure_Code__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\')';
        }
        
        
        if (String.isNotBlank(providerSearchKey)) {
            if(providerSearchKey.toLowerCase() == 'none'){
                baseQuery += ' AND AR_Provider__c = NULL ';
                countQuery += ' AND AR_Provider__c = NULL ';
            }else{
                baseQuery += ' AND AR_Provider__c LIKE \'%' + String.escapeSingleQuotes(providerSearchKey) + '%\'';
                countQuery += ' AND AR_Provider__c LIKE \'%' + String.escapeSingleQuotes(providerSearchKey) + '%\'';
            }
        }
        
        if (String.isNotBlank(patientSearchKey)) {
            if(patientSearchKey.toLowerCase() == 'none'){
                baseQuery += ' AND AR_Patient_Account__r.Name = NULL ';
                countQuery += ' AND AR_Patient_Account__r.Name = NULL ';
            }else{
                baseQuery += ' AND AR_Patient_Account__r.Name LIKE \'%' + String.escapeSingleQuotes(patientSearchKey) + '%\'';
                countQuery += ' AND AR_Patient_Account__r.Name LIKE \'%' + String.escapeSingleQuotes(patientSearchKey) + '%\'';
            }
        }
        
        if (String.isNotBlank(payerSearchKey)) {
            if(payerSearchKey.toLowerCase() == 'none'){
                baseQuery += ' AND AR_Payer__c = NULL ';
                countQuery += ' AND AR_Payer__c = NULL ';
            }else{
                baseQuery += ' AND AR_Payer__c LIKE \'%' + String.escapeSingleQuotes(payerSearchKey) + '%\'';
                countQuery += ' AND AR_Payer__c LIKE \'%' + String.escapeSingleQuotes(payerSearchKey) + '%\'';
            }
        }
        
        
        if (String.isNotBlank(status)) {
            if(status == 'Archived'){
                baseQuery += ' AND Injection_Status__c IN (\'ACC\', \'SPB\', \'PLN\', \'SPR\', \'P-NAP\', \'A-PRJ\')';
                countQuery += ' AND Injection_Status__c IN (\'ACC\', \'SPB\', \'PLN\', \'SPR\', \'P-NAP\', \'A-PRJ\')';
            } else {
                baseQuery += ' AND AR_Priority_Status__c = \'' + String.escapeSingleQuotes(status) + '\'';
                countQuery += ' AND AR_Priority_Status__c = \'' + String.escapeSingleQuotes(status) + '\'';
            }
        }

        Date dosDate;
        if (String.isNotBlank(dosSearchKey) && String.isNotBlank(selectedDOSOperator)){
            try {
                    dosDate = Date.valueOf(dosSearchKey);
                    baseQuery += ' AND AR_DOS__c ' + selectedDOSOperator + ' ' + ':dosDate ';
                    countQuery += ' AND AR_DOS__c ' + selectedDOSOperator + ' ' + ':dosDate ';
                } catch (Exception e) {
                    System.debug('Invalid Date Format for dosSearchKey: ' + dosSearchKey);
            }
		}
		Date lbdDate;
		if (String.isNotBlank(lbdSearchKey) && String.isNotBlank(selectedLBDOperator)){
            try {
                lbdDate = Date.valueOf(lbdSearchKey);
			baseQuery += ' AND AR_Last_Billed_Date__c ' + selectedLBDOperator + ' ' + ':lbdDate ';
			countQuery += ' AND AR_Last_Billed_Date__c ' + selectedLBDOperator + ' ' + ':lbdDate ';
             } catch (Exception e) {
        System.debug('Invalid Date Format for lbdSearchKey: ' + lbdSearchKey);
    }
		}
		Date ddDate;
		if (String.isNotBlank(ddSearchKey) && String.isNotBlank(selectedDDOperator)){
            try {
            ddDate = Date.valueOf(ddSearchKey);
                baseQuery += ' AND AR_Denial_Date__c ' + selectedDDOperator + ' ' + ':ddDate ';
                countQuery += ' AND AR_Denial_Date__c ' + selectedDDOperator + ' ' + ':ddDate ';
             } catch (Exception e) {
        System.debug('Invalid Date Format for ddSearchKey: ' + ddSearchKey);
    }
		} 
        
        //Set<String> allowedFields = new Set<String>{ 'AR_Procedure_Code__c', 'CreatedDate', 'AR_Location_Name__c', 'AR_DOS__c', 'Follow_Up_Date__c', 'Injection_Status__c', 'AR_Patient_Account__r.Name','AR_Provider__c','' };
        //String sortField = (String.isNotBlank(sortBy) && allowedFields.contains(sortBy)) ? sortBy : 'AR_Patient_Account__r.Name';
        String sortField;
        if(String.isNotBlank(sortBy) && sortBy == 'PatientName'){
            sortField = 'AR_Patient_Account__r.Name';
        } else if(String.isNotBlank(sortBy)) {
            sortField = (String.isNotBlank(sortBy)) ? sortBy : 'AR_Patient_Account__r.Name';
        }
        
        String sortDir = (sortDirection == 'asc' || sortDirection == 'ASC') ? 'ASC' : 'DESC';
        
        String finalQuery = '';
        if(sortDir == 'asc') {
             finalQuery = baseQuery + ' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT :pageSize OFFSET :offsetSize';
        } else {
             finalQuery = baseQuery + ' ORDER BY ' + sortField + ' ' + sortDir + ' nulls last LIMIT :pageSize OFFSET :offsetSize';
        }
        System.debug('final Query '+finalQuery);
        System.debug('Count Query '+countQuery);
        Integer totalRecords;
        List<AR_Accounts_Receivable__c> results;
        if(String.isNotBlank(viewType)){
            results = Database.query(finalQuery);
            totalRecords = (Integer)Database.countQuery(countQuery);
        }
        return new ARPaginationWrapper(results, totalRecords);
    }
    
    @AuraEnabled
    public static void updateARRecords(List<AR_Accounts_Receivable__c> updatedRecords) {
        if (updatedRecords == null || updatedRecords.isEmpty()) return;
        update updatedRecords;
    }
    
    public class ARPaginationWrapper {
        @AuraEnabled public List<AR_Accounts_Receivable__c> records;
        @AuraEnabled public Integer totalRecords;
        
        public ARPaginationWrapper(List<AR_Accounts_Receivable__c> records, Integer totalRecords) {
            this.records = records;
            this.totalRecords = totalRecords;
        }
    }
}