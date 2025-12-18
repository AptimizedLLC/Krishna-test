public class CareCloudAuthConnection extends HttpFormDataBuilder{
    private final static String ENP_POINT_URL = 'https://api.carecloud.com/oauth2/access_token';
    private final static Integer MAX_RETRY = 3;
    
    @InvocableMethod( label='Create CareCloud Patient' description='Create Patient in CareCloud System' category='Callout' )
    public static void getTitle(List<Id> leadIds) {
        createPatientInCareCloud(leadIds[0]);        
    }
    
    @future( callout=true )
    public static void createPatientInCareCloud(Id leadId) {
        System.debug('::: Lead Id = '+leadId);
        String relAccId;
        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        String accessToken = fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);

        Lead ldRec = [SELECT Id, ConvertedAccountId, LastName, FirstName, Email, Lead_Date_of_Birth__c, Gender__c, Phone, Street, City, State, PostalCode , Country FROM Lead WHERE Id=: leadId LIMIT 1];
        relAccId = ldRec.ConvertedAccountId;
        String firstName = ldRec.FirstName.replace('"', '');
        String lastName = ldRec.LastName.replace('"', '');
        String emailId = ldRec.Email == null ? '' : ldRec.Email;
        String phone = ldRec.Phone;
        String street = ldRec.Street.replace('"', '');
        String city = ldRec.City.replace('"', '');
        String state = ldRec.State.replace('"', '');
        String postalCode = ldRec.PostalCode;
         //Get State FIPS Code Mapping from Metadata
         String stateCode;
        CareCloud_State_FIPS_Code__mdt stateFIPS = [SELECT Id, State_Abbreviation__c, FIPS_Code__c FROM CareCloud_State_FIPS_Code__mdt where State_Abbreviation__c=:state LIMIT 1];
        if(stateFIPS != null) {
            stateCode = stateFIPS.FIPS_Code__c;
        } else {
            stateCode = '12';
        }
        String genderCode;
        if(ldRec.Gender__c == 'Male') {
            genderCode = 'male';
        } else if(ldRec.Gender__c == 'Female') {
            genderCode = 'female';
        } else {
            genderCode = 'unknown';
        }
        String dateofbirth = String.valueOf(ldRec.Lead_Date_of_Birth__c).removeEnd(' 00:00:00'); 
            
        String endPoint = 'https://api.carecloud.com/v2/patients';
        String jsonStr = '{"patient":{"first_name":"'+firstName+'","last_name":"'+lastName+'","email": "'+emailId+'","gender_code":"'+genderCode+'","date_of_birth":"'+dateofbirth+'"},"addresses":[{"line1":"'+street+'","line2":"","city":"'+city+'","state":"'+state+'","zip_code":"'+postalCode+'","country_name":"USA","is_primary":true}],"phones":[{"phone_number":"'+phone+'","phone_type_code":"C","extension":"+1","is_primary":true}]}';
        System.debug('::: Patient JSON = '+jsonStr);

        HttpRequest httpReq = new HttpRequest();
        httpReq.setHeader('Authorization','Bearer ' + accessToken);
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('accept','application/json');
        httpReq.setBody(jsonstr);
        httpReq.setMethod('POST');
        httpReq.setEndpoint(endPoint);
        httpReq.setTimeout(120000);
        HttpResponse httpRes;
        
        // make call
        makeRetriableCallout(httpReq, relAccId, leadId, 0);
        
    }
    
    public static void makeRetriableCallout(HttpRequest req, String relAccId, String leadId, Integer retryCount) {
        if (req == null) {
            return;
        }
        String getTokenEndpoint = 'https://api.carecloud.com/oauth2/access_token';
        HttpResponse httpRes;
        String errorMessage ='';
        try {
            Http http = new Http();
            // make call
            httpRes = http.send(req);
            System.debug('::: Response Body = '+httpRes.getBody());
            
            if(httpRes.getStatusCode() == 201){
                
                PatientResponse response = (PatientResponse)JSON.deserialize(httpRes.getBody(), PatientResponse.class);
                System.debug('::: Response PatientId = '+response.patient);
                String patientId = response.patient;
                Account perAcc = [SELECT Id, CareCloud_Patient_Id__c FROM Account where Id=: relAccId LIMIT 1];
                perAcc.CareCloud_Patient_Id__c =  patientId;
                update perAcc; 
            }else{
                if (retryCount < MAX_RETRY) {
                    system.debug('Retrying:' + retryCount);
                    // call recursively
                     makeRetriableCallout(req, relAccId, leadId, ++retryCount);
                } else {
                    String pException = 'Unexpected Error with CareCloud API'+'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                    system.debug('::: Something failed in CareCloud - '+pException);
                    String custMsg = 'Create Patient Failed for Lead Id - '+leadId ;
                    TransactionLogHandler.doHandleCustomException(pException, custMsg, 'CareCloudAuthConnection', 'createPatientInCareCloud');   
                }
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint'
                    +'Goto Remote Site Setting and add '+' '+ getTokenEndpoint +' Endpoint';
                system.debug( errorMessage);
            }else{
                errorMessage = 'Unexpected Error: '+e.getMessage()+' at line '+e.getLineNumber();
                system.debug(errorMessage);
            }
            String custMsg = 'Create Patient Failed for Lead Id - '+leadId ;
            TransactionLogHandler.doHandleCustomException(errorMessage, custMsg, 'CareCloudAuthConnection', 'createPatientInCareCloud');
        }
    }
    
    public static String fetchRefreshAccessToken(String refreshToken) {
        try {
            Carecloud_Setup__mdt apiConfig = Carecloud_Setup__mdt.getInstance('Care_Cloud');
            
            if(apiConfig != null){
                String ACCESS_TOKEN;
                String REFRESH_TOKEN = refreshToken; //'pSdjOpyOvWOyMC7y8y2KmrLFrnJBzbb-';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(ENP_POINT_URL);
                req.setMethod('POST');    
                Blob headerValue = Blob.valueOf(apiConfig.Consumer_Key__c + ':' + apiConfig.Consumer_Secret__c);
                String authorizationHeader = EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                
                String requestBody = 'grant_type=refresh_token'+'&refresh_token='+REFRESH_TOKEN;
                //System.debug('::: Refresh Request Body = '+requestBody);
                req.setBody(requestBody);
                req.setTimeout(60000);
                Http http = new Http();
                HttpResponse res = http.send(req);
                RefreshTokenResponse objAuthenticationInfo = (RefreshTokenResponse)JSON.deserialize(res.getbody(), RefreshTokenResponse.class);
                System.debug('::: Token  Details, Access Token - '+objAuthenticationInfo.access_token+' , Expires In - '+objAuthenticationInfo.expires_in+' and Type - '+objAuthenticationInfo.type);
                return objAuthenticationInfo.access_token;
            }
            return null;
        } catch(Exception ex) {
            System.debug('::: Exception ex = '+ex.getMessage());
            return null;
        }
    }
    
    @future(callout=true)
    public static void uploadPatientDocumentAsync(String intakeId) {
        uploadPatientDocument(intakeId);
    }
    
    public static void uploadPatientDocument(String intakeId) {
        Blob fileBody;
        String fileName; // name
        String formatType; //pdf or image
        Carecloud_Setup__mdt CareCloudMdt = [Select MasterLabel, Refresh_Token__c FROM Carecloud_Setup__mdt LIMIT 1];
        String accessToken = CareCloudAuthConnection.fetchRefreshAccessToken(CareCloudMdt.Refresh_Token__c);
        System.debug('::: Access Toekn - '+accessToken);
        
        try {
            Opportunity oppRec = [SELECT Id, AccountId , Account.CareCloud_Patient_Id__c  FROM Opportunity where Id=:intakeId];
            //String patientId = '572253a3-4963-4d55-81f0-5082b422c96e';
            String patientId = oppRec.Account.CareCloud_Patient_Id__c;
            
            List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: intakeId]; //0063I000007vXaIQAU
            ContentVersion contentData = [SELECT Id, Title, FileExtension, ContentDocumentId, VersionData FROM ContentVersion where ContentDocumentId=: ContentDocumentLinks[0].ContentDocumentId LIMIT 1];
            fileName = contentData.Title.replaceAll(' ','');
            fileName = fileName.replaceAll('[^a-zA-Z0-9 -]', '');
            fileName = fileName.replaceAll('-','');
            
            formatType = contentData.FileExtension;
            
            String metadataStr = '{"document":{"name":"'+fileName+'","description":"Uploaded from Salesforce Integration", "format":"'+formatType+'","source":"18138"}}';
            fileBody = contentData.VersionData;
            
            
            String endPoint = 'https://api.carecloud.com/v1/documents/patient/'+patientId+'/upload';
            
            Blob formData = build(metadataStr, EncodingUtil.base64Encode(fileBody));
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization','Bearer ' + accessToken);
            req.setHeader('Content-Type','multipart/form-data; boundary='+getBoundary());
            req.setHeader('Content-Transfer-Encoding','binary');
            req.setMethod('POST');
            req.setEndpoint(endPoint);
            req.setBodyAsBlob(formData);
            req.setTimeout(120000);
            
            Http http = new Http();
            if(!Test.isRunningTest()) {
                HTTPResponse res = http.send(req);
            } else {
                HTTPResponse res = new HTTPResponse();
            }
            
        } catch(Exception ex) {
            System.debug('Exception in CareCloudAuthConnection - '+ex.getMessage());
            String custMsg = 'Intake error Id - '+intakeId ;
            TransactionLogHandler.doHandleCustomException(ex, custMsg, 'CareCloudAuthConnection', 'uploadPatientDocument');
        }
    }
    
    public static Blob build(String mdata, String data) {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('metadata', mdata);
        body += WriteBoundary();
        body += WriteBlobBodyParameter('payload', data, 'Patient_doc.pdf');
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }
    
    public class RefreshTokenResponse {
        public String access_token{get;set;}
        public String expires_in{get;set;}
        public String type{get;set;}
    }
        
    public class PatientResponse {
        public String patient;
    }
    
    
}