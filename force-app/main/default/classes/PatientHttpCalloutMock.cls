@isTest
global class PatientHttpCalloutMock implements HttpCalloutMock {
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"patient":"a0bdae8b-aeb2-4906-966f-88985bec003c"}');
        response.setStatusCode(201);
        return response; 
    }
    
    public class PatientFailureHttpCalloutMock implements HttpCalloutMock {
	// Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(400);
            return response; 
        }
	}
    
}