public class HorizonChargeMergeHandler {

    public static void mergeAllCharges() {
        // Fetch all charges
        List<Hz_Horizon_Charges__c> allCharges = [
            SELECT Id, Hz_DOS__c, Hz_Provider_Id__c, Hz_Patient_Id__c,
                   Hz_Amount__c, Hz_Expected_Reimbursement__c, CreatedDate
            FROM Hz_Horizon_Charges__c
            WHERE Hz_DOS__c != NULL
            AND Hz_Provider_Id__c != NULL
            AND Hz_Patient_Id__c != NULL
        ];

        if (allCharges.isEmpty()) return;

        // Group by DOS + Provider + Patient
        Map<String, List<Hz_Horizon_Charges__c>> groupedCharges = new Map<String, List<Hz_Horizon_Charges__c>>();
        for (Hz_Horizon_Charges__c ch : allCharges) {
            String key = ch.Hz_DOS__c + '-' + ch.Hz_Provider_Id__c + '-' + ch.Hz_Patient_Id__c;
            if (!groupedCharges.containsKey(key)) {
                groupedCharges.put(key, new List<Hz_Horizon_Charges__c>());
            }
            groupedCharges.get(key).add(ch);
        }

        List<Hz_Horizon_Charges__c> updates = new List<Hz_Horizon_Charges__c>();
        List<Hz_Horizon_Charges__c> deletes = new List<Hz_Horizon_Charges__c>();

        for (String key : groupedCharges.keySet()) {
            List<Hz_Horizon_Charges__c> chargeGroup = groupedCharges.get(key);

            if (chargeGroup.size() > 1) {
                Decimal totalAmount = 0;
                Decimal totalReimbursement = 0;

                for (Hz_Horizon_Charges__c rec : chargeGroup) {
                    totalAmount += (rec.Hz_Amount__c != null ? rec.Hz_Amount__c : 0);
                    totalReimbursement += (rec.Hz_Expected_Reimbursement__c != null ? rec.Hz_Expected_Reimbursement__c : 0);
                }

                // 🔹 Find the most recent record (max CreatedDate)
                Hz_Horizon_Charges__c masterRecord = chargeGroup[0];
                for (Hz_Horizon_Charges__c rec : chargeGroup) {
                    if (rec.CreatedDate > masterRecord.CreatedDate) {
                        masterRecord = rec;
                    }
                }

                // Update master with summed values
                masterRecord.Hz_Amount__c = totalAmount;
                masterRecord.Hz_Expected_Reimbursement__c = totalReimbursement;
                updates.add(masterRecord);

                // Mark others (older ones) for deletion
                for (Hz_Horizon_Charges__c rec : chargeGroup) {
                    if (rec.Id != masterRecord.Id) {
                        deletes.add(rec);
                    }
                }
            }
        }

        if (!updates.isEmpty()) {
            update updates;
        }
        if (!deletes.isEmpty()) {
            delete deletes;
        }
    }
}