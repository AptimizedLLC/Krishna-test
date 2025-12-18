@isTest
public class NppCareCloudBatchableHelperTest {
    
    @isTest
    static void testDocumentExistsInBreeze() {
        // Test setup
        String fileName = 'TestDocument';
        String formatType = 'pdf';
        String patientId = '12345';
        String accessToken = 'dummyAccessToken';

        // Mock CareCloud Metadata
        Carecloud_Setup__mdt careCloudMdt = new Carecloud_Setup__mdt(
            MasterLabel = 'CareCloud Config',
            Refresh_Token__c = 'dummy_refresh_token',
            Breeze_ID__c = 'dummy_breeze_id'
        );

        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(true));

        // Start the test
        Test.startTest();
        Boolean result = NppCareCloudBatchableHelper.documentExistsInBreeze(fileName, formatType, patientId, careCloudMdt, accessToken);
        Test.stopTest();

        // Assert the result
        System.assert(result, 'The document should exist as per the mocked response.');
    }

    @isTest
    static void testDocumentDoesNotExistInBreeze() {
        // Test setup
        String fileName = 'TestDocument';
        String formatType = 'pdf';
        String patientId = '12345';
        String accessToken = 'dummyAccessToken';

        // Mock CareCloud Metadata
        Carecloud_Setup__mdt careCloudMdt = new Carecloud_Setup__mdt(
            MasterLabel = 'CareCloud Config',
            Refresh_Token__c = 'dummy_refresh_token',
            Breeze_ID__c = 'dummy_breeze_id'
        );

        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(false));

        // Start the test
        Test.startTest();
        Boolean result = NppCareCloudBatchableHelper.documentExistsInBreeze(fileName, formatType, patientId, careCloudMdt, accessToken);
        Test.stopTest();

        // Assert the result
        System.assert(!result, 'The document should not exist as per the mocked response.');
    }

    @isTest
    static void testBuildMethod() {
        // Test setup
        String metadata = '{"key":"value"}';
        String data = 'TestPayloadData';

        // Call the build method
        Blob resultBlob = NppCareCloudBatchableHelper.build(metadata, EncodingUtil.base64Encode(Blob.valueOf(data)));

        // Assert the result
        System.assertNotEquals(null, resultBlob, 'The build method should return a non-null Blob.');
        System.assert(resultBlob.size() > 0, 'The result Blob should have a size greater than zero.');
    }

    // Mock HTTP Callout
    private class MockHttpResponse implements HttpCalloutMock {
        private Boolean documentExists;

        MockHttpResponse(Boolean documentExists) {
            this.documentExists = documentExists;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success":' + documentExists + '}');
            res.setStatusCode(200);
            return res;
        }
    }
}