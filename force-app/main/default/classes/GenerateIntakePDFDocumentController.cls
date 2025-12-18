public class GenerateIntakePDFDocumentController{
    public String currentRecordId {get;set;}
    public String currentDate {get;set;}
    public Boolean midbackPain {get;set;}
    public Boolean neckPain {get;set;}
    public Boolean sciaticaPain {get;set;}
    public Boolean legPain {get;set;}
    public Boolean kneePain {get;set;}
    public Boolean hipPain {get;set;}
    public Boolean footAnklePain {get;set;}
    public Boolean shoulderPain {get;set;}
    public Boolean elbowPain {get;set;}
    public Boolean wristPain {get;set;}
    public Boolean scoliosis {get;set;}
    public Boolean headache {get;set;}
    public Boolean vertigo {get;set;}
    public Boolean neurological {get;set;}
    public Boolean wellness {get;set;}
    public Boolean otherCondition {get;set;}
    public String dobPrimary {get;set;}
    public String dobSecondary {get;set;}
    public String dobPatient {get;set;}
    public String dateofaccident {get;set;}
    public Set<String> setOfPains {get;set;}
    public Boolean fourCondition {get;set;}
    public Boolean twoCondition {get;set;}
    public Boolean threeCondition {get;set;}
    public Boolean oneCondition {get;set;}
    public Opportunity oppt {get;set;}
    public Case cs {get;set;}
    public String applicantName {get;set;}
    public List<Appointment__c> appointments{get;set;}
    public String locationName{get;set;}
    public String appDatetime{get;set;}
    public String providerName{get;set;}
    public String currentApptId {get;set;}
    public Boolean hadPrevioudTreatment{get;set;} 
    public Boolean otherPrimaryInsurance{get;set;}
    public Boolean otherSecondaryInsurance{get;set;}
    public Boolean isPipType{get;set;}
    public Boolean isCasePresent{get;set;}
    
    public GenerateIntakePDFDocumentController(ApexPages.StandardController sc) {
        setOfPains = new Set<String>();
        currentDate = Date.Today().format();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        currentApptId = ApexPages.CurrentPage().getparameters().get('appid');
        oppt = [SELECT Id, Patient_Name__c, Patient_Number__c, Mid_Back_Pain__c, Neck_Pain__c, Lower_Back_Pain_Sciatica__c,Type,
                Describe_Mid_Back_Pain__c,How_Long_Mid_Back_Pain__c,What_were_you_doing_when_pain_started__c,Describe_Neck_Pain__c,
                How_Long_Neck_Pain__c,Neck_Pain_Location__c,Describe_Lower_Back_Pain_Sciatica__c,How_Long_Lower_Back_Pain_Sciatica__c,
                Sciatica_Pain_Location__c,Describe_Leg_Pain__c,How_Long_Leg_Pain__c,Leg_Pain__c,Describe_Knee_Pain__c,How_Long_Knee_Pain__c,Knee_Pain__c,
                Describe_Hip_Pain__c,Hip_Pain__c,How_Long_Hip_Pain__c,Describe_Foot_Ankle_Pain__c,Foot_Ankle_Pain__c,How_Long_Foot_Ankle_Pain__c,Describe_Shoulder_Pain__c,
                How_Long_Shoulder_Pain__c,Shoulder_Pain__c,Describe_Elbow_Pain__c,Elbow_Pain__c,How_Long_Elbow_Pain__c,Describe_Wrist_Hand_Pain__c,How_Long_Wrist_Hand_Pain__c,
                Wrist_Hand_Pain__c,Describe_Scoliosis_Pain__c,How_Long_Scoliosis__c,Scoliosis__c,Describe_Headache_Migraine_Pain__c,Headache_Migraine__c,
                How_Long_Headache_Migraine__c,Describe_Vertigo_Pain__c,How_Long_Vertigo__c,Vertigo__c,Describe_Neurological_Condition_Pain__c,How_Long_Neurological_Condition__c,
                Neurological_Condition__c,How_Long_Wellness_No_Pain__c,Wellness_No_Pain__c,How_Long_Other_Condition__c,Other_Condition__c,
                Elbow_Pain_Location__c,Foot_Ankle_Pain_Location__c,Hip_Pain_Location__c,Knee_Pain_Location__c,Leg_Pain_Location__c,Shoulder_Pain_Location__c,Wrist_Hand_Pain_Location__c,
                Have_you_had_previous_treatment_NEW__c,Primary_Care_Physician_Practice__r.Name,Chiropractic_Practice__c, Chiropractic_Practice__r.Name,
                Orthopedic_Spine_Practice__r.Name, Orthopedic_Extremity_Practice__r.Name, Pain_Management_Practice__r.Name, MRI_CT_Facility__r.Name,
                X_Ray_Facility__r.Name,Neurology_Practice__r.Name,Physical_Therapy_Practice__r.Name,Occupational_Therapy_Practice__r.Name,
                Ophthalmology_Practice__r.Name,Podiatry_Practice__r.Name, Acupuncture_Practice__c, Acupuncture_Practice__r.Name,Dental_Practice__r.Name,ENT_Allergy_Practice__r.Name,
                Urgent_Care_Facility__r.Name, Hospital__r.Name,LeadSource,Related_To_PIP_MVA_Or_WC__c, Intake_Completed_By__r.Name,
                Patient_Address__c,Account.Date_of_Birth__c,Account.PersonEmail, Personal_Injury_Attorney__r.Name,Slip_Fall_Location__c ,Date_of_Accident__c
                ,State_Where_Accident_Occurred__c , New_Personal_Injury_Attorney__c,WC_Attorney__R.Name, How_WC_Accident_Happened__c ,New_WC_Attorney__c,New_Acupuncture_Practice__c,
                New_Chiropractic_Practice__c,New_ENT_Allergy_Practice__c,New_Neurology_Practice__c,New_Occupational_Therapy_Practice__c,New_Ophthalmology_Practice__c,New_Orthopedic_Spine_Practice__c,New_Orthopedic_Extremity_Practice__c,
                New_Pain_Management_Practice__c,New_Physical_Therapy_Practice__c,Intake_Completed_By_picklist__c,New_MRI_CT_Facility__c,New_X_Ray_Facility__c
 
                FROM Opportunity WHERE Id =: currentRecordId];
        
        List<Case> intakeCases = [SELECT Id, Primary_Insurance__c, Member_ID__c, Group_Number__c, Primary_Insurance_Phone__c, VOB_Type__c, Primary_Subscriber_Relationship__c, 
              Primary_Subscriber_Date_of_Birth__c, Intake__c,Primary_Subscriber_Name__c,Secondary_Subscriber_Relationship__c,Secondary_Subscriber_Name__c,
              Secondary_Subscriber_Date_of_Birth__c,Secondary_Insurance__c,Secondary_Member_ID__c,Secondary_Insurance_Phone__c,Secondary_Group_Number__c,
              Was_Payment_Arrangement_Discussed__c,Other_Primary_Insurance_Company__c,Other_Secondary_Insurance_Company__c,Other_Relationship_Detail__c
              ,Other_Secondary_Relationship_Detail__c, PIP_WC_or_School_Insurance__c, Claim_Number__c,Adjuster__c,Adjuster_Phone__c
              FROM Case WHERE Intake__c =: currentRecordId LIMIT 1]; 

        isCasePresent = !intakeCases.isEmpty();
        
        cs = intakeCases.isEmpty() ? new Case() : intakeCases[0];  
        
        appointments = new List<Appointment__c>();
        appointments = [Select Id , Location_Name__c, Appointment_Date_Time__c, Provider_Name__c 
                        FROM Appointment__c where Intake__c =: currentRecordId LIMIT 1];
        //System.debug('::: currentRecordId - '+currentRecordId);
        //System.debug('::: appointments - '+appointments);
        
        //System.debug('::: Appointments from Intake - '+[Select Id, Location_Name__c FROM Appointment__c WHERE Intake__c=:currentRecordId]);
        if(!appointments.isEmpty() && appointments != null) {
            if(appointments[0].Location_Name__c != null) {
                locationName = appointments[0].Location_Name__c;
            }
            if(appointments[0].Appointment_Date_Time__c != null) {
                appDatetime = appointments[0].Appointment_Date_Time__c.format();
            }
            if(appointments[0].Provider_Name__c != null) {
                providerName = appointments[0].Provider_Name__c;
            }
        }
        
        //Case Check
        if(cs != null){
            
            if(cs.Primary_Subscriber_Date_of_Birth__c != null){
                dobPrimary = cs.Primary_Subscriber_Date_of_Birth__c.format();
            }
            
            if(cs.Secondary_Subscriber_Date_of_Birth__c != null){
                dobSecondary = cs.Secondary_Subscriber_Date_of_Birth__c.format();
            } 
            
            if(cs.Primary_Insurance__c == 'Other') {
                otherPrimaryInsurance = true;
            } else {
                otherPrimaryInsurance = false;
            }
            
            if(cs.Secondary_Insurance__c == 'Other') {
                otherSecondaryInsurance = true;
            } else {
                otherSecondaryInsurance = false;
            }
        }
        
        if(oppt.Date_of_Accident__c != null) {
            dateofaccident = oppt.Date_of_Accident__c.format();
        }
        
        if(oppt.Have_you_had_previous_treatment_NEW__c != null) {
            if(oppt.Have_you_had_previous_treatment_NEW__c == 'Yes') {
                hadPrevioudTreatment = true;
            }
        } else {
            hadPrevioudTreatment = false;
        }
        
        if(oppt.Account.Date_of_Birth__c != null){
            dobPatient = oppt.Account.Date_of_Birth__c.format();
        }  
        
        if(oppt.Mid_Back_Pain__c == true){
            midbackPain = true;
            setOfPains.add('MidPain');
        }
        if(oppt.Neck_Pain__c == true){
            neckPain = true;
            setOfPains.add('NeckPain');
        }
        if(oppt.Lower_Back_Pain_Sciatica__c == true){
            sciaticaPain = true;
            setOfPains.add('SciaticaPain');
        }
        if(oppt.Leg_Pain__c == true){
            legPain = true;
            setOfPains.add('LegPain');
        }
        if(oppt.Knee_Pain__c == true){
            kneePain = true;
            setOfPains.add('KneePain');
        }
        if(oppt.Hip_Pain__c == true){
            hipPain = true;
            setOfPains.add('HipPain');
        }
        if(oppt.Foot_Ankle_Pain__c == true){
            footAnklePain = true;
            setOfPains.add('FootPain');
        }
        if(oppt.Shoulder_Pain__c == true){
            shoulderPain = true;
            setOfPains.add('ShoulderPain');
        }
        if(oppt.Elbow_Pain__c == true){
            elbowPain = true;
            setOfPains.add('ElbowPain');
        }
        if(oppt.Wrist_Hand_Pain__c == true){
            wristPain = true;
            setOfPains.add('WristPain');
        }
        if(oppt.Scoliosis__c == true){
            scoliosis = true;
            setOfPains.add('Scoliosis');
        }
        if(oppt.Headache_Migraine__c == true){
            headache = true;
            setOfPains.add('headache');
        }
        if(oppt.Vertigo__c == true){
            vertigo = true;
            setOfPains.add('vertigo');
        }
        if(oppt.Neurological_Condition__c == true){
            neurological = true;
            setOfPains.add('Neurological');
        }
        if(oppt.Wellness_No_Pain__c == true){
            wellness = true;
            setOfPains.add('wellness');
        }
        if(oppt.Other_Condition__c == true){
            otherCondition = true;
            setOfPains.add('other');
        }
        
        if(setOfPains.size() == 4){
            fourCondition = true;
        }
        
        if(setOfPains.size() == 2){
            twoCondition = true;
        }
        
        if(setOfPains.size() == 3){
            threeCondition = true;
        }
        
        if(setOfPains.size() == 1){
            oneCondition = true;
        }
    }
    
}