@IsTest
class DynamicFormMemberHelperTest {

    @IsTest
    static void testPage() {
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.Patient_Name__c = 'Test Patient';
        cs.Patient_Date_of_Birth__c = System.today();
        cs.Subject = 'test subject';
        cs.PIP_Date_of_Loss__c = System.today();
        insert cs;
        
        Test.StartTest(); 
            PageReference vfPage = Page.GenerateInsurancePlanPDFV2;
            Test.setCurrentPage(vfPage);
            ApexPages.currentPage().getParameters().put('id',cs.Id);
            DynamicFormMemberHelper insp = new DynamicFormMemberHelper();
        	String d = insp.morphedValue;
        	List<String> op = insp.splittedOptions;
        	insp.rOptions = 'gg, ll';
        	List<String> op2 = insp.splittedOptions;
		Test.StopTest();
    }
    
}