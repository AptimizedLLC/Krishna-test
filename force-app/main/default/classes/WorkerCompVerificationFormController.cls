public class WorkerCompVerificationFormController {
     public Case caseRecord{get;set;}
     public Insurance_Plan__c insurancePlanRecord { get; private set; }
     public String patientDOB{get;set;}
     public String closedate{get;set;}
     public String dateOfAccident{get;set;}
     public WorkerCompVerificationFormController() {
        this.insurancePlanRecord = new Insurance_Plan__c();
        
        String csId = ApexPages.currentPage().getParameters().get('id');
        
        caseRecord = [Select Id, 
                      //OwnerId,
                      Owner.Name,
                     // Owner.Username,
                      ClosedDate
                      FROM Case where Id=:csId];
         /*if (caseRecord.ClosedDate!= null ) {
             closedate = caseRecord.ClosedDate.format();
             System.debug(closedate);
         }*/
         closedate = Date.today().format();
          
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
             
             FROM Insurance_Plan__c WHERE
             VOB_Case__c = :csId
             order by createddate DESC
             LIMIT 1 ];
         
         if (plans != null && plans.size() > 0) {
             system.debug(plans);
             this.insurancePlanRecord = plans[0];
             
             if(insurancePlanRecord.Patient_Date_Of_Birth__c!= null) {
                 patientDOB = insurancePlanRecord.Patient_Date_Of_Birth__c.format();
                 System.debug(patientDOB);
             }
             if(insurancePlanRecord.Date_of_Accident__c!= null) {
                 dateOfAccident = insurancePlanRecord.Date_of_Accident__c.format();
             }
   
         }
     }
}