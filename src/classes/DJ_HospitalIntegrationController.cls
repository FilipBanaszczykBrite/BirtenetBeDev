public with sharing class DJ_HospitalIntegrationController {


    public List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO> searchHospitalList = new List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO>();
    public String queryName { get; set; }
    public String queryCity { get; set; }
    public Boolean hospitalCreatorDisplayed { get; set; }
    public soapSforceComSchemasClassHmHospital.HM_HospitalDTO newHospital { get; set; }
    public String selectedHospitalId { get; set; }

    private Boolean isForEdit { get; set; }
    private DJ_HospitalIntegrationCallout callout = new DJ_HospitalIntegrationCallout();


    public DJ_HospitalIntegrationController() {
        queryName = '';
        queryCity = '';
        hospitalCreatorDisplayed = false;
        newHospital = new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        newHospital.name = '';
        searchHospitalList = callout.getHospitals(queryName, queryCity);
    }


    public List<soapSforceComSchemasClassHmHospital.HM_HospitalDTO> getHospitals() {
        return searchHospitalList;
    }


    public Integer getResultsCount() {
        return searchHospitalList.size();
    }


    public void search() {
        searchHospitalList = callout.getHospitals(queryName.trim(), queryCity.trim());
    }


    public void openNewHospital() {
        newHospital.hospitalId = null;
        isForEdit = false;
        hospitalCreatorDisplayed = true;
    }


    public void openEdit() {
        isForEdit = true;
        newHospital = new soapSforceComSchemasClassHmHospital.HM_HospitalDTO();
        hospitalCreatorDisplayed = true;
        for (soapSforceComSchemasClassHmHospital.HM_HospitalDTO wrapper : searchHospitalList) {
            if (wrapper.hospitalId == selectedHospitalId) {
                newHospital = wrapper;
            }
        }
    }


    public void closePopup() {
        hospitalCreatorDisplayed = false;
    }


    public void saveHospital() {
        if (isForEdit) {

            putHospital();
        } else {
            postHospital();
        }
    }


    public void clear(){
        queryName = '';
        queryCity = '';
        searchHospitalList.clear();
    }


    public void deleteSelectedHospital(){
        if(callout.deleteHospital(selectedHospitalId)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.DeleteSuccessful));
        }
        search();
    }


    private void postHospital(){
        if(callout.postHospital(newHospital)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.CreateSuccessful));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.InsertionError));
        }
        closePopup();
        search();
    }


    private void putHospital(){
        if(callout.putHospital(newHospital)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.EditSuccesful));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.InsertionError));
        }
        closePopup();
        search();
    }
}