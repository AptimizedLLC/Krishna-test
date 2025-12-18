@isTest
public class CareCloudDocumentUploadControllerTest {
    @isTest static void testUploadDocumentInCC_patientIdIsPresent() {
        Account acc = new Account(Name ='Test');
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
        opp.Hip_Pain__c = true;
        opp.Foot_Ankle_Pain__c = true;
        opp.Shoulder_Pain__c = true;
        opp.Elbow_Pain__c = true;
        opp.Wrist_Hand_Pain__c = true;
        opp.Scoliosis__c = true;
        opp.Headache_Migraine__c = true;
        opp.Vertigo__c = true;
        opp.Neurological_Condition__c = true;
        opp.Wellness_No_Pain__c = true;
        opp.Other_Condition__c = true;
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Intake__c = opp.Id;
        cs.Patient_VOB__c = acc.Id;
        cs.Subject = 'test subject';
        insert cs;
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = 'test.pdf';
        conVer.Title = 'TEST PDF';
        conVer.VersionData = Blob.valueOf('Test');
        insert conVer;
        
        Test.startTest();
        CareCloudDocumentUploadController.InputWrapper input = new CareCloudDocumentUploadController.InputWrapper();
        input.ccFolderId = '12345';
        input.patientId = acc.Id;
        input.contentVersionIds = new List<Id>{conVer.Id};
            
        CareCloudDocumentUploadController.uploadDocument(new List<CareCloudDocumentUploadController.InputWrapper>{input});
        Test.stopTest();
    }
    
    @isTest static void testUploadDocumentInCC_patientIdIsNotPresent() {
        Account acc = new Account(Name ='Test');
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
        opp.Hip_Pain__c = true;
        opp.Foot_Ankle_Pain__c = true;
        opp.Shoulder_Pain__c = true;
        opp.Elbow_Pain__c = true;
        opp.Wrist_Hand_Pain__c = true;
        opp.Scoliosis__c = true;
        opp.Headache_Migraine__c = true;
        opp.Vertigo__c = true;
        opp.Neurological_Condition__c = true;
        opp.Wellness_No_Pain__c = true;
        opp.Other_Condition__c = true;
        opp.LeadSource = 'Internet_Google';
        opp.AccountId = acc.Id;
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Intake__c = opp.Id;
        cs.Patient_VOB__c = acc.Id;
        cs.Subject = 'test subject';
        insert cs;
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = 'test.pdf';
        conVer.Title = 'TEST PDF';
        conVer.VersionData = Blob.valueOf('Test');
        insert conVer;
        
        Test.startTest();
        CareCloudDocumentUploadController.InputWrapper input = new CareCloudDocumentUploadController.InputWrapper();
        input.ccFolderId = '12345';
        input.patientId = null;
        input.contentVersionIds = new List<Id>{conVer.Id};
            
        CareCloudDocumentUploadController.uploadDocument(new List<CareCloudDocumentUploadController.InputWrapper>{input});
        Test.stopTest();
    }
}