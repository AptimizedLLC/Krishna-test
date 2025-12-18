public class ApprovalController {
  
   
    public class FlowhsheetWrapper {
        @AuraEnabled public String appointmentId;
        @AuraEnabled public Date appointmentDate;
        @AuraEnabled public String visitReason;

        @AuraEnabled public String minutesSpent1;
        @AuraEnabled public String minutesSpent2;
        @AuraEnabled public String minutesSpent3;
        @AuraEnabled public String minutesSpent4;
        @AuraEnabled public String minutesSpent5;
        @AuraEnabled public String minutesSpent6;
        @AuraEnabled public String minutesSpent7;
        @AuraEnabled public String minutesSpent8;
        @AuraEnabled public String minutesSpent9;
        @AuraEnabled public String minutesSpent10;

        @AuraEnabled public String otherExercises1;
        @AuraEnabled public String otherExercises2;
        @AuraEnabled public String otherExercises3;
        @AuraEnabled public String otherExercises4;
        @AuraEnabled public String otherExercises5;
        @AuraEnabled public String otherExercises6;
        @AuraEnabled public String otherExercises7;
        @AuraEnabled public String otherExercises8;
        @AuraEnabled public String otherExercises9;
        @AuraEnabled public String otherExercises10;
    }

    @AuraEnabled(cacheable=true)
    public static List<FlowhsheetWrapper> submitForApproval(Id recordId, Integer countSize, String visitReason) {
        Appointment__c patient = [
            SELECT Id, Patient__c 
            FROM Appointment__c 
            WHERE Id = :recordId
            LIMIT 1
        ];

        List<Appointment__c> appointmentList = [
            SELECT Id, Flowsheet__r.Id 
            FROM Appointment__c  
            WHERE Patient__r.Id = :patient.Patient__c
                AND Visit_Reason_Type__c != 'MD' 
                AND (
                    Visit_Reason__c LIKE 'PT -%' OR 
                    Visit_Reason__c LIKE 'OT -%' OR 
                    Visit_Reason__c LIKE 'CHIRO -%'
                )
            
        ];

        List<Id> flowsheetIds = new List<Id>();
        for (Appointment__c app : appointmentList) {
            if (app.Flowsheet__r != null) {
                flowsheetIds.add(app.Flowsheet__r.Id);
            }
        }

        if (flowsheetIds.isEmpty()) return new List<FlowhsheetWrapper>();

        List<Flowhsheet__c> fsList = [
            SELECT Id, Appointment__r.Visit_Reason__c, Appointment__r.Appointment_Date__c, Appointment__c,
                   Minutes_spent_1__c, Minutes_spent_2__c, Minutes_spent_3__c, Minutes_spent_4__c, Minutes_spent_5__c,
                   Minutes_spent_6__c, Minutes_spent_7__c, Minutes_spent_8__c, Minutes_spent_9__c, Minutes_spent_10__c,
                   OtherExercises1__c, OtherExercises2__c, OtherExercises3__c, OtherExercises4__c, OtherExercises5__c,
                   OtherExercises6__c, OtherExercises7__c, OtherExercises8__c, OtherExercises9__c, OtherExercises10__c
            FROM Flowhsheet__c 
            WHERE Id IN :flowsheetIds 
              AND Data_Not_Required__c = false 
              AND Appointment__r.Appointment_Date__c != null
        ];

        // Group flowsheets by appointment date
        Map<Date, List<Flowhsheet__c>> groupedMap = new Map<Date, List<Flowhsheet__c>>();
        for (Flowhsheet__c fs : fsList) {
            Date apptDate = fs.Appointment__r.Appointment_Date__c;
            if (!groupedMap.containsKey(apptDate)) {
                groupedMap.put(apptDate, new List<Flowhsheet__c>());
            }
            groupedMap.get(apptDate).add(fs);
        }

        // Sort the appointment dates descending and limit to countSize
        List<Date> sortedDates = new List<Date>(groupedMap.keySet());
        sortedDates.sort(); // ascending

        List<Date> topDates = new List<Date>();
        for (Integer i = sortedDates.size() - 1; i >= 0 && topDates.size() < countSize; i--) {
            topDates.add(sortedDates[i]);
        }

        List<FlowhsheetWrapper> result = new List<FlowhsheetWrapper>();

        for (Date dateKey : topDates) {
            List<Flowhsheet__c> flowsheets = groupedMap.get(dateKey);
            Set<String> visitReasons = new Set<String>();

            List<String> m1 = new List<String>(), m2 = new List<String>(), m3 = new List<String>(), m4 = new List<String>(), m5 = new List<String>(),
                         m6 = new List<String>(), m7 = new List<String>(), m8 = new List<String>(), m9 = new List<String>(), m10 = new List<String>();

            List<String> o1 = new List<String>(), o2 = new List<String>(), o3 = new List<String>(), o4 = new List<String>(), o5 = new List<String>(),
                         o6 = new List<String>(), o7 = new List<String>(), o8 = new List<String>(), o9 = new List<String>(), o10 = new List<String>();

            String firstApptId;

            for (Flowhsheet__c fs : flowsheets) {
                if (firstApptId == null) {
                    firstApptId = fs.Appointment__c;
                }

                if (String.isNotBlank(fs.Appointment__r.Visit_Reason__c)) {
                    visitReasons.add(fs.Appointment__r.Visit_Reason__c);
                }

                if (String.isNotBlank(fs.Minutes_spent_1__c)) m1.add(fs.Minutes_spent_1__c);
                if (String.isNotBlank(fs.Minutes_spent_2__c)) m2.add(fs.Minutes_spent_2__c);
                if (String.isNotBlank(fs.Minutes_spent_3__c)) m3.add(fs.Minutes_spent_3__c);
                if (String.isNotBlank(fs.Minutes_spent_4__c)) m4.add(fs.Minutes_spent_4__c);
                if (String.isNotBlank(fs.Minutes_spent_5__c)) m5.add(fs.Minutes_spent_5__c);
                if (String.isNotBlank(fs.Minutes_spent_6__c)) m6.add(fs.Minutes_spent_6__c);
                if (String.isNotBlank(fs.Minutes_spent_7__c)) m7.add(fs.Minutes_spent_7__c);
                if (String.isNotBlank(fs.Minutes_spent_8__c)) m8.add(fs.Minutes_spent_8__c);
                if (String.isNotBlank(fs.Minutes_spent_9__c)) m9.add(fs.Minutes_spent_9__c);
                if (String.isNotBlank(fs.Minutes_spent_10__c)) m10.add(fs.Minutes_spent_10__c);

                if (String.isNotBlank(fs.OtherExercises1__c)) o1.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises1__c);
                if (String.isNotBlank(fs.OtherExercises2__c)) o2.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises2__c);
                if (String.isNotBlank(fs.OtherExercises3__c)) o3.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises3__c);
                if (String.isNotBlank(fs.OtherExercises4__c)) o4.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises4__c);
                if (String.isNotBlank(fs.OtherExercises5__c)) o5.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises5__c);
                if (String.isNotBlank(fs.OtherExercises6__c)) o6.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises6__c);
                if (String.isNotBlank(fs.OtherExercises7__c)) o7.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises7__c);
                if (String.isNotBlank(fs.OtherExercises8__c)) o8.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises8__c);
                if (String.isNotBlank(fs.OtherExercises9__c)) o9.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises9__c);
                if (String.isNotBlank(fs.OtherExercises10__c)) o10.add('<b><u>'+fs.Appointment__r.Visit_Reason__c+'</u></b>'+';'+fs.OtherExercises10__c);
            }

            FlowhsheetWrapper w = new FlowhsheetWrapper();
            w.appointmentId = firstApptId;
            w.appointmentDate = dateKey;
            w.visitReason = String.join(new List<String>(visitReasons), ' / ');

            w.minutesSpent1 = String.join(m1, '; ');
            w.minutesSpent2 = String.join(m2, '; ');
            w.minutesSpent3 = String.join(m3, '; ');
            w.minutesSpent4 = String.join(m4, '; ');
            w.minutesSpent5 = String.join(m5, '; ');
            w.minutesSpent6 = String.join(m6, '; ');
            w.minutesSpent7 = String.join(m7, '; ');
            w.minutesSpent8 = String.join(m8, '; ');
            w.minutesSpent9 = String.join(m9, '; ');
            w.minutesSpent10 = String.join(m10, '; ');

            w.otherExercises1 = String.join(o1, '; ');
            w.otherExercises2 = String.join(o2, '; ');
            w.otherExercises3 = String.join(o3, '; ');
            w.otherExercises4 = String.join(o4, '; ');
            w.otherExercises5 = String.join(o5, '; ');
            w.otherExercises6 = String.join(o6, '; ');
            w.otherExercises7 = String.join(o7, '; ');
            w.otherExercises8 = String.join(o8, '; ');
            w.otherExercises9 = String.join(o9, '; ');
            w.otherExercises10 = String.join(o10, '; ');

            result.add(w);
        }

        return result;
    }

    
 
    @AuraEnabled(cacheable=true)    
