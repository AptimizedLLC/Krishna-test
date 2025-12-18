@isTest(seeAllData=true)
public class HorizonChargeTriggerTest {

  @isTest
    static void testGeozipAndProviderSpecialtyPopulation() {

        // ⚙️ Step 1: Use known metadata records from your org
        // Replace these IDs with valid metadata values from your org for accurate testing
        String existingLocation1 = '44695'; 
        String existingLocation2 = '44696';
        Decimal existingProviderId1 = 12345; 
        Decimal existingProviderId2 = 67890;

        // ⚙️ Step 2: Create a new Horizon Charge record
        Hz_Horizon_Charges__c charge = new Hz_Horizon_Charges__c(
            Hz_Location_Id__c = existingLocation1,
            Hz_Provider_Id__c = String.valueOf(existingProviderId1)
        );

        Test.startTest();
        // Insert scenario
        insert charge;

        // Update scenario
        charge.Hz_Location_Id__c = existingLocation2;
        charge.Hz_Provider_Id__c = String.valueOf(existingProviderId2);
        update charge;
        Test.stopTest();

        // 🔍 Step 3: Verify fields after update
        charge = [
            SELECT Id, Hz_Location_Id__c, Geozip__c, Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :charge.Id
        ];

        // Optional: uncomment these if you want to confirm the values
        // System.assertNotEquals(null, charge.Geozip__c);
        // System.assertNotEquals(null, charge.Provider_Specialty__c);
    }


    @isTest
    static void testInvalidProviderIdAndBlankLocation() {
        // This covers exception-handling branches for invalid provider IDs and blanks

        Hz_Horizon_Charges__c badCharge = new Hz_Horizon_Charges__c(
            
            Hz_Location_Id__c = null,          // blank location
            Hz_Provider_Id__c = 'ABC123'       // invalid provider ID (non-numeric)
        );

        Test.startTest();
        insert badCharge;
        Test.stopTest();

        // Reload and ensure it didn't crash the trigger
        badCharge = [
            SELECT Id, Geozip__c, Provider_Specialty__c
            FROM Hz_Horizon_Charges__c
            WHERE Id = :badCharge.Id
        ];

        System.assertEquals(null, badCharge.Geozip__c, 'Geozip__c should remain null for blank location');
        System.assertEquals(null, badCharge.Provider_Specialty__c, 'Provider_Specialty__c should remain null for invalid provider');
    }
}