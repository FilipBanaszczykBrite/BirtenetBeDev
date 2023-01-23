global with sharing class DJ_HospitalServiceAPI {


    webService static List<DJ_HospitalDTO> getHospitals(String name, String city){
        String query = 'SELECT Id, Name__c, Country__c, City__c, Street__c, Postal_Code__c, Phone_Number__c, No_Ambulances__c,' +
                ' Helicotper_Access__c, Fax_Number__c FROM Hospital__c WHERE Id != null';
        if (!String.isBlank(name)) {
            query += ' AND Name__c=' + String.escapeSingleQuotes(name) + ' ';
        }
        if (!String.isBlank(city)) {
            query += ' AND City__c=' + String.escapeSingleQuotes(city);
        }
        List<Hospital__c> hospitals = Database.query(query);
        List<DJ_HospitalDTO> hospitalDTOS = new List<DJ_HospitalDTO>();
        for(Hospital__c hospital :  hospitals){
            hospitalDTOS.add(new DJ_HospitalDTO(hospital));
        }
        return hospitalDTOS;
    }


    webService static List<DJ_SoapResponse> deleteHospitals(List<String> ids) {
        List<DJ_SoapResponse> responses = new List<DJ_SoapResponse>();
        for(String id : ids){
            DJ_SoapResponse response = new DJ_SoapResponse();
            response.id = id;
            try {
                Hospital__c hospital = [SELECT Id FROM Hospital__c WHERE Id = :id];
                if (hospital != null) {
                    delete hospital;
                    response.isSuccess = true;
                    response.message= 'Deleted successfully';
                }
            } catch (Exception e) {
                response.isSuccess = false;
                response.message= 'Deletion failed';
            }
            responses.add(response);
        }
        return responses;
    }


    webService static DJ_SoapResponse insertHospitals(List<DJ_HospitalDTO> hospitalDTOS){
        DJ_SoapResponse response = new DJ_SoapResponse();
        List<Hospital__c> hospitals = new List<Hospital__c>();
        for(DJ_HospitalDTO dto : hospitalDTOS){
            hospitals.add(dto.dtoToHospital());
        }
        try {
         Database.insert(hospitals);
            response.isSuccess = true;
            response.message= 'Hospitals inserted successfully';
        }
         catch (Exception e) {
             response.isSuccess = false;
             response.message= 'Insertion failed ' + e.getMessage();
        }
        return response;
    }


    webService static DJ_SoapResponse updateHospitals(List<DJ_HospitalDTO> hospitalDTOS){
        DJ_SoapResponse response = new DJ_SoapResponse();
        List<Hospital__c> hospitals = new List<Hospital__c>();
        for(DJ_HospitalDTO dto : hospitalDTOS){
            hospitals.add(dto.dtoToHospital());
        }
        try {
            Database.update(hospitals);
            response.isSuccess = true;
            response.message= 'Hospitals inserted successfully';
        }
        catch (Exception e) {
            response.isSuccess = false;
            response.message= 'Insertion failed ' + e.getMessage();
        }
        return response;
    }
}