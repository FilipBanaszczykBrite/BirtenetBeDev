
@IsTest
global with sharing class DJ_DoctorIntegrationTest {


    @IsTest
    global static void getDoctorsTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';//TODO endopinty
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        Test.startTest();
        controller.search();
        Test.stopTest();
        System.assertNotEquals(0, controller.searchDoctorsList.size());
    }


    @IsTest
    global static void getDoctorsWithQueryTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(Country__c='Polska'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getQueryMock = new DJ_MockHttpResponse(endpoint+'?country=Polska', method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(getQueryMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.queryCountry = 'Polska';
        Test.startTest();
        controller.search();
        Test.stopTest();
        System.assert(controller.searchDoctorsList.get(0).country == 'Polska');
    }


    @IsTest
    global static void postDoctorTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor' ;
        String method = 'POST';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(First_Name__c='Janek'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse postMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, 'GET', body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(postMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.isForEdit = false;
        controller.newDoctor = new Doctor__c(First_Name__c='Janek');
        Test.startTest();
        controller.formBirthDate = '1990-10-10';
        controller.formStartCareer = '2020-10-10';
        controller.saveDoctor();
        controller.queryFirstName = 'Janek';
        Test.stopTest();
        System.assert(ApexPages.getMessages().get(0).getDetail() == System.Label.CreateSuccessful);
    }


    @IsTest
    global static void invalidDatePostDoctorTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor' ;
        String method = 'POST';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(First_Name__c='Janek'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse postMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, 'GET', body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(postMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.isForEdit = false;
        controller.newDoctor = new Doctor__c(First_Name__c='Janek');
        Test.startTest();
        controller.saveDoctor();
        controller.queryFirstName = 'Janek';
        Test.stopTest();

        System.assert(ApexPages.getMessages().get(0).getDetail() == System.Label.IntegrationDateError);
    }


    @IsTest
    global static void putDoctorTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor' ;
        String method = 'PUT';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(First_Name__c='Janek'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse putMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, 'GET', body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(putMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.isForEdit = true;
        controller.newDoctor = new Doctor__c(Id='a0068000006iS9oAAE', First_Name__c='Janek');
        Test.startTest();
        controller.formBirthDate = '1990-10-10';
        controller.formStartCareer = '2020-10-10';
        controller.saveDoctor();
        controller.queryFirstName = 'Janek';
        Test.stopTest();
        System.assertEquals(ApexPages.getMessages().get(0).getDetail(), System.Label.EditSuccesful);
    }


    @IsTest
    global static void invalidDatePutDoctorTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor' ;
        String method = 'PUT';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(First_Name__c='Janek'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse putMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, 'GET', body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(putMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.isForEdit = true;
        controller.newDoctor = new Doctor__c(Id='a0068000006iS9oAAE', First_Name__c='Janek');
        Test.startTest();
        controller.saveDoctor();
        controller.queryFirstName = 'Janek';
        Test.stopTest();
        System.assertEquals(ApexPages.getMessages().get(0).getDetail(), System.Label.IntegrationDateError);
    }


    @IsTest
    global static void deleteDoctorTest(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor' ;
        String method = 'DELETE';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c(First_Name__c='Janek'))) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse deleteMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, 'GET', body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        mocks.add(deleteMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        controller.isForEdit = true;
        controller.selectedDoctorId = 'a0068000006iS9oAAE';
        Test.startTest();
        controller.deleteSelectedDoctor();
        Test.stopTest();
        System.assertEquals(ApexPages.getMessages().get(0).getDetail(), System.Label.DeleteSuccessful);
    }


    @IsTest
    static void testEditPopupFlags(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        Test.startTest();
        controller.openEdit();
        Test.stopTest();
        System.assert(controller.isForEdit && controller.doctorCreatorDisplayed);
    }


    @IsTest
    static void testCreatePopupFlags(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        Test.startTest();
        controller.openNewDoctor();
        Test.stopTest();
        System.assert(!controller.isForEdit && controller.doctorCreatorDisplayed && controller.newDoctor.Id == null);
    }


    @IsTest
    static void testClosePopupFlags(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        Test.startTest();
        controller.closePopup();
        Test.stopTest();
        System.assert(!controller.doctorCreatorDisplayed);
    }

    @IsTest
    static void testClearQueryFields(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        Test.startTest();
        controller.clear();
        Test.stopTest();
        System.assert(controller.queryFirstName == '' && controller.queryLastName == '' && controller.queryEmail == '' && controller.queryCountry == '');
    }


    @IsTest
    static void testResultCount(){
        String loginEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        String endpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
        String method = 'GET';
        String body = '[' + JSON.serialize(new DJ_DoctorWrapper(new Doctor__c())) + ']';
        String content = 'application/json';
        Integer code = 200;
        DJ_MockHttpResponse loginMock = new DJ_MockHttpResponse(loginEndpoint,
                'POST', '{}', 200, 'application/x-www-form-urlencoded');
        DJ_MockHttpResponse getMock = new DJ_MockHttpResponse(endpoint, method, body, code, content);
        List<DJ_MockHttpResponse> mocks = new List<DJ_MockHttpResponse>();
        mocks.add(loginMock);
        mocks.add(getMock);
        DJ_MultiRequestMock multiMock = new DJ_MultiRequestMock(mocks);
        Test.setMock(HttpCalloutMock.class, multiMock);
        DJ_DoctorsIntegrationController controller = new DJ_DoctorsIntegrationController();
        System.assert(controller.getResultsCount() != 0);
    }

}