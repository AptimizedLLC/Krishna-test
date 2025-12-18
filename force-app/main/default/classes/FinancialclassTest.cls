@isTest
public class FinancialclassTest {
    @isTest
    static void testWorkersCompensationPayers() {
        // Create a test record with a payer from the Workers Compensation set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'ACE PROPERTY AND CASUALITY');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Workers Compensation', payment.Financial_Class__c);
    }
    
    @isTest
    static void testOutOfStatePayers() {
        // Create a test record with a payer from the Out of State set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'ANTHEM BLUE CROSS AND BLUE SHIELD');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Out of State', payment.Financial_Class__c);
    }
    
    @isTest
    static void testUnitedHealthCarePayers() {
        // Create a test record with a payer from the United HealthCare set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'OPTUM HEALTH');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('United HealthCare', payment.Financial_Class__c);
    }
    
    @isTest
    static void testMedicareReplacementPlanPayers() {
        // Create a test record with a payer from the Medicare Replacement Plan set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'AMERIVANTAGE');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Medicare Replacement Plan', payment.Financial_Class__c);
    }
    
    @isTest
    static void testMiscellaneousPayers() {
        // Create a test record with a payer from the Miscellaneous set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'AG ADMINISTRATORS');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Miscellaneous', payment.Financial_Class__c);
    }
    
    @isTest
    static void testHumanaPayers() {
        // Create a test record with a payer from the Humana set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'HUMANA');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Humana', payment.Financial_Class__c);
    }
    
    @isTest
    static void testMedicaidPayers() {
        // Create a test record with a payer from the Medicaid set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'AETNA BETTER HEALTH OF NEW JERSEY');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Medicaid', payment.Financial_Class__c);
    }
    
    @isTest
    static void testMedicareSupplementPayers() {
        // Create a test record with a payer from the Medicare / Supplement set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'AARP HEALTHCARE OPTIONS');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Medicare / Supplement', payment.Financial_Class__c);
    }
    
    @isTest
    static void testCignaPayers() {
        // Create a test record with a payer from the Cigna set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = 'CIGNA');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Cigna', payment.Financial_Class__c);
    }
    
    @isTest
    static void testGovernmentPayers() {
        // Create a test record with a payer from the Government set
        Applied_Payments__c payment = new Applied_Payments__c(Payer__c = '1199 NATIONAL BENEFIT FUND');
        insert payment;
        
        // Retrieve the inserted record
        payment = [SELECT Payer__c, Financial_Class__c FROM Applied_Payments__c WHERE Id = :payment.Id];
        
        // Verify the Financial_Class__c field is set correctly
        System.assertEquals('Government', payment.Financial_Class__c);
    }
    
}