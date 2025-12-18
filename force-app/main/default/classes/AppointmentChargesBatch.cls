/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-02-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class AppointmentChargesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    global List<String> errorMessages = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(
                                    'Select ID,Name,Patient__c,Patient__r.CareCloud_Patient_Id__c,Flowsheet_Total_Units2__c,Provider_Id__c  from Appointment__c where Visit_Reason_Type__c =\'Not MD\' AND Appointment_Status__c = \'Approved\' '
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Appointment__c> scope)
    {   
        System.debug('**Appointments Retrieved by Query: ' + scope.size());
        Set<String> patientIds = new Set<String>();    
        for(Appointment__c appointment : scope) 
        {
            patientIds.Add('\'' +appointment.Patient__r.CareCloud_Patient_Id__c+ '\'');
        }
        System.debug('patientIds'+patientIds);
        if(patientIds?.size() > 0)
        {  
            try
            {
                String patientIdString = String.join(new List<String>(patientIds), ', ');
                RecordType recordType = [Select Id from RecordType where Name = 'Compliance cases' and SobjectType = 'Case' limit 1];
                String sqlQuery = 'SELECT P.PATIENT_GUID,SUM(C.UNITS),LISTAGG(CONCAT(PROCEDURE_CODE, \'-\', PROCEDURE_DESCRIPTION, \'-\', UNITS), \' Units ;\') || \' Units\'  FROM PATIENTS P INNER JOIN CHARGES C ON P.PATIENT_ID = C.PATIENT_ID  WHERE  C._metadata__timestamp >= DATEADD(hour, '+System.label.Flowsheet_SnwFlk_Integ_Timestamp_Hrs+', CURRENT_TIMESTAMP()) AND P.PATIENT_GUID in ('+patientIdString+') AND PROCEDURE_CODE in ('+System.label.Flowsheet_SnwFlk_Integ_CPT_Codes+') GROUP BY P.PATIENT_GUID ORDER BY P.PATIENT_GUID';
          
        /*        String sqlQuery = 
    'SELECT ' +
        'P.PATIENT_GUID, ' +
        'C.PROVIDER_ID, ' +
        'SUM(C.UNITS) AS TOTAL_UNITS, ' +
        'LISTAGG(CONCAT(C.PROCEDURE_CODE, \'-\', C.PROCEDURE_DESCRIPTION, \'-\', C.UNITS), \' Units ;\') ' +
        'WITHIN GROUP (ORDER BY C.PROCEDURE_CODE) || \' Units\' AS PROCEDURE_DETAILS, ' +
        'LISTAGG(C.CHARGE_ID, \',\') WITHIN GROUP (ORDER BY C.CHARGE_ID) AS CHARGE_IDS ' +
    'FROM CARECLOUD_ODS.SHARE.CHARGES C ' +
    'INNER JOIN CARECLOUD_ODS.SHARE.PATIENTS P ' +
        'ON P.PATIENT_ID = C.PATIENT_ID ' +
    'WHERE C._metadata__timestamp >= DATEADD(hour, '+System.label.Flowsheet_SnwFlk_Integ_Timestamp_Hrs+', CURRENT_TIMESTAMP())' +  // Added space before AND
        'AND P.PATIENT_GUID IN (' + patientIdString + ') ' +
        'AND C.PROCEDURE_CODE IN (' + System.label.Flowsheet_SnwFlk_Integ_CPT_Codes + ') ' +
    'GROUP BY P.PATIENT_GUID, C.PROVIDER_ID ' +
    'ORDER BY P.PATIENT_GUID';
*/
System.debug('C._metadata__timestamp >= DATEADD(hour, ' + System.label.Flowsheet_SnwFlk_Integ_Timestamp_Hrs + ', CURRENT_TIMESTAMP())');
                System.debug('C.PROVIDER_ID');

                System.debug('sqlQuery-->'+sqlQuery);
                Map<String, List<Object>> snowflakeChargeResults = SnowflakeIntegration.executeSnowflakeQuery(sqlQuery);
                if (snowflakeChargeResults != null && !snowflakeChargeResults.isEmpty())
                {
                    List<Appointment__c> appointmentList = new List<Appointment__c>();
                    List<Case> caseList = new List<Case>();
                    
                    for (Appointment__c appointment : scope) 
                    {
                        System.debug('**Processing appointment: ' + appointment.Id + ', Patient Id: ' + appointment.Patient__r.CareCloud_Patient_Id__c);
                        List<Object> snowflakeChargeList = snowflakeChargeResults.get(appointment.Patient__r.CareCloud_Patient_Id__c);
                        System.debug('**snowflakeChargeList for patient ' + appointment.Patient__r.CareCloud_Patient_Id__c + ': ' + snowflakeChargeList);
                        
                        if (snowflakeChargeList != null && !snowflakeChargeList.isEmpty())
                        {
                            Boolean providerMatchFound = false;
                            for (Object obj : snowflakeChargeList) 
                            {
                                if (obj instanceof SnowFlakeResponse)
                                {
                                    SnowFlakeResponse snFlkResponse = (SnowFlakeResponse) obj;
                                    System.debug('**Snowflake Response - PatientId: ' + snFlkResponse.patientId + 
                                                ', ProviderID: ' + snFlkResponse.PROVIDERID + 
                                                ', TotalUnits: ' + snFlkResponse.totalUnits + 
                                                ', ChargeId: ' + snFlkResponse.chargeId);
                                    
                                    System.debug('**Comparing Provider IDs - Appointment: ' + appointment.Provider_Id__c + 
                                                ', Snowflake: ' + snFlkResponse.PROVIDERID);
                                    
                                    if (snFlkResponse.PROVIDERID == appointment.Provider_Id__c)
                                    {
                                        System.debug('**Provider ID match found for appointment: ' + appointment.Id);
                                        providerMatchFound = true;
                                        appointment.Flowsheets_Updated_By_SnwFlk_Integ__c = true;
                                        
                                        Object snFlakeUnits = snFlkResponse.totalUnits;
                                        System.debug('**Units comparison - Appointment: ' + appointment.Flowsheet_Total_Units2__c + 
                                                    ', Snowflake: ' + snFlakeUnits);
                                        
                                        if (appointment.Flowsheet_Total_Units2__c == Double.valueOf(String.valueOf(snFlakeUnits)))
                                        {
                                            appointment.Appointment_Status__c = 'Billed';
                                            appointment.Flowsheet_ChargeId__c = snFlkResponse.chargeId.replace(';', '\n');
                                            System.debug('**Billed for appointment: ' + appointment.Id);
                                        }
                                        else
                                        {
                                            appointment.Appointment_Status__c = 'Compliance Review';
                                            appointment.Flowsheet_ChargeId__c = snFlkResponse.chargeId.replace(';', '\n');
                                            
                                            Case c = new Case();
                                            c.RecordTypeId = recordType.Id;
                                            c.Subject = appointment.Name;
                                            c.Snowflake_charge_Id__c = snFlkResponse.chargeId.replace(';', '\n');
                                            c.Status = 'New';
                                            c.Appointment__c = appointment.Id;
                                            c.snowflake_Total_Units__c = snFlkResponse.totalUnits;
                                            c.Summary_of_Units_entered_snowflake__c = snFlkResponse.procedureCodeDesc.replace(';', '\n');
                                            caseList.add(c);
                                            System.debug('**Case added for appointment: ' + appointment.Id);
                                        }
                                        
                                        appointmentList.add(appointment);
                                        System.debug('**Appointment added to list: ' + appointment.Id);
                                        break;
                                    }
                                }
                            }
                            
                            if (!providerMatchFound)
                            {
                                System.debug('**No matching provider ID found for appointment: ' + appointment.Id);
                            }
                        }
                        else
                        {
                            System.debug('**No snowflake data for patient: ' + appointment.Patient__r.CareCloud_Patient_Id__c);
                        }
                    }
                    
                    System.debug('**appointmentList size: ' + appointmentList.size());
                    System.debug('**caseList size: ' + caseList.size());
                    if (appointmentList.size() > 0)
                    {
                        System.debug('**Updating appointments: ' + appointmentList);
                        try {
                            Database.SaveResult[] results = Database.update(appointmentList, false);
                            for (Integer i = 0; i < results.size(); i++) {
                                if (!results[i].isSuccess()) {
                                    String errorMsg = 'Failed to update appointment ' + appointmentList[i].Id + ': ' + 
                                                     results[i].getErrors()[0].getMessage();
                                    System.debug('**' + errorMsg);
                                    errorMessages.add(errorMsg);
                                }
                            }
                            System.debug('**Appointments updated');
                        } catch (Exception e) {
                            System.debug('**Error updating appointments: ' + e.getMessage());
                            errorMessages.add('Error updating appointments: ' + e.getMessage());
                        }
                    }
                    
                    if (caseList.size() > 0)
                    {
                        System.debug('**Inserting cases: ' + caseList);
                        try {
                            Database.SaveResult[] results = Database.insert(caseList, false);
                            for (Integer i = 0; i < results.size(); i++) {
                                if (!results[i].isSuccess()) {
                                    String errorMsg = 'Failed to insert case for appointment ' + caseList[i].Appointment__c + ': ' + 
                                                     results[i].getErrors()[0].getMessage();
                                    System.debug('**' + errorMsg);
                                    errorMessages.add(errorMsg);
                                }
                            }
                            System.debug('**Cases inserted');
                        } catch (Exception e) {
                            System.debug('**Error inserting cases: ' + e.getMessage());
                            errorMessages.add('Error inserting cases: ' + e.getMessage());
                        }
                    }
                }
                else
                {
                    errorMessages.add('No data found from the records in Snowflake');
                    System.debug('**No data found from Snowflake');
                }
            }
            catch (Exception ex) 
            {
                errorMessages.add('Error processing: ' + ex.getMessage() + '\nStack Trace: ' + ex.getStackTraceString());
                System.debug('**Exception: ' + ex.getMessage() + ', Stack Trace: ' + ex.getStackTraceString());
            }
        } 
        else
        {
            errorMessages.add('No valid PatientIds found');
            System.debug('**No valid PatientIds found');
        }
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        System.debug('Batch processing completed.');
        if (!errorMessages.isEmpty())
        {
            sendErrorReport();
        }
    }
    
    global void sendErrorReport() {
        
        String errorMessageString='';
        for(String errorMessage : errorMessages)
        {
            errorMessageString = errorMessageString + ' \n ' +errorMessage;
        }
        
        String emailBody = 'Snowflake Batch job encountered the following errors: \n' + errorMessageString;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> emailString = System.label.Flowsheet_SnwFlk_Integ_Error_Email.Split(', ');
        String[] toAddresses = emailString;
        mail.setToAddresses(toAddresses);
        mail.setSubject(System.label.Flowsheet_SnwFlk_Integ_Email_Subject);
        mail.setPlainTextBody(emailBody);
        if (!Test.isRunningTest())
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}