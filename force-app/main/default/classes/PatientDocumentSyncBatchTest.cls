@isTest
public class PatientDocumentSyncBatchTest {
	@isTest 
    static void testuploadPatientDocument() {
        Test.startTest();
        Account acc = new Account(Name ='Test Acc', CareCloud_Patient_Id__c = '572253a3-4963-4d55-81f0-5082b422c96e');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate= Date.today();
        opp.StageName= 'Initial Appointment';
        opp.Mid_Back_Pain__c = true;
        opp.Neck_Pain__c = true;
        opp.Lower_Back_Pain_Sciatica__c = true;
        opp.Leg_Pain__c = true;
        opp.Knee_Pain__c = true;
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        opp.Intake_PDF_Ready__c = true;
        opp.Time_Intake_Indicated_Appt_in_CareCloud__c = System.now();
        insert opp;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Patient Doc',
            PathOnClient = 'Patient_doc.pdf',
            VersionData = Blob.valueOf('Test Content for Patient documents'),
            IsMajorVersion = true
        );
        insert contentVersion;  
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = opp.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        PatientDocumentSyncBatch instance = new PatientDocumentSyncBatch();
        Id batchprocessid = Database.executeBatch(instance);

        Test.stopTest();
    }
}