public class FHClaimNumber {
    /* For charge records (Hz_Horizon_Charges__c) created today, if the related Case has a VOB Type of Reverification or Major Med,
       and the charge’s Provider_Specialty__c is OT, PT, CHIRO, or MD, the charge qualifies only when Hz_Payer_Id__c = 4882,
       is not in the excluded payer list, and Hz_Fee_Schedule__c is one of UCR, R&C, U&C. For OT, PT, or CHIRO, the corresponding
       Insurance Plan’s Daily Capitated Fee (Daily_OT_Capitated_Fee__c, Daily_PT_Capitated_Fee__c, or Daily_Chiro_Capitated_Fee__c)
       must be NULL; for MD, no capitated fee check is required. For qualifying charges, if other charges exist with the same Provider,
       DOS, and Patient Account, and the total amount is ≥ 5000, then reimbursement is determined from FairHealth schedules.
       If Hz_DOS__c ≥ 2025-05-01, use FH-70; if Hz_DOS__c < 2025-05-01, use FH-74. The allowance percentage from the charge
       determines which FH percentile (50th, 60th, 70th, 75th, 80th, 85th, 90th, or 95th) is selected, and that value is updated
       into Hz_Expected_Reimbursement__c. */

    // Set of excluded Payer IDs
    private static final Set<String> EXCLUDED_PAYER_IDS = new Set<String>{
        '4870', '4883', '4873', '12848', '5216', '4915', '7791', '1696', '5877'
    };
 
    // Date threshold for logic split
    private static final Date THRESHOLD_DATE = Date.newInstance(2025, 5, 1);
 
    public static void processCharges(List<Hz_Horizon_Charges__c> charges) {
        // Store charges to update
        List<Hz_Horizon_Charges__c> chargesToUpdate = new List<Hz_Horizon_Charges__c>();
     
        System.debug('Processing ' + charges.size() + ' charges at ' + System.now());
     
        // Collect Case IDs for VOB Type check
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
        System.debug('Queried ' + caseMap.size() + ' Case records');
      
        // Validate input charges and group by Provider, DOS, and Patient Account for amount check
        Map<String, List<Hz_Horizon_Charges__c>> chargeGroupMap = new Map<String, List<Hz_Horizon_Charges__c>>();
        Set<String> providerIds = new Set<String>();
        Set<Date> dosDates = new Set<Date>();
        Set<String> patientAccounts = new Set<String>();
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
          
            // Validate qualification criteria
            if (charge.Hz_Payer_Id__c != '4882' ||
                EXCLUDED_PAYER_IDS.contains(charge.Hz_Payer_Id__c) ||
                charge.Hz_Insurance_Plan__c == null ||
                charge.Hz_Procedure_Code__c == null ||
                charge.Hz_DOS__c == null ||
                charge.Hz_Provider_Id__c == null ||
                charge.Hz_Patient_Account__c == null ||
                charge.Hz_Allowance_Percentage_Number__c == null ||
                (charge.Hz_Fee_Schedule__c != 'R&C' && charge.Hz_Fee_Schedule__c != 'UCR' && charge.Hz_Fee_Schedule__c != 'U&C')) {
                System.debug('Skipping charge Id=' + charge.Id + ' due to invalid qualification criteria');
                continue;
            }
         
            String key = charge.Hz_Provider_Id__c + '_' + String.valueOf(charge.Hz_DOS__c) + '_' + charge.Hz_Patient_Account__c;
            if (!chargeGroupMap.containsKey(key)) {
                chargeGroupMap.put(key, new List<Hz_Horizon_Charges__c>());
            }
            chargeGroupMap.get(key).add(charge);
            providerIds.add(charge.Hz_Provider_Id__c);
            dosDates.add(charge.Hz_DOS__c);
            patientAccounts.add(charge.Hz_Patient_Account__c);
            System.debug('Added charge to map: Id=' + charge.Id + ', Key=' + key);
        }
     
        System.debug('Unique charge groups: ' + chargeGroupMap.size());
     
