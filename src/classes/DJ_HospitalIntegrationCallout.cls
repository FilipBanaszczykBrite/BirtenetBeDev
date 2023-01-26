public with sharing class DJ_HospitalIntegrationCallout {

    private String sessionId;
    private Cache.SessionPartition partition = Cache.Session.getPartition('local.SoapSessionIdCache');


    public void login(){
        DJ_Credentials__c login = DJ_Credentials__c.getInstance(UserInfo.getUserId());
        partnerSoapSforceCom.Soap soapObj = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = soapObj.login(login.username__c, login.password__c);
        sessionId = loginResult.sessionId;
        partition.put('sessionId', sessionId);
    }

    
    public List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO> getHospitals(String queryName, String queryCity){
        soapSforceComSchemasClassHmHospital.HM_HospitalWebService apiO = new soapSforceComSchemasClassHmHospital.HM_HospitalWebService();
        soapSforceComSchemasClassHmHospital.SessionHeader_element apiSH = new soapSforceComSchemasClassHmHospital.SessionHeader_element();
        try{
            apiSH.sessionId = partition.get('sessionId').toString();
            apiSH.sessionId = sessionId;
            apiO.SessionHeader = apiSH;
            return (List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>) apiO.getHospitals(queryName, queryCity);
        }
        catch (Exception e){
            login();
        }
        apiSH.sessionId = sessionId;
        apiO.SessionHeader = apiSH;
        return (List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>) apiO.getHospitals(queryName, queryCity);
    }


    public Boolean deleteHospital(String id){
        soapSforceComSchemasClassHmHospital.HM_HospitalWebService apiO = new soapSforceComSchemasClassHmHospital.HM_HospitalWebService();
        soapSforceComSchemasClassHmHospital.SessionHeader_element apiSH = new soapSforceComSchemasClassHmHospital.SessionHeader_element();
        try{
            apiSH.sessionId = partition.get('sessionId').toString();
            apiSH.sessionId = sessionId;
            apiO.SessionHeader = apiSH;
            List<String> removed = apiO.deleteHospitals(new List<String>{id});
            return removed == null;
        }
        catch (Exception e){
            login();
        }
        apiSH.sessionId = sessionId;
        apiO.SessionHeader = apiSH;
        List<String> removed = apiO.deleteHospitals(new List<String>{id});
        return removed == null;
    }


    public Boolean postHospital(soapSforceComSchemasClassHmHospital.HM_HospitalDTO dto){
        soapSforceComSchemasClassHmHospital.HM_HospitalWebService apiO = new soapSforceComSchemasClassHmHospital.HM_HospitalWebService();
        soapSforceComSchemasClassHmHospital.SessionHeader_element apiSH = new soapSforceComSchemasClassHmHospital.SessionHeader_element();
        try{
            apiSH.sessionId = partition.get('sessionId').toString();
            apiSH.sessionId = sessionId;
            apiO.SessionHeader = apiSH;
            List<String> inserted = apiO.insertHospitals(new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>{dto});
            return inserted == null;
        }
        catch (Exception e){
            login();
        }
        apiSH.sessionId = sessionId;
        apiO.SessionHeader = apiSH;
        List<String> inserted = apiO.insertHospitals(new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>{dto});
        return inserted == null;
    }


    public Boolean putHospital(soapSforceComSchemasClassHmHospital.HM_HospitalDTO dto){
        soapSforceComSchemasClassHmHospital.HM_HospitalWebService apiO = new soapSforceComSchemasClassHmHospital.HM_HospitalWebService();
        soapSforceComSchemasClassHmHospital.SessionHeader_element apiSH = new soapSforceComSchemasClassHmHospital.SessionHeader_element();
        try{
            apiSH.sessionId = partition.get('sessionId').toString();
            apiSH.sessionId = sessionId;
            apiO.SessionHeader = apiSH;
            List<String> updated = apiO.updateHospitals(new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>{dto});
            return updated == null;
        }
        catch (Exception e){
            login();
        }
        apiSH.sessionId = sessionId;
        apiO.SessionHeader = apiSH;
        List<String> updated = apiO.updateHospitals(new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>{dto});
        return updated == null;
    }
}