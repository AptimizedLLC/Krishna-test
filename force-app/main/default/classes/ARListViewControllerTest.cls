@IsTest
public class ARListViewControllerTest {
    
    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'testAccount');
        insert acc;

        AR_Accounts_Receivable__c a = new AR_Accounts_Receivable__c();
        a.AR_Patient_Account__c = acc.Id;
        a.AR_Age_by_Last_Billed__c = '84';
        a.AR_Procedure_Code__c = '97530';
        a.AR_Amount__c = 200;
        a.AR_Last_Billed_Date__c = Date.today();
        a.AR_DOS__c = Date.today();
        a.AR_Payer__c = 'GHI';
        a.AR_Provider__c = 'COLON CHARLIZE';
        a.AR_Priority_Status__c = 'NEW';
        a.AR_Location_Name__c = 'BLOOMFIELD OFFICE';
        a.AR_Denial_Date__c = Date.today();
        a.AR_Expected_Amount__c = '3200';
        a.Injection_Status__c = 'PLN';
        a.AR_Date_Worked__c = Date.today();
        a.Follow_Up_Date__c = Date.today();
        a.AR_Note__c = 'test';
        a.Adjustment_Code_1_Description__c = 'Payment made to patient/insured/responsible party/employer.';
        a.OwnerId = Userinfo.getUserId();
        insert a;
    }
	
    @isTest
    static void getARRecordsTest() {
        Test.startTest();
        ARListViewController.ARPaginationWrapper ac = ARListViewController.getARRecords('97530', 'NEW', 1, 100, 'COLON', 'test', 'GHI', 'CreatedDate', 'DESC','=',String.valueOf(Date.today()),'=', String.valueOf(Date.today()),'=',String.valueOf(Date.today()),'Injection Workbook');
        Test.stopTest();
    }
}