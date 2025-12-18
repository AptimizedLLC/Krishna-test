public class HorizonChargeNationalHandler {
    /* The automation applies to Hz_Horizon_Charges__c records created today, with a parent lookup to Insurance_Plan__c.
       It only proceeds if the related Case has a VOB Type of Reverification or Major Med, and the Insurance Plan meets the
       Provider_Specialty__c-based capitated fee condition (or is 'MD'). A charge qualifies when Hz_Payer_Id__c ≠ 4870, belongs to the set
       {4883, 4873, 12848, 5216, 4915, 7791, 1696, 5877}, has Hz_Fee_Schedule__c = 'FH', and Hz_Aggregate_Allowance__c = 'National'.
       The matching FairHealth record is selected from Hz_FairHealth_National_Schedule__c where the Procedure Code matches and the
       Release Date is closest to the charge DOS. The Expected Reimbursement is then updated by mapping the charge’s Allowance Percentage
       (50–95+) to the corresponding percentile field on the FairHealth record and storing the value in Hz_Expected_Reimbursement__c. */
   
    public static void processCharges(List<Hz_Horizon_Charges__c> charges) {
        // Store charges to update
        List<Hz_Horizon_Charges__c> chargesToUpdate = new List<Hz_Horizon_Charges__c>();
      
        System.debug('Processing ' + charges.size() + ' charges at ' + System.now());
      
        // Collect unique Case IDs for VOB Type check
        Set<Id> caseIds = new Set<Id>();
        for (Hz_Horizon_Charges__c charge : charges) {
            if (charge.Hz_VOB_Case__c != null) {
                caseIds.add(charge.Hz_VOB_Case__c);
            }
        }
       
        // Query Case records for VOB Type
        Map<Id, Case> caseMap = new Map<Id, Case>([
            SELECT Id, VOB_Type__c
            FROM Case
            WHERE Id IN :caseIds
        ]);
       
        // Collect unique combinations of Procedure Code and DOS for efficient querying
        Map<String, Hz_Horizon_Charges__c> chargeKeyToCharge = new Map<String, Hz_Horizon_Charges__c>();
        Date today = Date.today();
        for (Hz_Horizon_Charges__c charge : charges) {
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
           
            // Validate required fields
            if (charge.Hz_Procedure_Code__c == null || charge.Hz_DOS__c == null) {
                System.debug('Skipping charge Id=' + charge.Id + ' due to null Hz_Procedure_Code__c or Hz_DOS__c');
                continue;
            }
           
            // Check Provider_Specialty__c and corresponding Capitated Fee field
            if (charge.Hz_Insurance_Plan__c != null) {
                if (charge.Provider_Specialty__c != 'MD') {
                    Insurance_Plan__c plan = [SELECT Daily_Chiro_Capitated_Fee__c, Daily_OT_Capitated_Fee__c, Daily_PT_Capitated_Fee__c
                                            FROM Insurance_Plan__c
                                            WHERE Id = :charge.Hz_Insurance_Plan__c LIMIT 1];
                    Boolean isValidSpecialty = false;
                    if (charge.Provider_Specialty__c == 'OT' && plan.Daily_OT_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    } else if (charge.Provider_Specialty__c == 'PT' && plan.Daily_PT_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    } else if (charge.Provider_Specialty__c == 'CHIRO' && plan.Daily_Chiro_Capitated_Fee__c == null) {
                        isValidSpecialty = true;
                    }
                    if (!isValidSpecialty) {
                        System.debug('Skipping charge Id=' + charge.Id + ' due to invalid Provider_Specialty__c or non-null Capitated Fee');
                        continue;
                    }
                }
                // If Provider_Specialty__c is 'MD', proceed without checking any capitated fee
            }
           
            // Hz_Horizon_Charges__c conditions
            Set<String> validPayerIds = new Set<String>{'4883', '4873', '12848', '5216', '4915', '7791', '1696', '5877'};
            if (charge.Hz_Payer_Id__c == '4870' ||
                !validPayerIds.contains(charge.Hz_Payer_Id__c) ||
                charge.Hz_Fee_Schedule__c != 'FH' ||
                charge.Hz_Aggregate_Allowance__c != 'National') {
                System.debug('Skipping charge Id=' + charge.Id + ' due to failing payer, fee schedule, or aggregate allowance conditions');
                continue;
            }
           
            String key = charge.Hz_Procedure_Code__c + '-' + charge.Hz_DOS__c;
            chargeKeyToCharge.put(key, charge);
            System.debug('Added charge to map: Id=' + charge.Id + ', Key=' + key);
        }
      
        System.debug('Unique charge keys: ' + chargeKeyToCharge.size());
      
        // Query FairHealth National schedules
        for (String key : chargeKeyToCharge.keySet()) {
            Hz_Horizon_Charges__c charge = chargeKeyToCharge.get(key);
            String procedureCode = charge.Hz_Procedure_Code__c;
            Date dos = charge.Hz_DOS__c;
            Decimal allowancePercentage = charge.Hz_Allowance_Percentage_Number__c;
            System.debug('Processing charge Id=' + charge.Id + ', ProcedureCode=' + procedureCode + ', DOS=' + dos + ', AllowancePercentage=' + allowancePercentage);
          
            // Query Hz_FairHealth_National_Schedule__c
            List<Hz_FairHealth_National_Schedule__c> fairHealthRecords = [
                SELECT Hz_FH_NS_Release_Date__c, Hz_FH_NS_50TH__c, Hz_FH_NS_60TH__c,
                       Hz_FH_NS_70TH__c, Hz_FH_NS_75TH__c, Hz_FH_NS_80TH__c,
                       Hz_FH_NS_85TH__c, Hz_FH_NS_90TH__c, Hz_FH_NS_95TH__c
                FROM Hz_FairHealth_National_Schedule__c
                WHERE Hz_FH_NS_Procedure_Code__c = :procedureCode
            ];
            System.debug('Found ' + fairHealthRecords.size() + ' Hz_FairHealth_National_Schedule__c records for ProcedureCode=' + procedureCode);
          
            // Find the record with the closest release date to DOS
            Hz_FairHealth_National_Schedule__c closestRecord = null;
            Integer minDateDiff = null;
            for (Hz_FairHealth_National_Schedule__c record : fairHealthRecords) {
                if (record.Hz_FH_NS_Release_Date__c == null) {
                    System.debug('Skipping Hz_FairHealth_National_Schedule__c record Id=' + record.Id + ' due to null Release Date');
                    continue;
                }
                Integer dateDiff = Math.abs(record.Hz_FH_NS_Release_Date__c.daysBetween(dos));
                System.debug('Record Id=' + record.Id + ', Release Date=' + record.Hz_FH_NS_Release_Date__c + ', DateDiff=' + dateDiff);
                if (minDateDiff == null || dateDiff < minDateDiff) {
                    minDateDiff = dateDiff;
                    closestRecord = record;
                }
            }
          
            if (closestRecord != null) {
                System.debug('Closest Hz_FairHealth_National_Schedule__c record found: Id=' + closestRecord.Id + ', ReleaseDate=' + closestRecord.Hz_FH_NS_Release_Date__c);
                Decimal reimbursement = getReimbursement(allowancePercentage, closestRecord);
                System.debug('Calculated reimbursement=' + reimbursement + ' for AllowancePercentage=' + allowancePercentage);
                if (reimbursement != null) {
                    charge.Hz_Expected_Reimbursement__c = reimbursement;
                    chargesToUpdate.add(charge);
                    System.debug('Added charge Id=' + charge.Id + ' to update with Hz_Expected_Reimbursement__c=' + reimbursement);
                } else {
                    System.debug('No reimbursement calculated for charge Id=' + charge.Id);
                }
            } else {
                System.debug('No matching Hz_FairHealth_National_Schedule__c record found for charge Id=' + charge.Id);
            }
        }
      
        // Update charges with new reimbursement values
        System.debug('Updating ' + chargesToUpdate.size() + ' charges at ' + System.now());
        if (!chargesToUpdate.isEmpty()) {
            try {
                Database.SaveResult[] results = Database.update(chargesToUpdate, false);
                for (Integer i = 0; i < results.size(); i++) {
                    Database.SaveResult result = results[i];
                    Hz_Horizon_Charges__c charge = chargesToUpdate[i];
                    if (!result.isSuccess()) {
                        System.debug('Failed to update charge Id=' + charge.Id + ': ' + result.getErrors());
                    } else {
                        System.debug('Successfully updated charge Id=' + charge.Id + ' with Hz_Expected_Reimbursement__c=' + charge.Hz_Expected_Reimbursement__c);
                    }
                }
            } catch (Exception e) {
                System.debug('Error updating charges: ' + e.getMessage());
            }
        } else {
            System.debug('No charges to update');
        }
    }
  
    // Helper method to calculate reimbursement based on allowance percentage
    @TestVisible
    private static Decimal getReimbursement(Decimal allowancePercentage, sObject fairHealth) {
        if (allowancePercentage == null) {
            System.debug('AllowancePercentage is null, returning null reimbursement');
            return null;
        }
      
        System.debug('Calculating reimbursement for AllowancePercentage=' + allowancePercentage);
        if (fairHealth instanceof Hz_FairHealth_National_Schedule__c) {
            Hz_FairHealth_National_Schedule__c fh = (Hz_FairHealth_National_Schedule__c)fairHealth;
            if (allowancePercentage == 50) return fh.Hz_FH_NS_50TH__c;
            else if (allowancePercentage == 60) return fh.Hz_FH_NS_60TH__c;
            else if (allowancePercentage == 70) return fh.Hz_FH_NS_70TH__c;
            else if (allowancePercentage == 75) return fh.Hz_FH_NS_75TH__c;
            else if (allowancePercentage == 80) return fh.Hz_FH_NS_80TH__c;
            else if (allowancePercentage == 85) return fh.Hz_FH_NS_85TH__c;
            else if (allowancePercentage == 90) return fh.Hz_FH_NS_90TH__c;
            else if (allowancePercentage >= 95) return fh.Hz_FH_NS_95TH__c;
            System.debug('No matching percentile for AllowancePercentage=' + allowancePercentage + ' in Hz_FairHealth_National_Schedule__c');
        }
        return null;
    }
}