public static Map<Date, List<Flowhsheet__c>> submitForApproval2(Id recordId, Integer countSize, String visitReason) {
    Id x = recordId;
    Integer count = countSize;
    String visitReasonFilter = visitReason + '%';

    Appointment__c patient = [
        SELECT Id, Patient__c 
        FROM Appointment__c 
        WHERE Id = :recordId
    ];

    List<Appointment__c> appointmentList = [
        SELECT Id, Flowsheet__r.Id 
        FROM Appointment__c  
        WHERE Patient__r.Id = :patient.Patient__c   
        AND Visit_Reason_Type__c != 'MD' 
        AND (
            Visit_Reason__c LIKE 'PT -%'  
            OR Visit_Reason__c LIKE 'OT -%'  
            OR Visit_Reason__c LIKE 'CHIRO -%'
        )
    ];

    List<Id> flowsheetIds = new List<Id>();
    for (Appointment__c app : appointmentList) {
        if (app.Flowsheet__r != null) {
            flowsheetIds.add(app.Flowsheet__r.Id);
        }
    }

    List<Flowhsheet__c> fsList = [
        SELECT Id, Appointment__r.Visit_Reason__c,
               Minutes_spent_1__c, Minutes_spent_2__c, Minutes_spent_3__c, Minutes_spent_4__c,
               Minutes_spent_5__c, Minutes_spent_6__c, Minutes_spent_7__c, Minutes_spent_8__c,
               Minutes_spent_9__c, Minutes_spent_10__c,
               OtherExercises1__c, OtherExercises2__c, OtherExercises3__c, OtherExercises4__c,
               OtherExercises5__c, OtherExercises6__c, OtherExercises7__c, OtherExercises8__c,
               OtherExercises9__c, OtherExercises10__c,
               Appointment__r.Appointment_Date__c, Appointment__c
        FROM Flowhsheet__c 
        WHERE Id IN :flowsheetIds 
        AND Data_Not_Required__c = false 
        AND Appointment__r.Appointment_Date__c != null
        ORDER BY Appointment__r.Appointment_Date__c DESC 
        LIMIT :count
    ];

    // Group flowsheets by Appointment Date
    Map<Date, List<Flowhsheet__c>> groupedMap = new Map<Date, List<Flowhsheet__c>>();
    for (Flowhsheet__c fs : fsList) {
        Date apptDate = fs.Appointment__r.Appointment_Date__c;
        if (!groupedMap.containsKey(apptDate)) {
            groupedMap.put(apptDate, new List<Flowhsheet__c>());
        }
        groupedMap.get(apptDate).add(fs);
    }

    return groupedMap;
}


    
    @AuraEnabled(cacheable=true)    
    public static Appointment__c patientNameVisitReason(Id recordId){
        Appointment__c fsList=[SELECT Id,Patient__r.Name,Visit_Reason__c FROM Appointment__c WHERE Id=:recordId];
        return fsList;
    }
        
   /* @AuraEnabled
      public static void updateFlowsheets(Id recordId) {
      id x=recordId;
            List<Flowhsheet__c>fsList=new List<Flowhsheet__c>();
            Appointment__c patient=[SELECT id,Patient__c from Appointment__c WHERE id=:recordId];
            
            list<id>flowsheetIds=new list<id>();
            for(Appointment__c app:[select id,Flowsheet__r.Name,Flowsheet__r.id from Appointment__c  where Patient__r.id=:patient.Patient__c]){
                flowsheetIds.add(app.Flowsheet__r.id);
            }
          for(Flowhsheet__c fs:[SELECT Id, Minutes_spent_1__c, Minutes_spent_2__c,Minutes_spent_3__c,Minutes_spent_4__c,Minutes_spent_5__c,Appointment__r.Appointment_Date__c,Appointment__c FROM Flowhsheet__c where id In: flowsheetIds AND Appointment__r.Appointment_Date__c<>null order by Appointment__r.Appointment_Date__c desc   ]){
              fsList.add(new Flowhsheet__c(id=fs.Id,Data_Not_Required__c=true,Flowsheet_Cleared_Date__c=system.today()));
          }
          if(fsList.size()>0){
              system.debug('updates fsList'+fsList);
              update fsList;
          }
        } */
  /*  @AuraEnabled  // This method will only clear the specific appointment exercise...
public static void updateFlowsheets(Id recordId) {
    // Retrieve only the flowsheets associated with the specific appointment
    List<Flowhsheet__c> fsList = [
        SELECT Id, Minutes_spent_1__c, Minutes_spent_2__c, Minutes_spent_3__c,
               Minutes_spent_4__c, Minutes_spent_5__c, Appointment__c
        FROM Flowhsheet__c
        WHERE Appointment__c = :recordId
    ];
    
    // Mark flowsheets as cleared
    for (Flowhsheet__c fs : fsList) {
        fs.Data_Not_Required__c = true;
        fs.Flowsheet_Cleared_Date__c = System.today();
    }

    if (!fsList.isEmpty()) {
        update fsList;
        System.debug('Updated flowsheets for appointment ID: ' + recordId);
    } else {
        System.debug('No flowsheets found for the specific appointment.');
    }
} */
    /*
    @AuraEnabled
public static void updateFlowsheets(Id recordId) {
    // Define filter keywords (matching the LWC keywords)
    List<String> filterKeywords = new List<String>{
        'CHIRO ', 
        'ESTABLISHED 1 YEAR CMO F/U', 
        'OT ', 
        'PT ', 
        'NEW YEAR EVALUATION'
    };
    
    // Retrieve the target appointment's Visit Reason and Patient
    Appointment__c targetAppointment = [
        SELECT Id, Visit_Reason__c, Patient__c 
        FROM Appointment__c 
        WHERE Id = :recordId
        LIMIT 1
    ];
    
    String targetVisitReason = targetAppointment.Visit_Reason__c;
    String matchingKeyword = null;
    
    // Check if the target Visit Reason contains any of the filter keywords
    for (String keyword : filterKeywords) {
        if (targetVisitReason != null && targetVisitReason.containsIgnoreCase(keyword)) {
            matchingKeyword = keyword;
            break;
        }
    }
    
    // If no matching keyword is found, exit the method
    if (matchingKeyword == null) {
        System.debug('No matching keyword found for the Visit Reason.');
        return;
    }

    // Retrieve all appointments for the patient with matching Visit Reason
    List<Id> appointmentIds = new List<Id>();
    for (Appointment__c app : [
        SELECT Id, Visit_Reason__c 
        FROM Appointment__c 
        WHERE Patient__c = :targetAppointment.Patient__c
    ]) {
       if (app.Visit_Reason__c != null && app.Visit_Reason__c.startsWithIgnoreCase(matchingKeyword)) {
            appointmentIds.add(app.Id);
        }
    }

    // Retrieve and update flowsheets for the filtered appointments
    List<Flowhsheet__c> fsList = [
        SELECT Id, Appointment__c 
        FROM Flowhsheet__c 
        WHERE Appointment__c IN :appointmentIds
    ];

    for (Flowhsheet__c fs : fsList) {
        fs.Data_Not_Required__c = true;
        fs.Flowsheet_Cleared_Date__c = System.today();
    }

    if (!fsList.isEmpty()) {
        update fsList;
        System.debug('Updated flowsheets for appointments with matching Visit Reason.');
    } else {
        System.debug('No flowsheets found for appointments with matching Visit Reason.');
    }
}*/
    
    @AuraEnabled
