public without sharing class spdMetadaUpdateClass {
@InvocableMethod(label='Update Custom Metadata Type' description='Update Custom Metadata Type with appended string')
    public static void spdMetadaUpdateMethode(List<String> stringRequests) {
        
        //updateSpds(stringRequests);
         Boolean isMetadataUpdateNeeded = false;
        List<SPD_Creation_Exception_Rules__mdt> updatingRecords=new List<SPD_Creation_Exception_Rules__mdt>();
        String appendString = stringRequests[0];
        
                SPD_Creation_Exception_Rules__mdt customMetadataRecord=[SELECT Id,MasterLabel,DeveloperName, Excluded_GPNs__c,Excluded_GPNs_Values__c 
                FROM SPD_Creation_Exception_Rules__mdt 
                WHERE DeveloperName = :'SPD_Creation_Exceptions'
                LIMIT 1];
        if (customMetadataRecord != null && customMetadataRecord.Excluded_GPNs_Values__c.contains(appendString) != true ) {
            String existingValue = customMetadataRecord.Excluded_GPNs_Values__c;               
            //Create a deploy container which will be used for deploying(updating) the Custom Metadata Record
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            //create instance of Metadata.CustomMetadata
            Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
            metadataRec.fullName = 'SPD_Creation_Exception_Rules__mdt.'+customMetadataRecord.DeveloperName;
            metadataRec.label = customMetadataRecord.MasterLabel;
            
            //provide the value for the fields and add it to custom metadata instance
            Metadata.CustomMetadataValue ExcludedGPNsToUpdate = new Metadata.CustomMetadataValue();
            ExcludedGPNsToUpdate.field = 'Excluded_GPNs_Values__c';
            
            if (existingValue != null) {
                    ExcludedGPNsToUpdate.value = existingValue + ',' + appendString;
                } else {
                    // If existingValue is null or empty, just set the new string
                    ExcludedGPNsToUpdate.value = appendString;
                }            
            metadataRec.values.add(ExcludedGPNsToUpdate);
            //Add the custom metadata instances in the container
            mdContainer.addMetadata(metadataRec);
            isMetadataUpdateNeeded = true;
            
            //Check if metadata deployment is required
            if(isMetadataUpdateNeeded)
            {
                // Enqueue custom metadata deployment and get the deployment id
                Metadata.Operations.enqueueDeployment(mdContainer, null);
                system.debug(existingValue + ',' + appendString);
                
            }
            
            
          
            

        }

        
    }
   
            

}