@isTest
public class ARSurgListViewControllerTest {
    @testsetup
    static void setupData(){
        Account acc = new Account();
        acc.Name = 'testAccount';
        insert acc;
        AR_Surg_Accounts_Receivable__c  a = new AR_Surg_Accounts_Receivable__c();
        a.AR_Patient_Account__c = acc.Id;
        a.AR_Debit_Id__c = '325582450';
      a.AR_Debit_Id__c ='325582450';
    a.AR_Business_Entity_Id__c = '6049';
    a.AR_Patient_Id__c = '139362113';
    a.AR_Age_by_First_Billed__c = '156';
    a.AR_Age_by_Last_Billed__c = '84';
    a.AR_Age_by_DOS__c = '170';
    a.AR_Balance__c = '5.45';
    a.AR_Un_Applied__c = '0';
    a.AR_Responsibility__c = 'Insurance';
    a.AR_Responsibility_Type__c = 'Tertiary';
    a.AR_Location_Id__c = '44812';
    a.AR_Provider_Id__c = '39919';
    a.AR_Payer_Id__c = '1538';
    a.AR_Attending_Provider_Id__c = 3991;
    a.AR_Policy_Type__c = 'Medicare Supplement';
    a.AR_Insurance_Profile__c = 'Auto /MEDICARE B/GHI 10.16';
    a.AR_Effective_Date__c = Date.today();
    a.AR_Entered_Date__c = Date.today();
    a.AR_Procedure_Code__c = '97530';
    a.AR_Procedure_Description__c = 'THERAPEUTIC ACTIVITIES';
    a.AR_Modifier1_Code__c = 'GO';
    a.AR_Diagnosis1_Code__c = 'M25.511';
    a.AR_Units__c = 1;
    a.AR_Value_Balance__c = 115.09;
    a.AR_Insurance_Payments__c = 21.34;
    a.AR_Patient_Payments__c = 0;
    a.AR_Insurance_Adjustments__c = '172.77';
    a.AR_Amount__c = 200;
    a.AR_Transaction_Status__c = 'Posted';
    a.AR_Transaction_Type__c = 'Charge';
    a.AR_Charge_Status__c = 'Denied';
    a.AR_Responsibile_Party_Name__c = 'AMARNATH MUKHOPADHYAY';
    a.AR_Responsibile_Party_Relationship__c = 'Self';
    a.AR_Last_Claim_Id__c = '161696354';
    a.AR_Last_Billed_Date__c = Date.today();
    a.AR_DOS__c = Date.today();
    a.AR_Metadata_Time_Stamp__c = Date.today();
    a.AR_Patient_Account__c = '001U800000P33XAIAZ';
    a.AR_Payer__c = 'GHI';
    a.AR_Provider__c = 'COLON CHARLIZE';
    a.AR_Financial_Class__c = 'Out of State';
    a.AR_Location_Name__c = 'EAST BRUNSWICK OFFICE';
    a.AR_Re_Routing__c = true;
    a.Adjustment_Code_1_Description__c = 'Payer refund due to overpayment.';
    a.AR_Patient_Guid__c = 'd6920d87-7b3f-4c47-ba0f-0bbe43f1f8d7';
    a.AR_Denial_Date__c = Date.today();
        a.AR_Priority_Status__c = 'NEW';
        
        insert a;
    }
	
    @isTest
    static void getARRecordsTest(){
        LIST<AR_Surg_Accounts_Receivable__c> a = [SELECT Id, Name, CreatedDate, AR_Patient_Account__r.Name, AR_DOS__c, AR_Provider__c,AR_Payment_Variance__c, AR_Procedure_Code__c, AR_Location_Name__c, AR_Payer__c, AR_Age_by_Last_Billed__c, AR_Last_Billed_Date__c,AR_Denial_Date__c, AR_Amount__c, AR_Expected_Amount__c, Injection_Status__c,  AR_Date_Worked__c, Follow_Up_Date__c, AR_Note__c,AR_Priority_Status__c,Adjustment_Code_1_Description__c, Owner.Name FROM AR_Surg_Accounts_Receivable__c];
        ARSurgListViewController.ARPaginationWrapper ac =	ARSurgListViewController.getARRecords('97530', 'NEW', 1, 100, 'COLON', 'test', 'GHI', 'CreatedDate', 'DESC','=',String.valueOf(Date.today()),'=', String.valueOf(Date.today()),'=',String.valueOf(Date.today()));
    }
}