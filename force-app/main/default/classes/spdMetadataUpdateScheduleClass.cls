public without sharing class spdMetadataUpdateScheduleClass implements Schedulable {

    public static void spdMetadataUpdateMethod(List<SPD__c> appendStrings) {
        Boolean isMetadataUpdateNeeded = false;

        // Retrieve the custom metadata record
        SPD_Creation_Exception_Rules__mdt customMetadataRecord = [
            SELECT Id, MasterLabel, DeveloperName, Excluded_GPNs__c, Excluded_GPNs_Values__c 
            FROM SPD_Creation_Exception_Rules__mdt 
            WHERE DeveloperName = :'SPD_Creation_Exceptions'
            LIMIT 1
        ];
        
        // Initialize the string to store all GPNs to append
        String existingValue = customMetadataRecord.Excluded_GPNs_Values__c;
        
        for (SPD__c spdRecord : appendStrings) {
            String appendString = spdRecord.Current_Group_Policy_Number__c;
            
            // Check if the GPN already exists in the custom metadata field
            if (customMetadataRecord != null && appendString != null && !customMetadataRecord.Excluded_GPNs_Values__c.contains(appendString)) {
                // If it's not null and doesn't already exist, append the GPN to the list
                if (existingValue != null && existingValue != '') {
                    existingValue += ',' + appendString;
                } else {
                    existingValue = appendString;
                }
                isMetadataUpdateNeeded = true;
            }
        }
        system.debug('excisting values='+existingValue);

        // If we have any updates to make
        if (isMetadataUpdateNeeded) {
            // Create a deploy container for updating the Custom Metadata Record
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

            // Create an instance of Metadata.CustomMetadata
            Metadata.CustomMetadata metadataRec = new Metadata.CustomMetadata();
            metadataRec.fullName = 'SPD_Creation_Exception_Rules__mdt.' + customMetadataRecord.DeveloperName;
            metadataRec.label = customMetadataRecord.MasterLabel;

            // Provide the updated value for the field
            Metadata.CustomMetadataValue ExcludedGPNsToUpdate = new Metadata.CustomMetadataValue();
            ExcludedGPNsToUpdate.field = 'Excluded_GPNs_Values__c';
            ExcludedGPNsToUpdate.value = existingValue;

            // Add the custom metadata instance to the container
            metadataRec.values.add(ExcludedGPNsToUpdate);
            mdContainer.addMetadata(metadataRec);

            // Enqueue the custom metadata deployment
            Metadata.Operations.enqueueDeployment(mdContainer, null);
            System.debug('Updated GPNs: ' + existingValue);
        }
    }

    // Implementing the execute method for scheduling
    public void execute(SchedulableContext sc) {
        // Query the SPD__c records to get those that need to be appended
        List<SPD__c> spdList = [SELECT Current_Group_Policy_Number__c FROM SPD__c WHERE SPD_Not_Applicable_to_GPN__c = true];
        
        // Call the metadata update method with the list of SPD records
        spdMetadataUpdateMethod(spdList);
    }
}