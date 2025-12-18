public class spdNotApplicableToGPNClass {
 @InvocableMethod(label='Update SPD Not Applicable to GPN Fields' description='To Update SPD Not Applicable to GPN Fields onDaily basis')
    public static void updateSpds(List<String> UpdatingGPN){
        
        SPD_Creation_Exception_Rules__mdt customMetadataRecords=[SELECT Id,MasterLabel,DeveloperName, Excluded_GPNs__c 
                FROM SPD_Creation_Exception_Rules__mdt 
                WHERE DeveloperName = :'SPD_Creation_Exceptions'
                LIMIT 1];
        List<String> excludedGPNsList = new List<String>();
            if (customMetadataRecords != null && String.isNotBlank(customMetadataRecords.Excluded_GPNs__c)) {
                excludedGPNsList = customMetadataRecords.Excluded_GPNs__c.split(',');
            }
        
                List<SPD__c> spdList=new List<SPD__c>();
                List<SPD__c> updatingSpdList=new List<SPD__c>();
                spdList=[SELECT id,SPD_Not_Applicable_to_GPN__c,Current_Group_Policy_Number__c 
                         FROM SPD__c WHERE Current_Group_Policy_Number__c IN:excludedGPNsList];
        for(SPD__c spd:spdList){
            spd.SPD_Not_Applicable_to_GPN__c=true;
            updatingSpdList.add(spd);
            
        }
        If(!updatingSpdList.isEmpty()){
            update updatingSpdList;
        }
            }
}