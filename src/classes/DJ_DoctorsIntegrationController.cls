public with sharing class DJ_DoctorsIntegrationController {


    public List<DJ_DoctorWrapper> searchDoctorsList = new List<DJ_DoctorWrapper>();
    public String queryFirstName {get; set;}
    public String queryLastName {get; set;}
    public String queryEmail {get; set;}
    public String queryCountry {get; set;}
    public Boolean doctorCreatorDisplayed {get; set;}
    public DJ_DoctorWrapper newDoctor {get; set;}
    public String selectedDoctorId {get; set;}
    private Boolean isForEdit {get; set;}
    private Integer counter = 0;

    private final String baseEndpoint = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
    private String accessToken;


    public DJ_DoctorsIntegrationController(){
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
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
        newDoctor.Id = null;
        isForEdit = false;
        doctorCreatorDisplayed = true;
    }


    public void openEdit (){
        System.debug('EDIT OPEN');
        isForEdit = true;
        newDoctor = new DJ_DoctorWrapper();
        doctorCreatorDisplayed = true;
        for(DJ_DoctorWrapper wrapper : searchDoctorsList){
            if(wrapper.Id == selectedDoctorId){
                newDoctor = wrapper;
            }
        }
        System.debug('EDIT OPEN ' + newDoctor);
    }


    public void closePopup(){
        System.debug('CLOSE');
        doctorCreatorDisplayed = false;
    }


    public void saveDoctor(){
        System.debug('SAVE ' + newDoctor);
        System.debug(isForEdit);
        if(isForEdit){
            doctorCreatorDisplayed = false;
            if(checkDates()){
                updateDoctor();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
                closePopup();
            }
        }
        else{
            if(checkDates()){
                postNewDoctor();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
                closePopup();

            }
        }
    }


    public void clear(){
        System.debug('CLEAR ' + newDoctor);
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        searchDoctorsList.clear();
    }


    public void deleteSelectedDoctor(){
        deleteDoctor();
    }

    public void foo(){
        System.debug(counter);
        counter++;
        queryEmail = String.valueOf(counter);
        System.debug(counter);
    }


    private void deleteDoctor(){
        System.debug('DELETE ' + newDoctor);
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
        System.debug('POST ' + newDoctor);
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
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'COULDNT INSERT DOCTOR'));
        }
        System.debug('POST ' + response);
        closePopup();
        queryDoctors();
    }


    private void updateDoctor(){
        System.debug('PUT ' + newDoctor);
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
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'COULDNT UPDATE DOCTOR'));
        }
        System.debug('PUT ' + response.getStatusCode());
        closePopup();
        queryDoctors();
    }


    private void queryDoctors(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + getQueryParams());
        System.debug('GET ' + queryFirstName);
        System.debug('GET ' + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = httpCls.send(request);
        System.debug(response);
        searchDoctorsList.clear();
        if(response.getStatusCode() == 200){
            searchDoctorsList = (List<DJ_DoctorWrapper>) JSON.deserialize(response.getBody(), List<DJ_DoctorWrapper>.class);
        }
    }


    private Boolean checkDates(){
        System.debug('DATES ' + newDoctor);
        try{
            System.debug('DATES ' + newDoctor.startOfCareer + ' ' + newDoctor.dateOfBirth);
            Pattern datePattern = Pattern.compile('[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}');
            Matcher matchBirthDate = datePattern.matcher(newDoctor.dateOfBirth);
            Matcher matchCareerDate = datePattern.matcher(newDoctor.startOfCareer);
            return matchBirthDate.matches() && matchCareerDate.matches();
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
            closePopup();
            return false;
        }

    }


    private String getQueryParams(){
        if(queryFirstName == '' && queryLastName == '' && queryEmail == '' && queryCountry == ''){
            return '';
        }
        String result = '?';
        if(queryFirstName != ''){
            result += 'firstName='+ String.escapeSingleQuotes(queryFirstName.replace(' ', '+')) + '&';
        }
        if(queryLastName != ''){
            result += 'lastName='+ String.escapeSingleQuotes(queryLastName.replace(' ', '+')) + '&';
        }
        if(queryEmail != ''){
            result += 'email='+ String.escapeSingleQuotes(queryEmail.replace(' ', '+')) + '&';
        }
        if(queryCountry != ''){
            result += 'country='+ String.escapeSingleQuotes(queryCountry.replace(' ', '+'));
        }
        return result;
    }
}