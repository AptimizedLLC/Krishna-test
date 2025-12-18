public class AppointmentJSONResponse {

	public class Appointment {
		public String id;
		public Appointment_status appointment_status;
		public Patient patient;
		public Location location;
		public Cancellation_details cancellation_details;
		public String chief_complaint;
		public String appointment_cancellation_reason_id;
		public String arrived_at;
		public Integer business_entity_id;
		public String comments;
		public String confirmation_details;
		public String departed_at;
		public String exam_room_id;
		public String is_confirmed;
		public Boolean is_force_overbook;
		public String patient_contacted;
		public String recurrence_id;
		public String recurrence_index;
		public String referring_physician_npi;
		public Integer visit_reason_id;
		public Integer resource_id;
		public String provider_id;
		public String start_time;
		public String end_time;
		public String created_at;
		public String updated_at;
	}

	public Appointment appointment;

	public class Cancellation_details {
		public String id;
		public String detail;
		public String comments;
	}

	public class Appointment_status {
		public Integer id;
		public String code;
		public String name;
	}

	public class Patient {
		public String id;
		public String chart_number;
		public String date_of_birth;
		public String first_name;
		public String last_name;
		public String middle_initial;
		public String gender_id;
		public String email;
		public String patient_status;
		public String primary_phone_number;
	}

	public class Location {
		public Integer id;
		public String name;
	}

	
	public static List<AppointmentJSONResponse> parse(String json) {
		return (List<AppointmentJSONResponse>) System.JSON.deserialize(json, List<AppointmentJSONResponse>.class);
	}
}