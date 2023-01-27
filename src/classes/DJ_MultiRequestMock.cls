@IsTest
public with sharing class DJ_MultiRequestMock  implements HttpCalloutMock{
    List<DJ_MockHttpResponse> requests;

    public DJ_MultiRequestMock(List<DJ_MockHttpResponse> requests) { 
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest request) {
        try{
            for (DJ_MockHttpResponse mocks : requests) {
                if (mocks.expectedEndpoint == request.getEndpoint() && mocks.expectedMethod == request.getMethod()) {
                    HttpCalloutMock mock = mocks;
                    System.assertNotEquals(null, request.getEndpoint());
                    return mock.respond(request);
                }
            }
        }
        catch(Exception e){
            System.debug('EXCEPTION ' + e.getMessage());
        }
        return null;
    }
}