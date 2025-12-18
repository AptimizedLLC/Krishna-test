trigger Financialclass on Applied_Payments__c (before insert, before update) {
    // Define a set of unique payer names mapped to 'Workers Compensation' 
    Set<String> workersCompensationPayers = new Set<String>{
        'ACE PROPERTY AND CASUALITY', 'ACE PROPERTY AND CASUALTY INSURANCE',
        'AMTRUST', 'ATHENS INSURANCE', 'BERKLEY ENTERTAINMENT', 'BERKSHIRE HATHAWAY INSURANCE CO',
        'BIBERK', 'BROADSPIRE', 'CCMSI', 'CHUBB', 'CNA', 'CONTRACT CLAIMS SERVICES', 'EK HEALTH SERVICES',
        'ENCOMPASS', 'ESIS', 'ESIS WC CLAIMS', 'FMA C/O TALL TREE ADMIN', 'GALLAGHER AND BASSETT',
        'GALLAGHER BASSET', 'HARTFORD', 'HARTFORD INSURANCE CO', 'HELMSMAN MANAGEMENT SERVICES',
        'I.E. SHAFFER AND COMPANY', 'ICW', 'INDECS CORPORATION', 'INNOVATIVE CLAIMS STRATEGIES',
        'INTACT INSURANCE', 'MARRIOT CLAIMS SERVICES', 'NCA COMP', 'NEW JERSEY TRANSIT',
        'New York City Law Department', 'NEW YORK CITY TRANSIT AUTHORITY', 'NEW YORK GIANTS',
        'NEXT LEVEL ADMINISTRATORS', 'NJ PROPERTY & LIABILITY INS', 'NJM INSURANCE GROUP',
        'NORGUARD INSURANCE', 'NYCTA', 'NYCTA IN CARE OF CORVEL CORP', 'NYSIF', 'OWCP/DFEC',
        'PA STATE WORKERS INSURANCE FUND', 'PROTECTIVE INSURANCE CO', 'RMPG', 'SAGE', 'SAGE ADJUSTING',
        'SEDGWICK', 'SEDGWICK CLAIMS MANAGEMENT', 'SEDGWICK CMS', 'SENTRY INSURANCE MUTUAL CO',
        'THE BLACK CAR FUND', 'THE RISK MANAGEMENT PLANNING GROUP', 'TOKIO MARINE AMERICA',
        'TRISTAR RISK MANAGEMENT', 'US DEPARTMENT OF LABOR', 'UTICA NATIONAL INSURANCE GROUP',
        'WALMART CLAIMS SERVICE INC', 'WORKERS COMP TRUST', 'ZURICH', 'ZURICH AMERICAN INSURANCE',
        'BERKSHIRE HATHAWAY', 'NEW YORK COMPENSATION C/O CORVEL', 'PORTS AMERICA RISK MANAGEMENT',
        'NJ TRANSIT HEADQUARTERS', 'CNA INSURANCE', 'NEW YORK RISK MANAGEMENT', 'NYC LAW DEPARTMENT',
        'SEDGWICK CLAIMS MANAGEMENT SERVICES'
    };
    // Define a set of unique payer names mapped to 'Out of State' 
    Set<String> outOfStatePayers = new Set<String>{
        'ANTHEM BLUE CROSS AND BLUE SHIELD',
        'DAKOTACARE',
        'EMPIRE BCBS OF NEW YORK',
        'EMPIRE PLAN',
        'FIDELIS CARE NY',
        'FLORIDA BLUE',
        'GHI',
        'GLOBE LIFE INSURANCE COMPANY OF NY',
        'HIGHMARK BCBS OF PA BLUECARD POS',
        'MANAGED CARE - MLIC ACCESS',
        'Meritain Health Minneapolis'
    };
    // Define a set of unique payer names mapped to 'United HealthCare' 
    Set<String> unitedHealthCarePayers = new Set<String>{
        'DEFINITY HEALTH / UNITED HEALTH CAR',
        'OPTUM HEALTH',
        'OXFORD HEALTH PLANS',
        'UHC GLOBAL',
        'UHC KIOSK SILVER PLAN',
        'UHCLIC',
        'UMR',
        'UNICARE',
        'UNITED HEALTH CARE',
        'UNITED HEALTHCARE',
        'United Healthcare Shared Services',
        'UNITED HEALTHCARE STUDENT RESOURCES',
        'UNITED HEALTHCARESECURE HORIZONS',
        'WELLMEDUNITEDHEALTHCARE',
        'OPTUM CARE'
    };
    // Define a set of unique payer names mapped to 'Miscellaneous' 
    Set<String> miscellaneousSet = new Set<String>{
        'AG ADMINISTRATORS', 'AMERIHEALTH ADMINISTRATORS', 'AmeriHealth HMO New Jersey and Dela', 
        'AMERIHEALTH HMO NJ AND DE', 'AMERIHEALTH MEDIGAP PLAN', 'AMERIHEALTH PPO', 
        'BENEFIT ADMINISTRATIVE SYSTEMS LTD', 'BMI BENEFITS LLC', 'BOLLINGER INC', 
        'BOOMYHEALTH', 'CHRISTIAN BROTHER EMPLOYEE TRUST', 'EBMS', 'EBSO INSURANCE', 
        'EMBLEM HEALTH', 'GROUP & PENSION ADMINISTRATORS', 'GROUP ADMINISTRATORS LTD', 
        'HEALTH NET', 'HEALTH PARTNERS', 'HEALTH PLANS INC', 'HEALTH SPECIAL RISK INCORPORATED', 
        'HEALTHEZ', 'HEALTHSCOPE BENEFITS', 'IMG', 'IMPACT HEALTH SHARING', 'LIBERTY HEALTHSHARE', 
        'LOCAL 1964 ILA', 'LONGEVITY HEALTH PLAN OF NEW JERSEY', 'LUCENT HEALTH', 
        'LUMINARE HEALTH DETROIT', 'MAGNACARE', 'Medi-Share', 'Merchants Insurance Group', 
        'MVP HEALTHCARE', 'NAHGA CLAIM SERVICES', 'NIPPON LIFE BENEFITS', 
        'NIPPON LIFE INSURANCE COMPANY', 'OSCAR HEALTH', 'PHCS', 'RUTGERS ATHLETIC INSURANCE', 
        'S & S HEALTHCARE STRATEGIES', 'SELF INSURED SERVICES CO', 'Surest Bind', 
        'TALL TREE ADMINISTRATORS', 'THE LOOMIS COMPANY', 'TOTAL PLAN CONCEPTS', 
        'TRUSTMARK HEALTH BENEFITS', 'UNIVERSAL HEALTH', 'USFHP', 'VITORI HEALTH PHCS', 
        'WEB TPA', 'WEBTPA', 'PREFERRED BENEFIT ADMIMISTRATORS', 'Valenz Health', 
        'CHRISTIAN BROTHER SERVICES', 'AVERA HEALTH PLANS', 'HEALTHFIRST NEW YORK OUT OF NETWORK', 
        'NEIGHBORHOOD HEALTH PARTNERSHIP', 'INDEPENDENCE BLUE CROSS', 'NIU INTERCOLLEGIATE ATHLETIC'
    };
    // Define a set of unique payer names mapped to 'Medicare Replacement Plan' 
    Set<String> medicareReplacementPlanSet = new Set<String>{
        'AMERIVANTAGE', 'BRAVEN HEALTH', 'CIGNA MEDICARE CHOICE', 'CLOVER HEALTH', 
        'CLOVER HEALTHCARE', 'HUMANA GOLD PLUS PLAN', 'OPTUM', 'OPTUM MEDICAL NETWORK', 
        'UNITED HEALTHCARE MEDICARE COMPLETE', 'WELLCARE', 'WELLMED', 
        'CIGNA MEDICARE ADVANTAGE'
    };
    // Define a set of unique payer names mapped to 'Humana'   
    Set<String> humanaPayers = new Set<String>{
        'HUMANA', 'HUMANA INC', 'HUMANA INC.', 'HUMANA  INC'
    };

    // Define a set of unique payer names mapped to 'Medicaid'    
    Set<String> medicaidPayers = new Set<String>{
        'AETNA BETTER HEALTH OF NEW JERSEY', 'AMERIGROUP COMM CARE OF NEW MEXICO', 'AMERIGROUP COMMUNITY CARE',
        'AMERIGROUP COMMUNITY CARE VIRGINIA', 'AMERIGROUP TEXAS', 'HORIZON NJ HEALTH', 'PENNSYLVANIA MEDICAID',
        'UNITED HEALTHCARE COMMUNITY PLAN', 'UNITED HEALTHCARE COMMUNITY PLAN MO', 'WELLCARE HEALTH PLANS',
        'WELLCARE OF NJ', 'WELLPOINT', 'MEDICAID NEW JERSEY', 'METROPLUS HEALTH PLAN'
    };
    
    // Define a set of unique payer names mapped to 'Medicare / Supplement'    
    Set<String> medicareSupplementPayers = new Set<String>{
        'AARP HEALTHCARE OPTIONS', 'AETNA SENIOR SUPPLEMENTAL INSURANCE', 'ALLSTATE HEALTH SOLUTIONS',
        'AMA INSURANCE AGENCY', 'AMERICAN BENEFIT CORP', 'AMERICAN NATIONAL', 'AMERICAN UNITED LIFE INSURANCE COMP',
        'AMO MEDICAL PLAN', 'BANKERS FIDELITY', 'BANKERS FIDELITY LIFE INSURANCE', 'BANKERS INSURANCE GROUP',
        'BANKERS LIFE & CASUALTY', 'BANKERS LIFE & CASUALTY CO', 'BANKERS LIFE AND CASUALTY', 'BANKES LIFE AND CASUALTY',
        'CIGNA MEDICARE SUPPLEMENT INSURANCE', 'COLONIAL PENN LIFE', 'CRUM & FORSTER', 'CRUM & FORSTER INSURANCE',
        'DIVISION 1181 ATU', 'FOREIGN SERVICE BENEFIT PLAN / MUTU', 'FORETHOUGHT LIFE INSURANCE COMPANY',
        'GEISINGER HEALTH PLAN', 'GENWORTH', 'GENWORTH LIFE & ANNUITY', 'GERBER LIFE INSURANCE CO',
        'GMP EMPLOYERS RETIREE TRUST', 'GREAT SOUTHERN LIFE INSURANCE COMP', 'K & K INSURANCE GROUP',
        'MANHATTAN INSURANCE GROUP', 'MANHATTEN LIFE INSURANCE COMPANY', 'MEDICARE - DMERC CARRIERS REGION A',
        'Medicare DME JurisdictionA Noridian', 'MEDICARE RAILROAD PALMETTO GBA', 'MUTUAL OF OMAHA', 'MUTUAL OF OMAHA EAP',
        'NASSAU LIFE INSURANCE COMPANY', 'NEW ERA LIFE INSURANCE CO', 'NEW ERA LIFE INSURANCE COMPANY',
        'NEW JERSEY MEDICARE PART B J12', 'PAN AMERICAN LIFE INSURANCE', 'PAN AMERICAN LIFE INSURANCE CO',
        'Philadelphia American Life', 'SHEET METAL WORKERS', 'THRIVENT FINANCIAL', 'TRANSAMERICA ASSURANCE CO',
        'TRANSAMERICA LIFE INSURANCE COMPANY', 'UNITED OF OMAHA LIFE INSURANCE CO', 'UNITED WORLD LIFE',
        'UNITED LIFE INSURANCE COMP', 'INDIVIDUAL ASSURANCE COMPANY', 'CHCS', 'FAMILY LIFE INSURANCE COMPANY',
        'Medi-Share FIRST HEALTH', 'ACE'
    };
    
    // Define a set of unique payer names mapped to 'Cigna'
    Set<String> cignaPayers = new Set<String>{
        'AMERICAN PLAN ADMINISTRATOR',
        'CIGNA',
        'CIGNA HEALTHCARE',
        'CIGNA INTERNATIONAL',
        'CIGNA JFK EMPLOYEES',
        'FREEDOM LIFE VIA US HEALTH GROUP',
        'INSURANCE ADMINISTRATORS OF AMERICA',
        'NALC/CIGNA',
        'PRIORITY HEALTH',
        'S&S HEALTH',
        'ALLEGIANCE',
        'MEDICAL MUTUAL',
        'PHCS SAVILITY',
        'ADVANCE BENEFIT MANAGEMENT SYSTEMS'
    };
    
    // Define a set of unique payer names mapped to 'Government'
    Set<String> governmentPayers = new Set<String>{
        '1199 NATIONAL BENEFIT FUND',
        'CHAMP VA',
        'Division of Federal Employees Comp',
        'GEHA',
        'GEHA-ASA',
        'NALC HEALTH BENEFIT PLAN',
        'NATIONAL ELEVATOR INDUSTRY',
        'TRICARE EAST',
        'TRICARE FOR LIFE',
        'VA CCN OPTUM',
        'Government Employees Health Assoc',
        'MCA SEDGWICK WTC HEALTH PROGRAM'
    };

    // Define a set of unique payer names mapped to 'Cash Pay'
    Set<String> cashPayPayers = new Set<String>{
        'SELF PAY'
    };
    // Define a set of unique payer names mapped to 'Blue Cross Blue Shield'
    Set<String> blueCrossPayers = new Set<String>{
        'HORIZON BCBS OF NEW JERSEY BLUECARD',
        'NORTHERN NEW JERSEY TEAMSTERS',
        'HORIZON BCBS OF NEW JERSEY',
        'HORIZON BCBS OF NEW JERSEY FEP',
        'HORIZON BCBS OF NJ',
        'HORIZON NJ TOTAL CARE HMO',
        'INDEPENDENCE ADMINISTRATORS'
    };

    // Define a set of unique payer names mapped to 'Auto Insurance'
    Set<String> autoInsurancePayers = new Set<String>{
        'AAA',
        'AAA MID-ATLANTIC INSURANCE GROUP',
        'ACCURO SOLUTIONS',
        'AIS',
        'ALLSTATE',
        'ALLSTATE GROUP CLAIMS',
        'ALLSTATE INSURANCE CO',
        'American Family Insurance',
        'AMERICAN MODERN INSURANCE',
        'AMERICAN TRANSIT INSURANCE COMPANY',
        'AMERITRUST',
        'AMICA INSURANCE',
        'BLUE STAR CLAIMS MANAGEMENT',
        'BRISTOL WEST',
        'CALIFORNIA CASUALTY AUTO CLAIMS',
        'CSAA',
        'CURE AUTO INSURANCE',
        'DIRECT GENERAL INSURANCE',
        'ELECTRIC INSURANCE CO',
        'ESURANCE',
        'FARMERS',
        'FARMERS INSURANCE',
        'GEICO',
        'GENEX',
        'GOOD 2 GO',
        'GOOD TO GO',
        'HANOVER MEDICAL CLAIMS',
        'HEREFORD INSURANCE COMPANY',
        'INTACT ACCIDENT & HEALTH',
        'LIBERTY MUTUAL',
        'MED LOGIX',
        'MERCURY INSURANCE',
        'METROMILE',
        'National General Accident & Health',
        'NATIONAL GENERAL INSURANCE',
        'NATIONAL LIABILITY & FIRE INSURANCE',
        'NATIONWIDE',
        'NATIONWIDE INSURANCE',
        'NEW JERSEY MANUFACTURE',
        'NJ PLIGA',
        'PENN NATIONAL CLAIMS',
        'PLYMOUTH ROCK ASSURANCE',
        'PRIZM',
        'PROGRESSIVE',
        'PROGRESSIVE AUTO INSURANCE',
        'PROGRESSIVE CLAIMS',
        'RENTAL CLAIM SERVICES',
        'SAFETY INC',
        'SELECTIVE',
        'SELECTIVE AUTO INSURANCE OF AMERICA',
        'STATE FARM',
        'STATE FARM CLAIMS',
        'TOKIO MARINE INSURANCE',
        'TRAVELERS',
        'TRAVELERS AUTO INSURANCE',
        'Travelers Insurance',
        'USAA',
        'USAA AUTO INSURANCE',
        'ZURICH AMERICAN INSURANCE COMPANY',
        'ZURICH NORTH AMERICA',
        'THE GENERAL INSURANCE',
        'THE HARTFORD GROUP',
        'AMERICAN AUTOMBILE'
    };

    // Define a set of unique payer names mapped to 'Aetna'
    Set<String> aetnaPayers = new Set<String>{
        'AETNA',
        'AETNA U.S. HEALTHCARE',
        'AITHER HEALTH',
        'ALLIED BENEFIT SYSTEMS  INC',
        'ALLIED BENEFIT SYSTEMS LLC',
        'ALLIED BENEFIT SYSTEMS INC',
        'GRAVIE ADMINISTRATIVE SERVICES',
        'MARPAI HEALTH',
        'MERITAIN HEALTH'
    };

    // Loop through the records in the trigger context
    for (Applied_Payments__c record : Trigger.new) {
        if (record.Payer__c != null) {
            // Check if the payer name exists in the Workers Compensation set 
            if (workersCompensationPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Workers Compensation';
            }
            // Check if the payer name exists in the Out of State set 
            else if (outOfStatePayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Out of State';
            }
            // Check if the payer name exists in the United HealthCare set 
            else if (unitedHealthCarePayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'United HealthCare';
            }
            // Check if the payer name exists in the Medicare Replacement Plan set 
            else if (medicareReplacementPlanSet.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Medicare Replacement Plan';
            }
            // Check if the payer name exists in the Miscellaneous set 
            else if (miscellaneousSet.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Miscellaneous';
            }
            // Check if the payer name exists in the Humana set
            else if (humanaPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Humana';
            }
            // Check if the payer name exists in the Medicaid set
            else if (medicaidPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Medicaid';
            } 
            // Check if the payer name exists in the Medicare / Supplement set
            else if (medicareSupplementPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Medicare / Supplement';
            }
            // Check if the payer name exists in the Cigna set
            else if (cignaPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Cigna';
            }
            // Check if the payer name exists in the Government set
            else if (governmentPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Government';
            }
            // Check if the payer name exists in the Cash Pay set
            else if(cashPayPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Cash Pay';
            }
            // Check if the payer name exists in the Blue Cross Blue Shield set
            else if (blueCrossPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Blue Cross Blue Shield';
            }
            // Check if the payer name exists in the Auto Insurance set
            else if (autoInsurancePayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Auto Insurance';
            }
            // Check if the payer name exists in the Aetna set
            else if (aetnaPayers.contains(record.Payer__c)) {
                record.Financial_Class__c = 'Aetna';
            }
        }
    }
}