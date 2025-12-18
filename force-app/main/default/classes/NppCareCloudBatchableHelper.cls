public class NppCareCloudBatchableHelper extends HttpFormDataBuilder{
public static Boolean documentExistsInBreeze(String fileName, String formatType, String patientId, Carecloud_Setup__mdt careCloudMdt, String accessToken) {
    String query = 'SELECT Id FROM Document WHERE Patient__c = \'' + patientId + '\' AND Format__c = \'' + formatType + '\' AND Name = \'' + fileName + '\'';
    String endpoint = 'https://api.carecloud.com/v1/documents/query';
    
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + accessToken);
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');
    req.setEndpoint(endpoint);
    req.setBody(query);
    
    Http http = new Http();
    HTTPResponse res = http.send(req);
    if (res.getStatusCode() == 200) {
        // Parse the response properly
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Boolean documentExists = (Boolean)jsonResponse.get('success');
        return documentExists != null && documentExists;
    }
    return false;
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
  
}