public with sharing class VisitReasonController {
    public List<SelectOption> visitReasonOptions { get; set; }
    public String selectedReasons { get; set; }
    private final Account account;

    public VisitReasonController(ApexPages.StandardController controller) {
        account = (Account)controller.getRecord();
        selectedReasons = '';
        visitReasonOptions = new List<SelectOption>();
        initializeVisitReasons();
    }

    private void initializeVisitReasons() {
        visitReasonOptions.add(new SelectOption('OT -', 'OT'));
        visitReasonOptions.add(new SelectOption('PT -', 'PT'));
        visitReasonOptions.add(new SelectOption('CHIRO -', 'CHIRO'));
        visitReasonOptions.add(new SelectOption('ESTABLISHED 1', 'ESTABLISHED'));
        visitReasonOptions.add(new SelectOption('NEW YEAR EVALUATION', 'NEW YEAR EVALUATION'));
    }

    public PageReference generatePDF() {
        if (String.isEmpty(selectedReasons)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                'Please select at least one Visit Reason before generating the PDF.'));
            return null;
        }

        // Split the selected reasons and check each visit reason
        Set<String> selectedVisitReasons = new Set<String>(selectedReasons.split(','));
        List<String> invalidVisitReasons = new List<String>();

        // Debugging: Output the selected reasons
        System.debug('Selected visit reasons: ' + selectedVisitReasons);

        for (String reason : selectedVisitReasons) {
            // Query appointments related to the patient and the selected visit reason
            List<Appointment__c> appointments = [SELECT Id, Flowsheet_Approved__c 
                                     FROM Appointment__c 
                                     WHERE Patient__c = :account.Id 
                                     AND Visit_Reason__c LIKE :( reason + '%') AND Flowsheet_Approved__c=true];


            Boolean hasApprovedFlowsheet = false;

            // Debugging: Check the appointments retrieved
            System.debug('Appointments for reason ' + reason + ': ' + appointments);

            // Loop through appointments and check if any have Flowsheet_Approved__c enabled
            for (Appointment__c appointment : appointments) {
                if (appointment.Flowsheet_Approved__c) {
                    hasApprovedFlowsheet = true;
                    break;
                }
            }

            // Debugging: Output whether we found an approved appointment
            System.debug('Has approved flowsheet for reason ' + reason + ': ' + hasApprovedFlowsheet);

            // If no approved appointment found for this reason, mark it as invalid
            if (!hasApprovedFlowsheet) {
                invalidVisitReasons.add(reason);
            }
        }

        // If there are any visit reasons without approved appointments, show an error
        if (!invalidVisitReasons.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                'The following Visit Reasons have no appointments with Flowsheet Approval: ' + String.join(invalidVisitReasons, ', ')));
            return null;  // Prevent PDF page redirection
        }

        // If everything is valid, proceed to generate PDF
        PageReference pdfPage = Page.DownloadFlowSheetPDF;
        pdfPage.getParameters().put('accountId', account.Id);
        pdfPage.getParameters().put('selectedReasons', selectedReasons);
        pdfPage.setRedirect(true);

        return pdfPage;
    }
}