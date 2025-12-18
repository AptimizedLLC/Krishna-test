/*
@isTest()
public class NewYearEvaluationBatchJobTest {
@isTest()
    static void methode1(){
                // Create Accounts
        Account acc1 = new Account(Name = 'Test Account 1',PersonEmail='kkumar@aptimized.com');
        Account acc2 = new Account(Name = 'Test Account 2',PersonEmail='pdurgarao@aptimized.com');
        insert new List<Account>{acc1, acc2};
            
        List<Appointment__c>applist=new List<Appointment__c>();
        Appointment__c app1=new Appointment__c(Name = 'Test Appointment 1',Visit_Reason__c ='New Year Evaluation',Appointment_Date_Time__c = system.today().addDays(15) );
        Appointment__c app2=new Appointment__c(Name = 'Test Appointment 2',Visit_Reason__c ='New Year Evaluation',Appointment_Date_Time__c = system.today().addDays(15));
        Test.startTest();
         NewYearEvaluationBatchJob.methode1();
        Test.stopTest();
        
    }
}*/

@isTest
public class NewYearEvaluationBatchJobTest {
    @isTest
    static void testBatchExecution() {
        // Create Person Accounts
        Account acc1 = new Account(
            FirstName = 'Test',
            LastName = 'Account 1',
            PersonEmail = 'kkumar@aptimized.com',
            NPP_New_Year_Evaluation_Mail_Sent__c = false,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1].Id
        );
        Account acc2 = new Account(
            FirstName = 'Test',
            LastName = 'Account 2',
            PersonEmail = 'kkumar@aptimized.com',
            NPP_New_Year_Evaluation_Mail_Sent__c = false,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1].Id
        );
        insert new List<Account>{acc1, acc2};

        // Create Appointments associated with Person Accounts
        List<Appointment__c> applist = new List<Appointment__c>();
        Appointment__c app1 = new Appointment__c(
            Name = 'Test Appointment 1',
            Visit_Reason__c = 'New Year Evaluation',
            Appointment_Date_Time__c = System.now().addDays(15),
            Patient__c = acc1.Id
        );
        Appointment__c app2 = new Appointment__c(
            Name = 'Test Appointment 2',
            Visit_Reason__c = 'New Year Evaluation',
            Appointment_Date_Time__c = System.now().addDays(15),
            Patient__c = acc2.Id
        );
        applist.add(app1);
        applist.add(app2);
        insert applist;

        // Run the batch job
        Test.startTest();
        NewYearEvaluationBatchJob batchJob = new NewYearEvaluationBatchJob();
        Database.executeBatch(batchJob, 200); // Execute the batch job with a batch size of 200
        Test.stopTest();

        // Validate the results
        List<Account> updatedAccounts = [SELECT Id, NPP_New_Year_Evaluation_Mail_Sent__c FROM Account WHERE Id IN :new List<Id>{acc1.Id, acc2.Id}];
        
    }
}