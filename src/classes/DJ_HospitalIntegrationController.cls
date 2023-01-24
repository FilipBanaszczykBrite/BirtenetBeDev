public with sharing class DJ_HospitalIntegrationController {


    public List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO> searchHospitalList = new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>();
    public String queryName {get; set;}
    public String queryCity{get; set;}
    public Boolean hospitalCreatorDisplayed {get; set;}
    public soapSforceComSchemasClassHmHospital.HM_HospitalDTO newHospital {get; set;}
    public String selectedHospitalId {get; set;}
    public DJ_HospitalDTO dto {get; set;}
    private Boolean isForEdit {get; set;}
    private final String baseEndpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
    private String sessionId;


    public DJ_HospitalIntegrationController(){
        queryName = '';
        queryCity = '';
        hospitalCreatorDisplayed = false;
        newHospital = new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        newHospital.name = '';
        sessionId = DJ_AuthenticationTokenGetter.getToken();
        get();
    }


    public List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO> getHospitals() {
        return searchHospitalList;
    }


    public Integer getResultsCount(){
        return searchHospitalList.size();
    }


    public void search(){

    }


    public void openNewHospital(){
        newHospital.hospitalId = null;
        isForEdit = false;
        hospitalCreatorDisplayed = true;
    }


    public void openEdit (){
        System.debug('EDIT OPEN');
        isForEdit = true;
        newHospital = new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        hospitalCreatorDisplayed = true;
        for(soapSforceComSchemasClassHmHospital.HM_HospitalDTO wrapper : searchHospitalList){
            if(wrapper.hospitalId == selectedHospitalId){
                newHospital = wrapper;
            }
        }
        System.debug('EDIT OPEN ' + newHospital);
    }


    public void closePopup(){
        System.debug('CLOSE');
        hospitalCreatorDisplayed = false;
    }


    public void saveHospital(){
        System.debug('SAVE ' + newHospital);
        System.debug(isForEdit);
        if(isForEdit){
            hospitalCreatorDisplayed = false;
           //put
        }
        else{
            //post
        }
    }


    public void clear(){
        System.debug('CLEAR ' + newHospital);
        queryName = '';
        queryCity = '';
        searchHospitalList.clear();
    }

    public void deleteSelectedHospital(){

    }



    

    public void get(){
        EnterpriseConnection connection = new EnterpriseConnection();
        soapSforceComSchemasClassHmHospital.HM_HospitalWebService apiO = new soapSforceComSchemasClassHmHospital.HM_HospitalWebService();
        soapSforceComSchemasClassHmHospital.SessionHeader_element apiSH = new soapSforceComSchemasClassHmHospital.SessionHeader_element();
        apiSH.sessionId = '00D680000033UZy!ARYAQD.LQmJpuVVMq_iYu5tWoTenaAuvFCInjWp4wUqdaZQdsucSAkJd_hYXnMODo2z9nbKqnupXmsUE6ULeb1vZBPkTXCO6';
        apiO.SessionHeader = apiSH;
        System.debug(JSON.serialize(apiO.getHospitals('','')));
        searchHospitalList = (List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>) apiO.getHospitals(queryName,queryCity);
    }


}