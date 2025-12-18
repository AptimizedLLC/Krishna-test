public class PipVerificationFormController {
   
    public Case caseRecord{get;set;}
    public String patientDOB{get;set;}
    public String dateOfloss{get;set;}
    public String closedate{get;set;}
    
    public PipVerificationFormController() {
      
        String csId = ApexPages.currentPage().getParameters().get('id');
        
        caseRecord = [Select Id, 
                      PIP_Primary_Text__c,
                      PIP_Accident_State__c,
                      PIP_Policy_State__c,
                      PIP_Patient_Name__c,
                      PIP_Patient_Date_of_Birth__c,
                      PIP_Date_of_Loss__c,
                      PIP_WC_or_School_Insurance__c,
                      PIP_Insurance_Phone__c,
                      PIP_Insurance_Street_Address__c,
                      PIP_Insurance_City__c,
                      PIP_Insurance_State__c,
                      PIP_Insurance_Postal_Code__c,
                      PIP_Claim_Number__c,
                      PIP_Adjuster__c,
                      PIP_Adjuster_Phone__c,
                      PIP_Adjuster_Fax__c,
                      PIP_Pre_Cert_Company_Name__c,
                      PIP_Pre_Cert_Street_Address__c,
                      PIP_Pre_Cert_Phone__c,
                      PIP_Pre_Cert_Fax__c,
                      PIP_Office_Visits_Require_Precert__c,
                      Cut_Off_Specialty_Notes__c,
                      PIP_Policy_Belong_to_Patient_NEW__c,
                      PIP_Who_Does_Policy_Belong_To__c,
                      PIP_Funds_Available_NEW__c,
                      PIP_Is_The_Policy_Open_and_Active__c,
                      PIP_Fax_Number_21_Day_Letter__c,
                      PIP_Fax_Number_Send_Release__c,
                      PIP_Policy_Max_Amount__c,
                      //Personal_Injury_Attorney__c,
                      Personal_Injury_Attorney__r.Name,
                      PIP_LOP_on_File_NEW__c,
                      Declaration_Page_Received__c,
                      Police_Report_Received__c,
                      PIP_Most_Up_To_Date_PIP_Ledger__c,
                      PIP_Notes__c,
                      PIP_Pending_IMEs__c,
                      New_Personal_Injury_Attorney__c,
                      PIP_Attorney_Phone__c,
                      PIP_Acupuncture_Specialty__c,
                      PIP_Chrio_Specialty__c,
                      PIP_Neuro_Specialty__c,
                      PIP_Neuropsychologist_Specialty__c,
                      PIP_None_Specialty__c,
                      PIP_Orthopedic_Specialty__c,
                      PIP_PT_Specialty__c,
                      PIP_Pain_Management_Specialty__c,
                      PIP_Physiatry_Specialty__c,
                      PIP_Occupational_Therapy_Specialty__c,
                      PIP_Pre_Op_Testing_Req_Auth_NEW__c,
                      PIP_Pre_Op_Testing_More_Details__c,
                      Other_PIP_Insurance_Detail__c,
                      //OwnerId,
                      Owner.Name,
                     // Owner.Username,
                      ClosedDate
                      FROM Case where Id=:csId];
         if (caseRecord.PIP_Patient_Date_of_Birth__c!= null ) {
              patientDOB = caseRecord.PIP_Patient_Date_of_Birth__c.format();
         }
         if (caseRecord.PIP_Date_of_Loss__c!= null ) {
              dateOfloss = caseRecord.PIP_Date_of_Loss__c.format();
         }
        
         closedate = Date.today().format();
         
     }
}