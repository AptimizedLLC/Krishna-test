public class HorizonChargeBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Hz_Patient_Account__c, Hz_DOS__c, Hz_Insurance_Plan__c, Hz_VOB_Case__c, Hz_Provider_Id__c, Hz_Aggregate_Allowance__c,
                   Hz_Fee_Schedule__c, Hz_Allowance_Percentage_Number__c, Geozip__c, Hz_Procedure_Code__c, Hz_Payer_Id__c, FH_Geozip__c,
                   Medicare_Geozip__c, Hz_Location_Id__c, Hz_Review_Assessment_Notes__c, Hz_Insurance_Plan__r.Daily_OT_Capitated_Fee__c,
                   Hz_Insurance_Plan__r.Daily_Chiro_Capitated_Fee__c, Hz_Insurance_Plan__r.Daily_PT_Capitated_Fee__c, Hz_Amount__c, 
                   Hz_Expected_Reimbursement__c, CreatedDate, Provider_Specialty__c	
            FROM Hz_Horizon_Charges__c
            WHERE Hz_Patient_Account__c != null 
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Hz_Horizon_Charges__c> chargeList = new List<Hz_Horizon_Charges__c>();
        Map<Id, Decimal> originalReimbursementMap = new Map<Id, Decimal>();
        
        // Cast SObjects and store original Hz_Expected_Reimbursement__c values
        for (SObject sObj : scope) {
            Hz_Horizon_Charges__c charge = (Hz_Horizon_Charges__c) sObj;
            chargeList.add(charge);
            originalReimbursementMap.put(charge.Id, charge.Hz_Expected_Reimbursement__c);
        }
        System.debug('Starting batch with ' + chargeList.size() + ' charges for processing');

        // Process charges through HorizonChargeHandler first (no filtering)
        if (!chargeList.isEmpty()) {
            HorizonChargeHandler.processCharges(chargeList);
            System.debug('After HorizonChargeHandler, all ' + chargeList.size() + ' charges remain for reimbursement processing');
            
            // Now apply if-else logic for handlers that update Hz_Expected_Reimbursement__c
            if (!chargeList.isEmpty()) {
                // 1. HorizonChargeReimbursementHandler
                HorizonChargeReimbursementHandler.processReimbursements(chargeList);
                chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                System.debug('After HorizonChargeReimbursementHandler, ' + chargeList.size() + ' charges remain');

                if (!chargeList.isEmpty()) {
                    // 2. HorizonChargeFHAndMedicareHandler
                    HorizonChargeFHAndMedicareHandler.processCharges(chargeList);
                    chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                    System.debug('After HorizonChargeFHAndMedicareHandler, ' + chargeList.size() + ' charges remain');

                    if (!chargeList.isEmpty()) {
                        // 3. HorizonChargeNationalHandler
                        HorizonChargeNationalHandler.processCharges(chargeList);
                        chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                        System.debug('After HorizonChargeNationalHandler, ' + chargeList.size() + ' charges remain');

                        if (!chargeList.isEmpty()) {
                            // 4. HorizonChargeMedicares
                            HorizonChargeMedicares.processCharges(chargeList);
                            chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                            System.debug('After HorizonChargeMedicares, ' + chargeList.size() + ' charges remain');

                            if (!chargeList.isEmpty()) {
                                // 5. ReviewAssessmentNotesHandler
                                ReviewAssessmentNotesHandler.updateReviewNotes(chargeList);
                                chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                                System.debug('After ReviewAssessmentNotesHandler, ' + chargeList.size() + ' charges remain');

                                if (!chargeList.isEmpty()) {
                                    // 6. MedicareOnepointTwo
                                    MedicareOnepointTwo.processCharges(chargeList);
                                    chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                                    System.debug('After MedicareOnepointTwo, ' + chargeList.size() + ' charges remain');

                                    if (!chargeList.isEmpty()) {
                                        // 7. FHClaimNumber
                                        FHClaimNumber.processCharges(chargeList);
                                        chargeList = filterUnupdatedCharges(chargeList, originalReimbursementMap);
                                        System.debug('After FHClaimNumber, ' + chargeList.size() + ' charges remain');

                                        if (!chargeList.isEmpty()) {
                                            // 8. HorizonNorthHandler
                                            HorizonNorthHandler.processCharges(chargeList);
                                            System.debug('After HorizonNorthHandler, processing complete');
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Helper method to filter out charges that have been updated
    private List<Hz_Horizon_Charges__c> filterUnupdatedCharges(List<Hz_Horizon_Charges__c> charges, 
                                                              Map<Id, Decimal> originalReimbursementMap) {
        List<Hz_Horizon_Charges__c> unupdatedCharges = new List<Hz_Horizon_Charges__c>();
        for (Hz_Horizon_Charges__c charge : charges) {
            Decimal originalReimbursement = originalReimbursementMap.get(charge.Id);
            // Check if Hz_Expected_Reimbursement__c has changed
            if (charge.Hz_Expected_Reimbursement__c != originalReimbursement) {
                System.debug('Charge Id=' + charge.Id + ' updated with Hz_Expected_Reimbursement__c=' + 
                             charge.Hz_Expected_Reimbursement__c);
            } else {
                unupdatedCharges.add(charge);
            }
        }
        return unupdatedCharges;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Finished.');
    }
}