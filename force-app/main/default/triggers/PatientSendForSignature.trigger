trigger PatientSendForSignature on Account (after update) {

    // Collect Accounts that just flipped Send_for_Signature__c from false -> true
    Set<Id> accountIdsToProcess = new Set<Id>();

    for (Account p : Trigger.new) {
        Account oldP = Trigger.oldMap.get(p.Id);

        if (p.Send_for_Signature__c == true && oldP.Send_for_Signature__c == false) {
            accountIdsToProcess.add(p.Id);
        }
    }

    if (!accountIdsToProcess.isEmpty()) {
        // Call async method
        PdfToBase64Controller.publishSignatureEvents(new List<Id>(accountIdsToProcess));
    }
}