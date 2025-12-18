@isTest
global class AppointmentHttpCalloutMock implements HttpCalloutMock {
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"appointment":{"id":"4ccff41e-7a21-4348-b706-196666c7c986","appointment_status":{"id":1,"code":"P","name":"Pending"},"patient":{"id":"572253a3-4963-4d55-81f0-5082b422c96e","chart_number":"228169380","date_of_birth":"1992-03-18 12:00:00","first_name":"Barry","last_name":"Test","middle_initial":null,"gender_id":"1","email":null,"patient_status":"A","primary_phone_number":"1023456987"},"location":{"id":31304,"name":"EAST BRUNSWICK OFFICE"},"cancellation_details":{"id":null,"detail":null,"comments":null},"chief_complaint":null,"task_id":null,"updated_by_application":null,"appointment_cancellation_reason_id":null,"arrived_at":null,"business_entity_id":5052,"comments":null,"confirmation_details":null,"departed_at":null,"exam_room_id":null,"is_confirmed":false,"is_force_overbook":false,"patient_contacted":null,"recurrence_id":null,"recurrence_index":null,"referring_physician_npi":null,"visit_reason_id":93229,"resource_id":25221,"provider_id":"25280","start_time":"2022-04-01T16:45:00-04:00","end_time":"2022-04-01T17:00:00-04:00","created_at":"2022-03-31T15:27:04-04:00","updated_at":"2022-03-31T15:27:04-04:00"}}]');
        response.setStatusCode(201);
        return response; 
    }
}