public static void updateFlowsheets(Id recordId) {
    // Retrieve the target appointment's Patient
    Appointment__c targetAppointment = [
        SELECT Id, Patient__c 
        FROM Appointment__c 
        WHERE Id = :recordId
        LIMIT 1
    ];

    // Get all appointments for that patient
    List<Id> appointmentIds = new List<Id>();
    for (Appointment__c app : [
        SELECT Id 
        FROM Appointment__c 
        WHERE Patient__c = :targetAppointment.Patient__c AND Flowsheet__c<>null
    ]) {
        appointmentIds.add(app.Id);
    }

    // Retrieve and update flowsheets for all the patient's appointments
    List<Flowhsheet__c> fsList = [
        SELECT Id, Appointment__c 
        FROM Flowhsheet__c 
        WHERE Appointment__c IN :appointmentIds
    ];

    for (Flowhsheet__c fs : fsList) {
        fs.Data_Not_Required__c = true;
        fs.Flowsheet_Cleared_Date__c = System.today();
    }

    if (!fsList.isEmpty()) {
        update fsList;
        System.debug('Updated flowsheets for all appointments of the patient.');
    } else {
        System.debug('No flowsheets found for the patient\'s appointments.');
    }
}



@AuraEnabled(cacheable=true)
public static Flowhsheet__c returnLatestAppFsRecord(Id recordId,String visitReason) {
   /*
    String VR=visitReason + '%';
    // Step 1: Fetch the current appointment
    Appointment__c currentAppointment = [
        SELECT Id, Patient__c, Appointment_Date__c 
        FROM Appointment__c 
        WHERE Id = :recordId
        LIMIT 1
    ];
    
    // Step 2: Fetch the previous appointment with non-skipped flowsheet
    Appointment__c previousAppointment = [
        SELECT Id, Patient__c, Appointment_Date__c 
        FROM Appointment__c 
        WHERE Patient__c = :currentAppointment.Patient__c 
            AND Appointment_Date__c < :currentAppointment.Appointment_Date__c 
            AND Flowsheet__r.Data_Not_Required__c = false
            AND Flowsheet__c != null
        	//AND Visit_Reason__c LIKE:VR
        ORDER BY Appointment_Date__c DESC 
        LIMIT 1
    ];
    
    // Step 3: Get appointments matching criteria
    List<Appointment__c> appointmentList = [
        SELECT Id, Appointment_Date__c, Visit_Reason__c, Flowsheet__r.Name, Flowsheet__r.Id 
        FROM Appointment__c  
        WHERE Patient__c = :currentAppointment.Patient__c
            AND Visit_Reason__c != null 
            AND Appointment_Date__c = :previousAppointment.Appointment_Date__c 
            AND Visit_Reason_Type__c != 'MD' 
            AND (
                Visit_Reason__c LIKE 'PT -%' 
                OR Visit_Reason__c LIKE 'OT -%' 
                OR Visit_Reason__c LIKE 'CHIRO -%'
            )
        //AND Visit_Reason__c LIKE:VR
    ];
    
    // Step 4: Collect flowsheet IDs
    Set<Id> fsIdSet = new Set<Id>();
    for (Appointment__c app : appointmentList) {
        if (app.Flowsheet__r != null) {
            fsIdSet.add(app.Flowsheet__r.Id);
        }
    }
    */
      String VR = visitReason + '%';
    
    // Step 1: Fetch the current appointment
    Appointment__c currentAppointment = [
        SELECT Id, Patient__c, Appointment_Date__c ,Diagnostics__c,Visit_Reason__c
        FROM Appointment__c 
        WHERE Id = :recordId
        LIMIT 1
    ];
    
    // Step 2: Fetch all previous appointments with non-skipped flowsheets
    List<Appointment__c> previousAppointments = [
        SELECT Id, Patient__c, Appointment_Date__c, Visit_Reason__c, Visit_Reason_Type__c,
               Flowsheet__c, Flowsheet__r.Data_Not_Required__c
        FROM Appointment__c
        WHERE Patient__c = :currentAppointment.Patient__c
            AND Appointment_Date__c < :currentAppointment.Appointment_Date__c
            AND Flowsheet__c != null
            AND Flowsheet__r.Data_Not_Required__c = false
        ORDER BY Appointment_Date__c DESC
    ];
    
    if (previousAppointments.isEmpty()) {
        return null;
    }
    
    // Step 3: Collect PT, OT, CHIRO appointments
    Map<String, Appointment__c> latestByType = new Map<String, Appointment__c>();
    Set<String> requiredTypes = new Set<String>{'PT','OT','CHIRO'};
    
    for (Appointment__c app : previousAppointments) {
        if (app.Visit_Reason__c == null || app.Visit_Reason_Type__c == 'MD') continue;
        
        if (app.Visit_Reason__c.startsWith('PT -') && !latestByType.containsKey('PT')) {
            latestByType.put('PT', app);
        }
        else if (app.Visit_Reason__c.startsWith('OT -') && !latestByType.containsKey('OT')) {
            latestByType.put('OT', app);
        }
        else if (app.Visit_Reason__c.startsWith('CHIRO -') && !latestByType.containsKey('CHIRO')) {
            latestByType.put('CHIRO', app);
        }
        
        // If we found all 3, we can stop searching further back
        if (latestByType.keySet().containsAll(requiredTypes)) {
            break;
        }
    }
    
    // Step 4: Collect flowsheet IDs from the found appointments
    Set<Id> fsIdSet = new Set<Id>();
    for (Appointment__c app : latestByType.values()) {
        if (app.Flowsheet__c != null) {
            fsIdSet.add(app.Flowsheet__c);
        }
    }
    
    // Step 5: Query Flowsheets
    List<Flowhsheet__c> fsList = [
        SELECT Id, 
               Minutes_spent_1__c, Minutes_spent_2__c, Minutes_spent_3__c, Minutes_spent_4__c, Minutes_spent_5__c, 
               Minutes_spent_6__c, Minutes_spent_7__c, Minutes_spent_8__c, Minutes_spent_9__c, Minutes_spent_10__c,
               OtherExercises1__c, OtherExercises2__c, OtherExercises3__c, OtherExercises4__c, OtherExercises5__c, 
               OtherExercises6__c, OtherExercises7__c, OtherExercises8__c, OtherExercises9__c, OtherExercises10__c,
               Appointment__r.Appointment_Date__c, Appointment__c, Data_Not_Required__c, Appointment__r.Visit_Reason__c,Appointment__r.Diagnostics__c
        FROM Flowhsheet__c 
        WHERE Id IN :fsIdSet
            AND Data_Not_Required__c = false
            AND Appointment__r.Appointment_Date__c != null
    ];
    
    // ✅ Fallback: if no valid flowsheets found
    if (fsList.isEmpty()) {
        Flowhsheet__c fallbackFlowsheet = new Flowhsheet__c();
        fallbackFlowsheet.OtherExercises6__c = 'Traction-15 Minutes';
        fallbackFlowsheet.Appointment__c = currentAppointment.Id;
        return fallbackFlowsheet;
    }

    // Step 6: Aggregate data
    Map<String, Integer> minutesMap = new Map<String, Integer>();
    Map<String, String> exercisesMap = new Map<String, String>();
    Map<String, String> PTOTCHIROMap = new Map<String, String>();
    Map<string, string> PTOTCHIRODiagnosticsMap=new Map<string, string>();
    
    
  

for (Flowhsheet__c fs : fsList) {
    String diag = fs.Appointment__r.Diagnostics__c;
    String visitReason1 = fs.Appointment__r.Visit_Reason__c;

    if (visitReason1 != null && diag != null && diag != '') {
        if (visitReason1.startsWith('PT -')) {
            PTOTCHIRODiagnosticsMap.put('PTDiagnostics', diag);
        }
        else if (visitReason1.startsWith('OT -')) {
            PTOTCHIRODiagnosticsMap.put('OTDiagnostics', diag);
        }
        else if (visitReason1.startsWith('CHIRO -')) {
            PTOTCHIRODiagnosticsMap.put('CHIRODiagnostics', diag);
        }
    }
}

// Ensure defaults
if (!PTOTCHIRODiagnosticsMap.containsKey('PTDiagnostics')) {
    PTOTCHIRODiagnosticsMap.put('PTDiagnostics', '');
}
if (!PTOTCHIRODiagnosticsMap.containsKey('OTDiagnostics')) {
    PTOTCHIRODiagnosticsMap.put('OTDiagnostics', '');
}
if (!PTOTCHIRODiagnosticsMap.containsKey('CHIRODiagnostics')) {
    PTOTCHIRODiagnosticsMap.put('CHIRODiagnostics', '');
}

String PTOTCHIRODiagnostics = '';
String pt = PTOTCHIRODiagnosticsMap.get('PTDiagnostics');
String ot = PTOTCHIRODiagnosticsMap.get('OTDiagnostics');
String chiro = PTOTCHIRODiagnosticsMap.get('CHIRODiagnostics');

// Count occurrences
Map<String, Integer> diagCount = new Map<String, Integer>();
for (String val : new List<String>{pt, ot, chiro}) {
    if (val != null && val != '') {
        diagCount.put(val, diagCount.containsKey(val) ? diagCount.get(val) + 1 : 1);
    }
}

// Find majority (value with count >= 2)
for (String key : diagCount.keySet()) {
    if (diagCount.get(key) >= 2) {
        PTOTCHIRODiagnostics = key;
        break;
    }
}

    
    for (Integer i = 1; i <= 10; i++) {
        minutesMap.put('Minutes_spent_' + i + '__c', 0);
        exercisesMap.put('OtherExercises' + i + '__c', '');
        PTOTCHIROMap.put('Exercise_' + i + '__c', '');
    }
    
    
    for (Flowhsheet__c fs : fsList) {
        for (Integer i = 1; i <= 10; i++) {
            // Handle minutes
            String minField = 'Minutes_spent_' + i + '__c';
            Integer minValue = (Integer) fs.get(minField);
            if (minValue != null) {
                minutesMap.put(minField, minutesMap.get(minField) + minValue);
            }
            
            // Handle exercises
            String exField = 'OtherExercises' + i + '__c';
            String exercise = (String) fs.get(exField);
            if (exercise != null && exercise.trim() != '') {
                String existing = exercisesMap.get(exField);
                exercisesMap.put(exField, existing == '' ? exercise : existing + '; ' + exercise);
            }

            // Prefix: PT, OT, or CHIRO
            String PTOTCHIROField = 'Exercise_' + i + '__c';
            String prefix = '';
            if (fs.Appointment__r.Visit_Reason__c.startsWith('PT -')) {
                prefix = 'PT';
            } else if (fs.Appointment__r.Visit_Reason__c.startsWith('OT -')) {
                prefix = 'OT';
            } else if (fs.Appointment__r.Visit_Reason__c.startsWith('CHIRO -')) {
                prefix = 'CHIRO';
            }

            String PTOTCHIROdata = '';
            String rawValue = (String) fs.get(exField);
            if (String.isNotBlank(rawValue)) {
                List<String> parts = rawValue.split(';');
                for (String part : parts) {
                    if (String.isNotBlank(part)) {
                        PTOTCHIROdata += prefix + ';';
                    }
                }
            }
            if (PTOTCHIROdata != null) {
                PTOTCHIROMap.put(PTOTCHIROField, PTOTCHIROMap.get(PTOTCHIROField) + PTOTCHIROdata);
            }
        }
    }

    // Step 7: Create combined flowsheet
    Flowhsheet__c combinedFlowsheet = new Flowhsheet__c();
    for (Integer i = 1; i <= 10; i++) {
        String minField = 'Minutes_spent_' + i + '__c';
        String exField = 'OtherExercises' + i + '__c';
        String PTOTCHIROField = 'Exercise_' + i + '__c';

        Integer totalMinutes = minutesMap.get(minField);
        String exercises = exercisesMap.get(exField);
        String PTOTCHIROValues = PTOTCHIROMap.get(PTOTCHIROField);

        combinedFlowsheet.put(minField, totalMinutes != null ? String.valueOf(totalMinutes) : null);
        combinedFlowsheet.put(exField, exercises);
        combinedFlowsheet.put(PTOTCHIROField, PTOTCHIROValues);
    }

    // Step 8: Add code flags
    for (Integer i = 1; i <= 10; i++) {
        String exField = 'OtherExercises' + i + '__c';
        String codeField = 'Code_' + i + '__c';
        Boolean hasValue = combinedFlowsheet.get(exField) != null && String.valueOf(combinedFlowsheet.get(exField)).trim() != '';
        combinedFlowsheet.put(codeField, hasValue);
    }

    // Step 9: Add default exercises if missing
    if (String.isBlank(combinedFlowsheet.OtherExercises3__c)) {
        combinedFlowsheet.OtherExercises3__c = 'Kinetisense-15 Minutes';
    } else if (!combinedFlowsheet.OtherExercises3__c.contains('Kinetisense')) {
        combinedFlowsheet.OtherExercises3__c += ';Kinetisense-15 Minutes';
    }

    if (String.isBlank(combinedFlowsheet.OtherExercises4__c)) {
        combinedFlowsheet.OtherExercises4__c = 'See Daily Note-15 Minutes';
    } else if (!combinedFlowsheet.OtherExercises4__c.contains('See Daily Note')) {
        combinedFlowsheet.OtherExercises4__c += ';See Daily Note-15 Minutes';
    }

    if (String.isBlank(combinedFlowsheet.OtherExercises5__c)) {
        combinedFlowsheet.OtherExercises5__c = 'Physical Performance Test-15 Minutes';
    } else if (!combinedFlowsheet.OtherExercises5__c.contains('Physical Performance Test')) {
        combinedFlowsheet.OtherExercises5__c += ';Physical Performance Test-15 Minutes';
    }

    if (String.isBlank(combinedFlowsheet.OtherExercises6__c)) {
        combinedFlowsheet.OtherExercises6__c = 'Traction-15 Minutes';
    } else if (!combinedFlowsheet.OtherExercises6__c.contains('Traction')) {
        combinedFlowsheet.OtherExercises6__c += ';Traction-15 Minutes';
    }
    if (String.isBlank(combinedFlowsheet.OtherExercises7__c)) {
        combinedFlowsheet.OtherExercises7__c = 'VALD -15 Minutes';
    } else if (!combinedFlowsheet.OtherExercises7__c.contains('VALD')) {
        combinedFlowsheet.OtherExercises7__c += ';VALD -15 Minutes';
    }

    // Step 10: Link to current appointment
    combinedFlowsheet.Appointment__c = currentAppointment.Id;

    //diagnosis data
    combinedFlowsheet.FSDiagnostics__c = PTOTCHIRODiagnostics;//'testDiagnosics data';
    // Return the combined record
    return combinedFlowsheet;
}
    

    //-------------------------------------------------------------
  @AuraEnabled(cacheable=true)
