
@isTest
public with sharing class DJ_HospitalIntegrationTest {


    @isTest
    static void getHospitalsTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService('LOGIN'));
        testResp.add(new DJ_MockWebService('GET'));
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.search();
        Test.stopTest();
        System.assert(controller.searchHospitalList.size() > 0);
    }

    
}