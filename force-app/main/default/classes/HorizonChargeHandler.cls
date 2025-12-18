public class HorizonChargeHandler {
    /*From each Horizon Charge,:
         Get the related Account.
        Find Cases related to that Account with Record Type = 'Verification of Benefits'.
        From those Cases, choose the one whose CreatedDate is closest to but not greater than the charge’s Hz_DOS__c.
        From the selected Case, retrieve the related Insurance Plan (Insurance_Plans__r[0]).
        Update the Charge with both the closest Case and its related Insurance Plan.
        */
    
 public static void processCharges(List<Hz_Horizon_Charges__c> charges) {
        System.debug('Incoming Charges: ' + charges);

        Set<Id> accountIds = new Set<Id>();
        for (Hz_Horizon_Charges__c ch : charges) {
            System.debug('Processing Charge: ' + ch.Id + 
                         ', CreatedDate=' + ch.CreatedDate + 
                         ', DOS=' + ch.Hz_DOS__c +
                         ', Account=' + ch.Hz_Patient_Account__c);

            // Only today's charges
            if (ch.CreatedDate != null && ch.CreatedDate.date() == Date.today()) {
                accountIds.add(ch.Hz_Patient_Account__c);
                System.debug('Charge is created today, account added: ' + ch.Hz_Patient_Account__c);
            } else {
                System.debug('Skipping charge ' + ch.Id + ' - not created today.');
            }
        }

        if (accountIds.isEmpty()) {
            System.debug('No Accounts found for today’s charges. Exiting.');
            return;
        }

        // Fetch Cases for Accounts
        List<Case> caseList = [
            SELECT Id, CreatedDate, RecordType.Name, AccountId,
                   (SELECT Id FROM Insurance_Plans__r)
            FROM Case
            WHERE AccountId IN :accountIds
              AND RecordType.Name = 'Verification of Benefits'
        ];
        System.debug('Retrieved Cases: ' + caseList);

        Map<Id, List<Case>> accountToCasesMap = new Map<Id, List<Case>>();
        Map<Id, Id> caseToInsurancePlanMap = new Map<Id, Id>();

        for (Case c : caseList) {
            if (!accountToCasesMap.containsKey(c.AccountId)) {
                accountToCasesMap.put(c.AccountId, new List<Case>());
            }
            accountToCasesMap.get(c.AccountId).add(c);

            if (!c.Insurance_Plans__r.isEmpty()) {
                caseToInsurancePlanMap.put(c.Id, c.Insurance_Plans__r[0].Id);
                System.debug('Case ' + c.Id + ' has Insurance Plan ' + c.Insurance_Plans__r[0].Id);
            } else {
                System.debug('Case ' + c.Id + ' has no Insurance Plans');
            }
        }

        List<Hz_Horizon_Charges__c> updates = new List<Hz_Horizon_Charges__c>();

        for (Hz_Horizon_Charges__c charge : charges) {
            if (charge.CreatedDate == null || charge.CreatedDate.date() != Date.today()) {
                continue; // skip non-today charges
            }

            Id accId = charge.Hz_Patient_Account__c;
            Date dos = charge.Hz_DOS__c;
            System.debug('Evaluating Charge ' + charge.Id + ' with DOS=' + dos);

            if (accountToCasesMap.containsKey(accId)) {
                Case closestCase = null;
                Integer minDiff = 2147483647;

                for (Case c : accountToCasesMap.get(accId)) {
                    System.debug('➡ Checking Case ' + c.Id + ' (CreatedDate=' + c.CreatedDate + ') against DOS=' + dos);
                    if (c.CreatedDate.date() <= dos) {
                        Integer diff = Math.abs(dos.daysBetween(c.CreatedDate.date()));
                        System.debug('   Difference in days: ' + diff);
                        if (diff < minDiff) {
                            minDiff = diff;
                            closestCase = c;
                        }
                    }
                }

                if (closestCase != null) {
                    System.debug('Closest Case for Charge ' + charge.Id + ' is ' + closestCase.Id);
                    charge.Hz_VOB_Case__c = closestCase.Id;

                    if (caseToInsurancePlanMap.containsKey(closestCase.Id)) {
                        charge.Hz_Insurance_Plan__c = caseToInsurancePlanMap.get(closestCase.Id);
                        System.debug('Assigned Insurance Plan ' + caseToInsurancePlanMap.get(closestCase.Id));
                    } else {
                        System.debug('Closest Case has no Insurance Plan');
                    }
                    updates.add(charge);
                } else {
                    System.debug('No suitable Case found for Charge ' + charge.Id);
                }
            } else {
                System.debug('No Cases found for Account ' + accId + ' (Charge ' + charge.Id + ')');
            }
        }

        if (!updates.isEmpty()) {
            update updates;
            for (Hz_Horizon_Charges__c ch : updates) {
                System.debug('Successfully updated Charge ' + ch.Id +
                             ', VOB Case=' + ch.Hz_VOB_Case__c +
                             ', Insurance Plan=' + ch.Hz_Insurance_Plan__c);
            }
        } else {
            System.debug('No Charges qualified for update.');
        }
    }
}