@isTest
public class PatientJSONResponseTest {
    // This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"patient\": {'+
		'    \"id\": \"931ac90a-37c5-4f5a-b9f9-e6df35d3719e\",'+
		'    \"first_name\": \"DEV\",'+
		'    \"last_name\": \"TEST\",'+
		'    \"middle_initial\": null,'+
		'    \"prefix\": null,'+
		'    \"suffix\": null,'+
		'    \"preferred_name\": null,'+
		'    \"ssn\": null,'+
		'    \"name\": \"Dev Test\",'+
		'    \"dob\": \"2022-03-01T12:00:00-05:00\",'+
		'    \"email_address\": null,'+
		'    \"status\": \"active\",'+
		'    \"status_id\": \"A\",'+
		'    \"legacy_patient_id\": null,'+
		'    \"chart_number\": \"228169394\",'+
		'    \"account_number\": \"0705632-1049473125\",'+
		'    \"business_entity_id\": \"ac0565e5-1ff3-4835-be82-3d2e85039bde\",'+
		'    \"business_entity_name\": \"OLD BRIDGE SPINE & WELLNESS CTR PA\",'+
		'    \"interface\": {'+
		'      \"interface_code\": null,'+
		'      \"interface_password\": null'+
		'    },'+
		'    \"date_of_death\": null,'+
		'    \"last_seen_date\": null,'+
		'    \"drivers_license_number\": null,'+
		'    \"drivers_license_state_id\": null,'+
		'    \"drivers_license_state_cc_id\": null,'+
		'    \"marital_status\": null,'+
		'    \"mother_maiden_name\": null,'+
		'    \"language_id\": null,'+
		'    \"gender\": \"Female\",'+
		'    \"gender_id\": 2,'+
		'    \"ethnicity\": null,'+
		'    \"race_id\": null,'+
		'    \"race\": null,'+
		'    \"race_code\": null,'+
		'    \"primary_location\": {'+
		'      \"id\": null,'+
		'      \"name\": null'+
		'    },'+
		'    \"primary_provider_id\": null,'+
		'    \"referring_physician_npi\": null,'+
		'    \"primary_care_physician_npi\": null,'+
		'    \"responsible_party\": {'+
		'      \"responsible_party_person_relationship_type_id\": 1,'+
		'      \"responsible_party_person_relationship_type_name\": \"Self\",'+
		'      \"responsible_party_person_relationship_type_code\": \"18\",'+
		'      \"id\": 56166043,'+
		'      \"name\": \"DEV TEST\",'+
		'      \"last_name\": \"TEST\",'+
		'      \"first_name\": \"DEV\",'+
		'      \"middle\": null,'+
		'      \"dob\": \"2022-03-01T00:00:00+00:00\",'+
		'      \"gender_id\": 2,'+
		'      \"gender\": \"Female\",'+
		'      \"addresses\": ['+
		'        {'+
		'          \"id\": 46604656,'+
		'          \"line1\": \"1234 MAIN ST.\",'+
		'          \"line2\": \"1234 MAIN ST.\",'+
		'          \"city\": \"TAMPA\",'+
		'          \"state\": \"Florida\",'+
		'          \"state_id\": 10,'+
		'          \"state_code\": \"FL\",'+
		'          \"zip\": \"33629\",'+
		'          \"country_id\": 225,'+
		'          \"country_name\": \"UNITED STATES\",'+
		'          \"is_primary\": true'+
		'        }'+
		'      ],'+
		'      \"phones\": ['+
		'        {'+
		'          \"id\": 51484454,'+
		'          \"phone_number\": \"0995554444\",'+
		'          \"phone_type\": 3,'+
		'          \"phone_ext\": \"+1\",'+
		'          \"is_primary\": true'+
		'        }'+
		'      ]'+
		'    },'+
		'    \"insurance_profiles\": ['+
		'      {'+
		'        \"id\": 77022615,'+
		'        \"self_pay\": true,'+
		'        \"insurance_policies\": []'+
		'      }'+
		'    ],'+
		'    \"addresses\": ['+
		'      {'+
		'        \"id\": 46604656,'+
		'        \"line1\": \"1234 MAIN ST.\",'+
		'        \"line2\": \"1234 MAIN ST.\",'+
		'        \"city\": \"TAMPA\",'+
		'        \"state\": \"Florida\",'+
		'        \"state_id\": 10,'+
		'        \"state_code\": \"FL\",'+
		'        \"zip\": \"33629\",'+
		'        \"country_id\": 225,'+
		'        \"country_name\": \"UNITED STATES\",'+
		'        \"country_code\": \"US\",'+
		'        \"county_fips\": null,'+
		'        \"county_name\": null,'+
		'        \"is_primary\": true'+
		'      }'+
		'    ],'+
		'    \"phones\": ['+
		'      {'+
		'        \"id\": 51484454,'+
		'        \"phone_number\": \"0995554444\",'+
		'        \"phone_type\": 3,'+
		'        \"phone_ext\": \"+1\",'+
		'        \"is_primary\": true,'+
		'        \"phone_type_code\": \"C\"'+
		'      }'+
		'    ],'+
		'    \"photo\": {},'+
		'    \"created_at\": \"2022-04-01T11:19:23-04:00\",'+
		'    \"updated_at\": \"2022-04-01T11:19:23-04:00\",'+
		'    \"secondary_race_id\": null,'+
		'    \"tertiary_race_id\": null,'+
		'    \"gender_code\": \"F\"'+
		'  }'+
		'}';
		PatientJSONResponse r = PatientJSONResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Addresses objAddresses = new PatientJSONResponse.Addresses(System.JSON.createParser(json));
		System.assert(objAddresses != null);
		System.assert(objAddresses.id == null);
		System.assert(objAddresses.line1 == null);
		System.assert(objAddresses.line2 == null);
		System.assert(objAddresses.city == null);
		System.assert(objAddresses.state == null);
		System.assert(objAddresses.state_id == null);
		System.assert(objAddresses.state_code == null);
		System.assert(objAddresses.zip == null);
		System.assert(objAddresses.country_id == null);
		System.assert(objAddresses.country_name == null);
		System.assert(objAddresses.is_primary == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse objJSON2Apex = new PatientJSONResponse(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.patient == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Phones objPhones = new PatientJSONResponse.Phones(System.JSON.createParser(json));
		System.assert(objPhones != null);
		System.assert(objPhones.id == null);
		System.assert(objPhones.phone_number == null);
		System.assert(objPhones.phone_type == null);
		System.assert(objPhones.phone_ext == null);
		System.assert(objPhones.is_primary == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Addresses_Z objAddresses_Z = new PatientJSONResponse.Addresses_Z(System.JSON.createParser(json));
		System.assert(objAddresses_Z != null);
		System.assert(objAddresses_Z.id == null);
		System.assert(objAddresses_Z.line1 == null);
		System.assert(objAddresses_Z.line2 == null);
		System.assert(objAddresses_Z.city == null);
		System.assert(objAddresses_Z.state == null);
		System.assert(objAddresses_Z.state_id == null);
		System.assert(objAddresses_Z.state_code == null);
		System.assert(objAddresses_Z.zip == null);
		System.assert(objAddresses_Z.country_id == null);
		System.assert(objAddresses_Z.country_name == null);
		System.assert(objAddresses_Z.country_code == null);
		System.assert(objAddresses_Z.county_fips == null);
		System.assert(objAddresses_Z.county_name == null);
		System.assert(objAddresses_Z.is_primary == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Responsible_party objResponsible_party = new PatientJSONResponse.Responsible_party(System.JSON.createParser(json));
		System.assert(objResponsible_party != null);
		System.assert(objResponsible_party.responsible_party_person_relationship_type_id == null);
		System.assert(objResponsible_party.responsible_party_person_relationship_type_name == null);
		System.assert(objResponsible_party.responsible_party_person_relationship_type_code == null);
		System.assert(objResponsible_party.id == null);
		System.assert(objResponsible_party.name == null);
		System.assert(objResponsible_party.last_name == null);
		System.assert(objResponsible_party.first_name == null);
		System.assert(objResponsible_party.middle == null);
		System.assert(objResponsible_party.dob == null);
		System.assert(objResponsible_party.gender_id == null);
		System.assert(objResponsible_party.gender == null);
		System.assert(objResponsible_party.addresses == null);
		System.assert(objResponsible_party.phones == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Insurance_policies objInsurance_policies = new PatientJSONResponse.Insurance_policies(System.JSON.createParser(json));
		System.assert(objInsurance_policies != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Insurance_profiles objInsurance_profiles = new PatientJSONResponse.Insurance_profiles(System.JSON.createParser(json));
		System.assert(objInsurance_profiles != null);
		System.assert(objInsurance_profiles.id == null);
		System.assert(objInsurance_profiles.self_pay == null);
		System.assert(objInsurance_profiles.insurance_policies == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Patient objPatient = new PatientJSONResponse.Patient(System.JSON.createParser(json));
		System.assert(objPatient != null);
		System.assert(objPatient.id == null);
		System.assert(objPatient.first_name == null);
		System.assert(objPatient.last_name == null);
		System.assert(objPatient.middle_initial == null);
		System.assert(objPatient.prefix == null);
		System.assert(objPatient.suffix == null);
		System.assert(objPatient.preferred_name == null);
		System.assert(objPatient.ssn == null);
		System.assert(objPatient.name == null);
		System.assert(objPatient.dob == null);
		System.assert(objPatient.email_address == null);
		System.assert(objPatient.status == null);
		System.assert(objPatient.status_id == null);
		System.assert(objPatient.legacy_patient_id == null);
		System.assert(objPatient.chart_number == null);
		System.assert(objPatient.account_number == null);
		System.assert(objPatient.business_entity_id == null);
		System.assert(objPatient.business_entity_name == null);
		System.assert(objPatient.interface_Z == null);
		System.assert(objPatient.date_of_death == null);
		System.assert(objPatient.last_seen_date == null);
		System.assert(objPatient.drivers_license_number == null);
		System.assert(objPatient.drivers_license_state_id == null);
		System.assert(objPatient.drivers_license_state_cc_id == null);
		System.assert(objPatient.marital_status == null);
		System.assert(objPatient.mother_maiden_name == null);
		System.assert(objPatient.language_id == null);
		System.assert(objPatient.gender == null);
		System.assert(objPatient.gender_id == null);
		System.assert(objPatient.ethnicity == null);
		System.assert(objPatient.race_id == null);
		System.assert(objPatient.race == null);
		System.assert(objPatient.race_code == null);
		System.assert(objPatient.primary_location == null);
		System.assert(objPatient.primary_provider_id == null);
		System.assert(objPatient.referring_physician_npi == null);
		System.assert(objPatient.primary_care_physician_npi == null);
		System.assert(objPatient.responsible_party == null);
		System.assert(objPatient.insurance_profiles == null);
		System.assert(objPatient.addresses == null);
		System.assert(objPatient.phones == null);
		System.assert(objPatient.photo == null);
		System.assert(objPatient.created_at == null);
		System.assert(objPatient.updated_at == null);
		System.assert(objPatient.secondary_race_id == null);
		System.assert(objPatient.tertiary_race_id == null);
		System.assert(objPatient.gender_code == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Interface_Z objInterface_Z = new PatientJSONResponse.Interface_Z(System.JSON.createParser(json));
		System.assert(objInterface_Z != null);
		System.assert(objInterface_Z.interface_code == null);
		System.assert(objInterface_Z.interface_password == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Primary_location objPrimary_location = new PatientJSONResponse.Primary_location(System.JSON.createParser(json));
		System.assert(objPrimary_location != null);
		System.assert(objPrimary_location.id == null);
		System.assert(objPrimary_location.name == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PatientJSONResponse.Phones_Z objPhones_Z = new PatientJSONResponse.Phones_Z(System.JSON.createParser(json));
		System.assert(objPhones_Z != null);
		System.assert(objPhones_Z.id == null);
		System.assert(objPhones_Z.phone_number == null);
		System.assert(objPhones_Z.phone_type == null);
		System.assert(objPhones_Z.phone_ext == null);
		System.assert(objPhones_Z.is_primary == null);
		System.assert(objPhones_Z.phone_type_code == null);
	}
}