public static Flowhsheet__c returnLatestAppFsRecord2(Id recordId) {
    // Step 1: Fetch the current appointment
    Appointment__c currentAppointment = [
        SELECT Id, Patient__c, Appointment_Date__c 
        FROM Appointment__c 
        WHERE Id = :recordId
        LIMIT 1
    ];
    
    // Step 2: Fetch the previous appointment with non-skipped flowsheet
    Appointment__c previousAppointment = [
        SELECT Id, Patient__c, Appointment_Date__c 
        FROM Appointment__c 
        WHERE Patient__c = :currentAppointment.Patient__c 
            AND Appointment_Date__c = :currentAppointment.Appointment_Date__c 
            AND Flowsheet__r.Data_Not_Required__c = false
            AND Flowsheet__c != null
        ORDER BY Appointment_Date__c DESC 
        LIMIT 1
    ];
    
    // Step 3: Get appointments matching criteria
    List<Appointment__c> appointmentList = [
        SELECT Id, Appointment_Date__c, Visit_Reason__c, Flowsheet__r.Name, Flowsheet__r.Id 
        FROM Appointment__c  
        WHERE Patient__c = :currentAppointment.Patient__c
            AND Visit_Reason__c != null 
            AND Appointment_Date__c = :previousAppointment.Appointment_Date__c 
            AND Visit_Reason_Type__c != 'MD' 
            AND (
                Visit_Reason__c LIKE 'PT -%' 
                OR Visit_Reason__c LIKE 'OT -%' 
                OR Visit_Reason__c LIKE 'CHIRO -%'
            ) AND Flowsheet__c<>null
    ];
    
    // Step 4: Collect flowsheet IDs
    Set<Id> fsIdSet = new Set<Id>();
    for (Appointment__c app : appointmentList) {
        if (app.Flowsheet__r != null) {
            fsIdSet.add(app.Flowsheet__r.Id);
        }
    }
    
    // Step 5: Query Flowsheets
    List<Flowhsheet__c> fsList = [
        SELECT Id, 
               Minutes_spent_1__c, Minutes_spent_2__c, Minutes_spent_3__c, Minutes_spent_4__c, Minutes_spent_5__c, 
               Minutes_spent_6__c, Minutes_spent_7__c, Minutes_spent_8__c, Minutes_spent_9__c, Minutes_spent_10__c,
               OtherExercises1__c, OtherExercises2__c, OtherExercises3__c, OtherExercises4__c, OtherExercises5__c, 
               OtherExercises6__c, OtherExercises7__c, OtherExercises8__c, OtherExercises9__c, OtherExercises10__c,
               Appointment__r.Appointment_Date__c, Appointment__c, Data_Not_Required__c, Appointment__r.Visit_Reason__c,Appointment__r.Diagnostics__c
        FROM Flowhsheet__c 
        WHERE Id IN :fsIdSet
            AND Data_Not_Required__c = false
            AND Appointment__r.Appointment_Date__c != null
    ];
    
    

    // Step 6: Aggregate data
    Map<String, Integer> minutesMap = new Map<String, Integer>();
    Map<String, String> exercisesMap = new Map<String, String>();
    Map<String, String> PTOTCHIROMap = new Map<String, String>();
        Map<string, string> PTOTCHIRODiagnosticsMap=new Map<string, string>();
            
            
          
        
        for (Flowhsheet__c fs : fsList) {
            String diag = fs.Appointment__r.Diagnostics__c;
            String visitReason1 = fs.Appointment__r.Visit_Reason__c;
        
            if (visitReason1 != null && diag != null && diag != '') {
                if (visitReason1.startsWith('PT -')) {
                    PTOTCHIRODiagnosticsMap.put('PTDiagnostics', diag);
                }
                else if (visitReason1.startsWith('OT -')) {
                    PTOTCHIRODiagnosticsMap.put('OTDiagnostics', diag);
                }
                else if (visitReason1.startsWith('CHIRO -')) {
                    PTOTCHIRODiagnosticsMap.put('CHIRODiagnostics', diag);
                }
            }
        }
        
        // Ensure defaults
        if (!PTOTCHIRODiagnosticsMap.containsKey('PTDiagnostics')) {
            PTOTCHIRODiagnosticsMap.put('PTDiagnostics', '');
        }
        if (!PTOTCHIRODiagnosticsMap.containsKey('OTDiagnostics')) {
            PTOTCHIRODiagnosticsMap.put('OTDiagnostics', '');
        }
        if (!PTOTCHIRODiagnosticsMap.containsKey('CHIRODiagnostics')) {
            PTOTCHIRODiagnosticsMap.put('CHIRODiagnostics', '');
        }
        
        String PTOTCHIRODiagnostics = '';
        String pt = PTOTCHIRODiagnosticsMap.get('PTDiagnostics');
        String ot = PTOTCHIRODiagnosticsMap.get('OTDiagnostics');
        String chiro = PTOTCHIRODiagnosticsMap.get('CHIRODiagnostics');
        
        // Count occurrences
        Map<String, Integer> diagCount = new Map<String, Integer>();
        for (String val : new List<String>{pt, ot, chiro}) {
            if (val != null && val != '') {
                diagCount.put(val, diagCount.containsKey(val) ? diagCount.get(val) + 1 : 1);
            }
        }
        
        // Find majority (value with count >= 2)
        for (String key : diagCount.keySet()) {
            if (diagCount.get(key) >= 2) {
                PTOTCHIRODiagnostics = key;
                break;
            }
        }

    
    for (Integer i = 1; i <= 10; i++) {
        minutesMap.put('Minutes_spent_' + i + '__c', 0);
        exercisesMap.put('OtherExercises' + i + '__c', '');
        PTOTCHIROMap.put('Exercise_' + i + '__c', '');
    }
    
    for (Flowhsheet__c fs : fsList) {
        for (Integer i = 1; i <= 10; i++) {
            // Handle minutes
            String minField = 'Minutes_spent_' + i + '__c';
            Integer minValue = (Integer) fs.get(minField);
            if (minValue != null) {
                minutesMap.put(minField, minutesMap.get(minField) + minValue);
            }
            
            // Handle exercises
            String exField = 'OtherExercises' + i + '__c';
            String exercise = (String) fs.get(exField);
            if (exercise != null && exercise.trim() != '') {
                String existing = exercisesMap.get(exField);
                exercisesMap.put(exField, existing == '' ? exercise : existing + '; ' + exercise);
            }

            // Prefix: PT, OT, or CHIRO
            String PTOTCHIROField = 'Exercise_' + i + '__c';
            String prefix = '';
            if (fs.Appointment__r.Visit_Reason__c.startsWith('PT -')) {
                prefix = 'PT';
            } else if (fs.Appointment__r.Visit_Reason__c.startsWith('OT -')) {
                prefix = 'OT';
            } else if (fs.Appointment__r.Visit_Reason__c.startsWith('CHIRO -')) {
                prefix = 'CHIRO';
            }

            String PTOTCHIROdata = '';
            String rawValue = (String) fs.get(exField);
            if (String.isNotBlank(rawValue)) {
                List<String> parts = rawValue.split(';');
                for (String part : parts) {
                    if (String.isNotBlank(part)) {
                        PTOTCHIROdata += prefix + ';';
                    }
                }
            }
            if (PTOTCHIROdata != null) {
                PTOTCHIROMap.put(PTOTCHIROField, PTOTCHIROMap.get(PTOTCHIROField) + PTOTCHIROdata);
            }
        }
    }

    // Step 7: Create combined flowsheet
    Flowhsheet__c combinedFlowsheet = new Flowhsheet__c();
    for (Integer i = 1; i <= 10; i++) {
        String minField = 'Minutes_spent_' + i + '__c';
        String exField = 'OtherExercises' + i + '__c';
        String PTOTCHIROField = 'Exercise_' + i + '__c';

        Integer totalMinutes = minutesMap.get(minField);
        String exercises = exercisesMap.get(exField);
        String PTOTCHIROValues = PTOTCHIROMap.get(PTOTCHIROField);

        combinedFlowsheet.put(minField, totalMinutes != null ? String.valueOf(totalMinutes) : null);
        combinedFlowsheet.put(exField, exercises);
        combinedFlowsheet.put(PTOTCHIROField, PTOTCHIROValues);
    }

    // Step 8: Add code flags
    for (Integer i = 1; i <= 10; i++) {
        String exField = 'OtherExercises' + i + '__c';
        String codeField = 'Code_' + i + '__c';
        Boolean hasValue = combinedFlowsheet.get(exField) != null && String.valueOf(combinedFlowsheet.get(exField)).trim() != '';
        combinedFlowsheet.put(codeField, hasValue);
    }   

    // Step 10: Link to current appointment
    combinedFlowsheet.Appointment__c = currentAppointment.Id;
    //diagnosis data
    combinedFlowsheet.FSDiagnostics__c = PTOTCHIRODiagnostics;//'testDiagnosics data';

    // Return the combined record
    return combinedFlowsheet;
}
    

    //---------------------------------------------------------------
    

    

    
     @AuraEnabled(cacheable=true)    
        public static List<Appointment__c> last3Appointments(Id recordId,integer countSize) {
            id x=recordId;
            integer count=countSize;
            
            Appointment__c patient=[SELECT id,Patient__c,Appointment_Date__c from Appointment__c WHERE id=:recordId ];
            
            
            
            
            list<Appointment__c>AppointmentList=[select id,Appointment_Date__c,Visit_Reason__c,Flowsheet__r.Name,Flowsheet__r.id from Appointment__c  where Patient__r.id=:patient.Patient__c AND Visit_Reason__c <>null AND Appointment_Date__c=:patient.Appointment_Date__c AND Visit_Reason_Type__c != 'MD' ]; 
            
            return AppointmentList;
        } 
    
      @AuraEnabled(cacheable=true)    
        public static List<Appointment__c> last3Appointments2(Id recordId,integer countSize) {
            id x=recordId;
            integer count=countSize;
            
            Appointment__c patient=[SELECT id,Patient__c,Appointment_Date__c from Appointment__c WHERE id=:recordId ];
            
            
            
            
            list<Appointment__c>AppointmentList=[select id,Appointment_Date__c,Visit_Reason__c,Flowsheet__c,Flowsheet__r.Name,Flowsheet__r.id from Appointment__c  where Patient__r.id=:patient.Patient__c AND Visit_Reason__c <>null AND Appointment_Date__c=:patient.Appointment_Date__c AND Visit_Reason_Type__c != 'MD' AND Flowsheet__c<>null ]; 
            
            return AppointmentList;
        }
        
@AuraEnabled(cacheable=true)
        public static Boolean providerData(Id recordId) {
        Appointment__c appointment = [ SELECT Id, Patient__c, Provider_Name__c  FROM Appointment__c WHERE Id = :recordId LIMIT 1 ];
        
        List<User> matchedUsers = [ SELECT Id, Name, IsActive FROM User WHERE Name = :appointment.Provider_Name__c AND IsActive = true AND For_Flowsheets__c ='Provider' ];
        
       // return matchedUsers.size()>0?false:true;
            return false;
}

  
            

    }