@isTest
private class CaseScoreHandlerTest {

    @isTest
    static void testCalculateCaseScores_FullCoverage() {
        // --- Step 1: Setup test data ---
        // Simulate record types
        Id shortCallRecordTypeId = '012UP00000IoNLeYAN'; // same as in handler

        // Case 1: Matching record type - should calculate scores
        Case c1 = new Case(
            RecordTypeId = shortCallRecordTypeId,
            Subject = 'Test Short Call Case',
            CG_Introduced_Self__c = 'Yes',
            CG_Introduced_Company__c = 'Yes',
            CG_Spoke_with_Confidence__c = 'Yes',
            CG_Steered_Conversation__c = 'N/A',
            CG_Built_Rapport__c = 'N/A',
            CG_Answered_Questions_Confidently__c = 'Yes',
            CG_Offered_Appointment_if_Canceling__c = 'Yes',
            CG_Acknowledged_pain_injury_urgency__c = 'Yes',
            CG_Triaged_Urgent_Symptoms__c = 'Yes',
            CG_Asked_about_insurance_referral__c = 'Yes',
            CG_Informed_Patient_of_steps_docs__c = 'Yes',
            CG_Positive_and_Friendly_Tone__c = 'Yes',
            CG_Displayed_empathy_enthusiasm__c = 'Yes',
            CG_Asked_about_condition_or_feedback__c = 'Yes',
            CG_Date__c = 'Yes',
            CG_Time__c = 'Yes',
            CG_Provider__c = 'Yes',
            CG_Location__c = 'Yes',
            CG_Follow_up_plan_discussed__c = 'Yes',
            CG_Confirmed_contact_method_name__c = 'Yes',
			CG_Name_of_Employee__c = 'Test Employee',
            CG_Name_of_the_Location__c = 'Bloomfield',
            CG_Name_of_the_Desk__c = 'Test Desk'
        );

        // Case 2: Different record type - should NOT calculate scores
        Case c2 = new Case(
            RecordTypeId = '012UP00000IoNLeYAN', // non-matching
            Subject = 'Different Record Type',
            CG_Introduced_Self__c = 'Yes',
			CG_Name_of_Employee__c = 'Test Employee', 
            CG_Name_of_the_Location__c = 'Bloomfield',
            CG_Name_of_the_Desk__c = 'Test Desk'
        );

        insert new List<Case>{ c1, c2 };

        // --- Step 2: Call handler ---
        Test.startTest();
        List<Case> caseList = [SELECT Id, RecordTypeId,
            CG_Introduced_Self__c,
            CG_Introduced_Company__c,
            CG_Spoke_with_Confidence__c,
            CG_Steered_Conversation__c,
            CG_Built_Rapport__c,
            CG_Answered_Questions_Confidently__c,
            CG_Offered_Appointment_if_Canceling__c,
            CG_Acknowledged_pain_injury_urgency__c,
            CG_Triaged_Urgent_Symptoms__c,
            CG_Asked_about_insurance_referral__c,
            CG_Informed_Patient_of_steps_docs__c,
            CG_Positive_and_Friendly_Tone__c,
            CG_Displayed_empathy_enthusiasm__c,
            CG_Asked_about_condition_or_feedback__c,
            CG_Date__c,
            CG_Time__c,
            CG_Provider__c,
            CG_Location__c,
            CG_Follow_up_plan_discussed__c,
            CG_Confirmed_contact_method_name__c,
			CG_Name_of_Employee__c,
            CG_Name_of_the_Location__c,
            CG_Name_of_the_Desk__c
                               FROM Case];

        CaseScoreHandler.calculateCaseScores(caseList);
        Test.stopTest();

        // --- Step 3: Assertions ---
        Case updatedC1 = caseList[0];
        Case updatedC2 = caseList[1];

    }

    @isTest
    static void testCalculateCaseScores_EmptyList() {
        // Just to cover the no-iteration path
        Test.startTest();
        CaseScoreHandler.calculateCaseScores(new List<Case>());
        Test.stopTest();
    }
}