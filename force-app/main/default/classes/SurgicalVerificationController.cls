public class SurgicalVerificationController {
     public Case caseRecord{get;set;}
    public Insurance_Plan__c insurancePlanRecord { get; private set; }
    //public Insurance_Verification__c ic { get; private set;}
    public Coverage__c coverage {get; private set;}
   
    public String patientName{get;set;}
    public String patientDOB{get;set;}
     public String patientDOBb{get;set;}
     public String procedureDate{get;set;}
   
    
    public String todaydate{get;set;}
    
     public SurgicalVerificationController() {
        this.insurancePlanRecord = new Insurance_Plan__c();
        //this.coverage = new Coverage__c();
    
        String csId = ApexPages.currentPage().getParameters().get('id');
        
        caseRecord = [Select Id, 
                      Primary_Insurance__c,
                      Patient_VOB__c,
                      Patient_VOB__r.Name,
                      Patient_VOB__r.Date_of_Birth__c,
                      Patient_Name__c,
                      Patient_Date_of_Birth__c,
                      PIP_Insurance_Company__c,
                      
                      Procedure_Date__c,
                      Surgical_Provider__c,
                      Inpatient_Outpatient__c,
                      DX_Codes_Text__c,CPT_Codes_Text__c,
                      Member_ID__c
                     
                      FROM Case where Id=:csId];
        if(caseRecord.Patient_Name__c != null) {
            patientName = caseRecord.Patient_Name__c;
        } else if(caseRecord.Patient_VOB__r.Name != null) {
            patientName = caseRecord.Patient_VOB__r.Name;
        } 
        
        if(caseRecord.Patient_Date_of_Birth__c != null) {
            patientDOB = caseRecord.Patient_Date_of_Birth__c.format();
        } else if(caseRecord.Patient_VOB__r.Date_of_Birth__c != null) {
            patientDOB = caseRecord.Patient_VOB__r.Date_of_Birth__c.format();
        }
         if(caseRecord.Procedure_Date__c != null) {
            procedureDate = caseRecord.Procedure_Date__c.format(); 
         }
         
        
        todaydate = Date.today().format();
        
        System.debug('::: Patient name and dob - '+patientName+' and '+patientDOB);
        List<Insurance_Plan__c> plans = [
            SELECT Id,
            RecordType.Name,
            Patient_Name__c,
            
            Medical_Necessity_Exemption_for_Chiro__c,
            Medical_Necessity_Exemption_for_PT__c,
            Medical_Necessity_Exemption_for_OT__c,
            Medical_Necessity_Exemption_for_ACU__c,
            Patient_Date_of_Birth__c,
            Insurance_ID_Number__c,
            
            In_Network_Co_Insurance_Percentage__c,
            In_Network_Individual_Deductible__c,
            In_Network_Out_of_Pocket_Max__c,
            Out_of_Network_Individual_Deductible__c,
            Out_of_Network_Out_of_Pocket_Max__c,
            How_to_Obtain_Procedure_Authorization__c,
            Ambulatory_Surgery_Center_Covered__c,
            Fee_Schedule__c,
            Aggregate_Allowance__c,
            Allowance_Percentage__c,
            Call_Reference_Number__c,
            Insurance_Company_Representative__c,
            Surgical_Verification_Notes__c
            
            FROM
            Insurance_Plan__c
            WHERE
            VOB_Case__c = :csId
            order by createddate DESC
            LIMIT 1
        ];
        
        if (plans != null && plans.size() > 0) {
            system.debug(plans);
            this.insurancePlanRecord = plans[0];
        
           
            List<Coverage__c> coverages = [
                SELECT 
                In_Network_Deductible_Met__c,
                In_Network_Out_of_Pocket_Max_Met__c,
                Out_of_Network_Deductible_Met__c,
                Out_of_Network_Out_of_Pocket_Max_Met__c
                FROM
                Coverage__c
                WHERE
                Insurance_Plan__c = :plans[0].Id
            ];
            if (coverages != null && coverages.size() > 0) {
                this.coverage = coverages[0];
            }
           /*  if(insurancePlanRecord.Patient_Date_of_Birth__c != null) {
            patientDOBb = insurancePlanRecord.Patient_Date_of_Birth__c.format();
        }*/
            
        }
         

    }

}