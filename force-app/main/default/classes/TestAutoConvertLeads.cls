@isTest 
public class TestAutoConvertLeads{
    static testMethod void createnewlead() {
        Test.startTest();    
        Lead leadToCreate =new Lead();
        List<id> Ids= New List<Id>();
        Lead objLead = new Lead( FirstName = 'Gopi', 
                                LastName = 'Mishra', 
                                Company = 'Broadcom', 
                                Phone='7809876543', 
                                Street='80 Ollie' , 
                                City='Tampa', 
                                State='FL', 
                                Lead_Date_of_Birth__c=System.today().addYears(-20),
                                Gender__c = 'Male',
                                PostalCode='30329' , 
                                Country='USA' );  
        insert objLead; 
        
        Ids.add(objLead.id);
        AutoConvertLeads.LeadAssign(Ids);
        
        Test.stopTest();
    }
   
    static testMethod void failLeadConversion() {
        Test.startTest();   
        List<Lead> leadList = new List<Lead>();
        List<id> Ids= New List<Id>();
        
        Lead leadOne =new Lead();
        leadOne.FirstName = 'Eric';
        leadOne.LastName = 'Lukjanczuk';
        leadOne.City = 'east brunswick';
        leadOne.Email = 'elukjan@yahoo.com.invalid';
        leadOne.Gender__c = 'Male';
        leadOne.LeadSource = 'Walk In/ Drive By';
        leadOne.Phone = '7324393848';
        leadOne.PostalCode = '08816';
        leadOne.State = 'NJ';
        leadOne.Street = '79 wellington road';
        
        Lead lead2 =new Lead();
        lead2.FirstName = 'Eric';
        lead2.LastName = 'Lukjanczuk';
        lead2.City = 'east brunswick';
        lead2.Email = 'elukjan@yahoo.com.invalid';
        lead2.Gender__c = 'Male';
        lead2.LeadSource = 'Walk In/ Drive By';
        lead2.Phone = '7324393848';
        lead2.PostalCode = '08816';
        lead2.State = 'NJ';
        lead2.Street = '79 wellington road';
        lead2.Status='Open - Not Contacted';
        lead2.Rating='Hot';   
        lead2.LeadSource='Employee Referral';
        
        leadList.add(leadOne);
        leadList.add(lead2);
        
        insert leadList;
        
        Ids.add(leadOne.id);
        Ids.add(lead2.id);
        AutoConvertLeads.LeadAssign(Ids);
        
        Test.stopTest();
    }
}