public class CareCloudAPIHelper {
    private static final String END_POINT = 'https://api.carecloud.com';
    
    public static String accessToken{
        get{
            if(accessToken == null){
                Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        		accessToken = CareCloudMdt != null ? CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c) : null;
            }
            
            return accessToken;
        }
        set;
    }
    
    public static Integer getTotalPages(String linksInfo){
        String lastPageLink = linksInfo.substringBetween('<', '>; rel="last"');
        PageReference url = new PageReference(lastPageLink);
        return Integer.valueOf(url.getParameters().get('page'));
    }
    
    public static HTTPResponse fetchApointments(String startDate, String endDate, String pageNo){
        system.debug(accessToken);
        return CalloutUtility.doCallout(END_POINT+'/v2/appointments?end_date='+endDate+'&start_date='+startDate+'&page='+pageNo, 'GET', new Map<String, String>{'Authorization' => 'Bearer ' + accessToken}, '', 20000);
    }

    public static boolean isValidAppointment(String appointmentId, String accessToken){
        HTTPResponse resp = CalloutUtility.doCallout('https://api.carecloud.com/v2/appointments/'+appointmentId, 'GET', new map<string, string>{'Authorization' => 'Bearer ' + accessToken}, '', 120000);
        return resp.getStatusCode() == 200;
    }
}