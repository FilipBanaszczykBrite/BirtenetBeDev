public with sharing class DJ_DoctorsIntegrationController {


    public List<DJ_DoctorWrapper> searchDoctorsList = new List<DJ_DoctorWrapper>();
    public String queryFirstName {get; set;}
    public String queryLastName {get; set;}
    public String queryEmail {get; set;}
    public String queryCountry {get; set;}
    public String formBirthDate {get; set;}
    public String formStartCareer {get; set;}
    public Boolean doctorCreatorDisplayed {get; set;}
    public Doctor__c newDoctor {get; set;}
    public String selectedDoctorId {get; set;}
    public Boolean isForEdit {get; set;}

    private DJ_DoctorIntegrationCallout callout;

    public DJ_DoctorsIntegrationController(){
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        doctorCreatorDisplayed = false;
        newDoctor = new Doctor__c();
        callout = new DJ_DoctorIntegrationCallout();
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
        newDoctor = new Doctor__c();
        formStartCareer = '';
        formBirthDate = '';
        doctorCreatorDisplayed = true;
    }


    public void openEdit (){
        isForEdit = true;
        newDoctor = new Doctor__c();
        doctorCreatorDisplayed = true;
        for(DJ_DoctorWrapper wrapper : searchDoctorsList){
            if(wrapper.Id == selectedDoctorId){
                newDoctor = DJ_DoctorWrapper.dtoToDoctor(wrapper);
                formBirthDate = String.valueOf(newDoctor.Date_of_Birth__c);
                formStartCareer = String.valueOf(newDoctor.Start_of_career__c);
            }
        }
    }


    public void closePopup(){
        doctorCreatorDisplayed = false;
    }


    public void saveDoctor(){
        if(isForEdit){
            if(checkDates()){
                newDoctor.Date_of_Birth__c = Date.valueOf(formBirthDate);
                newDoctor.Start_of_career__c = Date.valueOf(formStartCareer);
                updateDoctor();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
                closePopup();
            }
        }
        else{
            if(checkDates()){
                newDoctor.Date_of_Birth__c = Date.valueOf(formBirthDate);
                newDoctor.Start_of_career__c = Date.valueOf(formStartCareer);
                postNewDoctor();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IntegrationDateError));
                closePopup();
            }
        }
    }


    public void clear(){
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        searchDoctorsList.clear();
    }


    public void deleteSelectedDoctor(){
        deleteDoctor();
    }


    private void deleteDoctor(){
        HttpResponse response = callout.deleteDoctors(selectedDoctorId);
        if(response.getStatusCode() == 200){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.DeleteSuccessful));
        }
        queryDoctors();
    }


    private void postNewDoctor(){
        HttpResponse response = callout.postDoctor(newDoctor);
        if(response.getStatusCode() == 200){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.CreateSuccessful));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.InsertionError));
        }
        queryDoctors();
        closePopup();
    }


    private void updateDoctor(){
        HttpResponse response = callout.updateDoctor(newDoctor);
        if(response.getStatusCode() == 200){

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.EditSuccesful));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.InsertionError));
        }
        queryDoctors();
        closePopup();
    }


    private void queryDoctors(){
        HttpResponse response = callout.getDoctors(getQueryParams());
        searchDoctorsList.clear();
        if(response.getStatusCode() == 200){
            searchDoctorsList = (List<DJ_DoctorWrapper>) JSON.deserialize(response.getBody(), List<DJ_DoctorWrapper>.class);
        }
    }


    private Boolean checkDates(){
        try{
            Pattern datePattern = Pattern.compile('[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}');
            Matcher matchBirthDate = datePattern.matcher(formBirthDate);
            Matcher matchCareerDate = datePattern.matcher(formBirthDate);
            Date d1 = Date.valueOf(formBirthDate);
            d1 = Date.valueOf(formBirthDate);
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
            queryFirstName = queryFirstName.trim();
            result += 'firstName='+ String.escapeSingleQuotes(queryFirstName.replace(' ', '+')) + '&';
        }
        if(queryLastName != ''){
            queryLastName = queryLastName.trim();
            result += 'lastName='+ String.escapeSingleQuotes(queryLastName.replace(' ', '+')) + '&';
        }
        if(queryEmail != ''){
            queryEmail = queryEmail.trim();
            result += 'email='+ String.escapeSingleQuotes(queryEmail.replace(' ', '+')) + '&';
        }
        if(queryCountry != ''){
            queryCountry = queryCountry.trim();
            result += 'country='+ String.escapeSingleQuotes(queryCountry.replace(' ', '+'));
        }
        return result;
    }
}