

global class DJ_DoctorWrapper {

    public Id Id { get; set; }

    public String firstName { get; set; }
    public String lastName { get; set; }
    public String specialty { get; set; }
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

    public DJ_DoctorWrapper wrapDoctor(Doctor__c doctor) {
        if (doctor.Id != null) {
            this.Id = doctor.Id;
        }
        if (doctor.First_Name__c != null) {
            this.firstName = doctor.First_Name__c;
        }
        if (doctor.Last_Name__c != null) {
            this.lastName = doctor.Last_Name__c;
        }
        if (doctor.Speciality__c != null) {
            this.specialty = doctor.Speciality__c;
        }
        if (doctor.Start_of_career__c != null) {
            this.startOfCareer = doctor.Start_of_career__c;
        }
        if (doctor.Date_of_Birth__c != null) {
            this.dateOfBirth = doctor.Date_of_Birth__c;
        }
        if (doctor.Phone__c != null) {
            this.phone = doctor.Phone__c;
        }
        if (doctor.Country__c != null) {
            this.country = doctor.Country__c;
        }
        if (doctor.City__c != null) {
            this.city = doctor.City__c;
        }
        if (doctor.Street__c != null) {
            this.street = doctor.Street__c;
        }
        if (doctor.Postal_Code__c != null) {
            this.postalCode = doctor.Postal_Code__c;
        }
        if (doctor.License_Number__c != null) {
            this.licenseNumber = doctor.License_Number__c;
        }
        if (doctor.Email__c != null) {
            this.email = doctor.Email__c;
        }
        return this;
    }

    public Doctor__c unWrapDoctor() {
        Doctor__c newDoctor = new Doctor__c();
        newDoctor.Id = this.id;
        newDoctor.First_Name__c = this.firstName;
        newDoctor.Last_Name__c = this.lastName;
        newDoctor.Speciality__c = this.specialty;
        newDoctor.Start_of_career__c = this.startOfCareer;
        newDoctor.Date_of_Birth__c = this.dateOfBirth;
        newDoctor.Phone__c = this.phone;
        newDoctor.Country__c = this.country;
        newDoctor.City__c = this.city;
        newDoctor.Street__c = this.street;
        newDoctor.Postal_Code__c = this.postalCode;
        newDoctor.License_Number__c = this.licenseNumber;
        newDoctor.Email__c = this.email;
        return newDoctor;
    }

    public static List<DJ_DoctorWrapper> wrapDoctors(List<Doctor__c> doctors) {
        List<DJ_DoctorWrapper> doctorWrappers = new List<DJ_DoctorWrapper>();
        for (Doctor__c doc : doctors) {
            doctorWrappers.add(new DJ_DoctorWrapper().wrapDoctor(doc));
        }
        return doctorWrappers;
    }

    public static List<Doctor__c> convertHM_DoctorWrapperToDoctorList(List<DJ_DoctorWrapper> HM_DoctorWrapperList){
        List<Doctor__c> doctors = new List<Doctor__c>();
        for(DJ_DoctorWrapper dw : HM_DoctorWrapperList){
            Doctor__c doctor = new Doctor__c();
            doctor.Id = dw.Id;
            doctor.First_Name__c = dw.firstName;
            doctor.Last_Name__c = dw.lastName;
            doctor.Speciality__c = dw.specialty;
            doctor.Start_of_career__c = dw.startOfCareer;
            doctor.Date_of_Birth__c = dw.dateOfBirth;
            doctor.Phone__c = dw.phone;
            doctor.Country__c = dw.country;
            doctor.City__c = dw.city;
            doctor.Street__c = dw.street;
            doctor.Postal_Code__c = dw.postalCode;
            doctor.License_Number__c = dw.licenseNumber;
            doctors.add(doctor);
        }
        return doctors;
    }

}