@isTest
public class InsurancePlanDocFlowControllerTest {
    @isTest static void testInsurancePlanDocs() {
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
        ins.Authorization_Required_for_PT__c = true;
        ins.Billable_Time_Limit_For_A4556__c = 'Billable time';
        ins.Billable_Time_Limit_For_A4557__c = '';
        ins.Billable_Time_Limit_For_E0218__c = '';
        ins.Billable_Time_Limit_For_E0748__c = '';
        ins.Call_Length__c = '';
        ins.Call_Reference_Number__c = '';
        ins.Can_Out_Of_Network_Provider_Treat_Here__c = '';
        ins.Can_we_buy_and_bill_injection_codes__c = '';
        ins.Claim_Number__c = '';
        ins.Claims_Address__c = '';
        ins.Conservative_Modalities_Combined_Per_Day__c = true;
        ins.Count_As_1_Or_2_Visits__c = '';
        ins.DME_Benefits_Notes__c = 'DME Benefits Notes';
        ins.DME_Diagnosis_Codes__c = '';
        ins.DME_Diagnosis_Dependent__c = true;
        ins.E0218__c = '';
        ins.Group_Number__c = '';
        ins.How_Is_Policy_Funded__c = '';
        ins.How_to_Obtain_Chiro_Authorization__c = '';
        ins.How_To_Obtain_DME_Authorization__c = '';
        ins.Injection_Authorization_Process__c = 'Injection Authorization Process';
        ins.J7320__c = 'Yes covered, NO AUTH REQ';
        ins.J7322__c = 'Yes covered, NO AUTH REQ';
        ins.J7322_Diagnosis_Driven__c = 'Yes';
        ins.J7324__c = 'Yes covered, NO AUTH REQ';
        ins.J7325__c = 'Yes covered, NO AUTH REQ';
        
        insert ins;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        InsurancePlanDocFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
    
    @isTest static void testInsurancePlanDocs2() {
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
        ins.Authorization_Required_for_PT__c = true;
        ins.Billable_Time_Limit_For_A4556__c = 'Billable time';
        ins.Billable_Time_Limit_For_A4557__c = '';
        ins.Billable_Time_Limit_For_E0218__c = '';
        ins.Billable_Time_Limit_For_E0748__c = '';
        ins.Call_Length__c = '';
        ins.Call_Reference_Number__c = '';
        ins.Can_Out_Of_Network_Provider_Treat_Here__c = '';
        ins.Can_we_buy_and_bill_injection_codes__c = '';
        ins.Claim_Number__c = '';
        ins.Claims_Address__c = '';
        ins.Conservative_Modalities_Combined_Per_Day__c = true;
        ins.Count_As_1_Or_2_Visits__c = '';
        ins.DME_Benefits_Notes__c = 'DME Benefits Notes';
        ins.DME_Diagnosis_Codes__c = '';
        ins.DME_Diagnosis_Dependent__c = true;
        ins.E0218__c = '';
        ins.Group_Number__c = '';
        ins.How_Is_Policy_Funded__c = '';
        ins.How_to_Obtain_Chiro_Authorization__c = '';
        ins.How_To_Obtain_DME_Authorization__c = '';
        ins.Injection_Authorization_Process__c = 'Injection Authorization Process';
        ins.J7320__c = 'Yes covered, NO AUTH REQ';
        ins.J7322__c = 'Yes covered, NO AUTH REQ';
        ins.J7322_Diagnosis_Driven__c = 'Yes';
        ins.J7324__c = 'Yes covered, NO AUTH REQ';
        ins.J7325__c = 'Yes covered, NO AUTH REQ';
        
        insert ins;
        
        List<Id> caseIds = new List<Id>();
        Test.startTest();
        caseIds.add(cs.Id);
        InsurancePlanDocFlowController.generateAndSendPDFDocument(caseIds);
        Test.stopTest();
    }
}