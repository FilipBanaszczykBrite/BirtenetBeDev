public with sharing class DJ_DoctorIntegrationCallout {

    private String accessToken;
    private final String baseEndpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';

    public DJ_DoctorIntegrationCallout(){
        accessToken = DJ_AuthenticationTokenGetter.getToken();
    }


    public HttpResponse deleteDoctors(String selectedDoctorId){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint);
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/json');
        List<Id> wrappers = new List<Id>{selectedDoctorId};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "ids": '+ body + ' }');
        return httpCls.send(request);
    }


    public HttpResponse postDoctor(Doctor__c newDoctor){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint);
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        DJ_DoctorWrapper wrapper = new DJ_DoctorWrapper(newDoctor);
        List<DJ_DoctorWrapper> wrappers = new List<DJ_DoctorWrapper>{wrapper};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "wrappers": '+ body + ' }');
        return httpCls.send(request);
    }


    public HttpResponse updateDoctor(Doctor__c newDoctor){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint);
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        DJ_DoctorWrapper wrapper = new DJ_DoctorWrapper(newDoctor);
        List<DJ_DoctorWrapper> wrappers = new List<DJ_DoctorWrapper>{wrapper};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "wrappers": '+ body + ' }');
        return httpCls.send(request);
    }


    public HttpResponse getDoctors(String query){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + query);
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        return httpCls.send(request);
    }
}