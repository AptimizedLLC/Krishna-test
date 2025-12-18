@isTest
public class WorkerCompVerificationFlowControllerTest {
    @isTest static void testWorkerCompForm() {
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
        cs.Intake__c = opp.Id;
        cs.Patient_VOB__c = acc.Id;
        cs.Subject = 'test subject';
        insert cs;
        
        Insurance_Plan__c ins = new Insurance_Plan__c();
        ins.Patient_Name__c = 'Test Name';
        ins.VOB_Case__c = cs.Id;
        ins.Chiro_Visits_Combined__c = 'yes';
        ins.Authorization_Required_for_Chiro__c = true;
        ins.How_to_Obtain_Acupuncture_Authorization__c = '8457598255';
        ins.Can_patient_treat_at_ASC__c = 'Yes'; 
        ins.Authorization_Required_for_Acupuncture__c = true;
        ins.Authorization_Required_for_DME__c = true;
        ins.Authorization_Required_for_OT__c = true;
        ins.Authorization_Required_for_Procedures__c = true;
        
        insert ins;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        WorkerCompVerificationFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
    @isTest static void testWorkerCompForm2() {
        Account acc = new Account(Name ='Test');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate= Date.today();
        opp.StageName= 'Initial Appointment';
        opp.Mid_Back_Pain__c = true;
        opp.Neck_Pain__c = true;
        opp.Lower_Back_Pain_Sciatica__c = true;
        
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Intake__c = opp.Id;
        cs.Subject = 'test subject';
        insert cs;
        
        Insurance_Plan__c ins = new Insurance_Plan__c();
        ins.Patient_Name__c = 'Test Name';
        ins.VOB_Case__c = cs.Id;
        ins.Chiro_Visits_Combined__c = 'yes';
        ins.Authorization_Required_for_Chiro__c = true;
        ins.How_to_Obtain_Acupuncture_Authorization__c = '8457598255';
        ins.Can_patient_treat_at_ASC__c = 'Yes'; 
       
        insert ins;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        WorkerCompVerificationFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
}