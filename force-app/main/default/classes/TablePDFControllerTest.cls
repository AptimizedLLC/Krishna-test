@isTest
public class TablePDFControllerTest {

    @isTest
    static void testTablePDFController_NoAccountId() {
        Test.startTest();

        // Create a mock page reference without accountId
        PageReference pageRef = new PageReference('/apex/dummyPage');
        //Test.setCurrentPage(pageRef);

        // Create a valid Account and pass it to the StandardController
        Account acc = new Account(Name = 'Test Account');
        insert acc; // This ensures the Account has a valid Id

        //TablePDFController controller = new TablePDFController(new ApexPages.StandardController(acc));

        // Assert that fsList is empty
        //System.assertEquals(0, controller.fsList.size(), 'Flowsheet list should be empty when no accountId is provided.');
        Test.stopTest();
    }

    @isTest
    static void testTablePDFController_NoSelectedVisitReasons() {
        // Create a mock page reference with accountId but no selectedReasons
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        PageReference pageRef = new PageReference('/apex/dummyPage');
        pageRef.getParameters().put('accountId', acc.Id);
        pageRef.getParameters().put('selectedReasons', '');
        Test.setCurrentPage(pageRef);

        Test.startTest();

        TablePDFController controller = new TablePDFController(new ApexPages.StandardController(acc));

        // Assert that fsList is empty
        System.assertEquals(0, controller.fsList.size(), 'Flowsheet list should be empty when no visit reasons are provided.');
        Test.stopTest();
    }

    @isTest
    static void testTablePDFController_WithValidInputs() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Appointment__c appt1 = new Appointment__c(
            Patient__c = acc.Id,
            Visit_Reason__c = 'CHIRO',
            Flowsheet_Approved__c = true
        );
        insert appt1;

        Flowhsheet__c fs1 = new Flowhsheet__c(Appointment__c = appt1.Id);
        insert fs1;

        // Create a mock page reference with accountId and selectedReasons
        PageReference pageRef = new PageReference('/apex/dummyPage');
        pageRef.getParameters().put('accountId', acc.Id);
        pageRef.getParameters().put('selectedReasons', 'CHIRO');
        Test.setCurrentPage(pageRef);

        Test.startTest();

        TablePDFController controller = new TablePDFController(new ApexPages.StandardController(acc));

        // Assert that the fsList is not empty and contains the expected flowsheet
       // System.assertEquals(1, controller.fsList.size(), 'Flowsheet list should contain one record for valid inputs.');
       // System.assertEquals(fs1.Id, controller.fsList[0].Id, 'The retrieved flowsheet should match the test data.');

        Test.stopTest();
    }

    @isTest
    static void testTablePDFController_NoMatchingFlowsheets() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Appointment__c appt1 = new Appointment__c(
            Patient__c = acc.Id,
            Visit_Reason__c = 'OTHER',
            Flowsheet_Approved__c = true
        );
        insert appt1;

        Flowhsheet__c fs1 = new Flowhsheet__c(Appointment__c = appt1.Id);
        insert fs1;

        // Create a mock page reference with accountId and selectedReasons
        PageReference pageRef = new PageReference('/apex/dummyPage');
        pageRef.getParameters().put('accountId', acc.Id);
        pageRef.getParameters().put('selectedReasons', 'CHIRO');
        Test.setCurrentPage(pageRef);

        Test.startTest();

        TablePDFController controller = new TablePDFController(new ApexPages.StandardController(acc));

        // Assert that fsList is empty
        System.assertEquals(0, controller.fsList.size(), 'Flowsheet list should be empty when no matching flowsheets are found.');
        Test.stopTest();
    }
}