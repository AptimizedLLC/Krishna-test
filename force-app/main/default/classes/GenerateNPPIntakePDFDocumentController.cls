public class GenerateNPPIntakePDFDocumentController{
    public String currentRecordId {get;set;}
    public String currentApptId {get;set;}
  public Attachment imageAttachment { get; set; }
public String contentDocumentLink { get; set; }
    public String currentDate {get;set;}
    public NPP__c oppt {get;set;}
public ContentVersion signatureContent { get; set; }
     public GenerateNPPIntakePDFDocumentController() {}


    public GenerateNPPIntakePDFDocumentController(ApexPages.StandardController sc) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        currentApptId = ApexPages.CurrentPage().getparameters().get('appid');
currentDate = Date.Today().format();

        oppt = [SELECT Id,Account__c,
Address_City_State_and_Zip_of_Doctor_o__c,
    Appointment_Confirmation_Contact_Prefere__c,
    HQ_Accident_Address__c,
    HQ_Accident__c,
    HQ_Additional_Pain_Complaints__c,
    HQ_Alcohol_Consumption__c,
    HQ_Allergies__c,
    HQ_Any_issues_or_concerns_with_immune__c,
    HQ_Any_new_surgeries_or_procedures_since__c,
    HQ_Appointment_Scheduled__c,
    HQ_Are_you_or_could_you_be_pregnant__c,
    HQ_Are_you_taking_blood_thinners__c,
    HQ_Assignment_benefits_consent__c,
    HQ_Attorney_Address__c,
    HQ_Attorney_Name__c,
    HQ_Billing_Address__c,
    HQ_Billing_Address_Street__c,
    HQ_Billing_City_and_State__c,
    HQ_Blood_Thinners_Usage__c,
    HQ_Card_Billing_Date__c,
    HQ_Card_Holder_Name__c,
    HQ_Cardiologist_Presence__c,
    HQ_Cell_Phone_Number__c,
    HQ_Chief_Complaint__c,
    HQ_City_and_State__c,
    HQ_Claim_SSN__c,
    HQ_Consent_for_Marketing_Mails__c,
    HQ_CONTACT_TO_CONFIRM_APPOINTMENT__c,
    HQ_COVID_19_Vaccination_Status__c,
    HQ_Covid_Vaccination_Date__c,
    HQ_Cramps_or_Restless_Legs__c,
    HQ_Credit_Card_Information__c,
    HQ_Credit_Card_Number__c,
    HQ_Credit_Card_Type__c,
    HQ_Credit_Card_Type_other__c,
    HQ_Current_Medications__c,
    HQ_Current_Medications_If_YES__c,
    HQ_Date__c,
    HQ_Date_of_Accident__c,
    HQ_Date_Range_Authorized_for_Release__c,
    HQ_Diabetes_and_Neuropathy_Diagnosis__c,
    HQ_Diseases_or_infections_bodily_fluids__c,
    HQ_Doctor_or_Hospital_Release__c,
    HQ_Doctor_s_Name__c,
    HQ_does_anyone_in_your_family_suffer__c,
    HQ_Does_anyone_suffer_in_family_Other__c,
    HQ_Dose_1__c,
    HQ_Dose_2__c,
    HQ_Dose_3__c,
    HQ_Do_you_experience_leg_fatigue__c,
    HQ_Do_you_have_history_of_following__c,
    HQ_Drinks_Per_Day__c,
    HQ_Drug_Use_History__c,
    HQ_Email_Address__c,
    HQ_Employer_Address__c,
    HQ_Employer__c,
    HQ_Employer_Name__c,
    HQ_Employer_Phone_Number__c,
    HQ_Entire_Medical_Record_Specific_Date__c,
    HQ_Expiration_Date__c,
    HQ_Explain__c,
    HQ_Family_Medical_History__c,
    HQ_Fax_Records_to__c,
    HQ_Feet__c,
    HQ_Foot_Tightness_with_Socks_Shoes__c,
    HQ_Get_Medical_Records__c,
    HQ_Goals_holded_because_of_Pain__c,
    HQ_goals_would_like_to_accomplish_Other__c,
    HQ_had_any_of_the_following_performed__c,
    HQ_Height__c,
    HQ_History_of_following_Other__c,
    HQ_History_of_Lower_Leg_Ulcers_or_Sores__c,
    HQ_Home_Phone_Number__c,
    HQ_Hospital_Address__c,
    HQ_How_did_you_hear_about_us__c,
    HQ_How_many_doses_received_and_when__c,
    HQ_HR_Contact_s_Name_if_known__c,
    HQ_I_may_be_concacted_at_home_phone__c,
    HQ_I_may_be_contaced_at_email_address__c,
    HQ_I_may_be_contacted_at_cell_phone__c,
    HQ_Immune_System_Concerns__c,
    HQ_Inches__c,
    HQ_Insurance_Carrier_Name__c,
    HQ_Insurance_Coverage_Source__c,
    HQ_Insurance_coverage_through_Family__c,
    HQ_Job_Title__c,
    HQ_Last_Doctor_Visit_Date__c,
    HQ_legs_feel_better_with_rest__c,
    HQ_legs_feel_heavy_tired_achy_or__c,
    HQ_legs_swell_at_the_end_of_the_day__c,
    HQ_Lower_Leg_Hair_Loss__c,
    HQ_Lower_Leg_Numbness_Tingling__c,
    HQ_Medical_Doctor_Consultation__c,
    HQ_Member_DOB__c,
    HQ_Member_ID__c,
    HQ_Member_Name__c,
    HQ_Message_Permission_for_Medical_Care__c,
    HQ_MESSAGE_REGARDING_MEDICAL_CARE_TEST__c,
    HQ_Morning_vs_Evening_Leg_Comfort__c,
    HQ_Motor_Vehiclle_Accident_Relevance__c,
    HQ_Name__c,
    HQ_Name_of_Designated_Representative__c,
    HQ_new_surgeries_procedure_If_yes__c,
    HQ_Occupational_Physical_Demands__c,
    HQ_Onset_of_Pain__c,
    HQ_Other_Allergies__c,
    HQ_Packs_Per_Day__c,
    HQ_Pain_Level_Numeric_Rating_Scale__c,
    HQ_Pain_Related_Goals__c,
    HQ_PaperFilled__c,
    HQ_Paperwork_Status__c,
    HQ_Past_Medical_Procedures__c,
    HQ_past_surgical_history_or_any_other__c,
    HQ_Patient_financial_concent__c,
    HQ_Patient_Id2__c,
    HQ_Patient_Id__c,
    HQ_Patient_Name__c,
    HQ_Patient_or_Legal_Represenatative_Sign__c,
    HQ_Pharmacy_Phone_Number__c,
    HQ_physical_demands_of_occupation_other__c,
    HQ_Post_Standing_Sitting_Leg_Discomfort__c,
    HQ_Prefered_Pharmacy_Address__c,
    HQ_Preferred_Pharmacy_Address__c,
    HQ_Preferred_Pharmacy_Name__c,
    HQ_Pregnancy_Status__c,
    HQ_Privacy_Response__c,
    HQ_Quality_of_the_pain__c,
    HQ_Record_End_Date__c,
    HQ_Record_Start_Date__c,
    HQ_Referral_Source__c,
    HQ_Related_person_Contact__c,
    HQ_Related_Person_Name__c,
    HQ_Relationship_to_Patient__c,
    HQ_Release_the_medical_records__c,
    HQ_Security_Code__c,
    HQ_Send_PDF__c,
    HQ_Signatrue__c,
    HQ_Signature__c,
    HQ_Skin_Condition_Below_Knees__c,
    HQ_Smoking_Status__c,
    HQ_Subscriber_Name__c,
    HQ_Summary_Plan__c,
    HQ_Title_of_designated_representative__c,
    HQ_To__c,
    HQ_Transmissible_Diseases_Infections__c,
    HQ_Vaccine_Scheduled_Date__c,
    HQ_Vein_Conditions__c,
    HQ_Weight__c,
    HQ_What_makes_it_better__c,
    HQ_what_makes_it_better_other__c,
    HQ_What_makes_it_worse__c,
    HQ_what_makes_it_worse_other__c,
    HQ_Zip_code__c,
    Name__c,
    pdf_sent_to_Carecloud__c,
    Test__c,
    HQ_Sign_Id__c

                FROM NPP__c WHERE Id =: currentRecordId];
       

String contentDocumentId = oppt.HQ_Sign_Id__c;
system.debug(contentDocumentId);
// Query ContentDocumentLink to get ContentVersionId

//ContentDocumentLink contentDocumentLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId LIMIT 1];
//system.debug(contentDocumentLink);
//ContentVersion contentVersion = [SELECT Id,ContentUrl FROM ContentVersion WHERE ContentDocumentId = : oppt.HQ_Sign_Id__c LIMIT 1];
 //String imageUrl = 'https://allianceortho.file.force.com/sfc/servlet.shepherd/version/download/'+oppt.HQ_Sign_Id__c;
 String imageUrl = 'https://allianceortho--stage.sandbox.file.force.com/sfc/servlet.shepherd/version/download/'+oppt.HQ_Sign_Id__c;
        //String imageUrl = 'https://allianceortho--stage.sandbox.file.force.com/sfc/servlet.shepherd/version/download/068U8000001CFM5IAO';

String richTextFieldValue = '<img src="' + imageUrl + '" alt="Image" />';

system.debug(richTextFieldValue); 
oppt.HQ_Signature__c = richTextFieldValue;
    }


}