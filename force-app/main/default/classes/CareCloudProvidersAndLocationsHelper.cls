public class CareCloudProvidersAndLocationsHelper implements Queueable, Database.AllowsCallouts {
    Private Static String BASE_ENDPOINT = 'https://api.carecloud.com/v2';
    Private boolean byPassBatch;
    
    public CareCloudProvidersAndLocationsHelper(Boolean byPassBatch){
        this.byPassBatch = byPassBatch;
    }
    
    public void execute(QueueableContext context) {       
        if(String.isNotBlank(CareCloudAPIHelper.accessToken)){
            List<CareCloud_Information__c> careCloudInfo = new List<CareCloud_Information__c>();
            
            for(CareCloudWrapperClasses.ProvidersWrapper_provider provider : fetchProviders()){
                careCloudInfo.add(new CareCloud_Information__c(
                	CareCloud_Id__c = 'P-'+provider.id,
                    Specialty__c = provider.speciality?.name,
                    Name = provider.name,
                    RecordTypeId =  Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Provider').getRecordTypeId()
                ));
            }
            
            for(CareCloudWrapperClasses.LocationsWrapper_location location : fetchLocations()){
                careCloudInfo.add(new CareCloud_Information__c(
                	CareCloud_Id__c = 'L-'+location.id,
                    Name = location.name,
                    RecordTypeId =  Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Location').getRecordTypeId()
                ));
            }
            
            for(CareCloudWrapperClasses.VisitReasonsWrapper visitreason : fetchVisitReasons()){
                careCloudInfo.add(new CareCloud_Information__c(
                	CareCloud_Id__c = 'VR-'+ visitreason.id,
                    Name = visitreason.name,
                    RecordTypeId =  Schema.SObjectType.CareCloud_Information__c.getRecordTypeInfosByName().get('Visit Reason').getRecordTypeId()
                ));
            }
            
            if(!careCloudInfo.isEmpty()){
                upsert careCloudInfo CareCloud_Id__c;
            }
        }
    }
    
    private List<CareCloudWrapperClasses.ProvidersWrapper_provider> fetchProviders(){
        HttpResponse resp = CalloutUtility.doCallout(BASE_ENDPOINT+'/providers', 'GET', new map<string,string>{'Authorization' => 'Bearer ' + CareCloudAPIHelper.accessToken}, '', 120000);
        CareCloudWrapperClasses.ProvidersWrapper providerResp = (CareCloudWrapperClasses.ProvidersWrapper) System.JSON.deserialize(resp.getBody(), CareCloudWrapperClasses.ProvidersWrapper.class);
        return providerResp.providers;
    }
    
    private List<CareCloudWrapperClasses.LocationsWrapper_location> fetchLocations(){
        HttpResponse resp = CalloutUtility.doCallout(BASE_ENDPOINT+'/locations?all_public=true', 'GET', new map<string,string>{'Authorization' => 'Bearer ' + CareCloudAPIHelper.accessToken}, '', 120000);
        CareCloudWrapperClasses.LocationsWrapper locationResp = (CareCloudWrapperClasses.LocationsWrapper) System.JSON.deserialize(resp.getBody(), CareCloudWrapperClasses.LocationsWrapper.class);
        return locationResp.locations;
    }
    
     private List<CareCloudWrapperClasses.VisitReasonsWrapper> fetchVisitReasons(){
        HttpResponse resp = CalloutUtility.doCallout(BASE_ENDPOINT+'/visit_reasons?request_types_only=false', 'GET', new map<string,string>{'Authorization' => 'Bearer ' + CareCloudAPIHelper.accessToken}, '', 120000);
        return (List<CareCloudWrapperClasses.VisitReasonsWrapper>) System.JSON.deserialize(resp.getBody(), List<CareCloudWrapperClasses.VisitReasonsWrapper>.class);
    }
}