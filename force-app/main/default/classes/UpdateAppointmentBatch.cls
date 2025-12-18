global class UpdateAppointmentBatch implements Database.Batchable<sObject>, Database.Stateful {

    // Store processed IDs for debugging

    Set<Id> processedIds = new Set<Id>();
 
    // Start method: Query the initial set of Appointment__c records

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(

            'SELECT Id, Patient__c FROM Appointment__c WHERE Patient_s_Currently_Assigned_Staff__c <> NULL AND Appointment_Date__c > 2025-02-01'

        );

    }
 
    // Execute method: Process records in batches

    global void execute(Database.BatchableContext BC, List<Appointment__c> scope) {

        // Collect unique patient IDs

        Set<Id> patientIds = new Set<Id>();

        for (Appointment__c app : scope) {

            patientIds.add(app.Patient__c);

        }
 
        // Query patients' latest appointments with NULL Assigned Staff

        Map<Id, Appointment__c> patientToEmptyStaffAppointments = new Map<Id, Appointment__c>();

        List<Account> patientList = [SELECT Id, 

                                        (SELECT Id, Name, Appointment_Date__c, Assigned_Staff_at_time_of_appointment__c, 

                                                OwnerId, Patient_s_Currently_Assigned_Staff__c 

                                         FROM Appointments1__r 

                                         WHERE Visit_Reason_Type__c = 'Not MD' 

                                                AND Location_ID__c <> NULL 

                                                AND Patient_s_Currently_Assigned_Staff__c = NULL

                                         ORDER BY Appointment_Date__c DESC LIMIT 1) 

                                     FROM Account WHERE Id IN :patientIds];
 
        for (Account acc : patientList) {

            if (!acc.Appointments1__r.isEmpty()) {

                patientToEmptyStaffAppointments.put(acc.Id, acc.Appointments1__r[0]);

            }

        }
 
        // Query patients' latest appointments WITH assigned staff

        Map<Id, Appointment__c> patientAppointmentMap = new Map<Id, Appointment__c>();

        List<Account> patientList2 = [SELECT Id, 

                                        (SELECT Id, Name, Appointment_Date__c, Assigned_Staff_at_time_of_appointment__c, 

                                                OwnerId, Patient_s_Currently_Assigned_Staff__c 

                                         FROM Appointments1__r 

                                         WHERE Visit_Reason_Type__c = 'Not MD' 

                                                AND Location_ID__c <> NULL 

                                                AND Patient_s_Currently_Assigned_Staff__c <> NULL

                                         ORDER BY Appointment_Date__c DESC) 

                                     FROM Account WHERE Id IN :patientIds];
 
        for (Account acc : patientList2) {

            if (!acc.Appointments1__r.isEmpty()) {

                patientAppointmentMap.put(acc.Id, acc.Appointments1__r[0]);

            }

        }
 
        // Prepare list of records to update

        List<Appointment__c> updateAppointments = new List<Appointment__c>();
 
        for (Id patientId : patientToEmptyStaffAppointments.keySet()) {

            if (patientAppointmentMap.containsKey(patientId)) {

                Appointment__c emptyAppointment = patientToEmptyStaffAppointments.get(patientId);

                Appointment__c assignedAppointment = patientAppointmentMap.get(patientId);
 
                emptyAppointment.Patient_s_Currently_Assigned_Staff__c = assignedAppointment.Patient_s_Currently_Assigned_Staff__c;

                emptyAppointment.Assigned_Staff_at_time_of_appointment__c = assignedAppointment.Patient_s_Currently_Assigned_Staff__c;
 
                updateAppointments.add(emptyAppointment);

                processedIds.add(emptyAppointment.Id);

            }

        }
 
        // Bulk update records

        if (!updateAppointments.isEmpty()) {

            update updateAppointments;

        }

    }
 
    // Finish method: Log processed records

    global void finish(Database.BatchableContext BC) {

        System.debug('Processed Appointment IDs: ' + processedIds);

    }

}