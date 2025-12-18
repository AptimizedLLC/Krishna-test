/*
    @Created Date : 28-April-2022
    @Description : Capture Log record if there is any Error while processing 
*/
public class TransactionLogHandler {
    public static void doHandleException(System.Exception ex, String className, String methodName) {
        Transaction_Log__c logRecord = new Transaction_Log__c(
            Error_Log__c = ex.getStackTraceString() +'<br/>' + ex.getMessage() + '<br/>' + ex.getCause() +' <br/>'+ ex.getTypeName(),
            Error_Log_Time__c = System.Now(),
            Status__c = 'New',
            Class_Name__c = className,
            Method_Name__c = methodName
        );

        if(Schema.sObjectType.Transaction_Log__c.isCreateable()){
            insert logRecord;
        }
    }
    
    public static void doHandleCustomException(System.Exception ex, String customMsg, String className, String methodName) {
        Transaction_Log__c logRecord = new Transaction_Log__c(
            Error_Log__c = ex.getStackTraceString() +'<br/>' + ex.getMessage() + '<br/>' + ex.getCause() +' <br/>'+ ex.getTypeName(),
            Custom_Message__c = customMsg,
            Error_Log_Time__c = System.Now(),
            Status__c = 'New',
            Class_Name__c = className,
            Method_Name__c = methodName
        );

        if(Schema.sObjectType.Transaction_Log__c.isCreateable()){
            insert logRecord;
        }
    }
    
    public static void doHandleCustomException(String customLog, String customMsg, String className, String methodName) {
        Transaction_Log__c logRecord = new Transaction_Log__c(
            Error_Log__c = customLog,
            Custom_Message__c = customMsg,
            Error_Log_Time__c = System.Now(),
            Status__c = 'New',
            Class_Name__c = className,
            Method_Name__c = methodName
        );

        if(Schema.sObjectType.Transaction_Log__c.isCreateable()){
            insert logRecord;
        }
    }
}