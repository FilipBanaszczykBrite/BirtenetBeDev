@RestResource(urlMapping='/doctors')
global with sharing class DJ_DoctorServiceAPI {


    @HttpGet
    global static void  doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String firstName = request.params.get('firstName') != null ? request.params.get('firstName') : '';
        String lastName = request.params.get('lastName') != null ? request.params.get('lastName') : '';
        String email = request.params.get('email') != null ? request.params.get('email') : '';
        String country = request.params.get('country') != null ? request.params.get('country') : '';
        String baseQuery = 'SELECT First_Name__c, Last_Name__c, Speciality__c, Nationality__c, Email__c, License_Number__c,\n' +
                'Date_of_Birth__c, Start_of_career__c, Phone__c, City__c, Street__c, Postal_Code__c, Country__c FROM Doctor__c WHERE Id!=null ';
        List<Doctor__c> doctors = Database.query(baseQuery + getQueryWithParams(firstName, lastName, email, country));
        if(doctors.size() == 0){
            response.statusCode = 404;
        }
        else{
            List<DJ_DoctorDTO> dtos = new List<DJ_DoctorDTO>();
            for(Doctor__c doctor : doctors){
                dtos.add(DJ_DoctorDTO.doctorToDTO(doctor));
            }
            response.responseBody = Blob.valueOf(JSON.serialize(dtos));
            response.statusCode = 200;
        }
    }

    @HttpPost
    global static void doPost(){
        RestResponse response = RestContext.response;
        String body = RestContext.request.requestBody.toString();
        List<DJ_DoctorDTO> newDoctorsDtos = (List<DJ_DoctorDTO>) JSON.deserialize(body, List<DJ_DoctorDTO>.class);
        List<Id> insertedDoctorsIds = new List<Id>();
        List<Doctor__c> newDoctors = new List<Doctor__c>();
        List<Database.SaveResult> srList;
        String responseBody = '';
        DJ_DoctorValidator validator = new DJ_DoctorValidator();
        if(validator.validateDoctors(newDoctorsDtos)){
            for(DJ_DoctorDTO dto : newDoctorsDtos){
                newDoctors.add(DJ_DoctorDTO.dtoToDoctor(dto));
            }
            try{
                srList = Database.insert(newDoctors);
            }
            catch(Exception e){
                response.statusCode = 400;
                responseBody +=  e.getMessage();
                response.responseBody = Blob.valueOf(responseBody);
                return;
            }
            for(Database.SaveResult sr : srList){
                insertedDoctorsIds.add(sr.id);
            }
            response.statusCode = 201;
            response.responseBody = Blob.valueOf(JSON.serialize(insertedDoctorsIds));
        }
        else{
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(validator.message);
        }
    }

    @HttpPut
    global static void doPut(){
        RestResponse response = RestContext.response;
        String body = RestContext.request.requestBody.toString();
        List<DJ_DoctorDTO> newDoctorsDtos = (List<DJ_DoctorDTO>) JSON.deserialize(body, List<DJ_DoctorDTO>.class);
        List<Id> insertedDoctorsIds = new List<Id>();
        List<Doctor__c> newDoctors = new List<Doctor__c>();
        List<Database.SaveResult> srList;
        DJ_DoctorValidator validator = new DJ_DoctorValidator();
        if(validator.validateDoctors(newDoctorsDtos)){
            for(DJ_DoctorDTO dto : newDoctorsDtos){
                newDoctors.add(DJ_DoctorDTO.dtoToDoctor(dto));
            }
            try{
                srList = Database.update(newDoctors);
            }
            catch(Exception e){
                response.statusCode = 400;
                response.responseBody = Blob.valueOf(e.getMessage());
                return;
            }
            for(Database.SaveResult sr : srList){
                insertedDoctorsIds.add(sr.id);
            }
            response.statusCode = 200;
            response.responseBody = Blob.valueOf(JSON.serialize(insertedDoctorsIds));
        }
        else{
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(validator.message);
        }
    }

    @HttpDelete
    global static void doDelete(){
        RestResponse response = RestContext.response;
        String body = RestContext.request.requestBody.toString();
        List<Id> doctorsIds = (List<Id>) JSON.deserialize(body, List<Id>.class);
        try{
            Database.delete(doctorsIds);
        }
        catch (Exception e){
            response.statusCode = 400;
            return;
        }
        response.statusCode = 204;
    }


    private static String getQueryWithParams(String firstName, String lastName, String email, String country){
        String result = '';
        if(firstName != ''){
            result += 'AND First_Name__c = \''+ String.escapeSingleQuotes(firstName) + '\' ';
        }
        if(lastName != ''){
            result += 'AND Last_Name__c = \''+ String.escapeSingleQuotes(lastName) + '\' ';
        }
        if(email != ''){
            result += 'AND Email__c = \''+ String.escapeSingleQuotes(email) + '\' ';
        }
        if(country != ''){
            result += 'AND Country__c = \''+ String.escapeSingleQuotes(country) + '\'';
        }
        return result;
    }
}