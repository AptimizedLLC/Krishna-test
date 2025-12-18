@IsTest
public class InsurancePlanPDFControllerTest {
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
        cs.Primary_Subscriber_Date_of_Birth__c = System.today()-30;
       
        cs.PIP_Date_of_Loss__c = System.today();
        insert cs;
        
        Insurance_Plan__c ins = new Insurance_Plan__c();
        ins.Patient_Name__c = 'Test Name';
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
        ins.VOB_Case__c = cs.Id;
        ins.Plan_Effective_Date__c = System.today();
        ins.Start_of_Plan_Year__c = System.today();
        ins.Secondary_Plan_Effective_Date__c = System.today();
        ins.Date_of_Accident__c = System.today();
        insert ins;
        
        
        Coverage__c cov = new Coverage__c();
        cov.Insurance_Plan__c = ins.Id;
        cov.In_Network_Deductible_Met__c =  10000000; 
        cov.In_Network_Family_Deductible_Met__c= 100000000 ;
        cov.In_Network_Out_of_Pocket_Max_Met__c= 20000000;
        cov.Out_of_Network_Deductible_Met__c= 300000000;
        cov.Out_of_Network_Family_Deductible_Met__c= 1000000;
        cov.Out_of_Network_Out_of_Pocket_Max_Met__c= 200000000;
        insert cov;
        
        
        
    }   
    
    @IsTest
    static void testInsurancePlanPDFController() {
        
        Test.startTest();
        List<Insurance_Plan__c> plans = [
            SELECT
            Patient_Name__c,
            Patient_Date_of_Birth__c,
            Chiropractor_Covered_by_WC_NEW__c,
            Chiro_Visits_To_Date__c,
            Chiro_Visits_Combined__c,
            Chiro_Visits_Allowed__c,
            Chiro_Modality_Limit_Per_Date_of_Service__c,
            Authorization_Required_for_Chiro__c,
            Chiropractic_Benefits_Cigna_ASHN__c,
            Chiropractic_Referral_Required__c,
            WC_Authorization_Phone__c,
            Chiropractic_Benefits_Notes__c,
            X97124__c,
            X29799__c,
            X72110__c,
            X97140__c,
            WC_PT_Covered_NEW__c,
            Physical_Therapy_Visits_Allowed__c,
            PT_OT_Combined_In_Same_Day__c,
            PT_Modality_Limit_Per_Date_of_Service__c,
            Authorization_Required_for_PT__c,
            How_to_Obtain_PT_Authorization__c,
            Physical_Therapy_Benefits_Notes__c,
            WC_OT_Covered_NEW__c,
            Occupation_Therapy_Visits_Allowed__c,
            OT_Modality_Limit_Per_Date_of_Service__c,
            Authorization_Required_for_OT__c,
            How_to_Obtain_OT_Authorization__c,
            Occupational_Therapy_Benefits_Notes__c,
            L3764__c,
            L3906__c,
            L3919__c,
            X72141__c,
            Acupuncture_Covered_by_WC_NEW__c,
            Acupuncture_Visits_Allowed__c,
            ACU_Modality_Limit_Per_Date_of_Service__c,
            Authorization_Required_for_Acupuncture__c,
            How_to_Obtain_Acupuncture_Authorization__c,
            Exclusions_in_Covering_Acupuncture__c,
            Acupuncture_Therapy_Benefits_Notes__c,
            X97139__c,
            CreatedDate,
            Call_Length__c,
            Insurance_Company_Representative__c,
            Call_Reference_Number__c,
            Authorization_Required_for_DME__c,
            How_To_Obtain_DME_Authorization__c,
            E0730__c,
            L0637__c,
            L0180__c,
            L1843__c,
            DME_Benefits_Notes__c,
            DME_Diagnosis_Dependent__c,
            DME_Diagnosis_Codes__c,
            How_many_pairs_of_orthotics_per_year__c,
            Policy_Follow_the_Orthotics_Mandate__c,
            X20610__c,
            X20553__c,
            X62321__c,
            X62323__c,
            X64483__c,
            J7320__c,
            J7322__c,
            J7324__c,
            J7325__c,
            J7327__c,
            X95886__c,
            X95907_95913__c,
            X93998__c,
            X36475__c,
            Procedure_Diagnosis_Codes__c,
            Can_we_buy_and_bill_injection_codes__c,
            Medicare_Annual_Deductible__c,
            Medicare_Deductible_Met__c,
            Plan_Effective_Date__c,
            Medicare_PT_Benefits_Used_To_Date__c,
            Medicare_OT_Benefits_Used_To_Date__c,
            Is_There_a_Medicare_Replacement_Plan_NEW__c,
            Supplemental_Policy_On_File_NEW__c,
            Pharmacy_Benefits__c,
            Pharmacy_Benefits_Phone__c,
            How_Is_Policy_Funded__c,
            Timely_Filing_Requirement_Original_Claim__c,
            Timely_Filing_Requirement_Reprocessing__c,
            Coverage_Year__c,
            Is_this_plan_Embedded_or_Aggregate__c,
            Deductible_Cross_Applies_NEW__c,
            In_Network_Co_Insurance__c,
            In_Network_Individual_Deductible__c,
            In_Network_Family_Deductible__c,
            In_Network_Out_of_Pocket_Max__c,
            Out_of_Network_Co_Insurance__c,
            Out_of_Network_Individual_Deductible__c,
            Out_of_Network_Family_Deductible__c,
            Out_of_Network_Out_of_Pocket_Max__c,
            Out_of_Network_Speciality_Co_Pay__c,
            Can_Out_Of_Network_Provider_Treat_Here__c,
            WC_Injury_State__c,
            Date_of_Accident__c,
            WC_Insurance_Company__c,
            WC_Insurance_Company_Street__c,
            WCB_Case_Number__c,
            Claim_Number__c,
            WC_Adjuster__c,
            WC_Adjuster_Fax__c,
            WC_Patient_Eligible_For_TENS__c,
            WC_Patient_TENS_Ineligible_Reason__c,
            Where_To_Submit_MG2_C4_Form__c,
            WC_Approved_Body_Region__c,
            If_NY_Is_Patient_Address_Listed_In_NY__c,
            Workers_Comp_Attorney__c,
            A4556__c,
            A4557__c,
            E0221__c,
            E0218__c,
            X644590__c,
            X64633__c,
            X64772__c,
            X63650__c,
            X20931__c,
            X64640__c,
            X64624__c,
            X93970__c,
            X95700__c,
            X95716__c,
            X95719__c,
            X95720__c,
            X72131__c,
            X62290__c,
            X29805__c,
            X36465__c,
            X36466__c,
            X97750__c,
            L3030__c,
            L0648__c,
            L3807__c,
            L1845__c,
            L1846__c,
            L4350__c,
            L4361__c,
            L4397__c,
            L1902__c,
            L1940__c,
            X29530__c,
            X97535__c,
            L3935__c,
            X20552__c,
            X20550__c,
            X38220__c,
            X23405__c,
            Insurance_Phone__c,
            Start_of_Plan_Year__c,
            Secondary_Plan_Effective_Date__c,
            Method_of_Payment__c,
            Amount_Remaining__c,
            Medicare_Notes__c,
            NJSW_Net_New__c,
            Patient_Eligible_For_Orhtotics__c,
            Acupuncture_Visits_Combined__c,
            Acupuncture_Referral_Required__c,
            Acupuncture_Benefits_Cigna_ASHN__c,
            Acupuncture_Visits_To_Date__c,
            Physical_Therapy_Visits_To_Date__c,
            How_to_Obtain_Procedure_Authorization__c,
            Physical_Therapy_Benefits_Cigna_ASHN__c,
            Physical_Therapy_Referral_Required__c ,
            Occupational_Therapy_Visits_To_Date__c,
            Occupational_Therapy_Benefits_Cigna_ASHN__c,
            Occupational_Therapy_Referral_Required__c,
            Rental_Required_For_Purchase_E0730__c,
            Rental_Required_For_Purchase_E0748__c,
            Rental_Required_For_Purchase_E0221__c,
            Rental_Required_For_Purchase_E0218__c,
            Can_patient_treat_at_ASC__c,
            How_To_Obtain_MD_Service_Authorization__c,
            E0730_Been_Prescribed_in_Last_3_Years__c,
            Who_Prescribed_E0730__c,
            When_Was_E0730_Prescribed__c,
            How_Often_is_Patient_Allowed_TENS_Unit__c,
            Billable_Time_Limit_For_A4556__c,
            Billable_Time_Limit_For_A4557__c,
            Billable_Time_Limit_For_E0748__c,
            Billable_Time_Limit_For_E0218__c,
            Billable_Time_Limit_For_E0221__c,
            Does_This_Plan_Have_Multiplan_Benefit__c,
            Who_Receives_The_Multiplan_Payment__c,
            Workers_Comp_Attorney_Phone__c,
            Workers_Comp_Attorney_Fax__c,
            Workers_Comp_Notes__c,
            L1833__c,
            Insurance_ID_Number__c,
            Chiro_Hard_Max__c,
            PT_Hard_Max__c,
            OT_Hard_Max__c,
            Acupuncture_Hard_Max__c
            
            FROM Insurance_Plan__c LIMIT 1 ];
        
        List<Case> caseLst = [Select Id, 
                        PIP_Primary_NEW__c,
                        PIP_Accident_State__c,
                        PIP_Policy_State__c,
                        Patient_VOB__r.Name,
                        Patient_Date_of_Birth__c,
                        PIP_Date_of_Loss__c,
                        PIP_Insurance_Company__c,
                        PIP_Insurance_Phone__c,
                        PIP_Insurance_Street_Address__c,
                        PIP_Claim_Number__c,
                        Adjuster__c,
                        PIP_Adjuster_Phone__c,
                        PIP_Adjuster_Fax__c,
                        PIP_Pre_Cert_Street_Address__c,
                        PIP_Pre_Cert_Company_Name__c,
                        PIP_Pre_Cert_Phone__c,
                        PIP_Pre_Cert_Fax__c,
                        PIP_Pre_Op_Testing_More_Details__c,
                        PIP_Office_Visits_Require_Precert__c,
                        PIP_Pending_IMEs__c,
                        PIP_Policy_Belong_to_Patient_NEW__c,
                        PIP_Funds_Available__c,
                        PIP_Fax_Number_21_Day_Letter__c,
                        PIP_Fax_Number_Send_Release__c,
                        PIP_Policy_Max_Amount__c,
                        Personal_Injury_Attorney__c,
                        PIP_LOP_on_File_NEW__c,
                        Declaration_Page_Received__c,
                        Police_Report_Received__c,
                        PIP_Most_Up_To_Date_PIP_Ledger__c,
                        PIP_Notes__c,
                        Employer__c,
                        Intake__r.Appointment__r.Appointment_Date_Time__c,
                        Intake__r.Appointment__r.Location_Name__c
                        //,Intake__r.Appointment__r.Intake_Completed_By__c
                        FROM Case ];
        List<Coverage__c> coverages = [
            SELECT 
            In_Network_Deductible_Met__c,
            In_Network_Family_Deductible_Met__c,
            In_Network_Family_Out_of_Pocket__c,
            In_Network_Out_of_Pocket_Max_Met__c,
            Out_of_Network_Deductible_Met__c,
            Out_of_Network_Family_Deductible_Met__c,
            Out_of_Network_Out_of_Pocket_Max_Met__c,
            Insurance_Plan__c
            FROM
            Coverage__c
        ];
        
        PageReference vfPage = Page.GenerateInsurancePlanPDF;
        Test.setCurrentPage(vfPage);
        ApexPages.currentPage().getParameters().put('id',caseLst[0].Id);
        InsurancePlanPDFController insp = new InsurancePlanPDFController();
        
        Test.stopTest();
    }
    
}