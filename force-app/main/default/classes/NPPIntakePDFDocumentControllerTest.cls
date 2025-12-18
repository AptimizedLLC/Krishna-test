@isTest
public class NPPIntakePDFDocumentControllerTest {
    
    @isTest
    static void testGenerateNPPIntakePDFController() {
        // 1️⃣ Create a test NPP__c record
        NPP__c nppRec = new NPP__c(
            Name = 'Test NPP',
            HQ_Sign_Id__c = '068U8000001CFM5IAO',  // fake ContentVersion Id
            HQ_Patient_Name__c = 'John Doe',
            HQ_Date__c = Date.today(),
            HQ_Appointment_Scheduled__c = Date.today(),
            HQ_Paperwork_Status__c = 'Complete'
        );
        insert nppRec;

        // 2️⃣ Create a PageReference and set parameters (simulate Visualforce page)
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/GenerateNPPIntakePDFDocument');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', nppRec.Id);
        ApexPages.currentPage().getParameters().put('appid', 'a1B000000123XYZ');

        // 3️⃣ Create a standard controller for the NPP record
        ApexPages.StandardController sc = new ApexPages.StandardController(nppRec);

        // 4️⃣ Instantiate your custom controller
        GenerateNPPIntakePDFDocumentController controller = new GenerateNPPIntakePDFDocumentController(sc);

        Test.stopTest();
    }
}