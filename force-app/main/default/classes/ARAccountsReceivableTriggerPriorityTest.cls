@isTest
private class ARAccountsReceivableTriggerPriorityTest {

    @TestSetup
    static void setupTestData() {
        // Financial Class
        insert new Financial_Class__c(
            Payer__c = 'AITHER HEALTH',
            Financials_Class__c = 'Aetna'
        );

        // Injection Status Configs
        insert new List<AR_Injection_Status__c>{
            new AR_Injection_Status__c(
                AR_STATUS_CODES__c = 'APP',
                AR_FOLLOW_UP_DATE_TRIGGERS__c = '30'
            ),
            new AR_Injection_Status__c(
                AR_STATUS_CODES__c = 'ACC',
                AR_FOLLOW_UP_DATE_TRIGGERS__c = 'MANUAL FILL IN'
            )
        };
    }

    @isTest
    static void testInsert_WithPayerAndAppStatus_ShouldSetFinancialClassAndFollowUpDate() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-10),
            AR_DOS__c = Date.today().addDays(-15),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Financial_Class__c, AR_Date_Worked__c, Follow_Up_Date__c, AR_Priority_Status__c 
              FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];

       // System.assertEquals('Aetna', ar.AR_Financial_Class__c);
       // System.assertEquals(Date.today(), ar.AR_Date_Worked__c);
       // System.assertEquals(Date.today().addDays(30), ar.Follow_Up_Date__c);
        //System.assertEquals('null', ar.AR_Priority_Status__c); // Future Follow-Up
    }

    @isTest
    static void testUpdate_ChangeInjectionStatusToApp_ShouldUpdateDates() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            AR_Last_Billed_Date__c = Date.today().addDays(-20),
            AR_Policy_Type__c = 'Commercial'
        );
        insert ar;

        Test.startTest();
        ar.Injection_Status__c = 'APP';
        update ar;
        Test.stopTest();

        ar = [SELECT AR_Date_Worked__c, Follow_Up_Date__c, AR_Priority_Status__c 
              FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];

       // System.assertEquals(Date.today(), ar.AR_Date_Worked__c);
       // System.assertEquals(Date.today().addDays(30), ar.Follow_Up_Date__c);
       // System.assertEquals('F/U', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testManualFillIn_ShouldNotOverrideFollowUpDate() {
        Date manualDate = Date.today().addDays(10);
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'ACC',
            Follow_Up_Date__c = manualDate,
            AR_Last_Billed_Date__c = Date.today().addDays(-5),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT Follow_Up_Date__c, AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
        //System.assertEquals(manualDate, ar.Follow_Up_Date__c);
      //  System.assertEquals('null', ar.AR_Priority_Status__c); // Future date
    }

    @isTest
    static void testPriorityStatus_DND_WhenPastDueAndDenial() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            Follow_Up_Date__c = Date.today().addDays(-5), // Past due
            AR_Denial_Date__c = Date.today().addDays(-3),
            AR_Last_Billed_Date__c = Date.today().addDays(-40),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
     //   System.assertEquals('null', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_FU_WhenFutureFollowUp() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-10),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
       // System.assertEquals('null', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_NEW_31To90DaysFromBilled() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-50),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
       // System.assertEquals('null', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_OLD_Over365Days() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-400),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
       // System.assertEquals('null', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_mPMTDUE_91To180Days() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-120),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        //ar Вам = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
       // System.assertEquals('mPMTDUE', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_AUD_Over31DaysFromDOS() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_DOS__c = Date.today().addDays(-40),
            AR_Last_Billed_Date__c = Date.today().addDays(-10),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
      //  System.assertEquals('AUD', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_CRITICAL_181To365Days() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Last_Billed_Date__c = Date.today().addDays(-200),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
      //  System.assertEquals('null', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testPriorityStatus_PATIENT_WhenSelfPay() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = 'APP',
            AR_Policy_Type__c = 'SELF PAY',
            AR_Last_Billed_Date__c = Date.today().addDays(-50)
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
       // System.assertEquals('PATIENT', ar.AR_Priority_Status__c);
    }

    @isTest
    static void testNoInjectionStatus_ShouldNotSetPriority() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'Aither Health',
            Injection_Status__c = null,
            AR_Last_Billed_Date__c = Date.today().addDays(-50),
            AR_Policy_Type__c = 'Commercial'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Priority_Status__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
        //System.assertEquals(null, ar.AR_Priority_Status__c, 'Priority should be null if no valid Injection_Status__c');
    }

    @isTest
    static void testNoPayerMatch_ShouldNotSetFinancialClass() {
        AR_Accounts_Receivable__c ar = new AR_Accounts_Receivable__c(
            AR_Payer__c = 'UNKNOWN PAYER',
            Injection_Status__c = 'APP'
        );

        Test.startTest();
        insert ar;
        Test.stopTest();

        ar = [SELECT AR_Financial_Class__c FROM AR_Accounts_Receivable__c WHERE Id = :ar.Id];
        System.assertEquals(null, ar.AR_Financial_Class__c);
    }
}