@isTest
public class AppointmentJSONResponseTest {
    static testMethod void testAppointmentJSONResponseParse() {
		String json = '['+
		'  {'+
		'    \"appointment\": {'+
		'      \"id\": \"string\",'+
		'      \"appointment_status\": {'+
		'        \"id\": 0,'+
		'        \"code\": \"string\",'+
		'        \"name\": \"string\"'+
		'      },'+
		'      \"patient\": {'+
		'        \"id\": \"string\",'+
		'        \"chart_number\": \"string\",'+
		'        \"date_of_birth\": \"string\",'+
		'        \"first_name\": \"string\",'+
		'        \"last_name\": \"string\",'+
		'        \"middle_initial\": \"string\",'+
		'        \"gender_id\": \"string\",'+
		'        \"email\": \"string\",'+
		'        \"patient_status\": \"string\",'+
		'        \"primary_phone_number\": \"string\"'+
		'      },'+
		'      \"location\": {'+
		'        \"id\": 0,'+
		'        \"name\": \"string\"'+
		'      },'+
		'      \"cancellation_details\": {'+
		'        \"id\": \"string\",'+
		'        \"detail\": \"string\",'+
		'        \"comments\": \"string\"'+
		'      },'+
		'      \"chief_complaint\": \"string\",'+
		'      \"appointment_cancellation_reason_id\": \"string\",'+
		'      \"arrived_at\": \"string\",'+
		'      \"business_entity_id\": 0,'+
		'      \"comments\": \"string\",'+
		'      \"confirmation_details\": \"string\",'+
		'      \"departed_at\": \"string\",'+
		'      \"exam_room_id\": \"string\",'+
		'      \"is_confirmed\": \"string\",'+
		'      \"is_force_overbook\": true,'+
		'      \"patient_contacted\": \"string\",'+
		'      \"recurrence_id\": \"string\",'+
		'      \"recurrence_index\": \"string\",'+
		'      \"referring_physician_npi\": \"string\",'+
		'      \"visit_reason_id\": 0,'+
		'      \"resource_id\": 0,'+
		'      \"provider_id\": \"string\",'+
		'      \"start_time\": \"string\",'+
		'      \"end_time\": \"string\",'+
		'      \"created_at\": \"string\",'+
		'      \"updated_at\": \"string\"'+
		'    }'+
		'  }'+
		']';
		List<AppointmentJSONResponse> obj = AppointmentJSONResponse.parse(json);
		System.assert(obj != null);
	}

}