@isTest
public class GenerateIntakePDFDocumentControllerTest {
 
    @isTest static void testGenerateIntakePDFDocumentController(){ 
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
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Intake__c = opp.Id;
        cs.Subject = 'test subject';
        insert cs;
 
        List<Id> listOfAppointmentIds = new List<Id>();
        Appointment__c ap = new Appointment__c();
        ap.Appointment_Date_Time__c = datetime.now();
        ap.Location_Email__c = 'frontdesktest@spineandwellness.com';
        ap.Location_Name__c = 'Test';
        ap.Patient__c = acc.Id;
        ap.Patient_Chart_Number__c = '2111';
        ap.Provider_Id__c = '344242';
        ap.Intake__c = opp.Id;
        Test.startTest();
        insert ap;
        
        PageReference testPage = Page.GenerateIntakePDFDocument; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', String.valueOf(opp.Id));
       
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);   
        GenerateIntakePDFDocumentController gc = new GenerateIntakePDFDocumentController(sc);
   } 
     @isTest static void testGenerateIntakePDFDocumentController2(){ 
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
        opp.Date_of_Accident__c = System.today();
        opp.Have_you_had_previous_treatment_NEW__c = 'Yes';
     
        insert opp;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Intake__c = opp.Id;
        cs.Subject = 'test subject';
        cs.Primary_Subscriber_Date_of_Birth__c = System.today();
        cs.Secondary_Subscriber_Date_of_Birth__c = System.today();
        cs.Primary_Insurance__c = 'Other';
        cs.Secondary_Insurance__c = 'Other';
        insert cs;
 
        List<Id> listOfAppointmentIds = new List<Id>();
        Appointment__c ap = new Appointment__c();
        ap.Appointment_Date_Time__c = datetime.now();
        ap.Location_Email__c = 'frontdesktest@spineandwellness.com';
        ap.Location_Name__c = 'Test';
        ap.Patient__c = acc.Id;
        ap.Patient_Chart_Number__c = '2111';
        ap.Provider_Id__c = '344242';
        ap.Provider_Name__c = 'Sanu test';
        ap.Intake__c = opp.Id;
        Test.startTest();
        insert ap;
        
        PageReference testPage = Page.GenerateIntakePDFDocument; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', String.valueOf(opp.Id));
       
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);   
        GenerateIntakePDFDocumentController gc = new GenerateIntakePDFDocumentController(sc);
   } 

  }