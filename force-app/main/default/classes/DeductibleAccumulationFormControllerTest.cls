@IsTest
public class DeductibleAccumulationFormControllerTest {
   @IsTest
    static void testDeductibleAccumulationFormController() {
         Account acc = new Account(Name ='Test');
        insert acc;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.Patient_Date_of_Birth__c = System.today();
       
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
        
        Test.startTest();
        
        List<Insurance_Plan__c> plans = [
            SELECT
             Id,
            RecordType.Name,
            Patient_Name__c,
            
            Patient_Date_of_Birth__c,
            
            In_Network_Individual_Deductible__c,
            Out_of_Network_Individual_Deductible__c,
            In_Network_Family_Deductible__c,
            Out_of_Network_Family_Deductible__c,
            In_Network_Out_of_Pocket_Max__c,
            Out_of_Network_Out_of_Pocket_Max__c,
            Fee_Schedule__c,
            Aggregate_Allowance__c,
            Allowance_Percentage__c,
            Chiro_Visits_Allowed__c,
            Chiro_Visits_To_Date__c,
            Physical_Therapy_Visits_Allowed__c,
            Physical_Therapy_Visits_To_Date__c,
            Occupation_Therapy_Visits_Allowed__c,
            Occupational_Therapy_Visits_To_Date__c,
            Acupuncture_Visits_Allowed__c,
            Acupuncture_Visits_To_Date__c,
            Medical_Necessity_Exemption_for_Chiro__c,
            Medical_Necessity_Exemption_for_PT__c,
            Medical_Necessity_Exemption_for_OT__c,
            Medical_Necessity_Exemption_for_ACU__c,
            Insurance_Company_Representative__c,
            Call_Reference_Number__c,
            Call_Length__c,
            Chiropractic_Benefits_Notes__c,
            Occupational_Therapy_Benefits_Notes__c,
            Physical_Therapy_Benefits_Notes__c,
            Acupuncture_Therapy_Benefits_Notes__c
            FROM Insurance_Plan__c LIMIT 1 ];
        
        List<Case> caseLst = [Select Id, 
                         Primary_Insurance__c,
                      Patient_VOB__c,
                      Patient_VOB__r.Name,
                      Patient_VOB__r.Date_of_Birth__c,
                      Patient_Name__c,
                      Patient_Date_of_Birth__c,
                     
                      PIP_Insurance_Company__c
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
        
        PageReference vfPage = Page.DeductibleAccumulationFormPDF;
        Test.setCurrentPage(vfPage);
        ApexPages.currentPage().getParameters().put('id',caseLst[0].Id);
        DeductibleAccumulationFormController insp = new DeductibleAccumulationFormController();
        
        Test.stopTest();
    }
     @IsTest
    static void testDeductibleAccumulationFormController2() {
         Account acc = new Account(Name ='Test');
        insert acc;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.Patient_Date_of_Birth__c = System.today();
       
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
        ins.Medical_Necessity_Exemption_for_Chiro__c = true;
        ins.Medical_Necessity_Exemption_for_PT__c = true;
        ins.Medical_Necessity_Exemption_for_OT__c = true;  
        ins.Medical_Necessity_Exemption_for_ACU__c = true;
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
        
        Test.startTest();
        
        List<Insurance_Plan__c> plans = [
            SELECT
             Id,
            RecordType.Name,
            Patient_Name__c,
            
            Patient_Date_of_Birth__c,
            
            In_Network_Individual_Deductible__c,
            Out_of_Network_Individual_Deductible__c,
            In_Network_Family_Deductible__c,
            Out_of_Network_Family_Deductible__c,
            In_Network_Out_of_Pocket_Max__c,
            Out_of_Network_Out_of_Pocket_Max__c,
            Fee_Schedule__c,
            Aggregate_Allowance__c,
            Allowance_Percentage__c,
            Chiro_Visits_Allowed__c,
            Chiro_Visits_To_Date__c,
            Physical_Therapy_Visits_Allowed__c,
            Physical_Therapy_Visits_To_Date__c,
            Occupation_Therapy_Visits_Allowed__c,
            Occupational_Therapy_Visits_To_Date__c,
            Acupuncture_Visits_Allowed__c,
            Acupuncture_Visits_To_Date__c,
            Medical_Necessity_Exemption_for_Chiro__c,
            Medical_Necessity_Exemption_for_PT__c,
            Medical_Necessity_Exemption_for_OT__c,
            Medical_Necessity_Exemption_for_ACU__c,
            Insurance_Company_Representative__c,
            Call_Reference_Number__c,
            Call_Length__c,
            Chiropractic_Benefits_Notes__c,
            Occupational_Therapy_Benefits_Notes__c,
            Physical_Therapy_Benefits_Notes__c,
            Acupuncture_Therapy_Benefits_Notes__c
            FROM Insurance_Plan__c LIMIT 1 ];
        
        List<Case> caseLst = [Select Id, 
                         Primary_Insurance__c,
                      Patient_VOB__c,
                      Patient_VOB__r.Name,
                      Patient_VOB__r.Date_of_Birth__c,
                      Patient_Name__c,
                      Patient_Date_of_Birth__c,
                     
                      PIP_Insurance_Company__c
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
        
        PageReference vfPage = Page.DeductibleAccumulationFormPDF;
        Test.setCurrentPage(vfPage);
        ApexPages.currentPage().getParameters().put('id',caseLst[0].Id);
        DeductibleAccumulationFormController insp = new DeductibleAccumulationFormController();
        
        Test.stopTest();
        
       
    }
 

}