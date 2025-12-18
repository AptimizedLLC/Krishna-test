trigger dnFinancialClass on dn_Denial__c (before insert, before update) {
   //Updating Provider Grouping field from the custom Metadata types RCM_MDCons_Provider_Grouping
    // Map to store Provider_Name__c -> (Grouping__c, Provider_ID__c)
    Map<String, Map<String, String>> providerMetadataMap = new Map<String, Map<String, String>>();

    // Query Custom Metadata Type to get Provider_Name__c, Grouping__c, Provider_ID__c
    for (Denials_MDCons_Provider_Grouping__mdt metaRecord : [
        SELECT Provider_Name__c, Grouping__c, Provider_ID__c 
        FROM Denials_MDCons_Provider_Grouping__mdt
    ]) {
        // Convert Decimal to String before putting into map
        String providerIdStr = metaRecord.Provider_ID__c != null ? String.valueOf(metaRecord.Provider_ID__c.intValue()) : null;


        providerMetadataMap.put(
            metaRecord.Provider_Name__c,
            new Map<String, String>{
                'Grouping' => metaRecord.Grouping__c,
                'ProviderId' => providerIdStr
            }
        );
    }

    // Iterate over dn_Denial__c records to update the fields
    for (dn_Denial__c denialRecord : Trigger.new) {
        if (denialRecord.dn_PROVIDER__c != null && providerMetadataMap.containsKey(denialRecord.dn_PROVIDER__c)) {
            Map<String, String> metaValues = providerMetadataMap.get(denialRecord.dn_PROVIDER__c);

            // Update Grouping logic
            String groupingValue = metaValues.get('Grouping');
            denialRecord.dn_PROVIDER_GROUPING__c = (groupingValue == 'MD') ? 'MD' : 'Not MD';

            // Set dn_Provider_Id__c as a String
            denialRecord.dn_Provider_Id__c = metaValues.get('ProviderId');
        }
    }

    

    // Define the payer sets
    Set<String> aetnaPayers = new Set<String>{
        'ALLIED BENEFIT SYSTEMS INC',
            'SENTARA HEALTH PLANS', 
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
        'NORTHERN NEW JERSEY TEAMSTERS', 
            'HORIZON BCBS OF NJ - ANTHEM'
    };
        
         Set<String> cashPayPayers = new Set<String>{
        'SELF PAY'
    };
        
        Set<String> cignaPayers = new Set<String>{
        'ADVANCE BENEFIT MANAGEMENT SYSTEMS',
        'ALLEGIANCE',
         '',
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
            'MEDICO INSURANCE COMPANY',
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
                    'BLACK CAR FUND',
            'AM TRUST NORTH AMERICA',
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



    for (dn_Denial__c record : Trigger.new) {
    String payer = '';

    if (record.dn_DENYING_PARTY__c == 'Primary') {
        payer = String.isNotBlank(record.dn_POLICY_PRIMARY_PAYER__c)
            ? record.dn_POLICY_PRIMARY_PAYER__c
            : record.dn_POLICY_SECONDARY_PAYER__c;
    } 
    else if (record.dn_DENYING_PARTY__c == 'Secondary') {
        payer = String.isNotBlank(record.dn_POLICY_SECONDARY_PAYER__c)
            ? record.dn_POLICY_SECONDARY_PAYER__c
            : record.dn_POLICY_PRIMARY_PAYER__c;
    } 
    else if (record.dn_DENYING_PARTY__c == 'Tertiary') {
        payer = String.isNotBlank(record.dn_POLICY_SECONDARY_PAYER__c)
            ? record.dn_POLICY_SECONDARY_PAYER__c
            : record.dn_POLICY_PRIMARY_PAYER__c;
    }

    if (String.isBlank(payer)) continue;

    String payerTrimmed = payer.trim().toUpperCase();


        // Apply logic based on payer match
        if (aetnaPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Aetna';
        } else if (autoInsurancePayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Auto Insurance';
        }
        else if (blueCrossBlueShieldPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Blue Cross Blue Shield';
        }
        else if (cashPayPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Cash Pay';
        }
         else if (cignaPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Cigna';
        }
        else if (governmentPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Government';
        }
        else if (humanaPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Humana';
        }
        else if (medicaidPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Medicaid';
        }
        else if (medicareSupplementPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Medicare / Supplement';
        }
        else if (medicareReplacementPlanPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Medicare Replacement Plan';
        }
        else if (miscellaneousPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Miscellaneous';
        }
        else if (outOfStatePayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Out of State';
        }
        else if (unitedHealthCarePayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'United HealthCare';
        }
        else if (workersCompensationPayers.contains(payerTrimmed)) {
            record.dn_Financial_Class__c = 'Workers Compensation';
        }
    }
    
    // Feature for updating the Patient Name. This feature is implemented to search the patient name in the Denial List View. 
 // Collect Account Ids from Denials
    Set<Id> accountIds = new Set<Id>();
    for (dn_Denial__c denial : Trigger.new) {
        if (denial.dn_Patient_Account__c != null) {
            accountIds.add(denial.dn_Patient_Account__c);
        }
    }

    // Query Accounts
    Map<Id, Account> accountMap = new Map<Id, Account>(
        [SELECT Id, dn_Name__c FROM Account WHERE Id IN :accountIds]
    );

    // Update Patient_Full_Name__c field
    for (dn_Denial__c denial : Trigger.new) {
        if (denial.dn_Patient_Account__c != null && 
            accountMap.containsKey(denial.dn_Patient_Account__c)) {
            denial.Patient_Full_Name__c = accountMap.get(denial.dn_Patient_Account__c).dn_Name__c;
        }
    }
    dn_DenialHandler.setBypassOnBeforeUpdate(Trigger.new,Trigger.old);
}