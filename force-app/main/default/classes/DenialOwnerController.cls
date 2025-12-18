public with sharing class DenialOwnerController {
    // Valid adjustment codes
    private static final Set<String> VALID_ADJUSTMENT_CODES = new Set<String>{
        '100', '27', '26', '252', '193', '119', '109', '16', '273', 'B5', 
        'W9', '50', '123', '198', '197', '22', '20', '19', '21'
    };
    
    // Map to cache usernames to IDs
    private static Map<String, Id> userNameToIdMap;
    
    // Main method to assign owners
    public static void assignOwners(List<dn_Denial__c> denials) {
        // Initialize user map
        initializeUserMap();
        
        for (dn_Denial__c denial : denials) {
            // Check if adjustment code is valid
            if (denial.dn_Adjustment_Code_1__c != null && 
                VALID_ADJUSTMENT_CODES.contains(denial.dn_Adjustment_Code_1__c)) {
                assignOwnerBasedOnRules(denial);
            }
        }
    }
    
    // Initialize user map
    private static void initializeUserMap() {
        userNameToIdMap = new Map<String, Id>();
        for (User u : [SELECT Id, Username FROM User WHERE IsActive = true]) {
            userNameToIdMap.put(u.Username.toLowerCase(), u.Id);
        }
    }
    
    // Get user ID by username
    private static Id getUserId(String userName) {
        return userNameToIdMap.get(userName.toLowerCase());
    }
    
    // Assign owner based on rules from Excel
    private static void assignOwnerBasedOnRules(dn_Denial__c denial) {
        String finClass = denial.dn_Financial_Class__c;
        String providerGrouping = denial.dn_PROVIDER_GROUPING__c;
        String locationId = denial.dn_Location_Id__c;
        String providerId = denial.dn_Provider_Id__c;
        String procCode = denial.dn_PROCEDURE_CODE__c;
        String patientName = denial.dn_Patient_Account__r?.dn_Name__c;
        String patientNameLower = patientName != null ? patientName.toLowerCase() : '';
        
        // Rule 1: Auto Insurance, Workers Comp
        if (new Set<String>{'Auto Insurance', 'Workers Comp'}.contains(finClass)) {
            Set<String> locIds = new Set<String>{
                '44810', '53754', '48721', '48722', '51009', '51834', '51835', 
                '44808', '44813', '48503', '48502', '48874', '53513', '53514', 
                '44814', '44815', '50056', '5005'
            };
            if (locIds.contains(locationId)) {
                denial.OwnerId = getUserId('2F005UP000006ne48YAA');
            } else if (providerGrouping == 'MD') {
                denial.OwnerId = getUserId('abbie@salesforce.com');
            }
            return;
        }
        
        // Rule 2: NOT Auto Insurance, Workers Comp
        if (!new Set<String>{'Auto Insurance', 'Workers Comp'}.contains(finClass)) {
            if (procCode != null && (procCode.startsWith('364') || procCode.startsWith('6303'))) {
                if (patientNameLower >= 'aaa' && patientNameLower <= 'fzz') {
                    denial.OwnerId = getUserId('danielle@salesforce.com');
                } else if (patientNameLower >= 'gaa' && patientNameLower <= 'ozz') {
                    denial.OwnerId = getUserId('vicki@salesforce.com');
                } else if (patientNameLower >= 'paa' && patientNameLower <= 'zzz') {
                    denial.OwnerId = getUserId('stacie@salesforce.com');
                }
                return;
            }
            
            Set<String> locIds = new Set<String>{
                '44810', '53754', '48721', '48722', '51009', '51834', '51835', 
                '44808', '44813', '48503', '48502', '48874', '53513', '53514', 
                '44814', '44815', '50056', '50057', '44816'
            };
            Set<String> provIds = new Set<String>{
                '34760', '35225', '35730', '35392', '37433', '32707', '32700', 
                '35974', '38624', '38179', '39028', '38625'
            };
            if (locIds.contains(locationId) && provIds.contains(providerId)) {
                if (patientNameLower >= 'aaa' && patientNameLower <= 'fzz') {
                    denial.OwnerId = getUserId('danielle@salesforce.com');
                } else if (patientNameLower >= 'gaa' && patientNameLower <= 'ozz') {
                    denial.OwnerId = getUserId('vicki@salesforce.com');
                } else if (patientNameLower >= 'paa' && patientNameLower <= 'zzz') {
                    denial.OwnerId = getUserId('stacie@salesforce.com');
                }
                return;
            }
        }
        
        // Rule 3: Aetna, Cigna, United Healthcare
        Set<String> specificProcCodes = new Set<String>{
            '62323', '62321', '64454', '64624', '64490', '64491', '64492', 
            '64493', '64494', '644 TA95', '64633', '64634', '64635', '64636', 
            '64483', '64484', '27096'
        };
        if (new Set<String>{'Aetna', 'Cigna', 'United Healthcare'}.contains(finClass)) {
            if (providerGrouping == 'MD' && specificProcCodes.contains(procCode)) {
                if (patientNameLower >= 'aaa' && patientNameLower <= 'kzz') {
                    denial.OwnerId = getUserId('brian@salesforce.com');
                } else if (patientNameLower >= 'laa' && patientNameLower <= 'zzz') {
                    denial.OwnerId = getUserId('taylor@salesforce.com');
                }
                return;
            }
            // No assignment for other cases
            return;
        }
        
        // Rule 4: Aetna
        if (finClass == 'Aetna') {
            if (providerGrouping == 'MD') {
                if (patientNameLower >= 'a' && patientNameLower <= 'l') {
                    denial.OwnerId = getUserId('ever@salesforce.com');
                } else if (patientNameLower >= 'm' && patientNameLower <= 'z') {
                    denial.OwnerId = getUserId('jazmin@salesforce.com');
                }
            } else {
                denial.OwnerId = getUserId('clara@salesforce.com');
            }
            return;
        }
        
        // Rule 5: Cigna
        if (finClass == 'Cigna') {
            if (providerGrouping == 'MD') {
                if (patientNameLower >= 'a' && patientNameLower <= 'i') {
                    denial.OwnerId = getUserId('crystal@salesforce.com');
                } else if (patientNameLower >= 'j' && patientNameLower <= 'z') {
                    denial.OwnerId = getUserId('tiana@salesforce.com');
                }
            } else {
                denial.OwnerId = getUserId('clara@salesforce.com');
            }
            return;
        }
        
        // Rule 6: United Healthcare
        if (finClass == 'United HealthCare') {
            if (providerGrouping == 'MD') {
                if (patientNameLower >= 'a' && patientNameLower <= 'i') {
                    denial.OwnerId = getUserId('crystal@salesforce.com');
                } else if (patientNameLower >= 'j' && patientNameLower <= 'z') {
                    denial.OwnerId = getUserId('tiana@salesforce.com');
                }
            } else {
                assignUnitedHealthcareNonMD(denial, patientNameLower);
            }
            return;
        }
        
        // Rule 7: Government, Humana, Medicaid, Medicare, etc.
        if (new Set<String>{
            'Government', 'Humana', 'Medicaid', 'Medicare/ Supplement', 
            'Medicare Replacement Plan', 'Out of State'
        }.contains(finClass)) {
            if (providerGrouping == 'MD') {
                denial.OwnerId = getUserId('natasha@salesforce.com');
            } else {
                assignGovernmentNonMD(denial, patientNameLower);
            }
            return;
        }
        
        // Rule 8: Misc
        if (finClass == 'Misc') {
            if (providerGrouping == 'MD') {
                if (patientNameLower >= 'a' && patientNameLower <= 'i') {
                    denial.OwnerId = getUserId('crystal@salesforce.com');
                } else if (patientNameLower >= 'j' && patientNameLower <= 'z') {
                    denial.OwnerId = getUserId('tiana@salesforce.com');
                }
            } else {
                assignGovernmentNonMD(denial, patientNameLower); // Same logic as Government non-MD
            }
            return;
        }
        
        // Rule 9: Blue Cross Blue Shield
        if (finClass == 'Blue Cross Blue Shield') {
            if (providerGrouping == 'MD') {
                assignBlueCrossMD(denial, patientNameLower);
            } else {
                assignBlueCrossNonMD(denial, patientNameLower);
            }
            return;
        }
    }
    
    // Helper method for United Healthcare non-MD assignments
    private static void assignUnitedHealthcareNonMD(dn_Denial__c denial, String patientNameLower) {
        if (patientNameLower >= 'a' && patientNameLower <= 'carm') {
            denial.OwnerId = getUserId('jamshad@salesforce.com');
        } else if (patientNameLower >= 'caro' && patientNameLower <= 'debb') {
            denial.OwnerId = getUserId('anzer@salesforce.com');
        } else if (patientNameLower >= 'debo' && patientNameLower <= 'gar') {
            denial.OwnerId = getUserId('umar@salesforce.com');
        } else if (patientNameLower >= 'gav' && patientNameLower <= 'jea') {
            denial.OwnerId = getUserId('waleed@salesforce.com');
        } else if (patientNameLower >= 'jef' && patientNameLower <= 'kam') {
            denial.OwnerId = getUserId('kashif@salesforce.com');
        } else if (patientNameLower >= 'kar' && patientNameLower <= 'luk') {
            denial.OwnerId = getUserId('salman@salesforce.com');
        } else if (patientNameLower >= 'lyn' && patientNameLower <= 'mic') {
            denial.OwnerId = getUserId('christina@salesforce.com');
        } else if (patientNameLower >= 'mig' && patientNameLower <= 'ph') {
            denial.OwnerId = getUserId('shoaib@salesforce.com');
        } else if (patientNameLower >= 'pi' && patientNameLower <= 'sandr') {
            denial.OwnerId = getUserId('shahbaz@salesforce.com');
        } else if (patientNameLower >= 'sandy' && patientNameLower <= 'teresa a') {
            denial.OwnerId = getUserId('aman@salesforce.com');
        } else if (patientNameLower >= 'teresa o' && patientNameLower <= 'z') {
            denial.OwnerId = getUserId('zahid@salesforce.com');
        }
    }
    
    // Helper method for Government, Misc non-MD assignments
    private static void assignGovernmentNonMD(dn_Denial__c denial, String patientNameLower) {
        if (patientNameLower >= 'a' && patientNameLower <= 'anth') {
            denial.OwnerId = getUserId('waqas@salesforce.com');
        } else if (patientNameLower >= 'anto' && patientNameLower <= 'catherine f') {
            denial.OwnerId = getUserId('waqar@salesforce.com');
        } else if (patientNameLower >= 'catherine k' && patientNameLower <= 'diana') {
            denial.OwnerId = getUserId('tamoor@salesforce.com');
        } else if (patientNameLower >= 'diane' && patientNameLower <= 'fel') {
            denial.OwnerId = getUserId('shahzaib@salesforce.com');
        } else if (patientNameLower >= 'fer' && patientNameLower <= 'hi') {
            denial.OwnerId = getUserId('adeel@salesforce.com');
        } else if (patientNameLower >= 'ho' && patientNameLower <= 'je') {
            denial.OwnerId = getUserId('rayyan@salesforce.com');
        } else if (patientNameLower >= 'ji' && patientNameLower <= 'jud') {
            denial.OwnerId = getUserId('hamza@salesforce.com');
        } else if (patientNameLower >= 'jul' && patientNameLower <= 'k') {
            denial.OwnerId = getUserId('nazir@salesforce.com');
        } else if (patientNameLower >= 'l' && patientNameLower <= 'lu') {
            denial.OwnerId = getUserId('aqib@salesforce.com');
        } else if (patientNameLower >= 'ly' && patientNameLower <= 'mat') {
            denial.OwnerId = getUserId('angela@salesforce.com');
        } else if (patientNameLower >= 'mau' && patientNameLower <= 'nan') {
            denial.OwnerId = getUserId('aamir@salesforce.com');
        } else if (patientNameLower >= 'nar' && patientNameLower <= 'p') {
            denial.OwnerId = getUserId('anees@salesforce.com');
        } else if (patientNameLower >= 'r' && patientNameLower <= 'ros') {
            denial.OwnerId = getUserId('toseeq@salesforce.com');
        } else if (patientNameLower >= 'rox' && patientNameLower <= 'sus') {
            denial.OwnerId = getUserId('hassan@salesforce.com');
        } else if (patientNameLower >= 'suz' && patientNameLower <= 'valerie') {
            denial.OwnerId = getUserId('sabeel@salesforce.com');
        } else if (patientNameLower >= 'valerin' && patientNameLower <= 'z') {
            denial.OwnerId = getUserId('zaryab@salesforce.com');
        }
    }
    
    // Helper method for Blue Cross Blue Shield MD assignments
    private static void assignBlueCrossMD(dn_Denial__c denial, String patientNameLower) {
        if (patientNameLower >= 'a' && patientNameLower <= 'and') {
            denial.OwnerId = getUserId('amanda@salesforce.com');
        } else if (patientNameLower >= 'ane' && patientNameLower <= 'bri') {
            denial.OwnerId = getUserId('muhammadfaizan@salesforce.com');
        } else if (patientNameLower >= 'brj' && patientNameLower <= 'cl') {
            denial.OwnerId = getUserId('john@salesforce.com');
        } else if (patientNameLower >= 'cm' && patientNameLower <= 'da') {
            denial.OwnerId = getUserId('iftikhar@salesforce.com');
        } else if (patientNameLower >= 'db' && patientNameLower <= 'em') {
            denial.OwnerId = getUserId('muhammadraheel@salesforce.com');
        } else if (patientNameLower >= 'en' && patientNameLower <= 'g') {
            denial.OwnerId = getUserId('zamir@salesforce.com');
        } else if (patientNameLower >= 'h' && patientNameLower <= 'jef') {
            denial.OwnerId = getUserId('ahmad@salesforce.com');
        } else if (patientNameLower >= 'jeg' && patientNameLower <= 'jo') {
            denial.OwnerId = getUserId('maskeen@salesforce.com');
        } else if (patientNameLower >= 'jp' && patientNameLower <= 'kh') {
            denial.OwnerId = getUserId('mujahid@salesforce.com');
        } else if (patientNameLower >= 'ki' && patientNameLower <= 'li') {
            denial.OwnerId = getUserId('rehman@salesforce.com');
        } else if (patientNameLower >= 'lj' && patientNameLower <= 'mar') {
            denial.OwnerId = getUserId('jeelani@salesforce.com');
        } else if (patientNameLower >= 'mas' && patientNameLower <= 'miz') {
            denial.OwnerId = getUserId('azam@salesforce.com');
        } else if (patientNameLower >= 'mj' && patientNameLower <= 'pat') {
            denial.OwnerId = getUserId('bilal@salesforce.com');
        } else if (patientNameLower >= 'pau' && patientNameLower <= 'q') {
            denial.OwnerId = getUserId('javaid@salesforce.com');
        } else if (patientNameLower >= 'r' && patientNameLower <= 'r') {
            denial.OwnerId = getUserId('khalil@salesforce.com');
        } else if (patientNameLower >= 'sa' && patientNameLower <= 'son') {
            denial.OwnerId = getUserId('sadiq@salesforce.com');
        } else if (patientNameLower >= 'soo' && patientNameLower <= 'the') {
            denial.OwnerId = getUserId('kazmi@salesforce.com');
        } else if (patientNameLower >= 'tf' && patientNameLower <= 'vin') {
            denial.OwnerId = getUserId('amanda@salesforce.com');
        } else if (patientNameLower >= 'vio' && patientNameLower <= 'z') {
            denial.OwnerId = getUserId('myreva@salesforce.com');
        }
    }
    
    // Helper method for Blue Cross Blue Shield non-MD assignments
    private static void assignBlueCrossNonMD(dn_Denial__c denial, String patientNameLower) {
        if (patientNameLower >= 'a' && patientNameLower <= 'alyssa c') {
            denial.OwnerId = getUserId('faizanhanif@salesforce.com');
        } else if (patientNameLower >= 'alyssa d' && patientNameLower <= 'antonin') {
            denial.OwnerId = getUserId('hassannisar@salesforce.com');
        } else if (patientNameLower >= 'antonio' && patientNameLower <= 'billi') {
            denial.OwnerId = getUserId('muhammadishaq@salesforce.com');
        } else if (patientNameLower >= 'billj' && patientNameLower <= 'bryann') {
            denial.OwnerId = getUserId('ikraam@salesforce.com');
        } else if (patientNameLower >= 'bryano' && patientNameLower <= 'christina k') {
            denial.OwnerId = getUserId('mohsin@salesforce.com');
        } else if (patientNameLower >= 'christina l' && patientNameLower <= 'dana') {
            denial.OwnerId = getUserId('furqan@salesforce.com');
        } else if (patientNameLower >= 'danb' && patientNameLower <= 'daz') {
            denial.OwnerId = getUserId('shayan@salesforce.com');
        } else if (patientNameLower >= 'db' && patientNameLower <= 'ede') {
            denial.OwnerId = getUserId('arslan@salesforce.com');
        } else if (patientNameLower >= 'edf' && patientNameLower <= 'eni') {
            denial.OwnerId = getUserId('aneeshafeez@salesforce.com');
        } else if (patientNameLower >= 'enj' && patientNameLower <= 'gerald') {
            denial.OwnerId = getUserId('waleednaeem@salesforce.com');
        } else if (patientNameLower >= 'geralda' && patientNameLower <= 'jack') {
            denial.OwnerId = getUserId('jahangir@salesforce.com');
        } else if (patientNameLower >= 'jacka' && patientNameLower <= 'jeffrey s') {
            denial.OwnerId = getUserId('amir@salesforce.com');
        } else if (patientNameLower >= 'jeffrey t' && patientNameLower <= 'joceli') {
            denial.OwnerId = getUserId('syed@salesforce.com');
        } else if (patientNameLower >= 'jocelj' && patientNameLower <= 'julian a') {
            denial.OwnerId = getUserId('jamshed@salesforce.com');
        } else if (patientNameLower >= 'julian b' && patientNameLower <= 'kei') {
            denial.OwnerId = getUserId('hasnain@salesforce.com');
        } else if (patientNameLower >= 'kej' && patientNameLower <= 'kyle') {
            denial.OwnerId = getUserId('inksar@salesforce.com');
        } else if (patientNameLower >= 'kylf' && patientNameLower <= 'lora f') {
            denial.OwnerId = getUserId('mubbshir@salesforce.com');
        } else if (patientNameLower >= 'lora g' && patientNameLower <= 'mariso') {
            denial.OwnerId = getUserId('usamatahir@salesforce.com');
        } else if (patientNameLower >= 'marisp' && patientNameLower <= 'michael la') {
            denial.OwnerId = getUserId('sabtain@salesforce.com');
        } else if (patientNameLower >= 'michael lb' && patientNameLower <= 'nell') {
            denial.OwnerId = getUserId('usamaghani@salesforce.com');
        } else if (patientNameLower >= 'nelm' && patientNameLower <= 'peter c') {
            denial.OwnerId = getUserId('jessica@salesforce.com');
        } else if (patientNameLower >= 'peter d' && patientNameLower <= 'roberta') {
            denial.OwnerId = getUserId('michelle@salesforce.com');
        } else if (patientNameLower >= 'roberto' && patientNameLower <= 'sean g') {
            denial.OwnerId = getUserId('liza@salesforce.com');
        } else if (patientNameLower >= 'sean l' && patientNameLower <= 'susan b') {
            denial.OwnerId = getUserId('kim@salesforce.com');
        } else if (patientNameLower >= 'susan c' && patientNameLower <= 'vickie p') {
            denial.OwnerId = getUserId('catherine@salesforce.com');
        } else if (patientNameLower >= 'vickie q' && patientNameLower <= 'z') {
            denial.OwnerId = getUserId('jennifer@salesforce.com');
        }
    }
}