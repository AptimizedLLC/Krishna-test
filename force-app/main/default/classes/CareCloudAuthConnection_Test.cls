@isTest
public class CareCloudAuthConnection_Test {
    
    @isTest 
    static void testPatientPostCallout() {
        Test.startTest();
        List<Id> ldIds = new List<Id>();
        Lead objLead = new Lead( FirstName = 'Test', 
                                LastName = 'Sample', 
                                Company = 'Alliance', 
                                Phone='2003695847', 
                                Street='27 Ollie' , 
                                City='Atlanta', 
                                State='GA', 
                                Lead_Date_of_Birth__c=System.today().addYears(-30),
                                Gender__c = 'Male',
                                PostalCode='30314' , 
                                Country='USA' );  
        insert objLead; 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.Id);
        lc.setConvertedStatus('Convert To Patient');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        ldIds.add(objLead.Id);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PatientHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CareCloudAuthConnection.getTitle(ldIds);
        Test.stopTest();
    }
    
    @isTest 
    static void testPatientPostCalloutEx() {
        Test.startTest();
        Lead objLead = new Lead( FirstName = 'Test', 
                                LastName = 'Sample', 
                                Company = 'Alliance', 
                                Phone='2003695847', 
                                Street='27 Ollie' , 
                                City='Atlanta', 
                                State='GA', 
                                Lead_Date_of_Birth__c=System.today().addYears(-30),
                                Gender__c = 'Male',
                                PostalCode='30314' , 
                                Country='USA' );  
        insert objLead; 
        
        try {
            CareCloudAuthConnection.createPatientInCareCloud(objLead.Id);
        } catch(Exception ex) {
            System.debug('::: Exception in CareCloudAuthConnection_Test = '+ex.getMessage());
        }
        Test.stopTest();
    }

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

        CareCloudAuthConnection.uploadPatientDocument(opp.Id);

        Test.stopTest();
    }
    
    @isTest
    static void createPatientRetryTest() {
        Lead objLead = new Lead( FirstName = 'Test', 
                                LastName = 'Sample', 
                                Company = 'Alliance', 
                                Phone='2003695847', 
                                Street='27 Ollie' , 
                                City='Atlanta', 
                                State='GA', 
                                Lead_Date_of_Birth__c=System.today().addYears(-30),
                                Gender__c = 'Male',
                                PostalCode='30314' , 
                                Country='USA' );  
        insert objLead; 
        
        Test.setMock(HttpCalloutMock.class, new PatientHttpCalloutMock()); 
        
        Test.startTest();
            CareCloudAuthConnection.createPatientInCareCloud(objLead.Id);
        Test.stopTest();
    }
    
    @isTest
    static void createPatientRetryFailureTest() {
        Lead objLead = new Lead( FirstName = 'Test', 
                                LastName = 'Sample', 
                                Company = 'Alliance', 
                                Phone='2003695847', 
                                Street='27 Ollie' , 
                                City='Atlanta', 
                                State='GA', 
                                Lead_Date_of_Birth__c=System.today().addYears(-30),
                                Gender__c = 'Male',
                                PostalCode='30314' , 
                                Country='USA' );  
        insert objLead; 
        
        Test.setMock(HttpCalloutMock.class, new PatientHttpCalloutMock.PatientFailureHttpCalloutMock()); 
        
        Test.startTest();
            CareCloudAuthConnection.createPatientInCareCloud(objLead.Id);
        Test.stopTest();
    }

}