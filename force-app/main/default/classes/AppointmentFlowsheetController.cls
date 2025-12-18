public with sharing class AppointmentFlowsheetController {
    @AuraEnabled(cacheable=true)
    public static List<WrapperRecord> getAppointmentsWithFlowsheets(Integer pageNumber, Integer pageSize) {
        Id currentUserId = UserInfo.getUserId();

        List<Flowhsheet__c> flowsheets = [
            SELECT Id, TE__c, TA__c,NMR__c,MT__c,PPT__c,TR__c,ROM__c,
                   Appointment__r.Id,
                   Appointment__r.Name,
                  Appointment__r.Patient__r.Name,
                   Appointment__r.Appointment_Date_Time__c,
                   Appointment__r.Visit_Reason__c
            FROM Flowhsheet__c
            WHERE Appointment__r.Appointment_Status__c = 'Provider Review'
              AND Appointment__r.OwnerId = :currentUserId
            ORDER BY Appointment__r.Appointment_Date_Time__c ASC
            LIMIT :pageSize OFFSET :((pageNumber-1) * pageSize)
        ];

        List<WrapperRecord> results = new List<WrapperRecord>();
        for (Flowhsheet__c fs : flowsheets) {
            results.add(new WrapperRecord(
                fs.Id,
                fs.Appointment__r.Id,
                fs.Appointment__r.Name,
                fs.Appointment__r.Appointment_Date_Time__c,
                fs.Appointment__r.Patient__r.Name,
                fs.Appointment__r.Visit_Reason__c,
                fs.TE__c,
                fs.PPT__c,
                fs.ROM__c,
                fs.NMR__c,
                fs.MT__c,
                fs.TR__c,
                fs.TA__c
            ));
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalCount() {
        return [
            SELECT COUNT()
            FROM Flowhsheet__c
            WHERE Appointment__r.Appointment_Status__c = 'Provider Review'
              AND Appointment__r.OwnerId = :UserInfo.getUserId()
        ];
    }
    
@AuraEnabled(cacheable=true)
public static List<WrapperRecord> getRecentAppointmentsWithFlowsheets(Date startDate, Date endDate, String searchKey) {
    Id currentUserId = UserInfo.getUserId();

    Date today = Date.today();
    Date sevenDaysAgo = today.addDays(-6);

    // if user didn’t select, fall back to last 7 days
    Date filterStart = (startDate == null) ? sevenDaysAgo : startDate;
    Date filterEnd   = (endDate == null)   ? today       : endDate;

    // base query
    String query = 
        'SELECT Id, TE__c, TA__c, NMR__c, MT__c, PPT__c, TR__c, ROM__c, ' +
        'Appointment__r.Id, Appointment__r.Name, Appointment__r.Patient__r.Name, ' +
        'Appointment__r.Appointment_Date_Time__c, Appointment__r.Visit_Reason__c, ' +
        'Appointment__r.Appointment_Status__c ' +
        'FROM Flowhsheet__c ' +
        'WHERE Appointment__r.Flowsheet_Approved__c = true ' +
        'AND Appointment__r.OwnerId = :currentUserId ' +
        'AND Appointment__r.Appointment_Date_Time__c >= :filterStart ' +
        'AND Appointment__r.Appointment_Date_Time__c <= :filterEnd ';

    // add search filter if provided
    if (String.isNotBlank(searchKey)) {
        query += 'AND Appointment__r.Patient__r.Name LIKE :(\'%' + searchKey + '%\') ';
    }

    query += 'ORDER BY Appointment__r.Appointment_Date_Time__c DESC';

    List<Flowhsheet__c> flowsheets = Database.query(query);

    List<WrapperRecord> results = new List<WrapperRecord>();
    for (Flowhsheet__c fs : flowsheets) {
        results.add(new WrapperRecord(
            fs.Id,
            fs.Appointment__r.Id,
            fs.Appointment__r.Name,
            fs.Appointment__r.Appointment_Date_Time__c,
            fs.Appointment__r.Patient__r.Name,
            fs.Appointment__r.Visit_Reason__c,
            fs.TE__c,
            fs.PPT__c,
            fs.ROM__c,
            fs.NMR__c,
            fs.MT__c,
            fs.TR__c,
            fs.TA__c
        ));
    }
    return results;
}
    @AuraEnabled
public static void approveAppointment(Id appointmentId) {
    if (appointmentId == null) return;

    Appointment__c appt = [
        SELECT Id, Appointment_Status__c,Flowsheet_Approved__c 
        FROM Appointment__c 
        WHERE Id = :appointmentId 
        LIMIT 1
    ];
    appt.Appointment_Status__c = 'Approved';
    appt.Flowsheet_Approved__c = true ;
    appt.Flowsheet_Provider_Approval_Date__c = Date.today(); // set approval date
    update appt;
}

    public class WrapperRecord {
        @AuraEnabled public Id flowsheetId { get; set; }
        @AuraEnabled public Id appointmentId { get; set; }
        @AuraEnabled public String appointmentName { get; set; }
        @AuraEnabled public Datetime appointmentDate { get; set; }
        @AuraEnabled public String patientName { get; set; }
        @AuraEnabled public String editFlowSheetLink { get; set; }
        @AuraEnabled public String te { get; set; }
        @AuraEnabled public String ta { get; set; }
        @AuraEnabled public String rom { get; set; }
        @AuraEnabled public String tr { get; set; }
        @AuraEnabled public String mt { get; set; }
        @AuraEnabled public String nmr { get; set; }
        @AuraEnabled public String ppt { get; set; }

        public WrapperRecord(
            Id fsId,
            Id apptId,
            String apptName,
            Datetime apptDate,
            String patName,
            String link,
            String teVal,
            String romVal,
            String pptVal,
            String nmrVal,
            String mtVal,
            String trVal,
            String taVal
        ) {
            flowsheetId = fsId;
            appointmentId = apptId;
            appointmentName = apptName;
            appointmentDate = apptDate;
            patientName = patName;
            editFlowSheetLink = link;
            te = teVal;
            ta = taVal;
            ppt =pptVal;
            nmr = nmrVal;
            mt=mtVal;
            tr=trVal;
            rom=romVal;
        }
    }
}