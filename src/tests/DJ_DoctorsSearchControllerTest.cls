@isTest
public with sharing class DJ_DoctorsSearchControllerTest {

    public static DJ_DoctorsSearchController dsController = new DJ_DoctorsSearchController();

    @TestSetup
    public static void setup(){
        Doctor__c fakeDoctor1 = new Doctor__c(Name = 'Jan K', First_Name__c = 'Jan', Last_Name__c = 'Ka',
                Phone__c = '123456879', Date_of_Birth__c = Date.newInstance(1990, 1, 1),
                Start_of_Career__c = Date.newInstance(2010, 1, 1), License_Number__c = '1235456',
                Speciality__c = 'surgeon', Nationality__c = 'american');
        Doctor__c fakeDoctor2 = new Doctor__c(Name = 'Dan K', First_Name__c = 'Dan', Last_Name__c = 'Kr',
                Phone__c = '123456879', Date_of_Birth__c = Date.newInstance(1990, 1, 1),
                Start_of_Career__c = Date.newInstance(2010, 1, 1), License_Number__c = '1235456',
                Speciality__c = 'surgeon', Nationality__c = 'american');
        Doctor__c fakeDoctor3 = new Doctor__c(Name = 'Ban K', First_Name__c = 'Ban', Last_Name__c = 'Ke',
                Phone__c = '123456879', Date_of_Birth__c = Date.newInstance(1990, 1, 1),
                Start_of_Career__c = Date.newInstance(2010, 1, 1), License_Number__c = '1235456',
                Speciality__c = 'surgeon', Nationality__c = 'american', Email__c = 'test@mail.com');
        Doctor__c fakeDoctor4 = new Doctor__c(Name = 'Zan K', First_Name__c = 'Zan', Last_Name__c = 'Ko',
                Phone__c = '123456879', Date_of_Birth__c = Date.newInstance(1990, 1, 1),
                Start_of_Career__c = Date.newInstance(2010, 1, 1), License_Number__c = '1235456',
                Speciality__c = 'surgeon', Nationality__c = 'american', Country__c = 'USA');
        List<Doctor__c> doctors = new List<Doctor__c>{fakeDoctor1, fakeDoctor2, fakeDoctor3, fakeDoctor4};

        insert doctors;
    }

    @IsTest
    public static void firstNameQueryParamTest(){
        Boolean properResults = true;
        dsController.queryLastName = '';
        dsController.queryEmail = '';
        dsController.queryCountry = '';
        dsController.queryFirstName = 'Jan';
        dsController.search();
        dsController.getDoctors();
        for(Doctor__c doc : dsController.searchDoctorsList){
            if(doc.First_Name__c != 'Jan'){
                properResults = false;
                break;
            }
        }
        System.assert(properResults);
    }

    @IsTest
    public static void lastNameQueryParamTest(){
        Boolean properResults = true;
        dsController.queryLastName = 'Kr';
        dsController.queryEmail = '';
        dsController.queryCountry = '';
        dsController.queryFirstName = '';
        dsController.search();
        dsController.getDoctors();
        for(Doctor__c doc : dsController.searchDoctorsList){
            if(doc.Last_Name__c != 'Kr'){
                properResults = false;
                break;
            }
        }
        System.assert(properResults);
    }

    @IsTest
    public static void emailQueryParamTest(){
        Boolean properResults = true;
        dsController.queryLastName = '';
        dsController.queryEmail = 'test@mail.com';
        dsController.queryCountry = '';
        dsController.queryFirstName = '';
        dsController.search();
        dsController.getDoctors();
        for(Doctor__c doc : dsController.searchDoctorsList){
            if(doc.Email__c != 'test@mail.com'){
                properResults = false;
                break;
            }
        }
        System.assert(properResults);
    }

    @IsTest
    public static void countryQueryParamTest(){
        Boolean properResults = true;
        dsController.queryLastName = '';
        dsController.queryEmail = '';
        dsController.queryCountry = 'USA';
        dsController.queryFirstName = '';
        dsController.search();
        dsController.getDoctors();
        for(Doctor__c doc : dsController.searchDoctorsList){
            if(doc.Country__c != 'USA'){
                properResults = false;
                break;
            }
        }
        System.assert(properResults);
    }

    @IsTest
    public static void resultsCountTest(){
        dsController.queryLastName = '';
        dsController.queryEmail = '';
        dsController.queryCountry = '';
        dsController.queryFirstName = '';
        dsController.getDoctors();
        System.assertEquals(dsController.searchDoctorsList.size(), 4);
    }

    @IsTest
    public static void clearResultsTest(){
        dsController.clear();
        dsController.getDoctors();
        System.assertEquals(dsController.searchDoctorsList.size(), 0);
    }
}