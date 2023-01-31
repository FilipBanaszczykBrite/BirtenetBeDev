public with sharing class DJ_FakeDoctorGenerator {

    private static final List<String> names = new List<String>{'Piotr', 'Paweł', 'Tomasz', 'Hubert', 'Jakub'};
    private static final List<String> lastNames = new List<String>{'Nowak', 'Kowalski', 'Karwacki', 'Ciok', 'Nowakowski'};
    private static final List<String> countries = new List<String>{'Polska', 'Niemcy', 'Czechy', 'Wielka Brytania', 'Holandia'};
    private static final List<String> specialities = new List<String>{'Chirurg', 'Ortopeda', 'Pediatra', 'Urolog', 'Anestezjolog'};

    public static List<Doctor__c> generateDoctors(Integer num){
        List<Doctor__c> result = new List<Doctor__c>();
        for(Integer i = 0; i < num; i++){
            Doctor__c newDoc = new Doctor__c();
            newDoc.First_Name__c = names.get(Integer.valueOf((Math.random() * names.size())));
            newDoc.Last_Name__c = lastNames.get(Integer.valueOf((Math.random() * lastNames.size())));
            newDoc.Country__c = countries.get(Integer.valueOf((Math.random() * countries.size())));
            newDoc.Speciality__c = specialities.get(Integer.valueOf((Math.random() * specialities.size())));
            newDoc.Nationality__c = 'polskie';
            newDoc.Phone__c =  (String.valueof(Integer.valueOf(Math.random() * 100000000)));
            newDoc.Email__c = 'testemail' + (String.valueof(Integer.valueOf(Math.random() * 10))) + i + '@dom.com';
            newDoc.License_Number__c = 'TST ' + (String.valueof(Integer.valueOf(Math.random() * 1000))) + i;
            newDoc.City__c = 'Miasto';
            newDoc.Postal_Code__c = '11-234';
            newDoc.Street__c = 'ulicowska';
            newDoc.Date_of_Birth__c = Date.newInstance(1970 + i, Integer.valueOf((Math.random() * 12)),  Integer.valueOf((Math.random() * 30)));
            newDoc.Start_of_career__c = Date.newInstance(2000 + i, Integer.valueOf((Math.random() * 12)),  Integer.valueOf((Math.random() * 30)));
            result.add(newDoc);
        }
        return result;
    }
}