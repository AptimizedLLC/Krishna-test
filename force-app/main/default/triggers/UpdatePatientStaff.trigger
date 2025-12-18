trigger UpdatePatientStaff on Appointment__c (after update, after insert, before insert, before update) {
    //---------------------------
    if (Trigger.isInsert && Trigger.isBefore) {
        System.debug('This is a Before operation');
        Set<Id> patientIds = new Set<Id>();
        Map<Id, Appointment__c> patientAppointmentMap = new Map<Id, Appointment__c>();
        for (Appointment__c app : Trigger.new) {
            patientIds.add(app.Patient__c);
        }
        List<Account> patientList = [SELECT Id, Name, 
                                    (SELECT Id, Name, Appointment_Date__c, Assigned_Staff_at_time_of_appointment__c, OwnerId, Patient_s_Currently_Assigned_Staff__c 
                                     FROM Appointments1__r 
                                     WHERE Visit_Reason_Type__c = 'Not MD' 
                                     AND Appointment_Date__c <> null 
                                     AND Patient_s_Currently_Assigned_Staff__c <> null 
                                     AND Owner.IsActive = true
                                     ORDER BY Appointment_Date__c DESC) 
                                     FROM Account                                         
                                     WHERE Id IN :patientIds];
        
        for (Account acc : patientList) {
            // Ensure there's at least one appointment before accessing it
            if (!acc.Appointments1__r.isEmpty()) {
                patientAppointmentMap.put(acc.Id, acc.Appointments1__r[0]);
            }
        }
        for (Appointment__c appoint : Trigger.new) {
            if (appoint.Patient__c != null && patientAppointmentMap.containsKey(appoint.Patient__c)) {
                Appointment__c latestAppointment = patientAppointmentMap.get(appoint.Patient__c);
                
                appoint.Assigned_Staff_at_time_of_appointment__c = latestAppointment.Patient_s_Currently_Assigned_Staff__c;
                appoint.OwnerId = latestAppointment.OwnerId;
                appoint.Owner_for_filter__c = latestAppointment.Patient_s_Currently_Assigned_Staff__c;
                appoint.Patient_s_Currently_Assigned_Staff__c = latestAppointment.Patient_s_Currently_Assigned_Staff__c;
            }

            // Assign Location based on Location_Id__c
            appoint.Location__c = getLocationName(appoint.Location_Id__c);
        }
    }
                

    public String getLocationName(String locationId) {
        // Define a Map to store Location_Id__c values and their corresponding names
        Map<String, String> locationMap = new Map<String, String>{
            '44811' => 'FREEHOLD',
            '44812' => 'EAST BRUNSWICK',
            '46964' => 'BLOOMFIELD',
            '38637' => 'FAIR LAWN',
            '48844' => 'RANDOLPH',
            '50687' => 'OLD BRIDGE',
            '48980' => 'OLD BRIDGE OFFICE MD',
            '46965' => 'BLOOMFIELD MD',
            '44697' => 'FREEHOLD OFFICE MD',
            '44695' => 'EAST BRUNSWICK MD',
            '44816' => 'TEAMMD SURGERY CENTER, LLC',
            '48845' => 'RANDOLPH MD',
            '45547' => 'FAIR LAWN MD',
            '48874' => 'MORRIS COUNTY SURGICAL CENTER',
            '52434' => 'MIDDLETOWN',
            '53312' => 'Union'
        };

        // Return the matching value, or the default if not found
        return locationMap.containsKey(locationId) ? locationMap.get(locationId) : 'default value';
    }
    //---------------------------
    if (Trigger.isAfter && Trigger.isUpdate) {
    if (AppointmentTriggerHandler.isTriggerActive) {
        AppointmentTriggerHandler.isTriggerActive = false;

        // Map to track updates for Patient_s_Currently_Assigned_Staff__c
        Map<Id, Id> patientToStaffMap = new Map<Id, Id>();

        // Collect changes from Trigger.new
        for (Appointment__c appt : Trigger.new) {
            if (appt.Patient_s_Currently_Assigned_Staff__c != Trigger.oldMap.get(appt.Id).Patient_s_Currently_Assigned_Staff__c) {
                patientToStaffMap.put(appt.Patient__c, appt.Patient_s_Currently_Assigned_Staff__c);
            }
        }

        if (!patientToStaffMap.isEmpty()) {
            // Query all appointments for the affected patients
            List<Appointment__c> appointmentsToUpdate = new List<Appointment__c>();
            Set<Id> patientIds = patientToStaffMap.keySet();

            List<Appointment__c> patientAppointments = [
                SELECT Id, Patient__c, Patient_s_Currently_Assigned_Staff__c
                FROM Appointment__c
                WHERE Patient__c IN :patientIds
            ];

            // Apply updates to all appointments for the affected patients
            for (Appointment__c appt : patientAppointments) {
                if (patientToStaffMap.containsKey(appt.Patient__c)) {
                    appt.Patient_s_Currently_Assigned_Staff__c = patientToStaffMap.get(appt.Patient__c);
                    appointmentsToUpdate.add(appt);
                }
            }

            // Perform the update
            if (!appointmentsToUpdate.isEmpty()) {
                update appointmentsToUpdate;
            }
        }

        AppointmentTriggerHandler.isTriggerActive = true;
    }
}
}