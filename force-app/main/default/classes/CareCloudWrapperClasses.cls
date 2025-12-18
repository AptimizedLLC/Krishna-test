public class CareCloudWrapperClasses {
    //provider wrapper
    public class ProvidersWrapper{
        public list<ProvidersWrapper_provider> providers {get; set;}
    }
    public class ProvidersWrapper_provider{
        public string id {get; set;}
        public string name {get; set;}
        public ProvidersWrapper_provider_speciality speciality {get; set;}
    }
     public class ProvidersWrapper_provider_speciality{
        public string name {get; set;}
    }
    
    //location wrapper
    public class LocationsWrapper{
        public list<LocationsWrapper_location> locations {get; set;}
    }
    
    public class LocationsWrapper_location{
        public string id {get;set;}
        public string name {get;set;}
    }
    
    //visitReason wrapper
    public class VisitReasonsWrapper{
        public string id {get;set;}
        public string name {get;set;}
    }
}