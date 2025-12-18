public class PatientSearchJSONResponse {

	public List<Patients> patients;

	public class Phones {
		public String phone_number;
		public Object extension;
		public String phone_type_code;
		public Boolean is_primary;
	}

	public class Photo {
	}

	public class Patients {
		public String id;
		public String first_name;
		public String last_name;
		public Object middle_initial;
		public String name;
		public String dob;
		public String account_balance;
		public String chart_number;
		public String last_seen_date;
		public String gender;
		public Integer primary_location_id;
		public List<Phones> phones;
		public String email;
		public Photo photo;
		public String gender_code;
	}

	
	public static PatientSearchJSONResponse parse(String json) {
		return (PatientSearchJSONResponse) System.JSON.deserialize(json, PatientSearchJSONResponse.class);
	}
}