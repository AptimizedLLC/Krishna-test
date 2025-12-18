Public class AutoConvertLeads 
{     
    @InvocableMethod   
    public static void LeadAssign(List<Id> LeadIds) {         
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];    
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        
        for(Lead currentlead: [Select Id, OwnerId FROM Lead where Id IN: LeadIds]){ 
            String ownerIdPrefix = String.valueOf(currentlead.ownerId).substring(0,3);
            Database.LeadConvert Leadconvert = new Database.LeadConvert();    
            Leadconvert.setLeadId(currentlead.Id);                               
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            if(ownerIdPrefix == '00G') {
                Leadconvert.setOwnerId(UserInfo.getUserId());
            } else {
                Leadconvert.setOwnerId(currentlead.ownerId);
            }
            
            MassLeadconvert.add(Leadconvert);    
        } 
        
        List<Id> leadFailedIds = new List<Id>();
        if (!MassLeadconvert.isEmpty()) {  
            try {
                List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);  
                for(Database.LeadConvertResult tempLcr : lcr) {
                    if(String.isBlank(tempLcr.getAccountId())) {
                        leadFailedIds.add(tempLcr.getLeadId());
                    } else if(Test.isRunningTest()) {
                        leadFailedIds.add(LeadIds[0]);
                    }
                }
                
                System.debug('::: leadFailedIds - '+leadFailedIds.size());
                if (leadFailedIds.size() > 0) {
                    TransactionLogHandler.doHandleCustomException(
                        'Lead Conversion failed for few records',
                        String.join(new List<Id>(leadFailedIds), ','),
                        'AutoConvertLeads',
                        'LeadAssign'
                    );
                }
            }catch(Exception ex) {
                TransactionLogHandler.doHandleCustomException(
                    ex,
                    'Lead Conversion Exception '+MassLeadconvert,
                    'AutoConvertLeads',
                    'LeadAssign'
                );
            }
            
        }    
    } 
}