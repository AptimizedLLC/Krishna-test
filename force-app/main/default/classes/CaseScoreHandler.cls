public with sharing class CaseScoreHandler {

    public static void calculateCaseScores(List<Case> newCases) {
        // Fetch RecordType ID dynamically based on DeveloperName and SObjectType
        Id SHORT_CALL_RECORDTYPE_ID;
        try {
            SHORT_CALL_RECORDTYPE_ID = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName = 'Short_form_cases' 
                                        AND SObjectType = 'Case' 
                                        LIMIT 1].Id;
        } catch (QueryException e) {
            // Handle case where RecordType is not found
            System.debug('Error: RecordType Short_form_cases not found for Case object.');
            return; // Exit if RecordType is not found
        }

        // Define the field weight map (100 total)
        Map<String, Decimal> fieldPoints = new Map<String, Decimal>{
            // Introduction (5 pts)
            'CG_Introduced_Self__c' => 2.5,
            'CG_Introduced_Company__c' => 2.5,

            // Call Quality (30 pts)
            'CG_Spoke_with_Confidence__c' => 6,
            'CG_Steered_Conversation__c' => 5,
            'CG_Built_Rapport__c' => 6,
            'CG_Answered_Questions_Confidently__c' => 6,
            'CG_Offered_Appointment_if_Canceling__c' => 5,
            'CG_Acknowledged_pain_injury_urgency__c' => 6,
            'CG_Triaged_Urgent_Symptoms__c' => 6,

            // Insurance & Referral (8 pts)
            'CG_Asked_about_insurance_referral__c' => 4,
            'CG_Informed_Patient_of_steps_docs__c' => 4,

            // Energy & Enthusiasm (25 pts)
            'CG_Positive_and_Friendly_Tone__c' => 12.5,
            'CG_Displayed_empathy_enthusiasm__c' => 12.5,

            // Patient Condition Inquiry (4 pts)
            'CG_Asked_about_condition_or_feedback__c' => 4,

            // Reconfirm Appointment (14 pts)
            'CG_Date__c' => 3.5,
            'CG_Time__c' => 3.5,
            'CG_Provider__c' => 3.5,
            'CG_Location__c' => 3.5,

            // Follow-Up & Callback (10 pts)
            'CG_Follow_up_plan_discussed__c' => 2,
            'CG_Confirmed_contact_method_name__c' => 2
        };

        for (Case c : newCases) {
            // Only apply scoring for the specific Record Type
            if (c.RecordTypeId == SHORT_CALL_RECORDTYPE_ID) {
                Decimal score = 0;
                Decimal totalScore = 100;

                for (String fieldName : fieldPoints.keySet()) {
                    Object val = c.get(fieldName);

                    if (val == 'Yes') {
                        score += fieldPoints.get(fieldName);
                    } else if (val == 'NA' || val == 'N/A') {
                        totalScore -= fieldPoints.get(fieldName);
                    }
                }

                // Assign final values
                c.short_call_score__c = score;
                c.TotalCaseScore__c = totalScore;

                // Set the Subject field in the format: "Short Call-Name of Employee / Location + Desk #"
                String employeeName = String.isNotBlank((String)c.get('CG_Name_of_Employee__c')) ? (String)c.get('CG_Name_of_Employee__c') : 'Unknown Employee';
                String locationName = String.isNotBlank((String)c.get('CG_Name_of_the_Location__c')) ? (String)c.get('CG_Name_of_the_Location__c') : 'Unknown Location';
                String deskName = String.isNotBlank((String)c.get('CG_Name_of_the_Desk__c')) ? (String)c.get('CG_Name_of_the_Desk__c') : 'Unknown Desk';
                
                c.Subject = 'Short Call- ' + employeeName + ' / ' + locationName + ' + Desk #' + deskName;
            }
        }
    }
}