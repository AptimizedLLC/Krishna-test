@IsTest
private class CreativeRequestEmailSender_Test {

    // Creates a valid Creative_Request__c that satisfies ALL required fields in your org
    private static Creative_Request__c createValidCreativeRequest() {
        return new Creative_Request__c(
            Name                    = 'CR-TEST-001',
            Type_of_Request__c      = 'Billboard',
            Due_Date__c             = Date.today().addDays(10),

            // Your org's REQUIRED fields
            Brand__c                = 'TeamMD',
            Direction_of_Artwork__c = 'Horizontal',        // or 'Vertical'
            Dimension_Format__c     = '1080x1080',          // any valid format
            Title_on_Artwork__c     = 'Test Creative Title',
            Publishing_Platform__c  = 'LinkedIn'            // or Facebook, Instagram, etc.
        );
    }

    @IsTest
    static void testSendEmail_SuccessfulFlow() {
        Creative_Request__c cr = createValidCreativeRequest();
        insert cr;

        CreativeRequestEmailSender.Input input = new CreativeRequestEmailSender.Input();
        input.recordId = cr.Id;

        Test.startTest();
        List<CreativeRequestEmailSender.Output> results = CreativeRequestEmailSender.sendEmail(
            new List<CreativeRequestEmailSender.Input>{ input }
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
    }

    @IsTest
    static void testSendEmail_BulkProcessing() {
        List<Creative_Request__c> records = new List<Creative_Request__c>();
        for (Integer i = 0; i < 3; i++) {
            Creative_Request__c cr = createValidCreativeRequest();
            cr.Name = 'CR-BULK-' + i;
            cr.Title_on_Artwork__c = 'Bulk Title ' + i;
            records.add(cr);
        }
        insert records;

        List<CreativeRequestEmailSender.Input> inputs = new List<CreativeRequestEmailSender.Input>();
        for (Creative_Request__c cr : records) {
            CreativeRequestEmailSender.Input inp = new CreativeRequestEmailSender.Input();
            inp.recordId = cr.Id;           // Correct way – no named parameters!
            inputs.add(inp);
        }

        Test.startTest();
        List<CreativeRequestEmailSender.Output> results = CreativeRequestEmailSender.sendEmail(inputs);
        Test.stopTest();

        System.assertEquals(3, results.size());
    }

    @IsTest
    static void testSendEmail_NoRecordId() {
        CreativeRequestEmailSender.Input inp = new CreativeRequestEmailSender.Input();
        // recordId is null by default

        Test.startTest();
        List<CreativeRequestEmailSender.Output> results = CreativeRequestEmailSender.sendEmail(
            new List<CreativeRequestEmailSender.Input>{ inp }
        );
        Test.stopTest();

        System.assertEquals('Creative Request not found: null', results[0].message);
    }

    @IsTest
    static void testSendEmail_InvalidRecordId() {
        CreativeRequestEmailSender.Input inp = new CreativeRequestEmailSender.Input();
        inp.recordId = '001xx000003DGPyXXX';

        Test.startTest();
        List<CreativeRequestEmailSender.Output> results = CreativeRequestEmailSender.sendEmail(
            new List<CreativeRequestEmailSender.Input>{ inp }
        );
        Test.stopTest();

        System.assertEquals('Creative Request not found: 001xx000003DGPyXXX', results[0].message);
    }

    @IsTest
    static void testSendEmail_EmptyInput() {
        Test.startTest();
        List<CreativeRequestEmailSender.Output> results = CreativeRequestEmailSender.sendEmail(null);
        Test.stopTest();

        System.assertEquals('No input requests provided.', results[0].message);
    }
}