public with sharing class PatientJSONResponse {
    public class Addresses {
		public Integer id {get;set;} 
		public String line1 {get;set;} 
		public String line2 {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public Integer state_id {get;set;} 
		public String state_code {get;set;} 
		public String zip {get;set;} 
		public Integer country_id {get;set;} 
		public String country_name {get;set;} 
		public Boolean is_primary {get;set;} 

		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'line1') {
							line1 = parser.getText();
						} else if (text == 'line2') {
							line2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'state_id') {
							state_id = parser.getIntegerValue();
						} else if (text == 'state_code') {
							state_code = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country_id') {
							country_id = parser.getIntegerValue();
						} else if (text == 'country_name') {
							country_name = parser.getText();
						} else if (text == 'is_primary') {
							is_primary = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Patient patient {get;set;} 

	public PatientJSONResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'patient') {
						patient = new Patient(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'PatientJSONResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Phones {
		public Integer id {get;set;} 
		public String phone_number {get;set;} 
		public Integer phone_type {get;set;} 
		public String phone_ext {get;set;} 
		public Boolean is_primary {get;set;} 

		public Phones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'phone_type') {
							phone_type = parser.getIntegerValue();
						} else if (text == 'phone_ext') {
							phone_ext = parser.getText();
						} else if (text == 'is_primary') {
							is_primary = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Phones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Addresses_Z {
		public Integer id {get;set;} 
		public String line1 {get;set;} 
		public String line2 {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public Integer state_id {get;set;} 
		public String state_code {get;set;} 
		public String zip {get;set;} 
		public Integer country_id {get;set;} 
		public String country_name {get;set;} 
		public String country_code {get;set;} 
		public Object county_fips {get;set;} 
		public Object county_name {get;set;} 
		public Boolean is_primary {get;set;} 

		public Addresses_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'line1') {
							line1 = parser.getText();
						} else if (text == 'line2') {
							line2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'state_id') {
							state_id = parser.getIntegerValue();
						} else if (text == 'state_code') {
							state_code = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country_id') {
							country_id = parser.getIntegerValue();
						} else if (text == 'country_name') {
							country_name = parser.getText();
						} else if (text == 'country_code') {
							country_code = parser.getText();
						} else if (text == 'county_fips') {
							county_fips = parser.readValueAs(Object.class);
						} else if (text == 'county_name') {
							county_name = parser.readValueAs(Object.class);
						} else if (text == 'is_primary') {
							is_primary = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Responsible_party {
		public Integer responsible_party_person_relationship_type_id {get;set;} 
		public String responsible_party_person_relationship_type_name {get;set;} 
		public String responsible_party_person_relationship_type_code {get;set;} 
		public Integer id {get;set;} 
		public String name {get;set;} 
		public String last_name {get;set;} 
		public String first_name {get;set;} 
		public Object middle {get;set;} 
		public String dob {get;set;} 
		public Integer gender_id {get;set;} 
		public String gender {get;set;} 
		public List<Addresses> addresses {get;set;} 
		public List<Phones> phones {get;set;} 

		public Responsible_party(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'responsible_party_person_relationship_type_id') {
							responsible_party_person_relationship_type_id = parser.getIntegerValue();
						} else if (text == 'responsible_party_person_relationship_type_name') {
							responsible_party_person_relationship_type_name = parser.getText();
						} else if (text == 'responsible_party_person_relationship_type_code') {
							responsible_party_person_relationship_type_code = parser.getText();
						} else if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'middle') {
							middle = parser.readValueAs(Object.class);
						} else if (text == 'dob') {
							dob = parser.getText();
						} else if (text == 'gender_id') {
							gender_id = parser.getIntegerValue();
						} else if (text == 'gender') {
							gender = parser.getText();
						} else if (text == 'addresses') {
							addresses = arrayOfAddresses(parser);
						} else if (text == 'phones') {
							phones = arrayOfPhones(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Responsible_party consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Insurance_policies {

		public Insurance_policies(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Insurance_policies consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Insurance_profiles {
		public Integer id {get;set;} 
		public Boolean self_pay {get;set;} 
		public List<Insurance_policies> insurance_policies {get;set;} 

		public Insurance_profiles(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'self_pay') {
							self_pay = parser.getBooleanValue();
						} else if (text == 'insurance_policies') {
							insurance_policies = arrayOfInsurance_policies(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Insurance_profiles consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Patient {
		public String id {get;set;} 
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public Object middle_initial {get;set;} 
		public Object prefix {get;set;} 
		public Object suffix {get;set;} 
		public Object preferred_name {get;set;} 
		public Object ssn {get;set;} 
		public String name {get;set;} 
		public String dob {get;set;} 
		public Object email_address {get;set;} 
		public String status {get;set;} 
		public String status_id {get;set;} 
		public Object legacy_patient_id {get;set;} 
		public String chart_number {get;set;} 
		public String account_number {get;set;} 
		public String business_entity_id {get;set;} 
		public String business_entity_name {get;set;} 
		public Interface_Z interface_Z {get;set;} // in json: interface
		public Object date_of_death {get;set;} 
		public Object last_seen_date {get;set;} 
		public Object drivers_license_number {get;set;} 
		public Object drivers_license_state_id {get;set;} 
		public Object drivers_license_state_cc_id {get;set;} 
		public Object marital_status {get;set;} 
		public Object mother_maiden_name {get;set;} 
		public Object language_id {get;set;} 
		public String gender {get;set;} 
		public Integer gender_id {get;set;} 
		public Object ethnicity {get;set;} 
		public Object race_id {get;set;} 
		public Object race {get;set;} 
		public Object race_code {get;set;} 
		public Primary_location primary_location {get;set;} 
		public Object primary_provider_id {get;set;} 
		public Object referring_physician_npi {get;set;} 
		public Object primary_care_physician_npi {get;set;} 
		public Responsible_party responsible_party {get;set;} 
		public List<Insurance_profiles> insurance_profiles {get;set;} 
		public List<Addresses_Z> addresses {get;set;} 
		public List<Phones_Z> phones {get;set;} 
		public Insurance_policies photo {get;set;} 
		public String created_at {get;set;} 
		public String updated_at {get;set;} 
		public Object secondary_race_id {get;set;} 
		public Object tertiary_race_id {get;set;} 
		public String gender_code {get;set;} 

		public Patient(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'middle_initial') {
							middle_initial = parser.readValueAs(Object.class);
						} else if (text == 'prefix') {
							prefix = parser.readValueAs(Object.class);
						} else if (text == 'suffix') {
							suffix = parser.readValueAs(Object.class);
						} else if (text == 'preferred_name') {
							preferred_name = parser.readValueAs(Object.class);
						} else if (text == 'ssn') {
							ssn = parser.readValueAs(Object.class);
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'dob') {
							dob = parser.getText();
						} else if (text == 'email_address') {
							email_address = parser.readValueAs(Object.class);
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'status_id') {
							status_id = parser.getText();
						} else if (text == 'legacy_patient_id') {
							legacy_patient_id = parser.readValueAs(Object.class);
						} else if (text == 'chart_number') {
							chart_number = parser.getText();
						} else if (text == 'account_number') {
							account_number = parser.getText();
						} else if (text == 'business_entity_id') {
							business_entity_id = parser.getText();
						} else if (text == 'business_entity_name') {
							business_entity_name = parser.getText();
						} else if (text == 'interface') {
							interface_Z = new Interface_Z(parser);
						} else if (text == 'date_of_death') {
							date_of_death = parser.readValueAs(Object.class);
						} else if (text == 'last_seen_date') {
							last_seen_date = parser.readValueAs(Object.class);
						} else if (text == 'drivers_license_number') {
							drivers_license_number = parser.readValueAs(Object.class);
						} else if (text == 'drivers_license_state_id') {
							drivers_license_state_id = parser.readValueAs(Object.class);
						} else if (text == 'drivers_license_state_cc_id') {
							drivers_license_state_cc_id = parser.readValueAs(Object.class);
						} else if (text == 'marital_status') {
							marital_status = parser.readValueAs(Object.class);
						} else if (text == 'mother_maiden_name') {
							mother_maiden_name = parser.readValueAs(Object.class);
						} else if (text == 'language_id') {
							language_id = parser.readValueAs(Object.class);
						} else if (text == 'gender') {
							gender = parser.getText();
						} else if (text == 'gender_id') {
							gender_id = parser.getIntegerValue();
						} else if (text == 'ethnicity') {
							ethnicity = parser.readValueAs(Object.class);
						} else if (text == 'race_id') {
							race_id = parser.readValueAs(Object.class);
						} else if (text == 'race') {
							race = parser.readValueAs(Object.class);
						} else if (text == 'race_code') {
							race_code = parser.readValueAs(Object.class);
						} else if (text == 'primary_location') {
							primary_location = new Primary_location(parser);
						} else if (text == 'primary_provider_id') {
							primary_provider_id = parser.readValueAs(Object.class);
						} else if (text == 'referring_physician_npi') {
							referring_physician_npi = parser.readValueAs(Object.class);
						} else if (text == 'primary_care_physician_npi') {
							primary_care_physician_npi = parser.readValueAs(Object.class);
						} else if (text == 'responsible_party') {
							responsible_party = new Responsible_party(parser);
						} else if (text == 'insurance_profiles') {
							insurance_profiles = arrayOfInsurance_profiles(parser);
						} else if (text == 'addresses') {
							addresses = arrayOfAddresses_Z(parser);
						} else if (text == 'phones') {
							phones = arrayOfPhones_Z(parser);
						} else if (text == 'photo') {
							photo = new Insurance_policies(parser);
						} else if (text == 'created_at') {
							created_at = parser.getText();
						} else if (text == 'updated_at') {
							updated_at = parser.getText();
						} else if (text == 'secondary_race_id') {
							secondary_race_id = parser.readValueAs(Object.class);
						} else if (text == 'tertiary_race_id') {
							tertiary_race_id = parser.readValueAs(Object.class);
						} else if (text == 'gender_code') {
							gender_code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Patient consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Interface_Z {
		public Object interface_code {get;set;} 
		public Object interface_password {get;set;} 

		public Interface_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'interface_code') {
							interface_code = parser.readValueAs(Object.class);
						} else if (text == 'interface_password') {
							interface_password = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'Interface_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Primary_location {
		public Object id {get;set;} 
		public Object name {get;set;} 

		public Primary_location(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.readValueAs(Object.class);
						} else if (text == 'name') {
							name = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'Primary_location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Phones_Z {
		public Integer id {get;set;} 
		public String phone_number {get;set;} 
		public Integer phone_type {get;set;} 
		public String phone_ext {get;set;} 
		public Boolean is_primary {get;set;} 
		public String phone_type_code {get;set;} 

		public Phones_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'phone_type') {
							phone_type = parser.getIntegerValue();
						} else if (text == 'phone_ext') {
							phone_ext = parser.getText();
						} else if (text == 'is_primary') {
							is_primary = parser.getBooleanValue();
						} else if (text == 'phone_type_code') {
							phone_type_code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Phones_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PatientJSONResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PatientJSONResponse(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	






    private static List<Insurance_profiles> arrayOfInsurance_profiles(System.JSONParser p) {
        List<Insurance_profiles> res = new List<Insurance_profiles>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Insurance_profiles(p));
        }
        return res;
    }



    private static List<Phones> arrayOfPhones(System.JSONParser p) {
        List<Phones> res = new List<Phones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones(p));
        }
        return res;
    }






    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
        }
        return res;
    }




    private static List<Insurance_policies> arrayOfInsurance_policies(System.JSONParser p) {
        List<Insurance_policies> res = new List<Insurance_policies>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Insurance_policies(p));
        }
        return res;
    }




    private static List<Addresses_Z> arrayOfAddresses_Z(System.JSONParser p) {
        List<Addresses_Z> res = new List<Addresses_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses_Z(p));
        }
        return res;
    }


    private static List<Phones_Z> arrayOfPhones_Z(System.JSONParser p) {
        List<Phones_Z> res = new List<Phones_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones_Z(p));
        }
        return res;
    }

}