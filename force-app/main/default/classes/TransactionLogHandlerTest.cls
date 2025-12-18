@isTest
public class TransactionLogHandlerTest {
    @isTest 
    static void testDoHandleException() {
        Account acc = new Account();
        try {
            insert acc;
        } catch(Exception ex) {
            System.debug('::: Exception - '+ex.getMessage());
            TransactionLogHandler.doHandleException(ex, 'TransactionLogHandlerTest', 'testDoHandleException');
        }
    }
    
    @isTest 
    static void testDoHandleCustomException() {
        Account acc = new Account();
        try {
            insert acc;
        } catch(Exception ex) {
            System.debug('::: Exception - '+ex.getMessage());
            TransactionLogHandler.doHandleCustomException(ex, 'Custom Error Message', 'TransactionLogHandlerTest', 'testDoHandleException');
        }
    }
    
    @isTest 
    static void testDoHandleCustomMessage() {
        TransactionLogHandler.doHandleCustomException('Custom Log Message not Exception log', 'Custom Error Message', 'TransactionLogHandlerTest', 'testDoHandleException');
    }
}