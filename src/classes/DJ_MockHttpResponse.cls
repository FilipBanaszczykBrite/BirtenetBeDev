
@IsTest
global with sharing class DJ_MockHttpResponse implements HttpCalloutMock{

    public String expectedEndpoint;
    public String expectedMethod;
    public String expectedBody;
    public Integer expectedCode;
    public String content;

    public DJ_MockHttpResponse(String endpoint, String method, String body, Integer code, String content){
        expectedEndpoint = endpoint;
        expectedMethod = method;
        expectedBody = body;
        expectedCode = code;
        this.content = content;
    }


    global HttpResponse respond(HttpRequest request){
        System.assertEquals(expectedEndpoint, request.getEndpoint());
        System.assertEquals(expectedMethod, request.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', content);
        res.setBody(expectedBody);
        res.setStatusCode(expectedCode);
        return res;
    }
}