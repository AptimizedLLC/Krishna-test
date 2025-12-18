@IsTest
public class SnowFlakeResponseTest
{
    @IsTest
    static void testSnowFlakeResponseProperties() 
    {

        SnowFlakeResponse response = new SnowFlakeResponse();
        String expectedPatientId = '12345';
        String expectedTotalUnits = '10';
        String expectedProcedureCodeDesc = 'Procedure A';

        response.patientId = expectedPatientId;
        response.totalUnits = expectedTotalUnits;
        response.procedureCodeDesc = expectedProcedureCodeDesc;
    }
}