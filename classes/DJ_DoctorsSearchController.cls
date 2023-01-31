public with sharing class DJ_DoctorsSearchController {

    public List<Doctor__c> searchDoctorsList = new List<Doctor__c>();
    public String queryFirstName {get; set;}
    public String queryLastName {get; set;}
    public String queryEmail {get; set;}
    public String queryCountry {get; set;}
    public Integer resultPageSize {get; set;}
    public Integer currentPage {get; set;}
    public Integer noOfRecords{get; set;}
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(queryDoctors());
                setCon.setPageSize(resultPageSize);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }

    private final String baseQuery = 'SELECT First_Name__c, Last_Name__c, License_Number__c,Email__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c WHERE Id!=null ';
    private String currentQuery = baseQuery;


    public DJ_DoctorsSearchController(){
        resultPageSize = 10;
        currentPage = 1;
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
    }


    public Integer getResultsCount(){
        return searchDoctorsList.size();
    }


    public void search(){
        currentQuery = baseQuery + getQueryParams();
        setCon = new ApexPages.StandardSetController(queryDoctors());
        setCon.setPageSize(resultPageSize);
        noOfRecords = setCon.getResultSize();
    }


    public PageReference refreshPageSize() {
        setCon.setPageSize(resultPageSize);
        return null;
    }


    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) setCon.getRecords();
    }


    public void clear(){
        currentQuery = '';
        queryFirstName = '';
        queryLastName = '';
        queryEmail = '';
        queryCountry = '';
        setCon = new ApexPages.StandardSetController(queryDoctors());
        setCon.setPageSize(resultPageSize);
        noOfRecords = setCon.getResultSize();
    }


    private List<Doctor__c> queryDoctors(){
        if(currentQuery != ''){
            searchDoctorsList = Database.query(currentQuery);
        }
        else{
            searchDoctorsList.clear();
        }
        return searchDoctorsList;
    }


    private String getQueryParams(){
        String result = '';
        if(queryFirstName != ''){
            result += 'AND First_Name__c = \''+ String.escapeSingleQuotes(queryFirstName) + '\' ';
        }
        if(queryLastName != ''){
            result += 'AND Last_Name__c = \''+ String.escapeSingleQuotes(queryLastName) + '\' ';
        }
        if(queryEmail != ''){
            result += 'AND Email__c = \''+ String.escapeSingleQuotes(queryEmail) + '\' ';
        }
        if(queryCountry != ''){
            result += 'AND Country__c = \''+ String.escapeSingleQuotes(queryCountry) + '\'';
        }
        return result;
    }
}