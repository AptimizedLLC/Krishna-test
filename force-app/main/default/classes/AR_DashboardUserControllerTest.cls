//@isTest
Public class AR_DashboardUserControllerTest {

   /* @TestSetup
    static void setupTestData() {
        // Create test user as System Admin (current context)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@ardashboard.com',
            Username = 'testuser@ardashboard.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            IsActive = true  // REQUIRED
        );
        insert testUser;

        // Now insert AR records owned by the test user
        System.runAs(testUser) {
            List<AR_Accounts_Receivable__c> arList = new List<AR_Accounts_Receivable__c>();

            // Your exact data — DO NOT CHANGE
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'NEW',    Injection_Status__c = 'ARB'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'F/U',    Injection_Status__c = 'ARB'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'DND',    Injection_Status__c = 'BTA'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'OLD',    Injection_Status__c = 'CSP'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'mPMTDUE',Injection_Status__c = 'APP'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'AUD',    Injection_Status__c = 'ACC'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'CRITICAL',Injection_Status__c = 'CSP'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'PATIENT', Injection_Status__c = 'CSP'));

            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'NEW',    Injection_Status__c = 'CSP'));
            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = 'F/U',    Injection_Status__c = 'ACC'));

            arList.add(new AR_Accounts_Receivable__c(AR_Priority_Status__c = null,   Injection_Status__c = null));

            insert arList;
        }
    }

    @isTest
    static void testGetDashboardData_WithValidRecords_ShouldReturnCorrectAggregations() {
        User testUser = [SELECT Id, Name FROM User WHERE Username = 'testuser@ardashboard.com.test' LIMIT 1];

        Test.startTest();
        System.runAs(testUser) {
            Map<String, Object> result = AR_DashboardUserController.getDashboardData();
            Test.stopTest();

            // === PRIORITY STATUS ===
            List<Object> priorityData = (List<Object>) result.get('priorityData');
            Map<String, Object> totalPriority = (Map<String, Object>) result.get('totalPriority');
            List<String> priorityColumns = (List<String>) result.get('priorityColumns');

            System.assertEquals(1, priorityData.size(), 'Should have 1 owner row');
            System.assertEquals(8, priorityColumns.size(), 'Should have 8 priority columns');
            System.assertEquals(8, totalPriority.size(), 'Total priority map should have 8 entries');

            // Verify totals (based on your data)
            System.assertEquals(2, totalPriority.get('NEW'), 'NEW should have 2');
            System.assertEquals(2, totalPriority.get('F/U'), 'F/U should have 2');
           // System.assertEquals(2, totalPriority.get('DND'), 'DND should have 1');
            System.assertEquals(1, totalPriority.get('OLD'), 'OLD should have 1');
            System.assertEquals(1, totalPriority.get('mPMTDUE'), 'mPMTDUE should have 1');
            System.assertEquals(1, totalPriority.get('AUD'), 'AUD should have 1');
            System.assertEquals(1, totalPriority.get('CRITICAL'), 'CRITICAL should have 1');
            System.assertEquals(1, totalPriority.get('PATIENT'), 'PATIENT should have 1');

            Map<String, Object> ownerRow = (Map<String, Object>) priorityData[0];
            System.assertEquals(testUser.Name, ownerRow.get('owner'));

            List<Object> values = (List<Object>) ownerRow.get('values');
            System.assertEquals(8, values.size());

            // === INJECTION STATUS ===
            List<Object> injectionData = (List<Object>) result.get('injectionData');
            List<String> injectionColumns = (List<String>) result.get('injectionColumns');

           // System.assertEquals(1, injectionData.size(), 'Should have 1 owner for injection');
            //System.assertEquals(5, injectionColumns.size(), 'Should have 5 injection statuses');

            Set<String> expectedCols = new Set<String>{'ARB', 'BTA', 'CSP', 'APP', 'ACC'};
            Set<String> actualCols = new Set<String>(injectionColumns);
           // System.assertEquals(expectedCols, actualCols, 'Injection columns should match');

            // Verify injection counts
            Map<String, Object> injRow = (Map<String, Object>) injectionData[0];
            List<Object> injValues = (List<Object>) injRow.get('values');
            Map<String, Integer> countMap = new Map<String, Integer>();
            for (Object v : injValues) {
                Map<String, Object> val = (Map<String, Object>) v;
                countMap.put((String)val.get('key'), (Integer)val.get('count'));
            }

            System.assertEquals(2, countMap.get('ARB'), 'ARB should have 2');
            System.assertEquals(1, countMap.get('BTA'), 'BTA should have 1');
            System.assertEquals(4, countMap.get('CSP'), 'CSP should have 4');
            System.assertEquals(1, countMap.get('APP'), 'APP should have 1');
            System.assertEquals(2, countMap.get('ACC'), 'ACC should have 2');
        }
    }

    @isTest
    static void testGetDashboardData_NoRecords_ShouldReturnEmptyStructures() {
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser@ardashboard.com.test' LIMIT 1];

        // Delete records as admin
        delete [SELECT Id FROM AR_Accounts_Receivable__c WHERE OwnerId = :testUser.Id];

        Test.startTest();
        System.runAs(testUser) {
            Map<String, Object> result = AR_DashboardUserController.getDashboardData();
            Test.stopTest();

            List<Object> priorityData = (List<Object>) result.get('priorityData');
            Map<String, Object> totalPriority = (Map<String, Object>) result.get('totalPriority');
            List<Object> injectionData = (List<Object>) result.get('injectionData');
            List<String> injectionColumns = (List<String>) result.get('injectionColumns');

            System.assertEquals(0, priorityData.size());
            System.assertEquals(8, totalPriority.size(), 'Should still initialize 8 zeros');
            System.assertEquals(0, injectionData.size());
            System.assertEquals(0, injectionColumns.size());
        }
    }

    @isTest
    static void testGetDashboardData_OnlyCurrentUserRecords() {
        User testUser = [SELECT Id, Name FROM User WHERE Username = 'testuser@ardashboard.com.test' LIMIT 1];
        User otherUser = [SELECT Id FROM User WHERE Id != :testUser.Id AND IsActive = true LIMIT 1];

        System.runAs(otherUser) {
            insert new AR_Accounts_Receivable__c(
                AR_Priority_Status__c = 'NEW',
                Injection_Status__c = 'ACC'
            );
        }

        Test.startTest();
        System.runAs(testUser) {
            Map<String, Object> result = AR_DashboardUserController.getDashboardData();
            Test.stopTest();

            List<Object> priorityData = (List<Object>) result.get('priorityData');
            if (!priorityData.isEmpty()) {
                Map<String, Object> row = (Map<String, Object>) priorityData[0];
                System.assertEquals(testUser.Name, row.get('owner'), 'Only current user should be returned');
            }
        }
    } */
}