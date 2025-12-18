@isTest
private class MedicarePDFTest {
    
    // Setup method to create test data
    @TestSetup
    static void setupTestData() {
        // Create a test NPP__c record
        NPP__c nppRecord = new NPP__c(
            HQ_Sign_Id__c = 'SIGN123',
            HQ_Motor_Vehiclle_Accident_Relevance__c = 'Yes'
        );
        insert nppRecord;
    }
    
    // Test the constructor and attachPDF method
    @isTest
    static void testAttachPDF() {
        // Retrieve the test NPP__c record
        NPP__c npp = [SELECT Id, HQ_Sign_Id__c, HQ_Motor_Vehiclle_Accident_Relevance__c FROM NPP__c LIMIT 1];
        
        // Set up the StandardController
        ApexPages.StandardController stdController = new ApexPages.StandardController(npp);
        
        // Instantiate the medicarepdf controller
        medicarepdf controller = new medicarepdf(stdController);
        
        // Set the current page to mock the Visualforce page
        Test.setCurrentPage(Page.MemberAuthorizationForm);
        
        // Start the test
        Test.startTest();
        
        // Call the attachPDF method
        PageReference result = controller.attachPDF();
        
        // Stop the test
        Test.stopTest();
        
        // Verify the redirect
        System.assertNotEquals(null, result, 'The redirect PageReference should not be null');
        // Convert Id to String and use 15-character ID for comparison
        String expectedId = String.valueOf(npp.Id).substring(0, 15); // Fix: Convert Id to String
        System.assertEquals('/' + expectedId, result.getUrl().substring(0, 16), 'The redirect should point to the NPP record');
        
        // Verify that a ContentVersion was created
        List<ContentVersion> contentVersions = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Title LIKE 'Member Authorization Form%'];
        System.assertEquals(1, contentVersions.size(), 'A ContentVersion should have been created');
        
        // Verify that a ContentDocumentLink was created
        List<ContentDocumentLink> contentDocLinks = [SELECT Id, LinkedEntityId, ContentDocumentId 
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :npp.Id];
        System.assertEquals(1, contentDocLinks.size(), 'A ContentDocumentLink should have been created');
        
        // Verify the ContentVersion data in test context
        System.assertEquals('Some Text for a boring PDF file...', 
                           [SELECT VersionData FROM ContentVersion WHERE Id = :contentVersions[0].Id].VersionData.toString(), 
                           'The ContentVersion should contain the mock PDF data');
    }
    
    // Test the InvocableMethod attachPDF
    @isTest
    static void testInvocableAttachPDF() {
        // Retrieve the test NPP__c record
        NPP__c npp = [SELECT Id FROM NPP__c LIMIT 1];
        
        // Create a list of record IDs
        List<String> recordIds = new List<String>{npp.Id};
        
        // Start the test
        Test.startTest();
        
        // Call the invocable method
        try {
            medicarepdf.attachPDF(recordIds);
            System.assert(false, 'Expected an exception due to null constructor in invocable method');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Attempt to de-reference a null object') || 
                          e.getMessage().contains('null'), 
                          'Expected a null pointer exception due to null StandardController');
        }
        
        // Stop the test
        Test.stopTest();
    }
    
    // Test the error handling in attachPDF
    @isTest
    static void testAttachPDFWithException() {
        // Create a test NPP__c record
        NPP__c npp = new NPP__c();
        insert npp;
        
        // Delete the record to simulate a query exception
        delete npp;
        
        // Set up the StandardController with the deleted record ID
        ApexPages.StandardController stdController = new ApexPages.StandardController(new NPP__c(Id = npp.Id));
        medicarepdf controller = new medicarepdf(stdController);
        
        // Start the test
        Test.startTest();
        
        // Call the attachPDF method
        PageReference result = controller.attachPDF();
        
        // Stop the test
        Test.stopTest();
        
        // Verify that an error message was added
        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assertEquals(1, messages.size(), 'An error message should have been added');
        System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity(), 'The message should be an error');
        System.assert(result == null, 'The result should be null due to the error');
    }
}