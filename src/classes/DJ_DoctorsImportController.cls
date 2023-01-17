public with sharing class DJ_DoctorsImportController {


    public List<DoctorListHolder> doctors {get;set;}
    public Blob csvFileBody {get;set;}
    public String csvAsString {get;set;}
    public String  fileName {get;set;}
    public List<String> csvFileLines {get;set;}
    public Boolean fileChosen {get;set;}
    public Boolean fileRead {get;set;}
    public Boolean doctorSelected {get;set;}

    private Integer maxCsvSize = 3 * 1024;

    public class DoctorListHolder{
        public Doctor__c doctor {get; set;}
        public Boolean selected {get; set;}
        public String status {get; set;}

        public DoctorListHolder(Doctor__c doc){
            doctor = doc;
            selected = false;
            status = '';
        }
    }

    public DJ_DoctorsImportController(){
        doctorSelected = false;
        fileChosen = false;
        doctors = new List<DoctorListHolder>();
    }


    public void enableRead(){
        Integer size = csvFileBody.size();
        if(size > maxCsvSize){
            fileChosen = false;
            fileRead = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DJ_ImportFileSizeExceeded));
        }
        else{
			fileChosen = true;
            fileRead = false;
        }
    }


    public void importCSVFile(){
        doctors = new List<DoctorListHolder>();
        try{
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            for(Integer i = 0; i < csvFileLines.size(); i++){
                Doctor__c newDoc = new Doctor__c();
                List<String> csvRecordData = csvFileLines.get(i).split('[;,]');
                newDoc.First_Name__c = csvRecordData.get(0);
                newDoc.Last_Name__c = csvRecordData.get(1);
                newDoc.Date_of_Birth__c = Date.valueOf(csvRecordData.get(2));
                newDoc.Nationality__c = csvRecordData.get(3);
                newDoc.License_Number__c = csvRecordData.get(4);
                newDoc.Speciality__c = csvRecordData.get(5);
                newDoc.Start_of_career__c = Date.valueOf(csvRecordData.get(6));
                newDoc.Phone__c = csvRecordData.get(7);
                newDoc.Email__c = csvRecordData.get(8);
                newDoc.Street__c = csvRecordData.get(9);
                newDoc.Postal_Code__c = csvRecordData.get(10);
                newDoc.City__c = csvRecordData.get(11);
                newDoc.Country__c = csvRecordData.get(12);
                DoctorListHolder docHolder = new DoctorListHolder(newDoc);
                doctors.add(docHolder);
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DJ_InvalidImportFile));
            fileChosen = false;
            fileRead = false;
            return;
        }
        fileRead = true;
        checkReadRecords();
    }


    public void importDoctors(){
        List<Doctor__c> doctorsToImport = new List<Doctor__c>();
        for(DoctorListHolder dh : doctors){
            if(dh.selected){
                doctorsToImport.add(dh.doctor);
                dh.status = '';
            }
        }
        removeUnselectedDoctors();
        try{
            List<Database.SaveResult> srList = Database.insert(doctorsToImport, false);
            for(Integer i = 0; i < srList.size(); i++){
                if(srList.get(i).isSuccess()){
                    doctors.get(i).status = System.Label.DJ_SuccessImport;
                }
                else{
                    for(Integer j = 0; j < srList.get(i).errors.size(); j++){
                        doctors.get(i).status += srList.get(i).errors.get(j).message.capitalize();
                    }
                }
            }
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DJ_InsertFailed));
        }
    }


    public void checkSelected(){
        doctorSelected = false;
        for(DoctorListHolder dh : doctors) {
            if (dh.selected) {
                doctorSelected = true;
                break;
            }
        }
    }

    public void selectAll(){
        doctorSelected = true;
        for(DoctorListHolder dh : doctors){
            dh.selected = true;
        }
    }


    public void deselectAll(){
        doctorSelected = false;
        for(DoctorListHolder dh : doctors){
            dh.selected = false;
        }
    }


    public void invertSelection(){
        doctorSelected = false;
        for(DoctorListHolder dh : doctors){
            dh.selected = !dh.selected;
            if(dh.selected){
                doctorSelected = true;
            }
        }
    }


    private void removeUnselectedDoctors(){
        for (Integer i = doctors.size() - 1; i >= 0 ; --i) {
            if (!doctors.get(i).selected) {
                doctors.remove(i);
            }
        }
    }


    private void checkReadRecords() {
        for (Integer i = 0; i < doctors.size(); i++) {
            doctors.get(i).status = System.Label.DJ_ImportReadStatus;
            for (Integer j = 0; j < doctors.size(); j++) {
                if (i != j) {
                    if (doctorIdentityCheck(doctors.get(i).doctor, doctors.get(j).doctor)) {
                        doctors.get(i).status = System.Label.DJ_ImportDuplicateDoctor + ' ' + String.valueOf(j + 1) + ' ' +
                                doctors.get(j).doctor.First_Name__c + ' ' + doctors.get(j).doctor.Last_Name__c + ' ' +
                                doctors.get(j).doctor.Email__c;
                    } else if (doctors.get(i).doctor.Email__c == doctors.get(j).doctor.Email__c) {
                        doctors.get(i).status = System.Label.DJ_ImportDuplicateEmail + ' ' + String.valueOf(j + 1) + ' ' +
                                doctors.get(j).doctor.First_Name__c + ' ' + doctors.get(j).doctor.Last_Name__c + ' ' +
                                doctors.get(j).doctor.Email__c;
                    }
                }
            }
        }
    }


    private Boolean doctorIdentityCheck(Doctor__c checked, Doctor__c other){
        Boolean indeticalDoctors = checked.First_Name__c == other.First_Name__c &&
                checked.Last_Name__c == other.Last_Name__c &&
                checked.Email__c == other.Email__c &&
                checked.Phone__c == other.Phone__c &&
                checked.License_Number__c == other.License_Number__c &&
                checked.Date_of_Birth__c == other.Date_of_Birth__c ;
        return indeticalDoctors;
    }
}