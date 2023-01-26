global with sharing class DJ_HospitalDTO {


    public String hospitalId {get; set;}
    public Integer ambulances {get; set;}
    public Boolean helicopter {get; set;}
    public String phone {get; set;}
    public String fax {get; set;}
    public String name {get; set;}
    public String country {get; set;}
    public String city {get; set;}
    public String street {get; set;}
    public String postalCode {get; set;} 

    public DJ_HospitalDTO(){

    }

    public DJ_HospitalDTO(Hospital__c hospital){
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

    public DJ_HospitalDTO(soapSforceComSchemasClassHmHospital.HM_HospitalDTO hospital){
        hospitalId = hospital.hospitalId;
        ambulances = (Integer) hospital.ambulances;
        helicopter = hospital.helicopter;
        phone = hospital.phone;
        fax = hospital.fax;
        street = hospital.street;
        postalCode = hospital.postalCode;
        name = hospital.name;
        country = hospital.country;
        city = hospital.city;
    }


    public  Hospital__c dtoToHospital(){
        return new Hospital__c(Name__c=name, Id=hospitalId, Country__c=country, City__c=city, Street__c=street,
                Postal_Code__c=postalCode, No_Ambulances__c=ambulances, Helicotper_Access__c=helicopter,
                Phone_Number__c=phone, Fax_Number__c=fax);
    }


}