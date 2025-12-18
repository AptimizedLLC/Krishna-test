public class DeductibleAccumulationFormController {
     public Case caseRecord{get;set;}
    public Insurance_Plan__c insurancePlanRecord { get; private set; }
    //public Insurance_Verification__c ic { get; private set;}
    public Coverage__c coverage {get; private set;}
   
    public String patientName{get;set;}
    public String patientDOB{get;set;}
   
    public String chirohard{get;set;}
    public String PThard{get;set;}
    public String OThard{get;set;}
    public String Accuhard{get;set;}
    public String todaydate{get;set;}
    
  
    public DeductibleAccumulationFormController() {
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
                     
                      PIP_Insurance_Company__c
                     
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
        
        todaydate = Date.today().format();
        
        System.debug('::: Patient name and dob - '+patientName+' and '+patientDOB);
        List<Insurance_Plan__c> plans = [
            SELECT Id,
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
                In_Network_Family_Deductible_Met__c,
                In_Network_Out_of_Pocket_Max_Met__c,
                Out_of_Network_Deductible_Met__c,
                Out_of_Network_Family_Deductible_Met__c,
                Out_of_Network_Out_of_Pocket_Max_Met__c,
                Out_of_Network_Family_Out_of_Pocket_Met__c,
                Patient_Eligible_for_TENS_Unit__c,
                In_Network_Family_Out_of_Pocket_Met__c,
                In_Network_Family_Out_of_Pocket__c,
                Out_of_Network_Family_Out_of_Pocket__c
                FROM
                Coverage__c
                WHERE
                Insurance_Plan__c = :plans[0].Id
            ];
            if (coverages != null && coverages.size() > 0) {
                this.coverage = coverages[0];
            }
        }
         if(insurancePlanRecord.Medical_Necessity_Exemption_for_Chiro__c != null) {
             if(insurancePlanRecord.Medical_Necessity_Exemption_for_Chiro__c == true) {
                 this.chirohard = 'Yes';
             }
             else{
                 this.chirohard = 'No';
             }
             if(insurancePlanRecord.Medical_Necessity_Exemption_for_PT__c == true) {
                 this.PThard = 'Yes';  
             }
             else{
                this.PThard ='No'; 
             }
             if(insurancePlanRecord.Medical_Necessity_Exemption_for_OT__c == true){
                 this.OThard = 'Yes';  
             }
             else{
                this.OThard ='No'; 
             }
             if(insurancePlanRecord.Medical_Necessity_Exemption_for_ACU__c == true){
                 this.Accuhard = 'Yes';  
             }
             else{
                this.Accuhard ='No'; 
             }
        }

    }
}