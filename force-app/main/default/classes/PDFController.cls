public with sharing class PDFController {
    @AuraEnabled(cacheable=false)
    public static String getPdfBase64() {

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        // Call your VF page through Named Credential
        req.setEndpoint('https://allianceortho--stage--c.sandbox.vf.force.com/apex/TestPdfPage');
        req.setMethod('GET');
        req.setTimeout(60000);
        req.setHeader('Accept', 'application/pdf');

        HttpResponse res = h.send(req);

        // If page returned an error (HTML), catch it
        if (res.getStatusCode() != 200) {
            throw new AuraHandledException(
                'Failed to generate PDF. Status: ' + res.getStatus() + 
                ' Body: ' + res.getBody()
            );
        }

        return EncodingUtil.base64Encode(res.getBodyAsBlob());
    }
}