public without sharing class AlexTest {
@InvocableMethod(label='Alex Test' description='na')
    public static void compareBuckets(){

  AlexTestReq__mdt mdta_1_Start=[SELECT Bucket_Start__c FROM AlexTestReq__mdt WHERE Friendly_Id__c = 1];
  AlexTestReq__mdt mtda_1_End=[SELECT Bucket_End__c FROM AlexTestReq__mdt WHERE Friendly_Id__c = 1]; 
  
  String bucket1Start = mdta_1_Start.Bucket_Start__c;
  String bucket1End = mtda_1_End.Bucket_End__c;
  
  AlexTestReq__mdt mdta_2_Start=[SELECT Bucket_Start__c FROM AlexTestReq__mdt WHERE Friendly_Id__c = 2];
  AlexTestReq__mdt mtda_2_End=[SELECT Bucket_End__c FROM AlexTestReq__mdt WHERE Friendly_Id__c = 2]; 
  
  String bucket2Start = mdta_2_Start.Bucket_Start__c;
  String bucket2End = mtda_2_End.Bucket_End__c;
  
//if the patient name starts with 'aza', log which bucket the name falls within    
  System.debug('aza within Bucket 1? ' + String.valueOf('aza'.compareTo(Bucket1Start) > 0 && 'aza'.compareTo(Bucket1End) < 0));
   System.debug('aza within Bucket 2? ' + String.valueOf('aza'.compareTo(Bucket2Start) > 0 && 'aza'.compareTo(Bucket2End) < 0));
  
  System.debug('Bucket 1 start: ' + bucket1Start + ' | Bucket 1 end: ' + bucket1End + ' | Bucket 2 start: ' + bucket2Start + ' | Bucket 2 end:  ' + bucket2End);

  }}