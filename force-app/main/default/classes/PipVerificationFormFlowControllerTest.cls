@isTest
public class PipVerificationFormFlowControllerTest {
    @isTest static void testPipFormFlow() {
        Account acc = new Account(Name ='Test');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate= Date.today();
        opp.StageName= 'Initial Appointment';
        opp.Mid_Back_Pain__c = true;
        opp.Neck_Pain__c = true;
        opp.Lower_Back_Pain_Sciatica__c = true;
        opp.Leg_Pain__c = true;
        opp.Knee_Pain__c = true;
        opp.Hip_Pain__c = true;
        opp.Foot_Ankle_Pain__c = true;
        opp.Shoulder_Pain__c = true;
        opp.Elbow_Pain__c = true;
        opp.Wrist_Hand_Pain__c = true;
        opp.Scoliosis__c = true;
        opp.Headache_Migraine__c = true;
        opp.Vertigo__c = true;
        opp.Neurological_Condition__c = true;
        opp.Wellness_No_Pain__c = true;
        opp.Other_Condition__c = true;
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.PIP_Patient_Date_of_Birth__c = System.today();
        cs.Intake__c = opp.Id;
        cs.Patient_VOB__c = acc.Id;
        // cs.ClosedDate = Date.today();
        cs.Subject = 'test subject';
        cs.PIP_Date_of_Loss__c = System.today();
        insert cs;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        PipVerificationFormFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
    
    @isTest static void testPipFormFlow2() {
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.PIP_Patient_Date_of_Birth__c = System.today();
        // cs.ClosedDate = Date.today();
        cs.Subject = 'test subject';
        cs.PIP_Date_of_Loss__c = System.today();
        insert cs;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        PipVerificationFormFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
}