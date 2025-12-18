public class HorizonChargeMedicares {
    /* The automation applies to Hz_Horizon_Charges__c records created today, with a parent lookup to Insurance_Plan__c.
       It only runs if the related Case has a VOB Type of Reverification or Major Med, and the Insurance Plan meets the
       Provider_Specialty__c-based capitated fee condition (or is 'MD'). A charge qualifies when Hz_Payer_Id__c ≠ 4870, is within
       {4883, 4873, 12848, 5216, 4915, 7791, 1696, 5877}, and Hz_Fee_Schedule__c = 'CMS'. The reference object is
       determined by Medicare_Geozip__c and DOS year: North NJ (08816, 08857, 07410, etc.) maps to Hz_North_NJ_2023/2024/2025,
       while Rest of NJ (07728, 07701, 07753, etc.) maps to Hz_Rest_of_NJ_2023/2024/2025. Matching is done where
       Hz_Proc_Code__c = Hz_Procedure_Code__c, and the Hz_Par_Fee__c from the reference record is updated into Hz_Expected_Reimbursement__c.
       If multiple matches exist, and the charge’s Hz_Location_Id__c is in a specified list, priority goes to records with
       Hz_Fac_Ind__c = '#'; otherwise, the first match is used. */
   
    // Set of valid Payer IDs
    private static final Set<String> VALID_PAYER_IDS = new Set<String>{'4883', '4873', '12848', '5216', '4915', '7791', '1696', '5877'};
  
    // Set of Location IDs for prioritizing Hz_Fac_Ind__c = '#'
    private static final Set<String> PRIORITY_LOCATION_IDS = new Set<String>{
        '44810', '48721', '48722', '51009', '51834', '51835',
        '44808', '44813', '48503', '48502', '48874', '44814',
        '44815', '50056', '50057', '44816', '44702', '53513',
        '53514', '55097', '55096', '53754', '55567'
    };
  
    // Sets of Medicare Geozips
    private static final Set<String> NORTH_NJ_GEOZIPS = new Set<String>{
        '08816', '08857', '07410', '07003', '07869', '07083', '07054', '07424', '07065', '07666', '07094', '07109', '07042'
    };
    private static final Set<String> REST_OF_NJ_GEOZIPS = new Set<String>{
        '07728', '07701', '07753', '07747', '07751', '08701'
    };
  
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
        System.debug('Queried ' + caseMap.size() + ' Case records');
       
        // Collect unique combinations of Procedure Code, DOS, and Medicare_Geozip__c
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
            if (charge.Hz_Procedure_Code__c == null || charge.Hz_DOS__c == null || charge.Medicare_Geozip__c == null) {
                System.debug('Skipping charge Id=' + charge.Id + ' due to null Hz_Procedure_Code__c, Hz_DOS__c, or Medicare_Geozip__c');
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
            if (charge.Hz_Payer_Id__c == '4870' ||
                !VALID_PAYER_IDS.contains(charge.Hz_Payer_Id__c) ||
                charge.Hz_Fee_Schedule__c != 'CMS') {
                System.debug('Skipping charge Id=' + charge.Id + ' due to failing payer or fee schedule conditions');
                continue;
            }
           
            String key = charge.Medicare_Geozip__c + '-' + charge.Hz_Procedure_Code__c + '-' + charge.Hz_DOS__c;
            chargeKeyToCharge.put(key, charge);
            System.debug('Added charge to map: Id=' + charge.Id + ', Key=' + key);
        }
      
        System.debug('Unique charge keys: ' + chargeKeyToCharge.size());
      
        // Process each charge
        for (String key : chargeKeyToCharge.keySet()) {
            Hz_Horizon_Charges__c charge = chargeKeyToCharge.get(key);
            String geozip = charge.Medicare_Geozip__c;
            String procedureCode = charge.Hz_Procedure_Code__c;
            Date dos = charge.Hz_DOS__c;
            Integer dosYear = dos.year();
            String locationId = charge.Hz_Location_Id__c;
            System.debug('Processing charge Id=' + charge.Id + ', Medicare_Geozip__c=' + geozip + ', ProcedureCode=' + procedureCode + ', DOS=' + dos + ', DOS Year=' + dosYear + ', LocationId=' + locationId);
          
            // Determine the reference object based on Geozip and DOS year
            String sObjectName;
            if (NORTH_NJ_GEOZIPS.contains(geozip)) {
                if (dosYear == 2023) {
                    sObjectName = 'Hz_North_NJ_2023__c';
                } else if (dosYear == 2024) {
                    sObjectName = 'Hz_North_NJ_2024__c';
                } else if (dosYear == 2025) {
                    sObjectName = 'Hz_North_NJ_2025__c';
                }
            } else if (REST_OF_NJ_GEOZIPS.contains(geozip)) {
                if (dosYear == 2023) {
                    sObjectName = 'Hz_Rest_of_NJ_2023__c';
                } else if (dosYear == 2024) {
                    sObjectName = 'Hz_Rest_of_NJ_2024__c';
                } else if (dosYear == 2025) {
                    sObjectName = 'Hz_Rest_of_NJ_2025__c';
                }
            }
          
            if (sObjectName == null) {
                System.debug('Charge Id=' + charge.Id + ' skipped: Medicare_Geozip__c=' + geozip + ', DOS Year=' + dosYear + ' does not match North NJ or Rest of NJ criteria');
                continue;
            }
          
            // Query the reference object
            String query = 'SELECT Id, Hz_Proc_Code__c, Hz_Par_Fee__c, Hz_Fac_Ind__c ' +
                          'FROM ' + sObjectName + ' ' +
                          'WHERE Hz_Proc_Code__c = :procedureCode';
            List<SObject> referenceRecords = Database.query(query);
            System.debug('Found ' + referenceRecords.size() + ' ' + sObjectName + ' records for ProcedureCode=' + procedureCode);
          
            // Find the matching record
            SObject selectedRecord = null;
            if (!referenceRecords.isEmpty()) {
                if (referenceRecords.size() > 1 && PRIORITY_LOCATION_IDS.contains(locationId)) {
                    // Prioritize record with Hz_Fac_Ind__c = '#'
                    for (SObject record : referenceRecords) {
                        if (record.get('Hz_Fac_Ind__c') == '#') {
                            selectedRecord = record;
                            System.debug('Selected ' + sObjectName + ' record Id=' + record.Id + ' with Hz_Fac_Ind__c=#, ProcedureCode=' + procedureCode);
                            break;
                        }
                    }
                }
                // If no priority record or single record, take the first one
                if (selectedRecord == null) {
                    selectedRecord = referenceRecords[0];
                    System.debug('Selected ' + sObjectName + ' record Id=' + selectedRecord.Id + ' (first match), ProcedureCode=' + procedureCode);
                }
              
                // Update the charge with Hz_Par_Fee__c
                Decimal parFee = (Decimal)selectedRecord.get('Hz_Par_Fee__c');
                if (parFee != null) {
                    charge.Hz_Expected_Reimbursement__c = parFee;
                    chargesToUpdate.add(charge);
                    System.debug('Added charge Id=' + charge.Id + ' to update with Hz_Expected_Reimbursement__c=' + parFee);
                } else {
                    System.debug('No Hz_Par_Fee__c value for ' + sObjectName + ' record Id=' + selectedRecord.Id + ', charge Id=' + charge.Id + ' not updated');
                }
            } else {
                System.debug('No matching ' + sObjectName + ' record found for charge Id=' + charge.Id + ', ProcedureCode=' + procedureCode);
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
}