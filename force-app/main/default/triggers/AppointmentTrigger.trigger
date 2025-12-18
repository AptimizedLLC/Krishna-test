trigger AppointmentTrigger on Appointment__c (after insert, after update) {

    // To validate if Opportunity Trigger settings is Active.
    Trigger_Settings__mdt appointmentTriggerSettings = [SELECT Id, Is_Active__c FROM Trigger_Settings__mdt WHERE DeveloperName = 'AppointmentTrigger'];
    if(appointmentTriggerSettings.Is_Active__c){
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            
            AppointmentTriggerServiceHandler.generateAndSendPDFDocument(json.serialize(Trigger.new), json.serialize(Trigger.oldMap));   
        }
    }
}