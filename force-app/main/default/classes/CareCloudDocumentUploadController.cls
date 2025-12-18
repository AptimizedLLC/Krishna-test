public class CareCloudDocumentUploadController {
	@InvocableMethod(label='Upload document to Care Cloud' description='Upload document under folder of patient in Care Cloud')
    public static void uploadDocument(List<InputWrapper> inputs) {
        uploadDocumentToCC(inputs[0]);
    }
    
    private static void uploadDocumentToCC(InputWrapper input) {
        //Send Document to Care Cloud
        if(String.isNotBlank(input.patientId)) {
            CareCloudDocumentServices.uploadDocumentToCC(input.patientId, null, input.contentVersionIds[0], input.ccFolderId);
        } else {
            String custMsg = 'Document Upload error for Patient - '+input.patientId;
            TransactionLogHandler.doHandleCustomException('', custMsg, 'CareCloudDocumentUploadController', 'uploadDocument');
        }
    }
    
    public class InputWrapper{
        @InvocableVariable
        public String ccFolderId;
        
        @InvocableVariable
        public Id patientId;
        
        @InvocableVariable
        public List<Id> contentVersionIds;
    }
}