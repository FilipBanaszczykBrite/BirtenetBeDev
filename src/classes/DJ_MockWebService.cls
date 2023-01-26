
@isTest
global with sharing class DJ_MockWebService implements WebServiceMock{

    public String method;

    public DJ_MockWebService(String method){
        this.method = method;

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
        if(requestName=='getHospitals'){
            soapSforceComSchemasClassHmHospital.getHospitalsResponse_element respElement =
                    new soapSforceComSchemasClassHmHospital.getHospitalsResponse_element();
            respElement.result = new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>{new soapSforceComSchemasClassHmHospital.HM_HospitalDTO()};
            response.put('response_x', respElement);

        }
        else if(requestName=='insertHospitals'){
            soapSforceComSchemasClassHmHospital.insertHospitalsResponse_element respElement =
                    new soapSforceComSchemasClassHmHospital.insertHospitalsResponse_element();
            respElement.result = new List<String>{'id'};
            response.put('response_x', respElement);

        }
        else if(requestName=='updateHospitals'){
            soapSforceComSchemasClassHmHospital.updateHospitalsResponse_element respElement =
                    new soapSforceComSchemasClassHmHospital.updateHospitalsResponse_element();
            respElement.result = new List<String>{'id'};
            response.put('response_x', respElement);

        }
        else if(requestName=='deleteHospitals'){
            soapSforceComSchemasClassHmHospital.deleteHospitalsResponse_element respElement =
                    new soapSforceComSchemasClassHmHospital.deleteHospitalsResponse_element();
            respElement.result = new List<String>{'id'};
            response.put('response_x', respElement);

        }
        else if(requestName == 'login'){
            partnerSoapSforceCom.LoginResult login = new partnerSoapSforceCom.LoginResult();
            login.sessionId = '00D680000033UZy!ARYAQHHmepwv7HajwbzsRoY7q7EmTojaV5sW37hP3LeHQRLqYPnLoh9eMpbUlTA17XdTStEvfzqe.HWio0jL0B3A_FIiISPS';
            partnerSoapSforceCom.loginResponse_element respElement = new partnerSoapSforceCom.loginResponse_element();
            respElement.result = login;
            response.put('response_x', respElement);
        }
    }
}