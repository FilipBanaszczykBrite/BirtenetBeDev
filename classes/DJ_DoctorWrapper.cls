global class DJ_DoctorWrapper {

    public String Id { get; set; }

    public String firstName { get; set; }
    public String lastName { get; set; }
    public String specialty { get; set; }
    public String nationality { get; set; }
    public Date startOfCareer { get; set; }
    public Date dateOfBirth { get; set; }
    public String phone { get; set; }
    public String country  { get; set; }
    public String city { get; set; }
    public String street { get; set; }
    public String postalCode { get; set; }
    public String licenseNumber { get; set; }

    public String email { get; set; }

    public String backMessage { get; set; }
    public Boolean selected { get; set; }


    public DJ_DoctorWrapper(Doctor__c doctor){
        id = doctor.Id;
        firstName = doctor.First_Name__c;
        lastName = doctor.Last_Name__c;
        specialty = doctor.Speciality__c;
        nationality = doctor.Nationality__c;
        licenseNumber = doctor.License_Number__c;
        email = doctor.Email__c;
        phone = doctor.Phone__c;
        dateOfBirth = doctor.Date_of_Birth__c;
        startOfCareer = doctor.Start_of_career__c;
        country = doctor.Country__c;
        city = doctor.City__c;
        street = doctor.Street__c;
        postalCode = doctor.Postal_Code__c;
    }

    public static DJ_DoctorDTO doctorToDTO(Doctor__c doctor){
        return new DJ_DoctorDTO(doctor);
    }

    public static Doctor__c dtoToDoctor(DJ_DoctorWrapper dto){
        Doctor__c newDoctor = new Doctor__c(
                Id=dto.Id,
                First_Name__c=dto.firstName,
                Last_Name__c=dto.lastName,
                Nationality__c=dto.nationality,
                Speciality__c=dto.specialty,
                License_Number__c=dto.licenseNumber,
                Email__c=dto.email,
                Phone__c=dto.phone,
                Date_of_Birth__c=dto.dateOfBirth,
                Start_of_career__c=dto.startOfCareer,
                Country__c=dto.country,
                City__c=dto.city,
                Street__c=dto.street,
                Postal_Code__c=dto.postalCode);
        return newDoctor;
    }
    
}