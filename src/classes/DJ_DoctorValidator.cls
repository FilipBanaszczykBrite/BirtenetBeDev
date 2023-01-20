

public with sharing class DJ_DoctorValidator{

    public String message = '';
    public Boolean validDate = true;
    public Boolean validLicenseNumber = true;

    public Boolean validateDoctors(List<DJ_DoctorDTO> doctorDtos){
        for(DJ_DoctorDTO dto : doctorDtos){
            validDate = true;
            validLicenseNumber = true;
            if(!validateDoctor(dto)){
                if(!validDate){
                    message += System.Label.DJ_APIInvalidDates + ' ';
                }
                if(!validLicenseNumber){
                    message += System.Label.DJ_APIInvalidLicenseNumber + ' ';
                }
                message += dto.doctorId + ' ' + dto.firstName + ' ' + dto.lastName + '\n';
                return false;
            }
        }
        return true;
    }


    private Boolean validateDoctor(DJ_DoctorDTO doctorDTO){
        return validateDates(doctorDTO.birthDate, doctorDTO.startOfCareer) && validateLicenseNumber(doctorDTO.licenseNumber);
    }


    private Boolean validateDates(Date birth, Date career){
        if(birth >= career){
            validDate = false;
            return false;
        }
        validDate = true;
        return true;
    }


    private Boolean validateLicenseNumber(String licenseNumber){
        if(licenseNumber.length() < 5 || !licenseNumber.isAlphanumericSpace()){
            validLicenseNumber = false;
            return false;
        }
        validLicenseNumber = true;
        return true;
    }
}