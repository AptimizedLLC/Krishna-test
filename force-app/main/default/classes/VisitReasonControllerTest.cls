@isTest
public class VisitReasonControllerTest {

    @isTest
    static void testVisitReasonController_NoReasonsSelected() {
        // Create and insert a test Account
        Account testAccount = new Account(Name = 'Test Patient');
        insert testAccount;

        // Set up the StandardController and the VisitReasonController
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        VisitReasonController controller = new VisitReasonController(sc);

        // Call the method without selecting any reasons
        PageReference result = controller.generatePDF();

        // Verify that an error message is added
        System.assertEquals(null, result, 'Expected null result when no reasons are selected');
        System.assertEquals(1, ApexPages.getMessages().size(), 'An error message should be added');
        System.assertEquals('Please select at least one Visit Reason before generating the PDF.',
                            ApexPages.getMessages()[0].getSummary());
    }

    @isTest
    static void testVisitReasonController_InvalidReasons() {
        // Create and insert test data
        Account testAccount = new Account(Name = 'Test Patient');
        insert testAccount;

        // Set up the StandardController and the VisitReasonController
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        VisitReasonController controller = new VisitReasonController(sc);

        // Set selectedReasons to invalid values
        controller.selectedReasons = 'INVALID_REASON';

        // Call the method
        PageReference result = controller.generatePDF();

        // Verify that an error message is added for invalid reasons
        System.assertEquals(null, result, 'Expected null result when invalid reasons are selected');
        System.assertEquals(1, ApexPages.getMessages().size(), 'An error message should be added');
        System.assert(ApexPages.getMessages()[0].getSummary().contains('The following Visit Reasons have no appointments with Flowsheet Approval: INVALID_REASON'),
                      'Error message should include the invalid reason');
    }

    @isTest
    static void testVisitReasonController_ValidReasons() {
        // Create and insert test data
        Account testAccount = new Account(Name = 'Test Patient');
        insert testAccount;

        Appointment__c appt = new Appointment__c(
            Patient__c = testAccount.Id,
            Visit_Reason__c = 'CHIRO',
            Flowsheet_Approved__c = true
        );
        insert appt;

        // Set up the StandardController and the VisitReasonController
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        VisitReasonController controller = new VisitReasonController(sc);

        // Set selectedReasons to valid values
        controller.selectedReasons = 'CHIRO';

        // Call the method
        PageReference result = controller.generatePDF();

        // Verify that no error message is added and the PageReference is returned
        System.assertNotEquals(null, result, 'Expected a valid PageReference for valid reasons');
        System.assertEquals(0, ApexPages.getMessages().size(), 'No error messages should be added for valid reasons');
        //System.assert(result.getUrl().contains('DownloadFlowSheetPDF'), 'The URL should redirect to the PDF page');
        System.assert(result.getParameters().get('accountId') == testAccount.Id, 'The accountId parameter should match');
        System.assert(result.getParameters().get('selectedReasons') == 'CHIRO', 'The selectedReasons parameter should match');
    }

    @isTest
    static void testVisitReasonController_MultipleReasonsWithInvalid() {
        // Create and insert test data
        Account testAccount = new Account(Name = 'Test Patient');
        insert testAccount;

        Appointment__c appt = new Appointment__c(
            Patient__c = testAccount.Id,
            Visit_Reason__c = 'PT',
            Flowsheet_Approved__c = true
        );
        insert appt;

        // Set up the StandardController and the VisitReasonController
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        VisitReasonController controller = new VisitReasonController(sc);

        // Set selectedReasons to include both valid and invalid values
        controller.selectedReasons = 'PT,INVALID_REASON';

        // Call the method
        PageReference result = controller.generatePDF();

        // Verify that an error message is added for the invalid reason
        System.assertEquals(null, result, 'Expected null result when invalid reasons are included');
        System.assertEquals(1, ApexPages.getMessages().size(), 'An error message should be added');
        System.assert(ApexPages.getMessages()[0].getSummary().contains('The following Visit Reasons have no appointments with Flowsheet Approval: INVALID_REASON'),
                      'Error message should include the invalid reason');
    }
}