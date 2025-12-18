public with sharing class VFExtractorController {
    @AuraEnabled(cacheable=false)
    public static String getVFHtml() {
        try {
            // Reference your VF page by name
            PageReference pg = Page.TestPdfPage;

            // Get raw HTML as string
            String html = pg.getContent().toString();

            return html;

        } catch (Exception e) {
            throw new AuraHandledException('Error reading VF page: ' + e.getMessage());
        }
    }
}