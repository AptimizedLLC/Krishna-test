public with sharing class NPPFileHandler {
    
    // Step 1: Delete existing files
    @AuraEnabled
    public static void deleteAllFiles(Id nppId) {
        if (nppId == null) throw new AuraHandledException('Record Id is required.');

        try {
            List<ContentDocumentLink> links = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :nppId
            ];

            if (!links.isEmpty()) {
                Set<Id> docIds = new Set<Id>();
                for (ContentDocumentLink l : links) docIds.add(l.ContentDocumentId);
                delete [SELECT Id FROM ContentDocument WHERE Id IN :docIds];
            }

        } catch (Exception ex) {
            throw new AuraHandledException('Error deleting files: ' + ex.getMessage());
        }
    }

    // Step 2: Update HQ_Sign_Id__c with latest uploaded file
    @AuraEnabled
    public static void updateHQSignId(Id nppId) {
        if (nppId == null) throw new AuraHandledException('Record Id is required.');
        try {
            ContentDocumentLink docLink = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :nppId 
            ];

            ContentVersion ver = [
                SELECT Id 
                FROM ContentVersion 
                WHERE ContentDocumentId = :docLink.ContentDocumentId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];

            update new NPP__c(Id = nppId, HQ_Sign_Id__c = ver.Id);

        } catch (Exception ex) {
            throw new AuraHandledException('Error updating HQ Sign Id: ' + ex.getMessage());
        }
    }
}