public class spdCreationBatchJob1 {
    
    // Fetching the custom metadata record for SPD_Creation_Exceptions with specific fields
    public static SPD_Creation_Exception_Rules__mdt customMetadataRecord = [SELECT Id, MasterLabel, DeveloperName, Excluded_GPNs__c, Excluded_GPNs_Values__c, Excluded_VOB_Types__c 
                                                                            FROM SPD_Creation_Exception_Rules__mdt 
                                                                            WHERE DeveloperName = :'SPD_Creation_Exceptions'
                                                                            LIMIT 1];
    Public static Group SPDQueue=[SELECT Id, Name FROM Group WHERE DeveloperName ='SPD_Queue'];
    Public static date yeasterDay=System.Today().addDays(-1);
    Public static map<string,string>accountUpdateMap=new map<string,string>(); 


    public static void GetAppointmentsProcess() {
        // Querying Appointment records with specific conditions
        List<Appointment__c> appList = [SELECT Id, VOB_Case__c, Visit_Reason__c, Status__c,VOB_Case__r.Account.Name,
                                               VOB_Case__r.Status,VOB_Case__r.AccountId,
                                        	   VOB_Case__r.PIP_Patient_Date_of_Birth__c, 
                                               VOB_Case__r.Member_ID__c, Appointment_Date__c, Appointment_Date_Time__c, 
                                               VOB_Case__r.Group_Number__c, VOB_Case__r.Fee_Schedule__c,VOB_Case__r.PIP_Patient_Name__c,
                                        	   VOB_Case__r.Primary_Insurance_Phone__c,VOB_Case__r.Primary_Insurance__c,VOB_Case__r.Owner.Id,
                                        	   VOB_Case__r.Subject,VOB_Case__r.VOB_Type__c,VOB_Case__r.Where_to_obtain_SPD__c
                                        FROM Appointment__c 	
                                        WHERE VOB_Case__c != null 
                                          AND VOB_Case__r.Status = 'Closed' 
                                          AND VOB_Case__r.Fee_Schedule__c <> 'No OON' 
                                          AND (Visit_Reason__c LIKE '%NEW PATIENT%' OR Visit_Reason__c LIKE '%RETURNING NEW%') 
                                          AND VOB_Case__r.Group_Number__c <> null
                                          AND Status__c NOT IN ('Cancelled', 'Pending')
                                          AND  Appointment_Date__c =: system.today().addDays(-1)];
        system.debug('applists are'+appList);
                system.debug('applists are'+appList.size());


        // Initializing a set to track unique Group Policy Numbers (GPN)
        Set<String> GpnValues = new Set<String>();  
        // List to hold new SPD records to be created
        List<SPD__c> NewSpdList = new List<SPD__c>(); 
        // List to hold accounts to be updated
        List<Account> updatingAccList = new List<Account>();
        Map<string,string>vobIdInsurancePhoneMap=new Map<string,string>();
        set<string>vobIds=new set<string>();
        
        //get all vob caseIds and create vobIdInsurancePhoneMap
        for(Appointment__c a : appList){
            vobIds.add(a.VOB_Case__c);
        }
        system.debug('vobIds are'+vobIds);
        
        List<Insurance_Plan__c>InsurancePlans=[SELECT Id, Name ,VOB_Case__c,Insurance_Phone__c
                                 FROM Insurance_Plan__c where VOB_Case__c IN:vobIds];
        for(Insurance_Plan__c ins:InsurancePlans){
            vobIdInsurancePhoneMap.put(ins.VOB_Case__c,ins.Insurance_Phone__c);
        }

        // Iterate through appointments to filter based on exclusion rules
        for (Appointment__c app : appList) {
            // Check if the Group Number and VOB Type are not in the exclusion lists
            if ((customMetadataRecord.Excluded_GPNs_Values__c.contains(app.VOB_Case__r.Group_Number__c) == false) 
                && (customMetadataRecord.Excluded_VOB_Types__c.contains(app.VOB_Case__r.VOB_Type__c) == false)) {
                GpnValues.add(app.VOB_Case__r.Group_Number__c); // Add Group Number to the set
            }

            // Query existing SPD records to exclude already processed GPNs
            List<SPD__c> spdList = [SELECT Id, Current_Group_Policy_Number__c 
                                    FROM SPD__c 
                                    WHERE Current_Group_Policy_Number__c IN :GpnValues 
                                      AND (Active__c = true OR SPD_Not_Applicable_to_GPN__c = true)];

            // Remove GPNs already present in SPD records
            for (SPD__c spd : spdList) {
                GpnValues.remove(spd.Current_Group_Policy_Number__c);
            }
            system.debug('GpnValues are '+GpnValues);

            // Iterate through appointments again to create new SPD records and prepare account updates
            
        }
        for (Appointment__c app2 : appList) {
                if (GpnValues.contains(app2.VOB_Case__r.Group_Number__c)) {
                    // Add a new SPD record to the list
                    NewSpdList.add(new SPD__c(
                        Current_Group_Policy_Number__c = app2.VOB_Case__r.Group_Number__c,
                        Appointment_Date_Time__c = app2.Appointment_Date_Time__c,
                        Insurance_Member_Id__c = app2.VOB_Case__r.Member_ID__c,
                    	Patient_Date_Of_Birth__c=app2.VOB_Case__r.PIP_Patient_Date_of_Birth__c,
                        Patient_Name__c=app2.VOB_Case__r.Account.Name,
                        Primary_Insurance_Phone_Number__c=app2.VOB_Case__r.Primary_Insurance_Phone__c,
                        Primary_Insurance__c=app2.VOB_Case__r.Primary_Insurance__c,
                        Related_to_VOB_Case__c=app2.VOB_Case__c,
						Fee_Schedule__c = app2.VOB_Case__r.Fee_Schedule__c,
                        Status__c='New',VOB_Specialist__c=app2.VOB_Case__r.Owner.Id,
                        VOB_Subject__c=app2.VOB_Case__r.Subject,
                        VOB_Type__c=app2.VOB_Case__r.VOB_Type__c,Where_to_obtain_SPD__c=app2.VOB_Case__r.Where_to_obtain_SPD__c,
                        OwnerId=SPDQueue.Id,Insurance_Phone_Number__c=vobIdInsurancePhoneMap.get(app2.VOB_Case__c)
                        
                    ));
					accountUpdateMap.put(app2.VOB_Case__r.AccountId,
                         app2.VOB_Case__r.Group_Number__c);
                   /* // Add an Account record for update to link the GPN
                    updatingAccList.add(new Account(
                        Id = app2.VOB_Case__r.AccountId,
                        Current_Group_Policy_Number__c = app2.VOB_Case__r.Group_Number__c));*/
                }
            }
        
       
                    // Query the accounts to update
            List<Account> accountsToUpdate = [
                SELECT Id
                FROM Account
                WHERE Id IN :accountUpdateMap.keySet()
            ];
            
            // Update the Group_Number__c field for each account
            for (Account acc : accountsToUpdate) {
                // Set the new value from the map
                if (accountUpdateMap.containsKey(acc.Id)) {
                    acc.Current_Group_Policy_Number__c = accountUpdateMap.get(acc.Id);
                }
            }

        // Insert new SPD records if any exist
        if (NewSpdList.size() > 0) {
            insert NewSpdList;
            system.debug('NewSpdList are'+NewSpdList.size());
            
        }

        // Update accounts if any exist
        if (accountsToUpdate.size() > 0) {
            update accountsToUpdate;
             system.debug('accountsToUpdate are'+accountsToUpdate);
        }
    }
}