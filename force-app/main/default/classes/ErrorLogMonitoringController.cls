public class ErrorLogMonitoringController {
    
    @AuraEnabled(cacheable=true)
    public static String findLogs (String searchDate,String searchClassName, String searchStatus, Integer pageSize, Integer pageNumber) {
        /* System.debug('::: Date ---'+searchDate);
        System.debug('::: className ---'+searchClassName);
        System.debug('::: Seach Status - '+searchStatus);
        System.debug('::: pageSize -'+pageSize);
        System.debug('::: pageNumber -'+pageNumber);*/
        
        String jsonDT = '';
        
        String queryStr = 'SELECT Id, Name, Custom_Message__c, Status__c, Review_Comment__c, Method_Name__c, Error_Log_Time__c, Error_Log__c, Class_Name__c FROM Transaction_Log__c';
        
        String countqueryStr = 'SELECT count() FROM Transaction_Log__c';
        
        if((searchDate != null && searchDate != '') || (searchClassName != null && searchClassName != '') || (searchStatus != null && searchStatus != '')) {
            queryStr += ' WHERE ';
            countqueryStr += ' WHERE ';
            
            if(searchClassName != '' && searchClassName != null && searchStatus != null && searchStatus != '' && searchDate != null && searchDate != ''){
                queryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND Status__c = '+'\''+searchStatus+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                countqueryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND Status__c = '+'\''+searchStatus+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                //System.de
            }else if(searchClassName != '' && searchClassName != null && searchStatus != null && searchStatus != ''){
                queryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND Status__c = '+'\''+searchStatus+'\'';
                countqueryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND Status__c = '+'\''+searchStatus+'\'';
                
            }else if(searchClassName != '' && searchClassName != null  && searchDate != null && searchDate != ''){
                queryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                countqueryStr += 'Class_Name__c = '+'\''+searchClassName+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                
            }else if( searchStatus != null && searchStatus != '' && searchDate != null && searchDate != ''){
                queryStr +=  'Status__c = '+'\''+searchStatus+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                countqueryStr +=  'Status__c = '+'\''+searchStatus+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate;
                
            }else if(searchClassName != null && searchClassName != '') {
                queryStr += ' Class_Name__c = '+'\''+searchClassName+'\'';
                countqueryStr += ' Class_Name__c = '+'\''+searchClassName+'\'';
                
            }else if(searchStatus != null && searchStatus != '') {
                queryStr += ' Status__c = '+'\''+searchStatus+'\'';
                countqueryStr += ' Status__c = '+'\''+searchStatus+'\'';
                
            }else if(searchDate != null && searchDate != '') {
                queryStr += 'DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate ;
                countqueryStr += 'DAY_ONLY(convertTimezone(CreatedDate)) = '+searchDate ;
            }
        }
        queryStr += ' Order By CreatedDate desc';
        // System.debug('::: Query String - '+queryStr);
        List<Transaction_Log__c> dataList = new List<Transaction_Log__c>();
        dataList = Database.query(queryStr);
        Integer totalRecords = Database.countQuery(countqueryStr);
        
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
        Integer recordEnd = pageSize * pageNumber;
        //System.debug(':::: totalRecords--'+totalRecords);
        
        TranslogDTWrapper objDT =  new TranslogDTWrapper();  
        objDT.pageSize = pageSize;
        objDT.pageNumber = pageNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        queryStr += ' limit ' + pageSize + ' offset ' + offset;
        //System.debug('Data limit--'+queryStr);
        objDT.dataListlimit = Database.query(queryStr);
        //System.debug(':::: Datat--'+objDT.dataListlimit);
        jsonDT = JSON.serialize(objDT);
        //System.debug(':::: Datatt--'+jsonDT);
        return jsonDT;
    }
    
    public class TranslogDTWrapper {
        public Integer pageSize {get;set;}
        public Integer pageNumber {get;set;}
        public Integer totalRecords {get;set;}
        public Integer recordStart {get;set;}
        public Integer recordEnd {get;set;}
        public List<Transaction_Log__c> dataListlimit {get;set;}
    }
}