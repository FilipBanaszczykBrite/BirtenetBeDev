

public with sharing class DJ_DoctorsIntegrationController {


    public List<DJ_DoctorWrapper> searchDoctorsList = new List<DJ_DoctorWrapper>();
    public String queryFirstName {get; set;}
    public String queryLastName {get; set;}
    public String queryEmail {get; set;}
    public String queryCountry {get; set;}
    public Integer resultPageSize {get; set;}
    public Integer currentPage {get; set;}
    public Integer noOfRecords{get; set;}
    public Boolean doctorCreatorDisplayed {get; set;}
    public DJ_DoctorWrapper newDoctor {get; set;}
//    public ApexPages.StandardSetController setCon {
//        get {
//            if(setCon == null) {
//                setCon = new ApexPages.StandardSetController(queryDoctors());
//                setCon.setPageSize(resultPageSize);
//                noOfRecords = setCon.getResultSize();
//            }
//            return setCon;
//        }
//        set;
//    }

    private final String baseQuery = 'https://wise-fox-flobac-dev-ed.trailblaze.my.salesforce.com/services/apexrest/v1/Doctor';
    private String currentQuery = baseQuery;
    private String accessToken;


    public DJ_DoctorsIntegrationController(){
        resultPageSize = 10;
        currentPage = 1;
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        doctorCreatorDisplayed = false;
        newDoctor = new DJ_DoctorWrapper();
        accessToken = DJ_AuthenticationTokenGetter.getToken();
    }


    public List<DJ_DoctorWrapper> getDoctors() {
        return queryDoctors();
    }


    public Integer getResultsCount(){
        return searchDoctorsList.size();
    }


    public void search(){

    }

    public void newDoctor(){
        doctorCreatorDisplayed = true;
    }


    public void postNewDoctor(){
        doctorCreatorDisplayed = false;
    }


    public void clear(){
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        //setCon = new ApexPages.StandardSetController(queryDoctors());
        //setCon.setPageSize(resultPageSize);
        //noOfRecords = setCon.getResultSize();
    }


    public PageReference refreshPageSize() {
        //setCon.setPageSize(resultPageSize);
        return null;
    }


    private List<DJ_DoctorWrapper> queryDoctors(){
        System.debug('GET ' + baseQuery + getQueryParams());
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        List<DJ_DoctorWrapper> result = new List<DJ_DoctorWrapper>();
        request.setEndpoint(baseQuery + getQueryParams());
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = httpCls.send(request);
        System.debug(response);
        if(response.getStatusCode() == 200){
            result = (List<DJ_DoctorWrapper>) JSON.deserialize(response.getBody(), List<DJ_DoctorWrapper>.class);
            System.debug(result.size());
        }
        return result;
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