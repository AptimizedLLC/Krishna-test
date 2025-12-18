@isTest
public class PicklistControllerTest {
    @TestSetup
    public static void dataSetup(){
        List<Transaction_Log__c> translist = new List<Transaction_Log__c>();
        Transaction_Log__c trans1 = new Transaction_Log__c();
        trans1.Class_Name__c = 'OpportunityTriggerHandler';
        trans1.Custom_Message__c = 'Intake error Id - 0068I000002K5voABC';
        trans1.Error_Log__c = 'Class.CareCloudAuthConnection.uploadPatientDocument: line 148, column 1Class.OpportunityTriggerHandler.sendDocumentToCareCloud: line 16, column 1Trigger.OpportunityTrigger: line 4, column 1<br/>Callout from triggers are currently not supported.<br/>null <br/>System.CalloutException';
        // trans1.Error_Log_Time__c = DateTime.valueOf('2022-04-28T12:45:41.000+0000') ; 
        trans1.Error_Log_Time__c = Datetime.valueOfGMT('2022-04-28 12:45:41') ;
        trans1.Method_Name__c = 'sendDocumentToCareCloud'; 
        trans1.Review_Comment__c = 'No Comment';
        trans1.Status__c = 'New';
        translist.add(trans1);
        
        Transaction_Log__c trans2 = new Transaction_Log__c();
        trans2.Class_Name__c = 'OpportunityTriggerHandler';
        trans2.Custom_Message__c = 'Intake error Id - 0068I000002K5voDEF';
        trans2.Error_Log__c = 'Class.CareCloudAuthConnection.uploadPatientDocument: line 148, column 1Class.OpportunityTriggerHandler.sendDocumentToCareCloud: line 16, column 1Trigger.OpportunityTrigger: line 4, column 1<br/>Callout from triggers are currently not supported.<br/>null <br/>System.CalloutException';
        trans2.Error_Log_Time__c = Datetime.valueOfGMT('2022-04-30 12:45:41'); 
        trans2.Method_Name__c = 'sendDocumentToCareCloud'; 
        trans2.Review_Comment__c = 'No Comment';
        trans2.Status__c = 'New';
        translist.add(trans2);
        
        Transaction_Log__c trans3 = new Transaction_Log__c();
        trans3.Class_Name__c = 'CareCloudAuthConnection';
        trans3.Custom_Message__c = 'Intake error Id - 0068I000002K5voDEF';
        trans3.Error_Log__c = 'Class.PatientDocumentSyncBatch.start: line 27, column 1<br/>List index out of bounds: 0<br/>null <br/>System.ListException';
        trans3.Error_Log_Time__c = Datetime.valueOfGMT('2022-05-11 17:03:32'); 
        trans3.Method_Name__c = 'uploadPatientDocument'; 
        trans3.Review_Comment__c = 'No Comment';
        trans3.Status__c = 'New';
        translist.add(trans3);
        
        insert translist;
    }
    
    @isTest static void getPickListValuesTest() {
        Test.startTest();
        List<Transaction_Log__c> transRecordList = [SELECT Id, Name,CreatedDate, Custom_Message__c, Status__c, Review_Comment__c, Method_Name__c, 
                                           Error_Log_Time__c, Error_Log__c, Class_Name__c FROM Transaction_Log__c]; 
        List < Map < String, String >>  pickVals = PicklistController.getPickListValues('Transaction_Log__c', 'Status__c');
        Test.stopTest();
    }
    
    @isTest static void getFieldLabelTest() {
        Test.startTest();
        List<Transaction_Log__c> transRecordList = [SELECT Id, Name,CreatedDate, Custom_Message__c, Status__c, Review_Comment__c, Method_Name__c, 
                                           Error_Log_Time__c, Error_Log__c, Class_Name__c FROM Transaction_Log__c]; 
        String pickLabel = PicklistController.getFieldLabel('Transaction_Log__c', 'Status__c');
        Test.stopTest();
    }
    
    @isTest static void getFieldLabelTestEx() {
        Test.startTest();
        List<Transaction_Log__c> transRecordList = [SELECT Id, Name,CreatedDate, Custom_Message__c, Status__c, Review_Comment__c, Method_Name__c, 
                                           Error_Log_Time__c, Error_Log__c, Class_Name__c FROM Transaction_Log__c]; 
        String pickLabel = PicklistController.getFieldLabel('Transaction_Log', 'Status');
        Test.stopTest();
    }
}