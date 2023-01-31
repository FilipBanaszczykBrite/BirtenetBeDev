global with sharing class DJ_MultiSoapMock implements WebServiceMock{
    List<DJ_MockWebService> requests;

    public DJ_MultiSoapMock(List<DJ_MockWebService> requests) {
        this.requests = requests;
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        for(DJ_MockWebService mock : requests){
            if(mock != null){
                System.debug(request.toString() + endpoint + soapAction +  requestName +  responseNS +  responseName + responseType);
                mock.doInvoke(stub, request, response, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            }
        }
    }
}