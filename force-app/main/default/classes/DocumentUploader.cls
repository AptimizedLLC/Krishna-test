public class DocumentUploader implements Queueable {
    private List<Id> nppIds;
    private Integer currentIndex;

    public DocumentUploader(List<Id> nppIds, Integer currentIndex) {
        this.nppIds = nppIds;
        this.currentIndex = currentIndex;
    }

    public void execute(QueueableContext context) {
        // Process the current ID using the batch class
        if (currentIndex < nppIds.size()) {
            String currentNppId = nppIds[currentIndex];

            // Execute the batch class for the current ID
            Database.executeBatch(new NppCareCloudBatchable(currentNppId), 1);

            // Enqueue the next job if there are remaining records
            if (currentIndex + 1 < nppIds.size()) {
                System.enqueueJob(new DocumentUploader(nppIds, currentIndex + 1));
            }
        }
    }
}