global with sharing class DJ_HospitalServiceAPI {


    webService static List<DJ_HospitalDTO> getHospitals(String name, String city){
        String query = 'SELECT Id, Name__c, Country__c, City__c, Street__c, Postal_Code__c, Phone_Number__c, No_Ambulances__c,' +
                ' Helicotper_Access__c, Fax_Number__c FROM Hospital__c WHERE Id != null';
        if (!String.isBlank(name)) {
            query += ' AND Name__c= \'' + String.escapeSingleQuotes(name) + '\' ';
        }
        if (!String.isBlank(city)) {
            query += ' AND City__c= \'' + String.escapeSingleQuotes(city) + '\'';
        }
        List<Hospital__c> hospitals = Database.query(query);
        List<DJ_HospitalDTO> hospitalDTOS = new List<DJ_HospitalDTO>();
        for(Hospital__c hospital :  hospitals){
            hospitalDTOS.add(new DJ_HospitalDTO(hospital));
        }
        return hospitalDTOS;
    }


    webService static List<Id>  deleteHospitals(List<String> ids) {
        List<Id> deleted = new List<Id>();
        for(String id : ids){
            try {
                Hospital__c hospital = [SELECT Id FROM Hospital__c WHERE Id = :id];
                if (hospital != null) {
                    delete hospital;
                    deleted.add(id);
                }
            } catch (Exception e) {

            }
        }
        return deleted;
    }


    webService static List<Id>  insertHospitals(List<DJ_HospitalDTO> hospitalDTOS){
        List<Id> inserted = new List<Id>();
        List<Hospital__c> hospitals = new List<Hospital__c>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        for(DJ_HospitalDTO dto : hospitalDTOS){
            hospitals.add(dto.dtoToHospital());
        }
        try {
            srList = Database.insert(hospitals);
            for(Database.SaveResult sr : srList){
                inserted.add(sr.id);
            }
        }
         catch (Exception e) {

        }
        return inserted;
    }


    webService static List<Id> updateHospitals(List<DJ_HospitalDTO> hospitalDTOS){
        List<Id> updated = new List<Id>();
        List<Hospital__c> hospitals = new List<Hospital__c>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        for(DJ_HospitalDTO dto : hospitalDTOS){
            hospitals.add(dto.dtoToHospital());
        }
        try {
            srList = Database.update(hospitals);
            for(Database.SaveResult sr : srList){
                updated.add(sr.id);
            }
        }
        catch (Exception e) {

        }
        return updated;
    }

    global class DJ_HospitalDTO {
        webService String hospitalId;
        webService Integer ambulances;
        webService Boolean helicopter;
        webService String phone;
        webService String fax;
        webService String name;
        webService String country;
        webService String city;
        webService String street;
        webService String postalCode;

        global DJ_HospitalDTO(Hospital__c hospital) {
            hospitalId = hospital.Id;
            ambulances = (Integer) hospital.No_Ambulances__c;
            helicopter = hospital.Helicotper_Access__c;
            phone = hospital.Phone_Number__c;
            fax = hospital.Fax_Number__c;
            street = hospital.Street__c;
            postalCode = hospital.Postal_Code__c;
            name = hospital.Name__c;
            country = hospital.Country__c;
            city = hospital.City__c;
        }


        global Hospital__c dtoToHospital() {
            return new Hospital__c(Name__c = name, Id = hospitalId, Country__c = country, City__c = city, Street__c = street,
                    Postal_Code__c = postalCode, No_Ambulances__c = ambulances, Helicotper_Access__c = helicopter,
                    Phone_Number__c = phone, Fax_Number__c = fax);
        }
    }
}