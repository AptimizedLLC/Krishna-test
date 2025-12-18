@isTest
public class AppointmentTriggerServiceHandlerTest {
 
    @isTest static void testAppointmentTriggerServiceHandler(){ 
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
        
        Appointment__c ap = new Appointment__c();
        ap.Appointment_Date_Time__c = datetime.now();
        ap.Location_Email__c = 'test@test.com';
        ap.Location_Name__c = 'Test';
        ap.Patient__c = acc.Id;
        ap.Patient_Chart_Number__c = '2111';
        ap.Provider_Id__c = '344242';
        Test.startTest();
        insert ap;
        Test.stopTest();
   } 
  }