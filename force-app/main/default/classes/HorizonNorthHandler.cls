public class HorizonNorthHandler {
    /* For charge records (Hz_Horizon_Charges__c) created today, if the related Case has a VOB Type of Reverification or Major Med,
       and the charge’s Provider_Specialty__c is OT, PT, CHIRO, or MD, the charge qualifies when its Fee Schedule is CMS, MNRP, or MCR.
       For OT, PT, or CHIRO, the corresponding Insurance Plan’s Daily Capitated Fee (Daily_OT_Capitated_Fee__c, Daily_PT_Capitated_Fee__c,
       or Daily_Chiro_Capitated_Fee__c) must be NULL; for MD, no capitated fee check is required. Based on the charge’s Medicare_Geozip__c
       and Hz_DOS__c, the corresponding North NJ reference object (per year) is selected. The system matches the charge’s procedure code
       with the reference record, retrieves the Hz_Par_Fee__c, and updates it into Hz_Expected_Reimbursement__c after multiplying by
       (Hz_Allowance_Percentage_Number__c / 100). If multiple reference records exist for the same procedure code, priority is given to
       those with Hz_Fac_Ind__c = '#' when the charge’s Location Id is in the specified list; otherwise, the first available record is used. */
      
    // Set of valid Fee Schedules
    private static final Set<String> VALID_FEE_SCHEDULES = new Set<String>{'CMS', 'MNRP', 'MCR'};
  
    // Set of valid North NJ GeoZips
    private static final Set<String> NORTH_NJ_GEOZIPS = new Set<String>{
        '08816', '08857', '07410', '07003', '07869', '07083', '07054',
        '07424', '07065', '07666', '07094', '07109', '07042'
    };
  
    // Set of Location IDs for prioritizing Hz_Fac_Ind__c = '#'
    private static final Set<String> PRIORITY_LOCATION_IDS = new Set<String>{
        '44810', '53754', '48721', '48722', '51009', '51834', '51835',
        '44808', '44813', '48503', '48502', '48874', '53513', '53514',
        '44814', '44815', '50056', '50057', '44816'
    };
  
    public static void processCharges(List<Hz_Horizon_Charges__c> charges) {
        // Log start of processing
        System.debug('Processing ' + charges.size() + ' Hz_Horizon_Charges__c records at ' + System.now());
      
        // Collect Insurance Plan IDs and Case IDs
        Set<Id> insurancePlanIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        for (Hz_Horizon_Charges__c charge : charges) {
            if (charge.Hz_Insurance_Plan__c != null) {
                insurancePlanIds.add(charge.Hz_Insurance_Plan__c);
            } else {
                System.debug('Skipping charge Id=' + charge.Id + ' due to null Hz_Insurance_Plan__c');
            }
            if (charge.Hz_VOB_Case__c != null) {
                caseIds.add(charge.Hz_VOB_Case__c);
            }
        }
        System.debug('Found ' + insurancePlanIds.size() + ' Insurance Plan IDs and ' + caseIds.size() + ' Case IDs');
      
        // Query parent Insurance Plans for capitated fee checks
        Map<Id, Insurance_Plan__c> insurancePlans = new Map<Id, Insurance_Plan__c>(
            [SELECT Id, Daily_Chiro_Capitated_Fee__c, Daily_OT_Capitated_Fee__c, Daily_PT_Capitated_Fee__c
             FROM Insurance_Plan__c
             WHERE Id IN :insurancePlanIds]
        );
        System.debug('Found ' + insurancePlans.size() + ' Insurance Plans');
      
        // Query Case records for VOB Type
        Map<Id, Case> caseMap = new Map<Id, Case>(
            [SELECT Id, VOB_Type__c
             FROM Case
             WHERE Id IN :caseIds]
        );
        System.debug('Found ' + caseMap.size() + ' Case records');
      
        // Filter qualified charges
        List<Hz_Horizon_Charges__c> chargesToUpdate = new List<Hz_Horizon_Charges__c>();
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
           
            // Check Provider_Specialty__c and corresponding Capitated Fee field
            Boolean isValidSpecialty = false;
            if (charge.Provider_Specialty__c == 'MD') {
                isValidSpecialty = true;
                System.debug('Charge Id=' + charge.Id + ' with Provider_Specialty__c=MD, proceeding without capitated fee check');
            } else {
                Insurance_Plan__c plan = insurancePlans.get(charge.Hz_Insurance_Plan__c);
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
           
            // Validate charge fields
            if (charge.Hz_Procedure_Code__c == null || charge.Hz_DOS__c == null || charge.Medicare_Geozip__c == null) {
                System.debug('Skipping charge Id=' + charge.Id + ' due to null Hz_Procedure_Code__c, Hz_DOS__c, or Medicare_Geozip__c');
                continue;
            }
            if (isValidSpecialty &&
                VALID_FEE_SCHEDULES.contains(charge.Hz_Fee_Schedule__c) &&
                NORTH_NJ_GEOZIPS.contains(charge.Medicare_Geozip__c)) {
                String key = charge.Medicare_Geozip__c + '-' + charge.Hz_Procedure_Code__c + '-' + charge.Hz_DOS__c;
                chargeKeyToCharge.put(key, charge);
                System.debug('Qualified charge Id=' + charge.Id + ', Key=' + key);
            } else {
                System.debug('Charge Id=' + charge.Id + ' did not qualify: ' +
                    'ValidSpecialty=' + isValidSpecialty +
                    ', FeeSchedule=' + VALID_FEE_SCHEDULES.contains(charge.Hz_Fee_Schedule__c) +
                    ', GeoZip=' + NORTH_NJ_GEOZIPS.contains(charge.Medicare_Geozip__c));
            }
        }
        System.debug('Found ' + chargeKeyToCharge.size() + ' qualifying charges');
      
        if (chargeKeyToCharge.isEmpty()) {
            System.debug('No charges qualified for processing');
            return;
        }
      
        // Map reference objects by year
        Map<Integer, String> yearToReferenceObject = new Map<Integer, String>{
            2023 => 'Hz_North_NJ_2023__c',
            2024 => 'Hz_North_NJ_2024__c',
            2025 => 'Hz_North_NJ_2025__c'
        };
      
        // Process each qualified charge
        for (String key : chargeKeyToCharge.keySet()) {
            Hz_Horizon_Charges__c charge = chargeKeyToCharge.get(key);
            String geozip = charge.Medicare_Geozip__c;
            String procedureCode = charge.Hz_Procedure_Code__c;
            Date dos = charge.Hz_DOS__c;
            Integer dosYear = dos.year();
            String locationId = charge.Hz_Location_Id__c;
            System.debug('Processing charge Id=' + charge.Id + ', Medicare_Geozip__c=' + geozip +
                ', ProcedureCode=' + procedureCode + ', DOS=' + dos + ', DOS Year=' + dosYear +
                ', LocationId=' + locationId);
          
            // Determine reference object
            String sObjectName = yearToReferenceObject.get(dosYear);
            if (sObjectName == null) {
                System.debug('Charge Id=' + charge.Id + ' skipped: DOS Year=' + dosYear + ' not supported');
                continue;
            }
          
            // Query reference object
            String query = 'SELECT Id, Hz_Proc_Code__c, Hz_Par_Fee__c, Hz_Fac_Ind__c ' +
                          'FROM ' + String.escapeSingleQuotes(sObjectName) + ' ' +
                          'WHERE Hz_Proc_Code__c = :procedureCode';
            List<SObject> referenceRecords;
            try {
                referenceRecords = Database.query(query);
                System.debug('Found ' + referenceRecords.size() + ' ' + sObjectName + ' records for ProcedureCode=' + procedureCode);
            } catch (Exception e) {
                System.debug('Error querying ' + sObjectName + ' for charge Id=' + charge.Id + ': ' + e.getMessage());
                continue;
            }
          
            // Find matching record
            SObject selectedRecord = null;
            if (!referenceRecords.isEmpty()) {
                if (referenceRecords.size() > 1 && PRIORITY_LOCATION_IDS.contains(locationId)) {
                    for (SObject record : referenceRecords) {
                        if ((String)record.get('Hz_Fac_Ind__c') == '#') {
                            selectedRecord = record;
                            System.debug('Selected ' + sObjectName + ' record Id=' + record.Id +
                                ' with Hz_Fac_Ind__c=#, ProcedureCode=' + procedureCode);
                            break;
                        }
                    }
                }
                if (selectedRecord == null) {
                    selectedRecord = referenceRecords[0];
                    System.debug('Selected ' + sObjectName + ' record Id=' + selectedRecord.Id +
                        ' (first match), ProcedureCode=' + procedureCode);
                }
              
                // Update Expected Reimbursement with allowance percentage
                Decimal parFee = (Decimal)selectedRecord.get('Hz_Par_Fee__c');
                if (parFee != null) {
                    Decimal allowancePercentage = charge.Hz_Allowance_Percentage_Number__c != null
                        ? charge.Hz_Allowance_Percentage_Number__c / 100
                        : 1.0;
                    charge.Hz_Expected_Reimbursement__c = parFee * allowancePercentage;
                    chargesToUpdate.add(charge);
                    System.debug('Added charge Id=' + charge.Id + ' to update with Hz_Expected_Reimbursement__c=' +
                        charge.Hz_Expected_Reimbursement__c + ', ParFee=' + parFee +
                        ', AllowancePercentage=' + allowancePercentage);
                } else {
                    System.debug('No Hz_Par_Fee__c value for ' + sObjectName + ' record Id=' + selectedRecord.Id +
                        ', charge Id=' + charge.Id + ' not updated');
                }
            } else {
                System.debug('No matching ' + sObjectName + ' record found for charge Id=' + charge.Id +
                    ', ProcedureCode=' + procedureCode);
            }
        }
      
        // Update charges
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
                        System.debug('Successfully updated charge Id=' + charge.Id +
                            ' with Hz_Expected_Reimbursement__c=' + charge.Hz_Expected_Reimbursement__c);
                    }
                }
            } catch (Exception e) {
                System.debug('Error during batch update: ' + e.getMessage());
                throw e;
            }
        } else {
            System.debug('No charges to update');
        }
    }
}