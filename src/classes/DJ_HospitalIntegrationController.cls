

public with sharing class DJ_HospitalIntegrationController {
    public String hospitalName { get; set; }
    public String hospitalCity{ get; set; }

    public PageReference searchHospital() {
        soapSforceComSchemasClassHMHospital.SessionHeader_element sessionObj = new soapSforceComSchemasClassHMHospital.SessionHeader_element();
        sessionObj.sessionId = '';
        soapSforceComSchemasClassHMHospital.HM_HospitalWebService hospitalServiceObj = new soapSforceComSchemasClassHMHospital.HM_HospitalWebService();
        hospitalServiceObj.sessionHeader = sessionObj;

        List<soapSforceComSchemasClassDJHospital.DJ_HospitalDTO> kWrap = hospitalServiceObj.getHospitals(hospitalName, hospitalCity);
        if (kWrap == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.HD_Not_found_error));
            isVisible = false;
            return null;
        }

        hospitalWrappers = HD_SOAPCallouts.servWrapToCli(kWrap);
        isVisible = true;

        return null;
    }
}