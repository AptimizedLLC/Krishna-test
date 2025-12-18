@IsTest
public class PatientSearchJSONResponseTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"patients\": ['+
		'    {'+
		'      \"id\": \"324e90e9-db2d-4a0f-84b7-949e55a3e7ac\",'+
		'      \"first_name\": \"JOHN\",'+
		'      \"last_name\": \"GRIMALDI\",'+
		'      \"middle_initial\": null,'+
		'      \"name\": \"John Grimaldi\",'+
		'      \"dob\": \"1961-01-10T12:00:00-05:00\",'+
		'      \"account_balance\": \"820.0\",'+
		'      \"chart_number\": \"228165186\",'+
		'      \"last_seen_date\": \"2021-08-27T12:00:00-04:00\",'+
		'      \"gender\": \"Male\",'+
		'      \"primary_location_id\": 31304,'+
		'      \"phones\": ['+
		'        {'+
		'          \"phone_number\": \"646-270-1902\",'+
		'          \"extension\": null,'+
		'          \"phone_type_code\": \"C\",'+
		'          \"is_primary\": true'+
		'        }'+
		'      ],'+
		'      \"email\": \"johnmgrimaldi1@gmail.com\",'+
		'      \"photo\": {},'+
		'      \"gender_code\": \"M\"'+
		'    }'+
		'  ]'+
		'}';
		PatientSearchJSONResponse obj = PatientSearchJSONResponse.parse(json);
		System.assert(obj != null);
	}
}