@IsTest
public class MedicareVerifyFormControllerTest {
    @TestSetup
    public static void dataSetup(){
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
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.Patient_Date_of_Birth__c = System.today();
        cs.Intake__c = opp.Id;
        cs.Subject = 'test subject';
        cs.PIP_Date_of_Loss__c = System.today();
        insert cs;
        
        Insurance_Plan__c ins = new Insurance_Plan__c();
        ins.Patient_Name__c = 'Test Name';
        ins.Chiro_Visits_Combined__c = 'yes';
        ins.Authorization_Required_for_Chiro__c = true;
        ins.How_to_Obtain_Acupuncture_Authorization__c = '8457598255';
        ins.Can_patient_treat_at_ASC__c = 'Yes'; 
        ins.Patient_Date_of_Birth__c = System.today()-100;
        ins.Call_Length__c = '';
        ins.Supplemental_Policy_On_File_NEW__c = 'N/A';
        ins.Supplemental_Follows_Medicare_Guidelines__c = 'N/A';
        ins.Call_Reference_Number__c = '';
        ins.Can_Out_Of_Network_Provider_Treat_Here__c = '';
        ins.Can_we_buy_and_bill_injection_codes__c = '';
        ins.Claim_Number__c = '';
        ins.Claims_Address__c = '';
        ins.VOB_Case__c = cs.Id;
        ins.Plan_Effective_Date__c = System.today();
        ins.Start_of_Plan_Year__c = System.today();
        ins.Secondary_Plan_Effective_Date__c = System.today();
        ins.Date_of_Accident__c = System.today();
        insert ins;
        
        
    }
    
    
    @IsTest
    static void testMedicareVerifyFormController() {
        
        Test.startTest();
        List<Insurance_Plan__c> plans = [
            SELECT
            RecordType.Name,
            Patient_Name__c,
            Plan_Type__c,
            Claims_Address__c,
            Patient_Date_of_Birth__c,
            Medicare_Annual_Deductible__c,
            Medicare_Deductible_Met__c,
            Plan_Effective_Date__c,
            Medicare_PT_Benefits_Used_To_Date__c,
            Medicare_Replacement_Plan_Carrier__c,
            Medicare_OT_Benefits_Used_To_Date__c,
            Supplemental_Policy_On_File_NEW__c,
            Supplemental_Plan_Type__c,
            Supplemental_Follows_Medicare_Guidelines__c,
            Medicare_Member_Id__c,
            Insurance_Company_Representative__c,
            Call_Reference_Number__c,
            Call_Length__c,
            Procedure_Benefits_Notes__c,
            OT_Visits_Combined__c
            
            FROM Insurance_Plan__c LIMIT 1 ];
        
        List<Case> caseLst = [Select Id, 
                              Patient_VOB__r.Name,
                              Patient_Date_of_Birth__c,
                              Personal_Injury_Attorney__c,
                              PIP_LOP_on_File_NEW__c,
                              Declaration_Page_Received__c,
                              Police_Report_Received__c,
                              PIP_Most_Up_To_Date_PIP_Ledger__c,
                              PIP_Notes__c,
                              Employer__c
                              
                              FROM Case ];
        
        PageReference vfPage = Page.MedicareVerificationFormPdf;
        Test.setCurrentPage(vfPage);
        ApexPages.currentPage().getParameters().put('id',caseLst[0].Id);
        MedicareVerifyFormController insp = new MedicareVerifyFormController();
        
        Test.stopTest();
    }
}