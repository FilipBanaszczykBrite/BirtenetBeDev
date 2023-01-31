@isTest
public with sharing class DJ_HospitalIntegrationTest {


    @isTest
    static void getHospitalsTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.search();
        Test.stopTest();
        System.assert(controller.searchHospitalList.size() > 0);
    }


    @isTest
    static void getHospitalsWithParametersTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        controller.queryName = 'Szpital św. Jadwigi';
        Test.startTest();
        controller.search();
        Test.stopTest();
        System.assert(controller.searchHospitalList.size() > 0);
    }


    @isTest
    static void updateHospitalTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        controller.newHospital =  new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        controller.newHospital.hospitalId = 'id';
        controller.newHospital.name = 'nazwa';
        controller.newHospital.country = 'nazwa';
        controller.newHospital.city = 'nazwa';
        controller.newHospital.street = 'nazwa';
        controller.newHospital.postalCode = 'nazwa';
        controller.newHospital.phone = 'nazwa';
        controller.newHospital.ambulances = 5;
        controller.isForEdit = true;
        Test.startTest();
        controller.saveHospital();
        Test.stopTest();
        System.assertEquals(System.Label.EditSuccesful, ApexPages.getMessages().get(0).getDetail());
    }


    @isTest
    static void postNewHospitalTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        controller.newHospital =  new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        controller.newHospital.name = 'nazwa';
        controller.newHospital.country = 'nazwa';
        controller.newHospital.city = 'nazwa';
        controller.newHospital.street = 'nazwa';
        controller.newHospital.postalCode = 'nazwa';
        controller.newHospital.phone = 'nazwa';
        controller.newHospital.ambulances = 5;
        controller.isForEdit = false;
        Test.startTest();
        controller.saveHospital();
        Test.stopTest();
        System.assertEquals(System.Label.CreateSuccessful, ApexPages.getMessages().get(0).getDetail());
    }


    @isTest
    static void deleteHospitalTest() {
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        controller.selectedHospitalId =  'id';
        Test.startTest();
        controller.deleteSelectedHospital();
        Test.stopTest();
        System.assertEquals(System.Label.DeleteSuccessful, ApexPages.getMessages().get(0).getDetail());
    }


    @IsTest
    static void clearQueryTest(){
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.clear();
        Test.stopTest();
        System.assert(controller.queryName == '' && controller.queryCity == '');
    }


    @IsTest
    static void closePopupTest(){
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.closePopup();
        Test.stopTest();
        System.assert(!controller.hospitalCreatorDisplayed);
    }


    @IsTest
    static void editPopupTest(){
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.openEdit();
        Test.stopTest();
        System.assert(controller.hospitalCreatorDisplayed && controller.isForEdit);
    }


    @IsTest
    static void createPopupTest(){
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        Test.startTest();
        controller.openNewHospital();
        Test.stopTest();
        System.assert(controller.hospitalCreatorDisplayed && !controller.isForEdit);
    }

    @IsTest
    static void resultCountTest(){
        List<DJ_MockWebService> testResp = new List<DJ_MockWebService>();
        testResp.add(new DJ_MockWebService());
        Test.setMock(WebServiceMock.class, new DJ_MultiSoapMock(testResp));
        Test.startTest();
        DJ_HospitalIntegrationController controller = new DJ_HospitalIntegrationController();
        controller.searchHospitalList = new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>(3);
        Test.stopTest();
        System.assert(controller.getResultsCount() == 3);
    }
}