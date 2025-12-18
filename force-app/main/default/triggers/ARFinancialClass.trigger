trigger ARFinancialClass on AR_Accounts_Receivable__c (before insert, before update) 
{
    // Define the payer sets
    Set<String> aetnaPayers = new Set<String>{
        'ALLIED BENEFIT SYSTEMS INC',
        'AETNA',
        'AETNA U.S. HEALTHCARE',
        'AITHER HEALTH',
        'ALLIED BENEFIT SYSTEMS  INC',
        'ALLIED BENEFIT SYSTEMS LLC',
        'BENEFIT ADMINISTRATION SERVICES',
        'BENEFIT ADMINISTRATIVE SYSTEMS  LTD',
        'GRAVIE ADMINISTRATIVE SERVICES',
        'MARPAI HEALTH',
        'MERITAIN HEALTH',
        'CHC MEDICAL PLAN'
    };

    Set<String> autoInsurancePayers = new Set<String>{
        'AAA',
        'AAA MID-ATLANTIC INSURANCE GROUP',
        'ACCURO SOLUTIONS',
        'AIS',
        'ALLSTATE',
        'ALLSTATE GROUP CLAIMS',
        'ALLSTATE INSURANCE CO',
        'AMERICAN AUTOMBILE',
        'American Family Insurance',
            'AMERICAN FAMILY INSURANCE',
        'AMERICAN MODERN INSURANCE',
        'AMERICAN NATIONAL PROPERTY & CASUAL',
        'AMERICAN TRANSIT INSURANCE COMPANY',
        'AMERITRUST',
        'AMICA INSURANCE',
        'BLUE STAR CLAIMS MANAGEMENT',
        'BRISTOL WEST',
        'BRISTOL WEST INSURANCE GROUP',
        'BROKERAGE CONCEPTS  INC',
        'CALIFORNIA CASUALTY AUTO CLAIMS',
        'CLAIMSAKE',
        'COMMERICAL LINES CLAIMS',
        'CSAA',
        'CURE AUTO INSURANCE',
        'DIRECT AUTO INSURANCE',
        'DIRECT GENERAL INSURANCE',
        'ELECTRIC INSURANCE CO',
        'ERIE INSURANCE',
        'ESURANCE',
        'FARMERS',
        'FARMERS INSURANCE',
        'FOREMOST INSURANCE',
        'GEICO',
        'GENEX',
        'GOOD 2 GO',
        'GOOD TO GO',
        'HANOVER MEDICAL CLAIMS',
        'HEREFORD INSURANCE COMPANY',
        'INTACT ACCIDENT & HEALTH',
        'KEMPER DIRECT',
        'KOMODO CLAIMS',
        'LIBERTY MUTUAL',
        'MED LOGIX',
        'MERCURY INSURANCE',
        'METROMILE',
        'National General Accident & Health',
            'NATIONAL GENERAL ACCIDENT & HEALTH',
        'NATIONAL GENERAL INSURANCE',
        'NATIONAL LIABILITY & FIRE INSURANCE',
        'NATIONWIDE',
        'NATIONWIDE INSURANCE',
        'NEW HIGHWAY INSRUANCE COMPANY',
        'NEW JERSEY MANUFACTURE',
        'NJ PLIGA',
        'PENN NATIONAL CLAIMS',
        'PLYMOUTH ROCK ASSURANCE',
        'PRIZM',
        'PROGRESSIVE',
        'PROGRESSIVE AUTO INSURANCE',
        'PROGRESSIVE CLAIMS',
        'REGENCE GROUP ADMINISTRATORS',
        'RENTAL CLAIM SERVICES',
        'SAFETY INC',
        'SELECTIVE',
        'SELECTIVE AUTO INSURANCE OF AMERICA',
        'STATE FARM',
        'STATE FARM CLAIMS',
        'THE GENERAL INSURANCE',
        'THE HARTFORD GROUP',
        'TOKIO MARINE INSURANCE',
        'TRAVELERS',
        'TRAVELERS AUTO INSURANCE',
        'Travelers Insurance',
         'TRAVELERS INSURANCE',
        'USAA',
        'USAA AUTO INSURANCE',
        'ZURICH AMERICAN INSURANCE COMPANY',
        'ZURICH NORTH AMERICA',
        'AMERICAN CLAIMS MANAGEMENT',
        'NEW JERSEY MANUFACTURERS INSURANCE'
    };
        
          Set<String> blueCrossBlueShieldPayers = new Set<String>{
        'HORIZON BCBS OF NEW JERSEY',
        'HORIZON BCBS OF NEW JERSEY BLUECARD',
        'HORIZON BCBS OF NEW JERSEY FEP',
        'HORIZON BCBS OF NJ',
        'HORIZON NJ TOTAL CARE HMO',
        'INDEPENDENCE ADMINISTRATORS',
        'NORTHERN NEW JERSEY TEAMSTERS'
    };
        
         Set<String> cashPayPayers = new Set<String>{
        'SELF PAY'
    };
        
        Set<String> cignaPayers = new Set<String>{
        'ADVANCE BENEFIT MANAGEMENT SYSTEMS',
        'ALLEGIANCE',
         'AMERICAN SPECIALTY HEALTH GROUP INC',
        'AMERICAN PLAN ADMINISTRATOR',
        'AMERICAN PLAN ADMINISTRATORS',
        'CIGNA',
        'CIGNA - NON-HAP MEMBERS ONLY - JVHL',
        'CIGNA HEALTHCARE',
        'CIGNA INTERNATIONAL',
        'CIGNA JFK EMPLOYEES',
        'FREEDOM LIFE VIA US HEALTH GROUP',
        'INSURANCE ADMINISTRATORS OF AMERICA',
        'MEDICAL MUTUAL',
        'NALC/CIGNA',
        'PHCS SAVILITY',
        'PRIORITY HEALTH',
        'S&S HEALTH',
        'OPTIMED HEALTH PLAN'
    };
         Set<String> governmentPayers = new Set<String>{
        '1199 NATIONAL BENEFIT FUND',
        'CHAMP VA',
        'GEHA',
        'GEHA-ASA',
        'Government Employees Health Assoc',
            'GOVERNMENT EMPLOYEES HEALTH ASSOC', 
        'MCA SEDGWICK WTC HEALTH PROGRAM',
        'NALC HEALTH BENEFIT PLAN',
        'NATIONAL ELEVATOR INDUSTRY',
        'TRICARE EAST',
        'TRICARE EAST REGION 2025',
        'TRICARE FOR LIFE',
        'TriWest VA CCN Claims',
            'TRIWEST VA CCN CLAIMS',
        'VA CCN OPTUM'
    };
        Set<String> humanaPayers = new Set<String>{
        'HUMANA',
        'HUMANA  INC',
        'HUMANA  INC.'
        
    };
        
        Set<String> medicaidPayers = new Set<String>{
        'AETNA BETTER HEALTH OF NEW JERSEY',
        'AMERICHOICE OF NEW JERSEY INC',
        'AMERIGROUP',
        'AMERIGROUP COMM CARE OF NEW MEXICO',
        'AMERIGROUP COMMUNITY CARE',
        'AMERIGROUP COMMUNITY CARE VIRGINIA',
        'AMERIGROUP TEXAS',
        'HORIZON NJ HEALTH',
        'MEDICAID NEW JERSEY',
        'METROPLUS HEALTH PLAN',
        'PENNSYLVANIA MEDICAID',
        'UHC HEALTHCARE COMMUNITY CARE PLAN',
        'UNITED HEALTHCARE COMMUNITY PLAN',
        'UNITED HEALTHCARE DUAL COMPLETE',
        'UNITED HEALTHCARE COMMUNITY PLAN MO',
        'UNITEDHEALTHCARE COMMUNITY PLAN',
        'WELLCARE HEALTH PLANS',
        'WELLCARE OF NJ',
        'WELLPOINT',
        'CARE 1ST HEALTH PLANS'
    };
        Set<String> medicareSupplementPayers = new Set<String>{
        'AARP HEALTHCARE OPTIONS',
        'ACE',
        'AETNA SENIOR SUPPLEMENTAL INSURANCE',
        'ALLSTATE HEALTH SOLUTIONS',
        'AMA INSURANCE AGENCY',
        'AMERICAN BENEFIT CORP',
        'AMERICAN CONTINENTAL INS. COMPANY',
        'AMERICAN CONTINENTAL INSURANCE',
        'AMERICAN NATIONAL',
        'AMERICAN UNITED LIFE INSURANCE COMP',
        'AMO MEDICAL PLAN',
        'BANKERS FIDELITY',
        'BANKERS FIDELITY LIFE INSURANCE',
        'BANKERS INSURANCE GROUP',
        'BANKERS LIFE & CASUALTY',
        'BANKERS LIFE & CASUALTY CO',
        'BANKERS LIFE AND CASUALTY',
        'BANKES LIFE AND CASUALTY',
        'CHCS',
        'CIGNA MEDICARE SUPPLEMENT INSURANCE',
        'COLONIAL PENN LIFE',
        'COMMONWEALTH OF MASSACHUSETTS',
        'CRUM & FORSTER',
        'CRUM & FORSTER INSURANCE',
        'CRUM AND FORSTER',
        'DIVISION 1181 ATU',
        'FAMILY LIFE INSURANCE COMPANY',
        'FOREIGN SERVICE BENEFIT PLAN / MUTU',
        'FORETHOUGHT LIFE INSURANCE COMPANY',
        'GEISINGER HEALTH PLAN',
        'GENWORTH',
        'GENWORTH LIFE & ANNUITY',
        'GERBER LIFE INSURANCE CO',
        'GLOBECARE',
        'GMP EMPLOYERS RETIREE TRUST',
        'GREAT SOUTHERN LIFE INSURANCE COMP',
        'HOLISTICARE HOSPICE',
        'INDIVIDUAL ASSURANCE COMPANY',
        'K & K INSURANCE GROUP',
        'MANHATTAN INSURANCE GROUP',
        'MANHATTEN LIFE INSURANCE COMPANY',
        'Medi-Share FIRST HEALTH',
            'MEDI-SHARE FIRST HEALTH',
        'MEDICARE - DMERC CARRIERS REGION A',
        'Medicare DME JurisdictionA Noridian',
         'MEDICARE DME JURISDICTIONA NORIDIAN',
        'MEDICARE RAILROAD PALMETTO GBA',
        'MUTUAL OF OMAHA',
        'MUTUAL OF OMAHA EAP',
        'NASSAU LIFE INSURANCE COMPANY',
        'NEW ERA LIFE INSURANCE CO',
        'NEW ERA LIFE INSURANCE COMPANY',
        'NEW JERSEY MEDICARE PART B J12',
        'PAN AMERICAN LIFE INSURANCE',
        'PAN AMERICAN LIFE INSURANCE CO',
        'Philadelphia American Life',
            'PHILADELPHIA AMERICAN LIFE',
        'SHEET METAL WORKERS',
        'ST CLOUD OPERATIONS',
        'THRIVENT FINANCIAL',
        'TRANSAMERICA',
        'TRANSAMERICA ASSURANCE CO',
        'TRANSAMERICA LIFE INSURANCE COMPANY',
        'TRIVENT',
        'UNITED AMERICAN INSURANCE COMPANY',
        'UNITED LIFE INSURANCE COMP',
        'UNITED OF OMAHA LIFE INSURANCE CO',
        'UNITED WORLD LIFE',
        'WASHINGTON NATIONAL',
        'WASHINGTON NATIONAL INSURANCE COMPA',
        'GLOBAL LIFE AND ACCIDENT'
    };
        Set<String> medicareReplacementPlanPayers = new Set<String>{
        'AMERIVANTAGE',
        'BRAVEN HEALTH',
        'CIGNA MEDICARE ADVANTAGE',
        'CIGNA MEDICARE CHOICE',
        'CLOVER HEALTH',
        'CLOVER HEALTHCARE',
        'HEALTHSPRING',
        'HUMANA GOLD PLUS PLAN',
        'OPTUM',
        'OPTUM MEDICAL NETWORK',
        'SENIOR WHOLE HEALTH',
        'UNITED HEALTHCARE MEDICARE',
        'UNITED HEALTHCARE MEDICARE COMPLETE',
        'WELLCARE',
        'WELLMED',
        'OPTUM HEALTH CARE SOLUTIONS INC'
    };
         Set<String> miscellaneousPayers = new Set<String>{
        'AG ADMINISTRATORS',
        'AMERIHEALTH ADMINISTRATORS',
        'AmeriHealth HMO New Jersey and Dela',
            'AMERIHEALTH HMO NEW JERSEY AND DELA',
        'AMERIHEALTH HMO NJ AND DE',
        'AMERIHEALTH MEDIGAP PLAN',
        'AMERIHEALTH PPO',
        'AVERA HEALTH PLANS',
        'BENEFIT ADMINISTRATIVE SYSTEMS LTD',
        'BMI BENEFITS LLC',
        'BOLLINGER  INC',
        'BOOMYHEALTH',
        'CHRISTIAN BROTHER EMPLOYEE TRUST',
        'CHRISTIAN BROTHER SERVICES',
        'CONNECTICARE INC',
        'DETEGO HEALTH',
        'EBMS',
        'EBSO INSURANCE',
        'EMBLEM HEALTH',
        'GROUP & PENSION ADMINISTRATORS',
        'GROUP ADMINISTRATORS LTD',
        'HEALTH NET',
        'HEALTH PARTNERS',
        'HEALTH PLANS INC',
        'HEALTH SPECIAL RISK INCORPORATED',
        'HEALTHEZ',
        'HEALTHFIRST NEW YORK OUT OF NETWORK',
        'HEALTHSCOPE BENEFITS',
        'IMG',
        'IMPACT HEALTH SHARING',
        'INDEPENDENCE BLUE CROSS',
        'LIBERTY HEALTHSHARE',
        'LOCAL 1964 ILA',
        'LONGEVITY HEALTH PLAN OF NEW JERSEY',
        'LUCENT HEALTH',
        'LUMINARE HEALTH DETROIT',
        'MAGNACARE',
        'Medi-Share',
            'MEDI-SHARE',
        'MERCHANTS BENEFITS ADMINISTRATION',
        'Merchants Insurance Group',
            'MERCHANTS INSURANCE GROUP',
        'MVP HEALTHCARE',
        'NAHGA CLAIM SERVICES',
        'NEIGHBORHOOD HEALTH PARTNERSHIP',
        'NIPPON LIFE BENEFITS',
        'NIPPON LIFE INSURANCE COMPANY',
        'NIU INTERCOLLEGIATE ATHLETIC',
        'OMNI ADMINISTRATORS INC',
        'OSCAR HEALTH',
        'PHCS',
        'PREFERRED BENEFIT ADMIMISTRATORS',
        'REDIRECT HEALTH',
        'RUTGERS ATHLETIC INSURANCE',
        'S & S HEALTHCARE STRATEGIES',
        'S AND S HEALTHCARE STRATEGIES',
        'SELF INSURED SERVICES CO',
       'TALL TREE ADMINISTRATORS',
        'THE LOOMIS COMPANY',
        'TOTAL PLAN CONCEPTS',
        'TRUSTMARK HEALTH BENEFITS',
        'TRUSTMARK INSURANCE',
        'UNIVERSAL HEALTH',
        'UNIVERSAL HEALTHSHARE',
        'USFHP',
        'Valenz Health',
            'VALENZ HEALTH',
        'VITORI HEALTH PHCS',
        'WEB TPA',
        'WEBTPA',
        'IUOE LOCAL 25 MEDICAL PLAN',
        'CLEARWATER PHCS',
        'HEALTH ADMINSTRATION CENTER',
        'ADMINISTRATIVE CONCEPTS INC',
        'TRIBADO',
        'CAREONE AT HOLMDEL'
    };
        Set<String> outOfStatePayers = new Set<String>{
        'ANTHEM BCBS OF WISCONSIN',
        'ANTHEM BCBS VIRGINIA',
        'ANTHEM BLUE CROSS AND BLUE SHIELD',
        'BLUE CROSS BLUE SHIELD OF ALABAMA',
        'BLUE CROSS BLUE SHIELD OF ILLINOIS',
        'DAKOTACARE',
        'EMPIRE BCBS OF NEW YORK',
        'FIDELIS CARE NY',
        'FLORIDA BLUE',
        'GHI',
        'GLOBE LIFE INSURANCE COMPANY OF NY',
        'HIGHMARK BCBS OF PA BLUECARD POS',
        'HIP',
        'MANAGED CARE - MLIC ACCESS',
        'Meritain Health Minneapolis',
         'MERITAIN HEALTH MINNEAPOLIS',
        'MICHIGAN STATE UNIVERSITY ATHLETICS'
    };
        Set<String> unitedHealthCarePayers = new Set<String>{
        'DEFINITY HEALTH / UNITED HEALTH CAR',
        'OPTUM CARE',
        'OPTUM HEALTH',
        'OXFORD HEALTH PLANS',
        'UHC GLOBAL',
        'UHC KIOSK SILVER PLAN',
        'UHCLIC',
        'UMR',
        'UNICARE',
        'EMPIRE PLAN',
        'UNITED HEALTH CARE',
        'UNITED HEALTHCARE',
        'UNITED HEALTHCARE NON GOLDEN RULE',
        'United Healthcare Shared Services',
            'UNITED HEALTHCARE SHARED SERVICES',
        'UNITED HEALTHCARE STUDENT RESOURCES',
        'UNITED HEALTHCARESECURE HORIZONS',
        'WELLMEDUNITEDHEALTHCARE',
        'GEHA UNITED HEALTHCARE',
            'Surest Bind',
            'SUREST BIND',
            'HARVARD PILGRIM HEALTH CARE'
    };
        Set<String> workersCompensationPayers = new Set<String>{
        'ACE PROPERTY AND CASUALITY',
            'SPHERE RISK PARTNERS',
        'ACE PROPERTY AND CASUALTY INSURANCE',
        'AMTRUST',
        'ATHENS INSURANCE',
        'BERKLEY ENTERTAINMENT',
        'BERKSHIRE HATHAWAY',
        'BERKSHIRE HATHAWAY INSURANCE CO',
        'BIBERK',
        'BROADSPIRE',
        'CBCS',
        'CCMSI',
        'CHUBB',
        'CHUBB SUPLEMENT INSURANCE',
        'Claims Service Bureau of NY',
            'CLAIMS SERVICE BUREAU OF NY',
        'CNA',
        'CNA INSURANCE',
        'CONTRACT CLAIMS SERVICES',
        'Division of Federal Employees Comp',
            'DIVISION OF FEDERAL EMPLOYEES COMP',
        'EK HEALTH SERVICES',
        'ENCOMPASS',
        'ESIS',
        'ESIS WC CLAIMS',
        'FMA C/O TALL TREE ADMIN',
        'GALLAGHER AND BASSETT',
        'GALLAGHER BASSET',
        'GALLAGHER BASSETT',
        'HARTFORD',
        'HARTFORD INSURANCE CO',
        'HELMSMAN MANAGEMENT SERVICES',
        'I.E. SHAFFER AND COMPANY',
        'ICW',
        'INDECS CORPORATION',
        'INNOVATIVE CLAIMS STRATEGIES',
        'INTACT INSURANCE',
        'LIBERTY MUTUAL',
        'LIBERTY MUTUAL INSURANCE COMPANY',
        'MARRIOT CLAIMS SERVICES',
        'NCA COMP',
        'NEW JERSEY TRANSIT',
        'New York City Law Department',
        'NEW YORK CITY LAW DEPARTMENT',
        'NEW YORK CITY TRANSIT AUTHORITY',
        'NEW YORK COMPENSATION C/O CORVEL',
        'NEW YORK GIANTS',
        'NEW YORK RISK MANAGEMENT',
        'NEXT LEVEL ADMINISTRATORS',
        'NJ PROPERTY & LIABILITY INS',
        'NJ TRANSIT HEADQUARTERS',
        'NJM INSURANCE GROUP',
        'NJM INSURANCE',
        'NORGUARD INSURANCE',
        'NYC LAW DEPARTMENT',
        'NYCTA',
        'NYCTA IN CARE OF CORVEL CORP',
        'NYSIF',
        'OWCP',
        'OWCP/DFEC',
        'PA STATE WORKERS INSURANCE FUND',
        'PMA INSURANCE GROUP',
        'PORTS AMERICA RISK MANAGEMENT',
        'PROTECTIVE INSURANCE CO',
        'RMPG',
        'SAGE',
        'SAGE ADJUSTING',
        'SEDGWICK',
        'SEDGWICK CLAIMS MANAGEMENT',
        'SEDGWICK CLAIMS MANAGEMENT SERVICES',
        'SEDGWICK CMS',
        'SENTRY INSURANCE MUTUAL CO',
        'STATE WORKERS INSURANCE FUND',
        'THE BLACK CAR FUND',
        'THE RISK MANAGEMENT PLANNING GROUP',
        'TOKIO MARINE AMERICA',
        'TRISTAR RISK MANAGEMENT',
        'US DEPARTMENT OF LABOR',
        'UTICA NATIONAL INSURANCE GROUP',
        'WALMART CLAIMS SERVICE INC',
        'WORKERS COMP TRUST',
        'ZURICH',
        'ZURICH AMERICAN INSURANCE',
        'ZURICH INSURANCE COMPANY',
        'POLICE FIRE & SANITATION CORRECTION',
        'MSA CAREGUARD'
    };



   for (AR_Accounts_Receivable__c record : Trigger.new) {
        if (String.isNotBlank(record.AR_Payer__c)) {
            String payerTrimmed = record.AR_Payer__c.trim();


        // Apply logic based on payer match
        if (aetnaPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Aetna';
        } else if (autoInsurancePayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Auto Insurance';
        }
        else if (blueCrossBlueShieldPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Blue Cross Blue Shield';
        }
        else if (cashPayPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Cash Pay';
        }
         else if (cignaPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Cigna';
        }
        else if (governmentPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Government';
        }
        else if (humanaPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Humana';
        }
        else if (medicaidPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Medicaid';
        }
        else if (medicareSupplementPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Medicare / Supplement';
        }
        else if (medicareReplacementPlanPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Medicare Replacement Plan';
        }
        else if (miscellaneousPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Miscellaneous';
        }
        else if (outOfStatePayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Out of State';
        }
        else if (unitedHealthCarePayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'United HealthCare';
        }
        else if (workersCompensationPayers.contains(payerTrimmed)) {
            record.AR_Financial_Class__c = 'Workers Compensation';
        }
    }
    
   }
    
      // Define sets for matching criteria
Set<String> validFinancialClasses = new Set<String>{
    'Medicare / Supplement', 'Cigna', 'Aetna', 'Medicare Replacement Plan', 
    'Blue Cross Blue Shield', 'United HealthCare', 'Cash Pay'
};

Set<String> validProcedureCodes = new Set<String>{
    '62323', '62321', '64454', '64624', '64490', '64491', '64492', 
    '64493', '64494', '64495', '64633', '64634', '64635', '64636', 
    '64483', '64484', '27096'
};

// Valid provider Ids
Set<String> validProviderIds = new Set<String>{
    '32706', '35227', '35224', '38948', '32515'
};

// Collect Patient Account IDs for querying dn_Name__c
Set<Id> patientAccountIds = new Set<Id>();
for (AR_Accounts_Receivable__c arRecord : Trigger.new) {
    if (arRecord.AR_Patient_Account__c != null) {
        patientAccountIds.add(arRecord.AR_Patient_Account__c);
    }
}

// Query Patient Account records for dn_Name__c
Map<Id, Account> patientAccounts = new Map<Id, Account>(
    [SELECT Id, dn_Name__c FROM Account WHERE Id IN :patientAccountIds]
);

// Query User records for username matching
Map<String, Id> usernameToUserId = new Map<String, Id>();
for (User u : [
    SELECT Id, Username 
    FROM User 
    WHERE Username IN (
        'brian.chatelier@alliancehealthsystem.com.stage', 
        'taylor.demaio@allianceortho.com.stage'
    )
]) {
    usernameToUserId.put(u.Username, u.Id);
}

// Process records
for (AR_Accounts_Receivable__c arRecord : Trigger.new) {
    // Check if record matches criteria
    if (validFinancialClasses.contains(arRecord.AR_Financial_Class__c) &&
        validProcedureCodes.contains(arRecord.AR_Procedure_Code__c) &&
        validProviderIds.contains(arRecord.AR_Provider_Id__c)) {
        
        // Get the patient account's dn_Name__c
        String dnName = patientAccounts.get(arRecord.AR_Patient_Account__c)?.dn_Name__c;
        
        if (String.isNotBlank(dnName)) {
            String firstLetter = dnName.substring(0, 1).toUpperCase();
            
            // Assign owner based on first letter of dn_Name__c
            if (firstLetter >= 'A' && firstLetter <= 'J') {
                Id ownerId = usernameToUserId.get('brian.chatelier@alliancehealthsystem.com.stage');
                if (ownerId != null) {
                    arRecord.OwnerId = ownerId;
                } else {
                    arRecord.addError('User with username brian.chatelier@alliancehealthsystem.com.stage not found.');
                }
            } else if (firstLetter >= 'K' && firstLetter <= 'Z') {
                Id ownerId = usernameToUserId.get('taylor.demaio@allianceortho.com.stage');
                if (ownerId != null) {
                    arRecord.OwnerId = ownerId;
                } else {
                    arRecord.addError('User with username taylor.demaio@allianceortho.com.stage not found.');
                }
            }
        } else {
            arRecord.addError('Patient Account dn_Name__c is blank.');
        }
    }
}

    //---------------------------
    
  /*  if (Trigger.isBefore && (Trigger.isInsert )) {
        for (AR_Accounts_Receivable__c dp : Trigger.new) {
            if (dp.Injection_Status__c == 'UNB') {
                dp.Follow_Up_Display_Date__c = Date.today().addDays(7);
            } else if (dp.Injection_Status__c == 'INP') {
                dp.Follow_Up_Display_Date__c = Date.today();
            }
             else if (dp.Injection_Status__c == 'REP') {
                dp.Follow_Up_Display_Date__c = Date.today();
            }
             else if (dp.Injection_Status__c == 'APP') {
                dp.Follow_Up_Display_Date__c = Date.today().addDays(30);
            }
            
        }
    }  */

    //--------------------------------
   for (AR_Accounts_Receivable__c rec : Trigger.new) {
        AR_Accounts_Receivable__c oldRec = Trigger.isUpdate ? Trigger.oldMap.get(rec.Id) : null;

        //  Update AR_Date_Worked__c only when Injection_Status__c changes
        if (Trigger.isInsert || (oldRec != null && rec.Injection_Status__c != oldRec.Injection_Status__c)) {
            rec.AR_Date_Worked__c = Date.today();

            //  Handle AR_Follow_Up_Date__c based on Injection_Status__c
            if (rec.Injection_Status__c == 'ACC') {
                rec.AR_Follow_Up_Date__c = 'None';
            } else if (rec.Injection_Status__c == 'UNB') {
                rec.AR_Follow_Up_Date__c = '7 DAYS';
            } else if (rec.Injection_Status__c == 'APP') {
                rec.AR_Follow_Up_Date__c = '30 DAYS';
            } else if (rec.Injection_Status__c == 'PLN') {
                rec.AR_Follow_Up_Date__c = 'None';
            } else if (rec.Injection_Status__c == 'R-PLN') {
                rec.AR_Follow_Up_Date__c = '30 TO 45 DAYS';
            }
        }

        //  Ensure AR_Date_Worked__c is system-controlled (not user editable)
        if (Trigger.isUpdate && oldRec != null && rec.AR_Date_Worked__c != oldRec.AR_Date_Worked__c 
            && rec.Injection_Status__c == oldRec.Injection_Status__c) {
            rec.AR_Date_Worked__c = oldRec.AR_Date_Worked__c;
        }
       // -----------------------------
       // Calculate day differences (positive numbers)
Integer daysFromBilled = rec.AR_Last_Billed_Date__c != null 
    ? rec.AR_Last_Billed_Date__c.daysBetween(Date.today()) 
    : null;

Integer daysFromDOS = rec.AR_DOS__c != null 
    ? rec.AR_DOS__c.daysBetween(Date.today()) 
    : null;

        if (daysFromBilled != null && daysFromBilled >= 31 && daysFromBilled <= 90) {
    rec.AR_Priority_Status__c = 'NEW';
    } 
       else if (rec.AR_Charge_Status__c == 'Current') {
    rec.AR_Priority_Status__c = 'F/U';
     }
       else if (rec.Injection_Status__c != null) {
    rec.AR_Priority_Status__c = 'DND';
    } 
       else if (daysFromBilled != null && daysFromBilled > 365) {
    rec.AR_Priority_Status__c = 'OLD';
    }
       else if (daysFromBilled != null && daysFromBilled >= 91 && daysFromBilled <= 180) {
    rec.AR_Priority_Status__c = 'mPMTDUE';
       }
       else if (daysFromDOS != null && daysFromDOS > 31) {
    rec.AR_Priority_Status__c = 'AUD';
   } 
       else if (daysFromBilled != null && daysFromBilled >= 181 && daysFromBilled <= 365) {
    rec.AR_Priority_Status__c = 'CRITICAL';
    }  
       else if (rec.AR_Policy_Type__c == 'SELF PAY') {
    rec.AR_Priority_Status__c = 'PATIENT';
     }
    }
    
    //----------------------------------
    

 
    for (AR_Accounts_Receivable__c arRec : Trigger.new) {
        AR_Accounts_Receivable__c oldRec = Trigger.isUpdate ? Trigger.oldMap.get(arRec.Id) : null;

        // Run only if Injection_Status__c changes (or on insert)
        if (Trigger.isInsert || (oldRec != null && arRec.Injection_Status__c != oldRec.Injection_Status__c)) {

            if (arRec.Injection_Status__c == 'UNB') {
                arRec.Follow_Up_Date__c = Date.today().addDays(7);
            } 
            else if (arRec.Injection_Status__c == 'APP') {
                arRec.Follow_Up_Date__c = Date.today().addDays(30);
            } 
            else if (arRec.Injection_Status__c == 'R-PLN') {
                arRec.Follow_Up_Date__c = Date.today().addDays(45);
            }
        }
    }



    
    }