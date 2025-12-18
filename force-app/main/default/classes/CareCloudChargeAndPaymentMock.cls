@isTest
public class CareCloudChargeAndPaymentMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if (req.getEndpoint().contains('charges')) {
            res.setBody(getChargePayload());
            res.setHeader('Link', '<http://test>; rel="last"');
        } else if (req.getEndpoint().contains('transaction')) {
            res.setBody(getPaymentPayload());
            res.setHeader('Link', '<http://test>; rel="last"');
        } else if (req.getEndpoint().contains('access_token')) {
            res.setBody('{"access_token" : "dddf"}');
        }
        res.setStatusCode(200);
        return res;
    }
    
    public class CareCloudChargeAndPaymentFailureMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('charges')) {
                res.setStatusCode(401);
            } else if (req.getEndpoint().contains('transaction')) {
                res.setStatusCode(401);
            } else if (req.getEndpoint().contains('access_token')) {
                res.setBody('{"access_token" : "dddf"}');
                res.setStatusCode(200);
            }
            return res;
        }
    }
    
    
    
    public String getChargePayload() {
        return '[' +
                '  {' +
                '    "id": 238333789,' +
                '    "amount": "155.0",' +
                '    "balance": "155.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "97014 - ELECTRIC STIMULATION THERAPY"' +
                '  },' +
                '  {' +
                '    "id": 238333791,' +
                '    "amount": "200.0",' +
                '    "balance": "200.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "99212 - OFFICE/OUTPATIENT VISIT EST"' +
                '  },' +
                '  {' +
                '    "id": 238333792,' +
                '    "amount": "85.0",' +
                '    "balance": "85.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "98940 - CHIROPRACT MANJ 1-2 REGIONS"' +
                '  },' +
                '  {' +
                '    "id": 238333793,' +
                '    "amount": "200.0",' +
                '    "balance": "200.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "97140 - MANUAL THERAPY 1/> REGIONS"' +
                '  }' +
                ']';
    }
    
    public String getPaymentPayload() {
        return '[' +
                '  {' +
                '    "id": 238333789,' +
                '    "amount": "155.0",' +
                '    "balance": "155.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "97014 - ELECTRIC STIMULATION THERAPY"' +
                '  },' +
                '  {' +
                '    "id": 238333791,' +
                '    "amount": "200.0",' +
                '    "balance": "200.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "99212 - OFFICE/OUTPATIENT VISIT EST"' +
                '  },'+
                '  {'+
                '    "id": 238333792,' +
                '    "amount": "85.0",' +
                '    "balance": "85.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "98940 - CHIROPRACT MANJ 1-2 REGIONS"' +
                '  },' +
                '  {' +
                '    "id": 238333793,' +
                '    "amount": "200.0",' +
                '    "balance": "200.0",' +
                '    "unapplied_credit": 0,' +
                '    "posting_date": "2022-05-31T12:00:00-04:00",' +
                '    "transaction_type": "charge",' +
                '    "transaction_status": "posted",' +
                '    "location_id": 30232,' +
                '    "provider_id": 25293,' +
                '    "attending_provider_id": 25293,' +
                '    "units": "1.0",' +
                '    "description": "97140 - MANUAL THERAPY 1/> REGIONS"' +
                '  }' +
                ']';
    }
}