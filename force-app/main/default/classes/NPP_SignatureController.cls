public without sharing class NPP_SignatureController {
    
    @AuraEnabled(cacheable=true)
public static Account getAccountDat(Id accId){
    return [
        SELECT Id, Name
        FROM Account
        WHERE Id = :accId
        LIMIT 1
    ];
}

    @AuraEnabled
    public static Id saveNPP(String issuesValue, 
                                                   // HQ_Any_issues_or_concerns_with_immune__c
        String signatureData,                    // Signature field on NPP__c (update API name below)
        Decimal weight,                           // HQ_Weight__c
        String employer,                         // HQ_Employer__c
        String jobTitle,                         // HQ_Job_Title__c
        String covidStatus,                      // HQ_COVID_19_Vaccination_Status__c
        String chiefComplaint,                   // HQ_Chief_Complaint__c
        String currentMedicationsStatus,         // HQ_Current_Medications__c
        String currentMedicationsText,           // HQ_Current_Medications_If_YES__c
        String yearValue,                        // Year__c
        String painStart,                        // Pain_Start__c
        Decimal feet,                            // HQ_Feet__c
        Decimal inches,                          // HQ_Inches__c
        String painLevel,                        // HQ_Pain_Level_Numeric_Rating_Scale__c
        String onsetOfPain,                      // HQ_Onset_of_Pain__c
        String additionalPainComplaints,         // HQ_Additional_Pain_Complaints__c
        String medicalDoctorConsultation,        // HQ_Medical_Doctor_Consultation__c
        String doctorsName,                       // HQ_Doctor_s_Name__c
        string Account
                            ) {

        // Validate inputs
        if (String.isBlank(issuesValue)) {
            throw new AuraHandledException('Issues Yes/No value is required.');
        }
        if (String.isBlank(signatureData)) {
            throw new AuraHandledException('Signature is missing.');
        }

         // Build the record
        NPP__c npp = new NPP__c();

        // Map all fields
        npp.HQ_Any_issues_or_concerns_with_immune__c      = issuesValue;
        npp.HQ_Weight__c                                  = weight;
        npp.HQ_Employer__c                                = employer;
        npp.HQ_Job_Title__c                               = jobTitle;
        npp.HQ_COVID_19_Vaccination_Status__c             = covidStatus;
        npp.HQ_Chief_Complaint__c                         = chiefComplaint;
        npp.HQ_Current_Medications__c                     = currentMedicationsStatus;
        npp.HQ_Current_Medications_If_YES__c              = currentMedicationsText;
        npp.Year__c                                       = yearValue;
        npp.Pain_Start__c                                 = painStart;
        npp.HQ_Feet__c                                    = feet;
        npp.HQ_Inches__c                                  = inches;
        npp.HQ_Pain_Level_Numeric_Rating_Scale__c         = painLevel;
        npp.HQ_Onset_of_Pain__c                           = onsetOfPain;
        npp.HQ_Additional_Pain_Complaints__c              = additionalPainComplaints;
        npp.HQ_Medical_Doctor_Consultation__c             = medicalDoctorConsultation;
        npp.HQ_Doctor_s_Name__c                           = doctorsName;
        npp.Account__c=Account;

        // 🔁 Signature field – update the API name here
        // Example: npp.HQ_Signature__c = signatureData;
        // For now, leaving this as a comment for you to plug in:
        // npp.Signature__c = signatureData;

        insert npp;


        // --- 2. Convert signature base64 to Blob ---
        String base64Data = signatureData.split(',')[1];
        Blob fileBlob = EncodingUtil.base64Decode(base64Data);

        // --- 3. Upload file to Salesforce as ContentVersion ---
        ContentVersion cv = new ContentVersion(
            Title = 'Signature_' + npp.Id,
            PathOnClient = 'signature.png',
            VersionData = fileBlob,
            FirstPublishLocationId = npp.Id
        );
        insert cv;

        return npp.Id;
    }
    @AuraEnabled(cacheable=true)
public static NPP__c getNppData(Id accId){
   NPP__c npp= [SELECT Id,Account__c,CreatedDate FROM NPP__c WHERE Account__c=: accId order by CreatedDate desc limit 1];
    return [
        SELECT HQ_Any_issues_or_concerns_with_immune__c,HQ_Weight__c,HQ_Employer__c, HQ_Job_Title__c,HQ_COVID_19_Vaccination_Status__c,HQ_Chief_Complaint__c,HQ_Current_Medications__c,HQ_Current_Medications_If_YES__c,Year__c ,
        Pain_Start__c,HQ_Feet__c,HQ_Inches__c,HQ_Pain_Level_Numeric_Rating_Scale__c,HQ_Onset_of_Pain__c,HQ_Additional_Pain_Complaints__c,HQ_Medical_Doctor_Consultation__c,HQ_Doctor_s_Name__c,Account__c
        FROM NPP__c WHERE Id =:npp.id
            ];
}
}