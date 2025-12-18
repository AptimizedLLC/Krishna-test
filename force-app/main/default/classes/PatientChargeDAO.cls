public inherited sharing class PatientChargeDAO {
	
    private final static String CHARGE_TYPE = 'charge';
    private final static String REVERSE_CHARGE_TYPE = 'charge_reversal';
    private final static String PATIENT_PAYMENT_TYPE = 'patient_payment';
    private final static String INSURANCE_PAYMENT_TYPE = 'insurance_payment';
    
    public static CCPaymentAndChargeSyncSetting__mdt getSyncSetting(){
        return CCPaymentAndChargeSyncSetting__mdt.getInstance('IncrementalSync');
    }
    
    public static Boolean isValidTransactionTypes(String transactionType) {
        if (String.isNotBlank(transactionType)) {
            if (
                CHARGE_TYPE == transactionType.toLowerCase()
                ||
                REVERSE_CHARGE_TYPE == transactionType.toLowerCase()
                ||
	            PATIENT_PAYMENT_TYPE == transactionType.toLowerCase()
                ||
                INSURANCE_PAYMENT_TYPE == transactionType.toLowerCase()
            ) {
                return true;
            }
        }
        return false;
    }
    
    public static List<CareCloud_Charge__c> createCharges(String accountId, List<Object> rawCharges) {
		List<CareCloud_Charge__c> charges = new List<CareCloud_Charge__c>();
        if (rawCharges != null && rawCharges.size() > 0) {
            for (Object rawChargeObj: rawCharges) {
                Map<String, Object> rawCharge = (Map<String, Object>) rawChargeObj;
                if (isValidTransactionTypes((String) rawCharge.get('transaction_type'))) {
                    charges.add(
                        new CareCloud_Charge__c (
                            Amount__c = getDecimal(rawCharge.get('amount')),
                            Attending_Provider_Id__c = getInt2String(rawCharge.get('attending_provider_id')),
                            Balance__c = getDecimal(rawCharge.get('balance')),
                            CareCloud_Charges_Id__c = getInt2String(rawCharge.get('id')),
                            Description__c = (String) rawCharge.get('description'),
                            Location_Id__c = getInt2String(rawCharge.get('location_id')),
                            Diagnosis_Code_s__c = (String) rawCharge.get('diagnosis_code(s)'),
                            Procedure_Code__c = (String) rawCharge.get('procedure_code'),
                            Posting_Date__c = formatDatetime((String) rawCharge.get('posting_date')),
                            Provider_Id__c = getInt2String(rawCharge.get('provider_id')),
                            Service_Date__c = rawCharge.get('service_date') != null ? formatDatetime((String) rawCharge.get('service_date')).date() : null,
                            Transaction_Status__c = (String) rawCharge.get('transaction_status'),
                            Transaction_Type__c = (String) rawCharge.get('transaction_type'),
                            Unapplied_Credit__c = getDecimal(rawCharge.get('unapplied_credit')),
                            Units__c = (String) rawCharge.get('units'),
                            Account__c = accountId
                        )
                	);
                }
            }
        }
        return charges;
    }
    
    public static void commitCharges(List<CareCloud_Charge__c> charges) {
    	if (charges.size() > 0) {
        	upsert charges CareCloud_Charges_Id__c;
        }
    }
    
    public static Datetime formatDatetime(String dt) {
        if (String.isBlank(dt)) {
            return null;
        }
        return Datetime.valueOf(dt.substring(0, 18).replace('T', ' '));
    }
    
    // payments
    
    public static List<CareCloud_Payment__c> createPayments(String accountId, List<Object> rawpayments) {
        system.debug(rawpayments);
		List<CareCloud_Payment__c> payments = new List<CareCloud_Payment__c>();
        if (rawpayments != null && rawpayments.size() > 0) {
            for (Object rawPaymentObj: rawpayments) {
                Map<String, Object> rawPayment = (Map<String, Object>) rawPaymentObj;
               if (isValidTransactionTypes((String) rawPayment.get('transaction_type'))) {
                    payments.add(
                        new CareCloud_Payment__c(
                            Amount__c = getDecimal(rawPayment.get('amount')),
                            Attending_Provider_Id__c = getInt2String(rawPayment.get('attending_provider_id')),
                            Balance__c = getDecimal(rawPayment.get('balance')),
                            CareCloud_Payment_Id__c = getInt2String(rawPayment.get('id')),
                            Description__c = (String) rawPayment.get('description'),
                            Location_Id__c = getInt2String(rawPayment.get('location_id')),
                            Posting_Date__c = formatDatetime((String) rawPayment.get('posting_date')),
                            Provider_Id__c = getInt2String(rawPayment.get('provider_id')),
                            Service_Date__c = rawPayment.get('service_date') != null ? formatDatetime((String) rawPayment.get('service_date')).date() : null,
                            Procedure_Code__c = (String) rawPayment.get('procedure_code'),
                            Transaction_Status__c = (String) rawPayment.get('transaction_status'),
                            Transaction_Type__c = (String) rawPayment.get('transaction_type'),
                            Unapplied_Credit__c = getDecimal(rawPayment.get('unapplied_credit')),
                            Units__c = (String) rawPayment.get('units'),
                            Account__c = accountId
                        )
                    );
               }
            }
        }
        return payments;
    }
    
    public static void commitPayments(List<CareCloud_Payment__c> payments) {
    	if (payments.size() > 0) {
        	upsert payments CareCloud_Payment_Id__c;
        }
    }
    
    private static Decimal getDecimal(Object obj) {
        if (obj instanceof String) {
            return Decimal.valueOf((String) obj);
        }
        return (Decimal) obj;
    }
    
    private static String getInt2String(Object obj) {
        if (obj instanceof Integer) {
            return String.valueOf(obj);
        }
        return (String) obj;
    }
}