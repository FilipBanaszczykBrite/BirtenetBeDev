public with sharing class DJ_DoctorsIntegrationController {


    public List<DJ_DoctorWrapper> searchDoctorsList = new List<DJ_DoctorWrapper>();
    public String queryFirstName {get; set;}
    public String queryLastName {get; set;}
    public String queryEmail {get; set;}
    public String queryCountry {get; set;}
    public String formDateOfBirth {get; set;}
    public String formStartOfCareer {get; set;}
    public Integer resultPageSize {get; set;}
    public Integer currentPage {get; set;}
    public Integer noOfRecords{get; set;}
    public Boolean doctorCreatorDisplayed {get; set;}
    public DJ_DoctorWrapper newDoctor {get; set;}
    public String selectedDoctorId {get; set;}
    public Boolean isForEdit {get; set;}

    private final String baseEndpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
    private String accessToken;


    public DJ_DoctorsIntegrationController(){
        resultPageSize = 10;
        currentPage = 1;
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        formDateOfBirth = '';
        formStartOfCareer = '';
        doctorCreatorDisplayed = false;
        newDoctor = new DJ_DoctorWrapper();
        accessToken = DJ_AuthenticationTokenGetter.getToken();
        queryDoctors();
    }


    public List<DJ_DoctorWrapper> getDoctors() {
        return searchDoctorsList;
    }


    public Integer getResultsCount(){
        return searchDoctorsList.size();
    }


    public void search(){
        queryDoctors();
    }


    public void openNewDoctor(){
        isForEdit = false;
        newDoctor = new DJ_DoctorWrapper();
        doctorCreatorDisplayed = true;
    }


    public void openEdit (){
        isForEdit = true;
        doctorCreatorDisplayed = true;
        for(DJ_DoctorWrapper wrapper : searchDoctorsList){
            if(wrapper.Id == selectedDoctorId){
                newDoctor = wrapper;
            }
        }
    }


    public void closePopup(){
        doctorCreatorDisplayed = false;
    }


    public void saveDoctor(){
        if(checkDates()){
            doctorCreatorDisplayed = false;
            if(isForEdit){
                updateDoctor();
            }
            else{
                postNewDoctor();
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
            closePopup();
        }
    }


    public void clear(){
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        searchDoctorsList.clear();
    }


    public PageReference refreshPageSize() {
        return null;
    }


    public void deleteSelectedDoctor(){
        deleteDoctor();
    }


    private void deleteDoctor(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/json');
        List<Id> wrappers = new List<Id>{selectedDoctorId};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "ids": '+ body + ' }');
        HttpResponse response = httpCls.send(request);
        if(response.getStatusCode() == 200){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.DeleteSuccessful));
        }
        queryDoctors();
    }


    private void postNewDoctor(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        List<DJ_DoctorWrapper> wrappers = new List<DJ_DoctorWrapper>{newDoctor};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "wrappers": '+ body + ' }');
        HttpResponse response = httpCls.send(request);
        if(response.getStatusCode() == 200){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.CreateSuccessful));
        }
        queryDoctors();
    }


    private void updateDoctor(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        List<DJ_DoctorWrapper> wrappers = new List<DJ_DoctorWrapper>{newDoctor};
        String body = JSON.serialize(wrappers);
        request.setBody('{ "wrappers": '+ body + ' }');
        HttpResponse response = httpCls.send(request);
        if(response.getStatusCode() == 200){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.EditSuccesful));
        }
        queryDoctors();
    }


    private void queryDoctors(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = httpCls.send(request);
        System.debug(response);
        if(response.getStatusCode() == 200){
            searchDoctorsList = (List<DJ_DoctorWrapper>) JSON.deserialize(response.getBody(), List<DJ_DoctorWrapper>.class);
        }
    }


    private Boolean checkDates(){
        Pattern datePattern = Pattern.compile('[0-9]{4}-[0-2][0-9]-[0-2][0-9]');
        Matcher matchBirthDate = datePattern.matcher(newDoctor.dateOfBirth);
        Matcher matchCareerDate = datePattern.matcher(newDoctor.startOfCareer);
        return matchBirthDate.matches() && matchCareerDate.matches();
    }


    private String getQueryParams(){
        if(queryFirstName == '' && queryLastName == '' && queryEmail == '' && queryCountry == ''){
            return '';
        }
        String result = '?';
        if(queryFirstName != ''){
            result += 'firstName='+ String.escapeSingleQuotes(queryFirstName) + '&';
        }
        if(queryLastName != ''){
            result += 'lastName='+ String.escapeSingleQuotes(queryLastName) + '&';
        }
        if(queryEmail != ''){
            result += 'email='+ String.escapeSingleQuotes(queryEmail) + '&';
        }
        if(queryCountry != ''){
            result += 'country='+ String.escapeSingleQuotes(queryCountry);
        }
        return result;
    }
}