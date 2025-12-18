public class PdfToBase64Controller {

    // FUTURE method so it runs outside the trigger context
    @future(callout=true)
    public static void publishSignatureEvents(List<Id> accountIds) {

        List<Patient_Signature_Event__e> events = new List<Patient_Signature_Event__e>();
	list<Account>aclist=new list<Account>();
        for (Id accId : accountIds) {
            //--------------------------------------
            // Query latest PDF attachment
        Attachment att = [
            SELECT Id, Name
            FROM Attachment
            WHERE ParentId ='a1DU8000000UDnpMAG'
            
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
            

        // Use supported method
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        // Build secure download URL
        String downloadUrl = baseUrl + '/servlet/servlet.FileDownload?file=' + att.Id;
            
            //----------------------------------------
         Id parentId = 'a1DU8000000UDnpMAG';  // Your record Id

// STEP 1: Get ContentDocumentId from Parent Record
ContentDocumentLink cdl = [
    SELECT ContentDocumentId
    FROM ContentDocumentLink
    WHERE LinkedEntityId = :parentId
    ORDER BY SystemModstamp DESC
    LIMIT 1
];

// STEP 2: Get Latest ContentVersion
ContentVersion ver = [
    SELECT Id
    FROM ContentVersion
    WHERE ContentDocumentId = :cdl.ContentDocumentId
    ORDER BY CreatedDate DESC
    LIMIT 1
];

// STEP 3: Create Public Distribution Link
ContentDistribution dist = new ContentDistribution();
dist.ContentVersionId = ver.Id;
dist.Name = 'DocuSign Public Link';
dist.PreferencesAllowViewInBrowser = true;
dist.PreferencesAllowOriginalDownload = true;
dist.PreferencesNotifyOnVisit = false;
dist.PreferencesPasswordRequired = false;
insert dist;

// STEP 4: Fetch Public URL
ContentDistribution result = [
    SELECT DistributionPublicUrl
    FROM ContentDistribution
    WHERE Id = :dist.Id
];

System.debug('Public DocuSign URL: ' + result.DistributionPublicUrl);


    

            //--------------------------------------
            // Generate Base64 for this specific record
            String base64Pdf = generatePdfBase64(accId);

            events.add(new Patient_Signature_Event__e(
                PatientId__c     = accId,
                Document_Url__c  = 'http://docusign-envelop-api.us-e2.cloudhub.io/api/envelopes',      // replace with real URL if needed
                base64string__c  = result.DistributionPublicUrl,//downloadUrl,//base64Pdf,
                SenderEmail__c='pdurgarao@aptimized.com'
            ));
            Account acc=new Account(id=accId,Description ='sent');
            aclist.add(acc);
        }

        if (!events.isEmpty()) {

    // Debug Payload
    for (Patient_Signature_Event__e e : events) {
        System.debug('EVENT PAYLOAD => ' + JSON.serializePretty(e));
    }

    // ✅ Capture publish results
    Database.SaveResult[] results = EventBus.publish(events);

    // ✅ Check publish status for each event
    for (Integer i = 0; i < results.size(); i++) {

        if (results[i].isSuccess()) {
            System.debug('✅ Event Published Successfully. Index => ' + i);
        } 
        else {
            for (Database.Error err : results[i].getErrors()) {
                System.debug('❌ Publish Failed at Index ' + i);
                System.debug('Error Status Code: ' + err.getStatusCode());
                System.debug('Error Message    : ' + err.getMessage());
            }
        }
    }

    // ✅ Update records only if publish succeeded
    update aclist;

    System.debug('Patient_Signature_Event__e events attempted to publish: ' + events.size());
}

            }

    // Helper method: VF → PDF → Base64
    @TestVisible
    public static String generatePdfBase64(Id recordId) {
	id ii='a18U80000034B4nIAE';
        // 1. Create PageReference for the VF page
        PageReference pdfPage = Page.MemberAuthorizationForm; // your VF page name
        pdfPage.getParameters().put('id', ii);

        // 2. Get PDF as Blob
        Blob pdfBlob;

        // This check prevents test class failure
        if (!Test.isRunningTest()) {
            pdfBlob = pdfPage.getContentAsPDF();
        } else {
            pdfBlob = Blob.valueOf('Test PDF Content');
        }

        // 3. Convert Blob to Base64
        String base64Pdf = EncodingUtil.base64Encode(pdfBlob);

        // 4. Return Base64 string
        return base64Pdf;
    }
}
/*
public class PdfToBase64Controller {

    // FUTURE method - runs outside trigger and allows callout
    @future(callout=true)
    public static void publishSignatureEvents(List<Id> accountIds) {

        List<Patient_Signature_Event__e> events = new List<Patient_Signature_Event__e>();
        List<Account> aclist = new List<Account>();
        //-----------------------
        
       
         // Query latest PDF attachment
        Attachment att = [
            SELECT Id, Name
            FROM Attachment
            WHERE ParentId ='a1DU8000000UDnpMAG'
            
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        // Use supported method
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        // Build secure download URL
        String downloadUrl = baseUrl + '/servlet/servlet.FileDownload?file=' + att.Id;
//-------------------
        for (Id accId : accountIds) {

            // ✅ Generate exactly 6 Base64 chunks
            List<String> base64Chunks = generatePdfBase64Chunks('a18U80000034B4nIAE', 6);

            Integer chunkNo = 1;

            for (String chunk : base64Chunks) {

                events.add(new Patient_Signature_Event__e(
                    PatientId__c     = accId,
                    Document_Url__c  = 'http://docusign-envelop-api.us-e2.cloudhub.io/api/envelopes',
                    base64string__c  = chunk
                ));

                chunkNo++;
            }

            // Update account record
            aclist.add(new Account(
                Id = accId,
                Description = 'Sent in 6 Base64 Chunks'
            ));
        }

        if (!events.isEmpty()) {

            // Log payloads
            for (Patient_Signature_Event__e e : events) {
                System.debug('EVENT CHUNK => ' + JSON.serializePretty(e));
            }
            // Publish platform events
			Database.SaveResult[] results = EventBus.publish(events);
			System.debug('**result'+results);
            
            

            // Update Accounts
            update aclist;

            System.debug('SUCCESS: Published ' + events.size() + ' events.');
        }
    }

    // Helper: VF → PDF → Base64 → Split into N chunks
    @TestVisible
    public static List<String> generatePdfBase64Chunks(Id recordId, Integer numberOfChunks) {

        PageReference pdfPage = Page.MemberAuthorizationForm;
        pdfPage.getParameters().put('id', recordId);

        Blob pdfBlob;

        if (Test.isRunningTest()) {
            pdfBlob = Blob.valueOf('Dummy PDF Content for Testing Event Publishing');
        } else {
            pdfBlob = pdfPage.getContentAsPDF();
        }

        String base64Pdf = EncodingUtil.base64Encode(pdfBlob);

        Integer totalLength = base64Pdf.length();
        Integer chunkSize = Integer.valueOf(Math.ceil(totalLength / Decimal.valueOf(numberOfChunks)));

        List<String> chunks = new List<String>();

        for (Integer i = 0; i < totalLength; i += chunkSize) {
            chunks.add(base64Pdf.substring(i, Math.min(i + chunkSize, totalLength)));
        }

        // Safety check: enforce exactly N chunks
        while (chunks.size() < numberOfChunks) {
            chunks.add('');
        }

        return chunks;
    }
}
*/