public with sharing class ReviewAssessmentNotesHandler {
    /* The automation applies to Hz_Horizon_Charges__c records created today, with a parent lookup to Hz_Insurance_Plan__c.
       It runs only if the related Case has a VOB Type of Reverification or Major Med. A charge qualifies when the
       Provider_Specialty__c field on Hz_Horizon_Charges__c is OT, PT, CHIRO, or MD. For OT, PT, or CHIRO, the corresponding
       capitated fee field (Daily_OT_Capitated_Fee__c, Daily_PT_Capitated_Fee__c, or Daily_Chiro_Capitated_Fee__c) in the
       related Insurance Plan must be null; for MD, no capitated fee check is required. Additionally, the charge’s
       Hz_Payer_Id__c ≠ 4870 and is within {4883, 4873, 12848, 5216, 4915, 7791, 1696, 5877}, and Hz_Fee_Schedule__c
       is not equal to CMS or FH. When these conditions are met, the Review Assessment Notes field on the charge is updated
       with the following message:
       "The Daily OT Capitated Fee, Daily PT Capitated Fee, and Daily Chiro Capitated Fee are all null. The Payer is equal to one of the
        following values: HORIZON BCBS OF NJ, HORIZON HEALTH, HORIZON NJ TOTAL CARE HMO, or HORIZON BCBS OF NEW JERSEY. In addition,
        the Fee Schedule is not equal to either FH or CMS. Please review these records." */
   
    public static void updateReviewNotes(List<Hz_Horizon_Charges__c> chargeList) {
        if (chargeList == null || chargeList.isEmpty()) {
            return;
        }
      
        // Collect parent Insurance Plan Ids and Case Ids
        Set<Id> planIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        for (Hz_Horizon_Charges__c charge : chargeList) {
            if (charge.Hz_Insurance_Plan__c != null) {
                planIds.add(charge.Hz_Insurance_Plan__c);
            }
            if (charge.Hz_VOB_Case__c != null) {
                caseIds.add(charge.Hz_VOB_Case__c);
            }
        }
       
        // Query Insurance Plan data
        Map<Id, Insurance_Plan__c> planMap = new Map<Id, Insurance_Plan__c>(
            [SELECT Id,
                    Daily_Chiro_Capitated_Fee__c,
                    Daily_OT_Capitated_Fee__c,
                    Daily_PT_Capitated_Fee__c
             FROM Insurance_Plan__c
             WHERE Id IN :planIds]
        );
       
        // Query Case records for VOB Type
        Map<Id, Case> caseMap = new Map<Id, Case>(
            [SELECT Id, VOB_Type__c
             FROM Case
             WHERE Id IN :caseIds]
        );
       
        // Allowed Payer Ids
        Set<String> allowedPayerIds = new Set<String>{
            '4883', '4873', '12848', '5216', '4915', '7791', '1696', '5877'
        };
       
        // Notes text to set
        String notesText = 'The Daily OT Capitated Fee, Daily PT Capitated Fee, and Daily Chiro Capitated Fee are all null. ' +
                           'The Payer is equal to one of the following values: HORIZON BCBS OF NJ, HORIZON HEALTH, ' +
                           'HORIZON NJ TOTAL CARE HMO, or HORIZON BCBS OF NEW JERSEY. ' +
                           'In addition, the Fee Schedule is not equal to either FH or CMS. Please review these records.';
       
        List<Hz_Horizon_Charges__c> chargesToUpdate = new List<Hz_Horizon_Charges__c>();
        Date today = Date.today();
        for (Hz_Horizon_Charges__c charge : chargeList) {
            // Check if CreatedDate is today
            if (charge.CreatedDate == null || charge.CreatedDate.date() != today) {
                System.debug('Skipping charge Id=' + charge.Id + ' as CreatedDate=' + charge.CreatedDate + ' is not today');
                continue;
            }
           
            // Check VOB Type from related Case
            Case relatedCase = caseMap.get(charge.Hz_VOB_Case__c);
            if (relatedCase == null || (relatedCase.VOB_Type__c != 'Reverification' && relatedCase.VOB_Type__c != 'Major Med')) {
                System.debug('Skipping charge Id=' + charge.Id + ' due to invalid or missing Case VOB Type');
                continue;
            }
           
            // Check Provider_Specialty__c and corresponding Capitated Fee field
            Boolean isValidSpecialty = false;
            if (charge.Provider_Specialty__c == 'MD') {
                isValidSpecialty = true;
                System.debug('Charge Id=' + charge.Id + ' with Provider_Specialty__c=MD, proceeding without capitated fee check');
            } else {
                Insurance_Plan__c plan = planMap.get(charge.Hz_Insurance_Plan__c);
                if (plan != null) {
                    if (charge.Provider_Specialty__c == 'OT' && plan.Daily_OT_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    } else if (charge.Provider_Specialty__c == 'PT' && plan.Daily_PT_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    } else if (charge.Provider_Specialty__c == 'CHIRO' && plan.Daily_Chiro_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    }
                }
            }
            
            // Check Insurance Plan and Charge conditions
            if (isValidSpecialty
                && charge.Hz_Insurance_Plan__c != null
                && charge.Hz_Payer_Id__c != '4870'
                && allowedPayerIds.contains(charge.Hz_Payer_Id__c)
                && (charge.Hz_Fee_Schedule__c == null
                    || (!charge.Hz_Fee_Schedule__c.equalsIgnoreCase('CMS')
                        && !charge.Hz_Fee_Schedule__c.equalsIgnoreCase('FH')))
            ) {
                charge.Hz_Review_Assessment_Notes__c = notesText;
                chargesToUpdate.add(charge);
                System.debug('Added charge Id=' + charge.Id + ' to update with Hz_Review_Assessment_Notes__c');
            } else {
                System.debug('Skipping charge Id=' + charge.Id + ' due to failing validation conditions');
            }
        }
       
        if (!chargesToUpdate.isEmpty()) {
            try {
                Database.SaveResult[] results = Database.update(chargesToUpdate, false);
                for (Integer i = 0; i < results.size(); i++) {
                    Database.SaveResult result = results[i];
                    Hz_Horizon_Charges__c charge = chargesToUpdate[i];
                    if (!result.isSuccess()) {
                        System.debug('Failed to update charge Id=' + charge.Id + ': ' + result.getErrors());
                    } else {
                        System.debug('Successfully updated charge Id=' + charge.Id + ' with Hz_Review_Assessment_Notes__c');
                    }
                }
            } catch (Exception e) {
                System.debug('Error updating charges: ' + e.getMessage());
            }
        } else {
            System.debug('No charges to update');
        }
    }
}