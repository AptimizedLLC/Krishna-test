@isTest
public class NppCareCloudBatchableTest {

    @isTest
    static void testNppCareCloudBatchable() {
        // Test setup
        String nppId = createTestNpp();
        Id contentDocumentId = createTestContentDocument();
        createTestContentDocumentLink(nppId, contentDocumentId);
        Carecloud_Setup__mdt careCloudMdt = getTestCareCloudMetadata();

        // Mocking the HTTP callout
        Test.setMock(HttpCalloutMock.class, new CareCloudMock());

        // Start the test
        Test.startTest();
        NppCareCloudBatchable batch = new NppCareCloudBatchable(nppId);
        Database.executeBatch(batch);
        Test.stopTest();

        // Assertions (if applicable)
    }

    private static String createTestNpp() {
        Npp__c npp = new Npp__c(Name = 'Test NPP');
        insert npp;
        return npp.Id;
    }

    private static Id createTestContentDocument() {
        ContentVersion contentVersion = new ContentVersion(
            Title = 'TestDocument',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test content')
        );
        insert contentVersion;

        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        return insertedVersion.ContentDocumentId;
    }

    private static void createTestContentDocumentLink(String nppId, Id contentDocumentId) {
        ContentDocumentLink contentDocLink = new ContentDocumentLink(
            LinkedEntityId = nppId,
            ContentDocumentId = contentDocumentId,
            ShareType = 'V'
        );
        insert contentDocLink;
    }

    private static Carecloud_Setup__mdt getTestCareCloudMetadata() {
        return [SELECT MasterLabel, Refresh_Token__c, Breeze_ID__c FROM Carecloud_Setup__mdt LIMIT 1];
    }

    private class CareCloudMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{\"success\": true}');
            res.setStatusCode(200);
            return res;
        }
    }
}