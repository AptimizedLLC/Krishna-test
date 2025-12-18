@isTest
public class CareCloudProvidersAndLocationsHelperTest {    
    static testMethod void testFetchProvidersAndLocations(){
        SingleRequestMock fakeAccessTokenResp = new SingleRequestMock(200, 'Complete', '{"access_token": "test_access_token"}', null);
        SingleRequestMock fakeFetchProvidersResp = new SingleRequestMock(200, 'Complete', '{ "providers" : [{ "id" : "1234", "name" : "test", "speciality" : { "name" : "test"}}]}', null);
        SingleRequestMock fakeFetchLocationssResp = new SingleRequestMock(200, 'Complete', '{ "locations" : [{ "id" : "1234", "name" : "test"}]}', null);
        SingleRequestMock fakeFetchReasonsResp = new SingleRequestMock(200, 'Complete', '[{ "id" : "1234", "name" : "test"}]', null);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.carecloud.com/oauth2/access_token', fakeAccessTokenResp);
        endpoint2TestResp.put('https://api.carecloud.com/v2/providers', fakeFetchProvidersResp);
        endpoint2TestResp.put('https://api.carecloud.com/v2/locations?all_public=true', fakeFetchLocationssResp);
        endpoint2TestResp.put('https://api.carecloud.com/v2/visit_reasons?request_types_only=false', fakeFetchReasonsResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();
        system.enqueueJob(new CareCloudProvidersAndLocationsHelper(true));
        Test.stopTest();
        
        System.assertEquals(3, [SELECT Id from CareCloud_Information__c].size());
    }
}