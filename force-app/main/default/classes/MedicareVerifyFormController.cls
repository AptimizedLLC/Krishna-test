public class MedicareVerifyFormController {
    public Case caseRecord{get;set;}
    public Insurance_Plan__c insurancePlanRecord { get; private set; }
    //public Insurance_Verification__c ic { get; private set; }
   
    public String patientName{get;set;}
    public String patientDOB{get;set;}
    public String effectiveDate{get;set;}
    public String primaryeffectiveDate{get;set;}
 
    public Boolean isMedicareRecordType{get;set;}
    public String isCheckType {get;set;}
    public String todayDate {
        get {
            return Datetime.now().format('MM/dd/yyyy', 'EST');
        }
        set;
    } 
    
     public MedicareVerifyFormController() {
        this.insurancePlanRecord = new Insurance_Plan__c();
        
        String csId = ApexPages.currentPage().getParameters().get('id');
        
        caseRecord = [Select Id, 
                      PIP_Primary_NEW__c,
                      PIP_Accident_State__c,
                      Primary_Insurance__c,
                      Secondary_Insurance__c,
                       Patient_VOB__c,
                      Patient_VOB__r.Name,
                      Patient_VOB__r.Date_of_Birth__c,
                      Patient_Name__c,
                      Patient_Date_of_Birth__c,
                      Member_ID__c,
                           Intake__r.Appointment__r.Location_Name__c
                      //,Intake__r.Appointment__r.Intake_Completed_By__c
                      FROM Case where Id=:csId];
        if(caseRecord.Patient_Name__c != null) {
            patientName = caseRecord.Patient_Name__c;
        } else if(caseRecord.Patient_VOB__r.Name != null) {
            patientName = caseRecord.Patient_VOB__r.Name;
        } 
        
       /* if(caseRecord.Patient_Date_of_Birth__c != null) {
            patientDOB = caseRecord.Patient_Date_of_Birth__c.format();
        } else if(caseRecord.Patient_VOB__r.Date_of_Birth__c != null) {
            patientDOB = caseRecord.Patient_VOB__r.Date_of_Birth__c.format();
        }*/
        
        System.debug('::: Patient name and dob - '+patientName+' and '+patientDOB);
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
            OT_Visits_Combined__c,
            Medicare_Notes__c 
            
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
            
        }
        
        if(insurancePlanRecord.Plan_Effective_Date__c!= null) {
            effectiveDate = insurancePlanRecord.Plan_Effective_Date__c.format();
        }
        if(insurancePlanRecord.Plan_Effective_Date__c!= null) {
            primaryeffectiveDate = insurancePlanRecord.Plan_Effective_Date__c.format();
        }
          if(insurancePlanRecord.Patient_Date_of_Birth__c != null) {
            patientDOB = insurancePlanRecord.Patient_Date_of_Birth__c.format();
          }
        if(insurancePlanRecord.RecordType.Name != null) {
            isMedicareRecordType = (insurancePlanRecord.RecordType.Name == 'Medicare') ? true : false;
            isCheckType = (isMedicareRecordType == true) ? 'Yes' : 'No';
        }
         if(insurancePlanRecord.Supplemental_Policy_On_File_NEW__c == 'N/A') {
             insurancePlanRecord.Supplemental_Policy_On_File_NEW__c = '';
             
         }
          if(insurancePlanRecord.Supplemental_Follows_Medicare_Guidelines__c == 'N/A') {
             insurancePlanRecord.Supplemental_Follows_Medicare_Guidelines__c = '';
             
         }
       
        
     }

}