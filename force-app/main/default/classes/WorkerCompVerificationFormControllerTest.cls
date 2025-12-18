@IsTest
public class WorkerCompVerificationFormControllerTest {
     @TestSetup
    public static void dataSetup(){
        Account acc = new Account(Name ='Test');
        insert acc;
       
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.Patient_Date_of_Birth__c = System.today();
       // cs.Intake__c = opp.Id;
        cs.Subject = 'test subject';
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
       
        ins.Patient_Date_Of_Birth__c = System.today();
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
        
        
    }   
     @IsTest
    static void testWorkerCompVerificationFormController() {
        
        Test.startTest();
        List<Insurance_Plan__c> plans = [
            SELECT
             Id,
             Patient_Name__c,
             WC_Injury_State__c,
             Patient_Date_Of_Birth__c,
             Date_of_Accident__c,
             WC_Insurance_Company__c,
             WC_Insurance_Company_Phone__c,
             WC_Insurance_Company_Street__c,
             WC_Insurance_Company_City__c,
             WC_Insurance_Company_State__c,
             WC_Insurance_Company_Zip__c,
             WCB_Case_Number__c,
             Claim_Number__c,
             WC_Adjuster__c,
             WC_Adjuster_Phone__c,
             WC_Adjuster_Fax__c,
             Where_To_Submit_MG2_C4_Form__c,
             WC_Authorization_Phone__c,
             WC_Authorization_Fax__c,
             WC_Authorization_Required_for_Visits_NEW__c,
             WC_Approved_Body_Region__c,
             Employer__c,
             Employer_Phone__c,
             WC_PT_Covered_NEW__c,
             Chiropractor_Covered_by_WC_NEW__c,
             Acupuncture_Covered_by_WC_NEW__c,
             Are_We_In_Network_Out_Network_Provider__c, 
             Can_Out_Of_Network_Provider_Treat_Here__c,
             If_NY_Is_Patient_Address_Listed_In_NY__c,
             Workers_Comp_Attorney__c,
             Workers_Comp_Attorney_Fax__c,
             Workers_Comp_Attorney_Phone__c,
             WC_Conservative_Care_on_Same_Day__c
             FROM Insurance_Plan__c order by createddate DESC LIMIT 1 ];
        
        List<Case> caseLst = [Select Id, 
                               Owner.Name,
                               ClosedDate
                               FROM Case ];
       
        
        PageReference vfPage = Page.WorkerCompVerificationFormPDF;
        Test.setCurrentPage(vfPage);
        ApexPages.currentPage().getParameters().put('id',caseLst[0].Id);
        WorkerCompVerificationFormController insp = new WorkerCompVerificationFormController();
        
        Test.stopTest();
    }

}