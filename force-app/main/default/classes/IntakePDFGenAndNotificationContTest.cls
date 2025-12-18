@isTest
public class IntakePDFGenAndNotificationContTest {
 
    @isTest static void testNotificationControllerNonUrgent(){ 
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
        cs.Subject = 'test subject';
        insert cs;
        
        List<Id> listOfAppointmentIds = new List<Id>();
        Test.startTest();
        
        Appointment__c ap1 = new Appointment__c();
        ap1.Appointment_Date_Time__c = datetime.now().adddays(3);
        ap1.Location_Email__c = 'brandon.bart@alliancehealthsystem.com';
        ap1.Location_Name__c = 'Test';
        ap1.Patient__c = acc.Id;
        ap1.Patient_Chart_Number__c = '212211';
        ap1.Provider_Id__c = '34424222';
        ap1.Intake__c = opp.Id;
        insert ap1;
        
        listOfAppointmentIds.add(ap1.Id);
        IntakePDFGenAndNotificationController.generateAndSendPDFDocument(listOfAppointmentIds);
        Test.stopTest();
   } 
   
   @isTest static void testNotificationControllerUrgent(){ 
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
        cs.Subject = 'test subject';
        insert cs;
        
        List<Id> listOfAppointmentIds = new List<Id>();
        Appointment__c ap = new Appointment__c();
        ap.Appointment_Date_Time__c = datetime.now();
        ap.Location_Email__c = 'brandon.bart@alliancehealthsystem.com';
        ap.Location_Name__c = 'Test';
        ap.Patient__c = acc.Id;
        ap.Patient_Chart_Number__c = '2111';
        ap.Provider_Id__c = '344242';
        ap.Intake__c = opp.Id;
        Test.startTest();
        insert ap;
        
        listOfAppointmentIds.add(ap.Id);
        IntakePDFGenAndNotificationController.generateAndSendPDFDocument(listOfAppointmentIds);
        Test.stopTest();
   }
  }