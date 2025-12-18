public with sharing class TablePDFController {
    public List<Flowhsheet__c> fsList { get; set; }
    public List<List<Flowhsheet__c>> fsListBatches { get; set; }
    public Set<String> selectedVisitReasons { get; set; }
    public String selectedReasons { get; set; }
    public String Name { get; set; }
    public String providerLicense { get; set; }
    public string vistreason{get; set;}
    public String providerName { get; set; }
    public Map<String, Map<String, String>> dateToExerciseMap { get; set; }
    public List<String> exercises { get; set; }

    public TablePDFController(ApexPages.StandardController controller) {
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        String reasons = ApexPages.currentPage().getParameters().get('selectedReasons');
        
        selectedVisitReasons = new Set<String>(reasons.split(','));
    selectedReasons = reasons; // Store the raw string for VF page display
        fsList = new List<Flowhsheet__c>();
        fsListBatches = new List<List<Flowhsheet__c>>();

        if (accountId != null && !selectedVisitReasons.isEmpty()) {
            fsList = getFilteredFlowsheets(accountId, selectedVisitReasons);

            // Create batches of Flowsheet__c records
            Integer batchSize = 04;
List<Flowhsheet__c> batch = new List<Flowhsheet__c>();
for (Integer i = 0; i < fsList.size(); i++) {
    batch.add(fsList[i]);
    if (batch.size() == batchSize || i == fsList.size() - 1) {
        fsListBatches.add(batch);
        batch = new List<Flowhsheet__c>();
    }
}

            // Set provider license and name if available
            for (Flowhsheet__c fs : fsList) {
                if (fs.Appointment__r != null && fs.Appointment__r.Provider_License_Number__c != null) {
                    providerLicense = fs.Appointment__r.Provider_License_Number__c;
                    providerName = fs.Appointment__r.Provider_Name__c;
                    vistreason = fs.Appointment__r.Visit_Reason__c;
                    break;
                }
            }

            if (fsList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'No appointments with approved Flowsheets found for the selected Visit Reasons.'));
            }
        }

        if (accountId != null) {
            Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
            Name = acc.Name;
        }

        // Initialize exercises list (all 10 exercise codes)
        exercises = new List<String>{
            '97110', '97530', '97112', '97140', '97750', '97012', '95851', '97016', '97014/G0283', '9039/S8948'
        };

        // Build dateToExerciseMap
        dateToExerciseMap = new Map<String, Map<String, String>>();
        for (Flowhsheet__c record : fsList) {
            if (record.Appointment__r != null && record.Appointment__r.Appointment_Date__c != null) {
                String dateStr = String.valueOf(record.Appointment__r.Appointment_Date__c);
                if (!dateToExerciseMap.containsKey(dateStr)) {
                    dateToExerciseMap.put(dateStr, new Map<String, String>());
                    for (String exercise : exercises) {
                        dateToExerciseMap.get(dateStr).put(exercise, '');
                    }
                }
                Map<String, String> exerciseData = dateToExerciseMap.get(dateStr);
                exerciseData.put('97110', combineFields(record.Minutes_spent_1__c, record.OtherExercises1__c));
                exerciseData.put('97530', combineFields(record.Minutes_spent_2__c, record.OtherExercises2__c));
                exerciseData.put('97112', combineFields(record.Minutes_spent_3__c, record.OtherExercises3__c));
                exerciseData.put('97140', combineFields(record.Minutes_spent_4__c, record.OtherExercises4__c));
                exerciseData.put('97750', combineFields(record.Minutes_spent_5__c, record.OtherExercises5__c));
                exerciseData.put('97012', combineFields(record.Minutes_spent_6__c, record.OtherExercises6__c));
                exerciseData.put('95851', combineFields(record.Minutes_spent_7__c, record.OtherExercises7__c));
                exerciseData.put('97016', combineFields(record.Minutes_spent_8__c, record.OtherExercises8__c));
                exerciseData.put('97014/G0283', combineFields(record.Minutes_spent_9__c, record.OtherExercises9__c));
                exerciseData.put('9039/S8948', combineFields(record.Minutes_spent_10__c, record.OtherExercises10__c));
            }
        }
    }

    private List<Flowhsheet__c> getFilteredFlowsheets(String accountId, Set<String> visitReasons) {
        set<id>AppIds=new set<id>();
        for(Appointment__c app:[SELECT Id,Patient__c,Flowsheet__c FROM Appointment__c WHERE Patient__c =: accountId And Flowsheet__c <>null AND Flowsheet_Approved__c = true]){
            AppIds.add(app.Flowsheet__c);
        }
        List<Flowhsheet__c> allFlowsheets = [SELECT Appointment__r.Appointment_Date__c, 
                                                  Appointment__r.Visit_Reason__c,
                                                  Appointment__r.Provider_License_Number__c,
                                                  Appointment__r.Provider_Name__c,
                                                  Appointment__r.Flowsheet_Approved__c,
                                             Appointment__r.Flowsheet_Provider_Approval_Date__c,
                                                  Minutes_spent_1__c, OtherExercises1__c, 
                                                  Minutes_spent_2__c, OtherExercises2__c,
                                                  Minutes_spent_3__c, OtherExercises3__c,
                                                  Minutes_spent_4__c, OtherExercises4__c,
                                                  Minutes_spent_5__c, OtherExercises5__c,
                                                  Minutes_spent_6__c, OtherExercises6__c,
                                                  Minutes_spent_7__c, OtherExercises7__c,
                                                  Minutes_spent_8__c, OtherExercises8__c,
                                                  Minutes_spent_9__c, OtherExercises9__c,
                                                  Minutes_spent_10__c, OtherExercises10__c
                                           FROM Flowhsheet__c
                                           WHERE id in:AppIds //Appointment__r.Patient__c = :accountId 
                                           AND Appointment__r.Flowsheet_Approved__c = true
                                             AND Appointment__r.Appointment_Status__c NOT IN ('Provider Review', 'Sent Back To Floor staff')
                                           ORDER BY Appointment__r.Appointment_Date__c];

        List<Flowhsheet__c> filteredList = new List<Flowhsheet__c>();
        for (Flowhsheet__c fs : allFlowsheets) {
            if (fs.Appointment__r.Visit_Reason__c != null) {
                for (String reason : visitReasons) {
                    if (fs.Appointment__r.Visit_Reason__c.contains(reason)) {
                        filteredList.add(fs);
                        break;
                    }
                }
            }
        }
        return filteredList;
    }

    private String combineFields(String minutes, String otherExercises) {
        List<String> parts = new List<String>();
        if (!String.isBlank(minutes)) {
            parts.add(minutes.replace(';', ', ').trim());
        }
        if (!String.isBlank(otherExercises)) {
            parts.add(otherExercises.replace(';', ', ').trim());
        }
        String result = parts.isEmpty() ? '' : String.join(parts, ', ');
        // Always wrap in quotes to ensure consistent CSV parsing
        return '"' + result.replace('"', '""').replace('\n', ' ').trim() + '"';
    }
}