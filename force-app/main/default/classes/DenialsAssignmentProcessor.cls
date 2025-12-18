public class DenialsAssignmentProcessor {
    // Define filter lists based on Excel criteria
    private static final List<String> AUTO_WORKERS_COMP = new List<String>{'Auto Insurance', 'Workers Comp'};
    private static final List<String> SPECIFIC_LOCATIONS = new List<String>{'44810', '53754', '48721', '48722', '51009', '51834', 
        '51835', '44808', '44813', '48503', '48502', '48874', '53513', '53514', '44814', '44815', '50056', '5005'};
    private static final List<String> SPECIFIC_PROC_CODES = new List<String>{'62323', '62321', '64454', '64624', '64490', '64491', 
        '64492', '64493', '64494', '64495', '64633', '64634', '64635', '64636', '64483', '64484', '27096'};
    private static final List<String> AETNA_CIGNA_UHC = new List<String>{'Aetna', 'Cigna', 'United Healthcare'};
    private static final List<String> GOVT_INSURANCE = new List<String>{'Government', 'Humana', 'Medicaid', 'Medicare/ Supplement', 
        'Medicare Replacement Plan', 'Out of State'};
    private static final List<String> SPECIFIC_PROVIDERS = new List<String>{'34760', '35225', '35730', '35392', '37433', '32707', 
        '32700', '35974', '38624', '38179', '39028', '38625'};
    
    public static String assignDenial(Map<String, Object> denialRecord) {
        String financialClass = (String)denialRecord.get('FinancialClass');
        String providerGrouping = (String)denialRecord.get('ProviderGrouping');
        String locationId = (String)denialRecord.get('LocationId');
        String providerId = (String)denialRecord.get('ProviderId');
        String procedureCode = (String)denialRecord.get('ProcedureCode');
        String patientName = (String)denialRecord.get('PatientName');
        
        // Rule 1: Auto Insurance, Workers Comp
        if (AUTO_WORKERS_COMP.contains(financialClass)) {
            if (SPECIFIC_LOCATIONS.contains(locationId)) {
                return 'Lois';
            } else if (providerGrouping == 'MD') {
                return 'Abbie';
            }
        }
        
        // Rule 2: Non-Auto/Workers Comp with specific procedure codes
        if (!AUTO_WORKERS_COMP.contains(financialClass)) {
            if (procedureCode != null && (procedureCode.startsWith('364') || procedureCode.startsWith('6303'))) {
                if (patientName != null) {
                    String firstLetter = patientName.substring(0, 1).toUpperCase();
                    if (firstLetter >= 'A' && firstLetter <= 'F') return 'Danielle';
                    if (firstLetter >= 'G' && firstLetter <= 'O') return 'Vicki';
                    if (firstLetter >= 'P' && firstLetter <= 'Z') return 'Stacie';
                }
            }
        }
        
        // Rule 3: Non-Auto/Workers Comp with specific locations and providers
        if (!AUTO_WORKERS_COMP.contains(financialClass) && SPECIFIC_LOCATIONS.contains(locationId) && 
            SPECIFIC_PROVIDERS.contains(providerId)) {
            if (patientName != null) {
                String firstLetter = patientName.substring(0, 1).toUpperCase();
                if (firstLetter >= 'A' && firstLetter <= 'F') return 'Danielle';
                if (firstLetter >= 'G' && firstLetter <= 'O') return 'Vicki';
                if (firstLetter >= 'P' && firstLetter <= 'Z') return 'Stacie';
            }
        }
        
        // Rule 4: Aetna, Cigna, United Healthcare with specific procedure codes
        if (AETNA_CIGNA_UHC.contains(financialClass) && providerGrouping == 'MD' && 
            SPECIFIC_PROC_CODES.contains(procedureCode)) {
            if (patientName != null) {
                String firstLetter = patientName.substring(0, 1).toUpperCase();
                if (firstLetter >= 'A' && firstLetter <= 'K') return 'Brian';
                if (firstLetter >= 'L' && firstLetter <= 'Z') return 'Taylor';
            }
        }
        
        // Rule 5: Aetna specific
        if (financialClass == 'Aetna') {
            if (providerGrouping == 'MD') {
                if (patientName != null) {
                    String firstLetter = patientName.substring(0, 1).toUpperCase();
                    if (firstLetter >= 'A' && firstLetter <= 'L') return 'Ever';
                    if (firstLetter >= 'M' && firstLetter <= 'Z') return 'Jazmin';
                }
            } else {
                return 'Clara';
            }
        }
        
        // Rule 6: Cigna specific
        if (financialClass == 'Cigna') {
            if (providerGrouping == 'MD') {
                if (patientName != null) {
                    String firstLetter = patientName.substring(0, 1).toUpperCase();
                    if (firstLetter >= 'A' && firstLetter <= 'I') return 'Crystal';
                    if (firstLetter >= 'J' && firstLetter <= 'Z') return 'Tiana';
                }
            } else {
                return 'Clara';
            }
        }
        
        // Rule 7: United Healthcare specific
        if (financialClass == 'United Healthcare') {
            if (providerGrouping == 'MD') {
                if (patientName != null) {
                    String firstLetter = patientName.substring(0, 1).toUpperCase();
                    if (firstLetter >= 'A' && firstLetter <= 'I') return 'Crystal';
                    if (firstLetter >= 'J' && firstLetter <= 'Z') return 'Tiana';
                }
            } else {
                return assignUnitedHealthcareNonMD(patientName);
            }
        }
        
        // Rule 8: Government and related
        if (GOVT_INSURANCE.contains(financialClass)) {
            if (providerGrouping == 'MD') {
                return 'Natasha';
            } else {
                return assignGovernmentNonMD(patientName);
            }
        }
        
        // Rule 9: Miscellaneous
        if (financialClass == 'Misc') {
            if (providerGrouping == 'MD') {
                if (patientName != null) {
                    String firstLetter = patientName.substring(0, 1).toUpperCase();
                    if (firstLetter >= 'A' && firstLetter <= 'I') return 'Crystal';
                    if (firstLetter >= 'J' && firstLetter <= 'Z') return 'Tiana';
                }
            } else {
                return assignGovernmentNonMD(patientName); // Same logic as Government Non-MD
            }
        }
        
        // Rule 10: Blue Cross Blue Shield
        if (financialClass == 'Blue Cross Blue Shield') {
            if (providerGrouping == 'MD') {
                return assignBlueCrossMD(patientName);
            } else {
                return assignBlueCrossNonMD(patientName);
            }
        }
        
        return null; // No assignment
    }
    
    private static String assignUnitedHealthcareNonMD(String patientName) {
        if (patientName == null) return null;
        String name = patientName.toUpperCase();
        
        if (name < 'CARM') return 'Jamshad Akram';
        if (name < 'DEBB') return 'Anzer Shabir';
        if (name < 'GAR') return 'Umar Saddique';
        if (name < 'JEA') return 'Waleed Sharif';
        if (name < 'KAM') return 'Kashif Qumbar';
        if (name < 'LUK') return 'Salman Jamil';
        if (name < 'MIC') return 'Christina';
        if (name < 'PH') return 'Shoaib Saeed';
        if (name < 'SANDR') return 'Shahbaz Ashraf';
        if (name < 'TERESA A') return 'Aman Ashraaf';
        return 'Zahid Yaqoob';
    }
    
    private static String assignGovernmentNonMD(String patientName) {
        if (patientName == null) return null;
        String name = patientName.toUpperCase();
        
        if (name < 'ANTH') return 'Waqas Saeed';
        if (name < 'CATHERINE F') return 'Waqar Afraz';
        if (name < 'DIANA') return 'Tamoor Ahmed';
        if (name < 'FEL') return 'Shahzaib Afraz';
        if (name < 'HI') return 'Adeel Munawar';
        if (name < 'JE') return 'Rayyan Manzoor';
        if (name < 'JUD') return 'Hamza Hafeez';
        if (name < 'K') return 'Nazir Hussain';
        if (name < 'LU') return 'Aqib Hameed';
        if (name < 'MAT') return 'Angela';
        if (name < 'NAN') return 'Aamir Gulzar';
        if (name < 'P') return 'Anees Awan';
        if (name < 'ROS') return 'Toseeq Dilpazir';
        if (name < 'SUS') return 'Hassan Ali';
        if (name < 'VALERIE') return 'Sabeel Ahmed';
        return 'Zaryab Zahoor';
    }
    
    private static String assignBlueCrossMD(String patientName) {
        if (patientName == null) return null;
        String name = patientName.toUpperCase();
        
        if (name <= 'AND') return 'Amanda';
        if (name <= 'BRI') return 'Muhammad Faizan';
        if (name <= 'CL') return 'John';
        if (name <= 'DA') return 'Iftikhar Mohsin';
        if (name <= 'EM') return 'Muhammad Raheel';
        if (name <= 'G') return 'Zamir Osairam';
        if (name <= 'JEF') return 'Ahmad Zafran';
        if (name <= 'JO') return 'Maskeen Saqib';
        if (name <= 'KH') return 'Mujahid Raja';
        if (name <= 'LI') return 'Rehman Saif';
        if (name <= 'MAR') return 'Jeelani Ghulam';
        if (name <= 'MIZ') return 'Azam Faizan';
        if (name <= 'PAT') return 'Bilal Muhammad';
        if (name <= 'Q') return 'Javaid Nayyer';
        if (name <= 'R') return 'Khalil Rafaqat';
        if (name <= 'SON') return 'Sadiq Shahzaib';
        if (name <= 'THE') return 'Kazmi Baseerat';
        if (name <= 'VIN') return 'Amanda';
        return 'Myreva';
    }
    
    private static String assignBlueCrossNonMD(String patientName) {
        if (patientName == null) return null;
        String name = patientName.toUpperCase();
        
        if (name <= 'ALYSSA C') return 'Faizan Hanif';
        if (name <= 'ANTONIN') return 'Hassan Nisar';
        if (name <= 'BILLI') return 'Muhammad Ishaq';
        if (name <= 'BRYANN') return 'Ikraam Razzaq';
        if (name <= 'CHRISTINA K') return 'Mohsin Ashiq';
        if (name <= 'DANA') return 'Furqan Ali';
        if (name <= 'DAZ') return 'Shayan Nawaz';
        if (name <= 'EDE') return 'Arslan Tahir';
        if (name <= 'ENI') return 'Anees Hafeez';
        if (name <= 'GERALD') return 'Waleed Naeem';
        if (name <= 'JACK') return 'Jahangir Khan';
        if (name <= 'JEFFREY S') return 'Amir Yaqoob';
        if (name <= 'JOCELI') return 'Syed Abbas';
        if (name <= 'JULIAN A') return 'Jamshed Ishtiaq';
        if (name <= 'KEI') return 'Hasnain Abbas';
        if (name <= 'KYLE') return 'Inksar Sadiq';
        if (name <= 'LORA F') return 'Mubbshir Sheikh';
        if (name <= 'MARISO') return 'Usama Tahir';
        if (name <= 'MICHAEL LA') return 'Sabtain Ajaz';
        if (name <= 'NELL') return 'Usama Ghani';
        if (name <= 'PETER C') return 'Jessica';
        if (name <= 'ROBERTA') return 'Michelle';
        if (name <= 'SEAN G') return 'Liza';
        if (name <= 'SUSAN B') return 'Kim';
        if (name <= 'VICKIE P') return 'Catherine';
        return 'Jennifer';
    }
}