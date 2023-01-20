

public with sharing class DJ_DoctorDTO {

    public Id doctorId;
    public String firstName;
    public String lastName;
    public String speciality;
    public String nationality;
    public String licenseNumber;
    public String email;
    public String phone;
    public Date birthDate;
    public Date startOfCareer;
    public String country;
    public String city;
    public String street;
    public String postalCode;

    public DJ_DoctorDTO(Doctor__c doctor){
        doctorId = doctor.Id;
        firstName = doctor.First_Name__c;
        lastName = doctor.Last_Name__c;
        speciality = doctor.Speciality__c;
        nationality = doctor.Nationality__c;
        licenseNumber = doctor.License_Number__c;
        email = doctor.Email__c;
        phone = doctor.Phone__c;
        birthDate = doctor.Date_of_Birth__c;
        startOfCareer = doctor.Start_of_career__c;
        country = doctor.Country__c;
        city = doctor.City__c;
        street = doctor.Street__c;
        postalCode = doctor.Postal_Code__c;
    }

    public static DJ_DoctorDTO doctorToDTO(Doctor__c doctor){
       return new DJ_DoctorDTO(doctor);
    }


    public static Doctor__c dtoToDoctor(DJ_DoctorDTO dto){
        Doctor__c newDoctor = new Doctor__c(
                Id=dto.doctorId,
                First_Name__c=dto.firstName,
                Last_Name__c=dto.lastName,
                Nationality__c=dto.nationality,
                Speciality__c=dto.speciality,
                License_Number__c=dto.licenseNumber,
                Email__c=dto.email,
                Phone__c=dto.phone,
                Date_of_Birth__c=dto.birthDate,
                Start_of_career__c=dto.startOfCareer,
                Country__c=dto.country,
                City__c=dto.city,
                Street__c=dto.street,
                Postal_Code__c=dto.postalCode);
        return newDoctor;
    }


}