        // Query to get sum of amounts for grouped charges
        Map<String, Decimal> keyToTotalAmount = new Map<String, Decimal>();
        for (AggregateResult ar : [
            SELECT Hz_Provider_Id__c, Hz_DOS__c, Hz_Patient_Account__c, SUM(Hz_Amount__c) totalAmount
            FROM Hz_Horizon_Charges__c
            WHERE Hz_Provider_Id__c IN :providerIds
            AND Hz_DOS__c IN :dosDates
            AND Hz_Patient_Account__c IN :patientAccounts
            GROUP BY Hz_Provider_Id__c, Hz_DOS__c, Hz_Patient_Account__c
            HAVING SUM(Hz_Amount__c) >= 5000
        ]) {
            String key = (String)ar.get('Hz_Provider_Id__c') + '_' + String.valueOf((Date)ar.get('Hz_DOS__c')) + '_' + (String)ar.get('Hz_Patient_Account__c');
            keyToTotalAmount.put(key, (Decimal)ar.get('totalAmount'));
            System.debug('Group key=' + key + ', Total Amount=' + (Decimal)ar.get('totalAmount'));
        }
     
        // Process each charge
        for (String key : chargeGroupMap.keySet()) {
            // Skip if total amount < 5000
            if (!keyToTotalAmount.containsKey(key)) {
                System.debug('Skipping group key=' + key + ' due to total amount < 5000');
                continue;
            }
         
            for (Hz_Horizon_Charges__c charge : chargeGroupMap.get(key)) {
                String procedureCode = charge.Hz_Procedure_Code__c;
                Date dos = charge.Hz_DOS__c;
                Decimal allowancePercentage = charge.Hz_Allowance_Percentage_Number__c;
                System.debug('Processing charge Id=' + charge.Id + ', ProcedureCode=' + procedureCode + ', DOS=' + dos +
                            ', AllowancePercentage=' + allowancePercentage);
             
                if (dos >= THRESHOLD_DATE) {
                    // Query Hz_FairHealth_070_Schedule__c
                    try {
                        List<Hz_FairHealth_070_Schedule__c> fairHealthRecords = [
                            SELECT Hz_FH_070_Release_Date__c, Hz_FH_070_50TH__c, Hz_FH_070_60TH__c,
                                   Hz_FH_070_70TH__c, Hz_FH_070_75TH__c, Hz_FH_070_80TH__c,
                                   Hz_FH_070_85TH__c, Hz_FH_070_90TH__c, Hz_FH_070_95TH__c
                            FROM Hz_FairHealth_070_Schedule__c
                            WHERE Hz_FH_070_PROCEDURE_CODE__c = :procedureCode
                        ];
                        System.debug('Found ' + fairHealthRecords.size() + ' Hz_FairHealth_070_Schedule__c records for ProcedureCode=' + procedureCode);
                     
                        // Find the record with the closest release date to DOS
                        Hz_FairHealth_070_Schedule__c closestRecord = null;
                        Integer minDateDiff = null;
                        for (Hz_FairHealth_070_Schedule__c record : fairHealthRecords) {
                            if (record.Hz_FH_070_Release_Date__c == null) {
                                System.debug('Skipping Hz_FairHealth_070_Schedule__c record Id=' + record.Id + ' due to null Release Date');
                                continue;
                            }
                            Integer dateDiff = Math.abs(record.Hz_FH_070_Release_Date__c.daysBetween(dos));
                            System.debug('Record Id=' + record.Id + ', Release Date=' + record.Hz_FH_070_Release_Date__c + ', DateDiff=' + dateDiff);
                            if (minDateDiff == null || dateDiff < minDateDiff) {
                                minDateDiff = dateDiff;
                                closestRecord = record;
                            }
                        }
                     
                        if (closestRecord != null) {
                            System.debug('Closest Hz_FairHealth_070_Schedule__c record found: Id=' + closestRecord.Id + ', ReleaseDate=' + closestRecord.Hz_FH_070_Release_Date__c);
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
                            System.debug('No matching Hz_FairHealth_070_Schedule__c record found for charge Id=' + charge.Id);
                        }
                    } catch (Exception e) {
                        System.debug('Error querying Hz_FairHealth_070_Schedule__c for charge Id=' + charge.Id + ': ' + e.getMessage());
                    }
                } else {
                    // Query Hz_FairHealth_074_Schedule__c
                    try {
                        List<Hz_FairHealth_074_Schedule__c> fairHealthRecords = [
                            SELECT Hz_FH_074_Release_Date__c, Hz_FH_074_50TH__c, Hz_FH_074_60TH__c,
                                   Hz_FH_074_70TH__c, Hz_FH_074_75TH__c, Hz_FH_074_80TH__c,
                                   Hz_FH_074_85TH__c, Hz_FH_074_90TH__c, Hz_FH_074_95TH__c
                            FROM Hz_FairHealth_074_Schedule__c
                            WHERE Hz_FH_074_Procedure_Code__c = :procedureCode
                        ];
                        System.debug('Found ' + fairHealthRecords.size() + ' Hz_FairHealth_074_Schedule__c records for ProcedureCode=' + procedureCode);
                     
                        // Find the record with the closest release date to DOS
                        Hz_FairHealth_074_Schedule__c closestRecord = null;
                        Integer minDateDiff = null;
                        for (Hz_FairHealth_074_Schedule__c record : fairHealthRecords) {
                            if (record.Hz_FH_074_Release_Date__c == null) {
                                System.debug('Skipping Hz_FairHealth_074_Schedule__c record Id=' + record.Id + ' due to null Release Date');
                                continue;
                            }
                            Integer dateDiff = Math.abs(record.Hz_FH_074_Release_Date__c.daysBetween(dos));
                            System.debug('Record Id=' + record.Id + ', Release Date=' + record.Hz_FH_074_Release_Date__c + ', DateDiff=' + dateDiff);
                            if (minDateDiff == null || dateDiff < minDateDiff) {
                                minDateDiff = dateDiff;
                                closestRecord = record;
                            }
                        }
                     
                        if (closestRecord != null) {
                            System.debug('Closest Hz_FairHealth_074_Schedule__c record found: Id=' + closestRecord.Id + ', ReleaseDate=' + closestRecord.Hz_FH_074_Release_Date__c);
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
                            System.debug('No matching Hz_FairHealth_074_Schedule__c record found for charge Id=' + charge.Id);
                        }
                    } catch (Exception e) {
                        System.debug('Error querying Hz_FairHealth_074_Schedule__c for charge Id=' + charge.Id + ': ' + e.getMessage());
                    }
                }
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
        if (fairHealth instanceof Hz_FairHealth_070_Schedule__c) {
            Hz_FairHealth_070_Schedule__c fh = (Hz_FairHealth_070_Schedule__c)fairHealth;
            if (allowancePercentage == 50) return fh.Hz_FH_070_50TH__c;
            else if (allowancePercentage == 60) return fh.Hz_FH_070_60TH__c;
            else if (allowancePercentage == 70) return fh.Hz_FH_070_70TH__c;
            else if (allowancePercentage == 75) return fh.Hz_FH_070_75TH__c;
            else if (allowancePercentage == 80) return fh.Hz_FH_070_80TH__c;
            else if (allowancePercentage == 85) return fh.Hz_FH_070_85TH__c;
            else if (allowancePercentage == 90) return fh.Hz_FH_070_90TH__c;
            else if (allowancePercentage >= 95) return fh.Hz_FH_070_95TH__c;
            System.debug('No matching percentile for AllowancePercentage=' + allowancePercentage + ' in Hz_FairHealth_070_Schedule__c');
        } else if (fairHealth instanceof Hz_FairHealth_074_Schedule__c) {
            Hz_FairHealth_074_Schedule__c fh = (Hz_FairHealth_074_Schedule__c)fairHealth;
            if (allowancePercentage == 50) return fh.Hz_FH_074_50TH__c;
            else if (allowancePercentage == 60) return fh.Hz_FH_074_60TH__c;
            else if (allowancePercentage == 70) return fh.Hz_FH_074_70TH__c;
            else if (allowancePercentage == 75) return fh.Hz_FH_074_75TH__c;
            else if (allowancePercentage == 80) return fh.Hz_FH_074_80TH__c;
            else if (allowancePercentage == 85) return fh.Hz_FH_074_85TH__c;
            else if (allowancePercentage == 90) return fh.Hz_FH_074_90TH__c;
            else if (allowancePercentage >= 95) return fh.Hz_FH_074_95TH__c;
            System.debug('No matching percentile for AllowancePercentage=' + allowancePercentage + ' in Hz_FairHealth_074_Schedule__c');
        }
        return null;
    }
}