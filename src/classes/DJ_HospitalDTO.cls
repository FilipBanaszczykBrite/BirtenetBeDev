global with sharing class DJ_HospitalDTO {
    public String hospitalId;
    public Integer ambulances;
    public Boolean helicopter;
    public String phone;
    public String fax;
    public String name;
    public String country;
    public String city;
    public String street;
    public String postalCode;

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


    public  Hospital__c dtoToHospital(){
        return new Hospital__c(Name__c=name, Id=hospitalId, Country__c=country, City__c=city, Street__c=street,
                Postal_Code__c=postalCode, No_Ambulances__c=ambulances, Helicotper_Access__c=helicopter,
                Phone_Number__c=phone, Fax_Number__c=fax);
    }
}