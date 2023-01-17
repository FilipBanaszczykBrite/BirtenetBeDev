@isTest
public class DJ_ContractValidationTriggerTest {

    @testSetup 
    static void setup(){
        Contract__c contract;
        Doctor__c fakeDoctor = new Doctor__c(Name = 'Jan K', First_Name__c = 'Jan', Last_Name__c = 'K',
                Phone__c = '123456879', Date_of_Birth__c = Date.newInstance(1990, 1, 1),
                Start_of_Career__c = Date.newInstance(2010, 1, 1), License_Number__c = '1235456',
                Speciality__c = 'surgeon', Nationality__c = 'american');
        Hospital__c fakeHospital = new Hospital__c(Name = 'Fake Hospital', Name__c = 'Fake Hospital', Street__c = 'test', Postal_Code__c = 'test',
                City__c = 'test', Country__c = 'test', Phone_Number__c = '1231231231');
        insert fakeDoctor;
        insert fakeHospital;
        contract = new Contract__c(Doctor__c = fakeDoctor.Id, Hospital__c = fakeHospital.Id,
                Start_Date__c = Date.newInstance(2023, 1, 2), End_Date__c = Date.newInstance(2023, 1, 11));
        insert contract;
    }

    @isTest
    public static void shouldNotInsertOverlappingContractsTest(){
        Doctor__c fakeDoctor = [SELECT Id, Name FROM Doctor__c WHERE Name = 'Jan K' LIMIT 1];
        Hospital__c fakeHospital = [SELECT Id, Name FROM Hospital__c WHERE Name = 'Fake Hospital' LIMIT 1];
        Contract__c newContract = new Contract__c(Doctor__c = fakeDoctor.Id, Hospital__c = fakeHospital.Id,
                Start_Date__c = Date.newInstance(2023, 1, 7), End_Date__c = Date.newInstance(2023, 1, 15));

        try{
            Test.startTest();
            Database.SaveResult result = Database.insert(newContract, false);
            Test.stopTest();
        }
        catch(System.FinalException exp){
            System.assertEquals(exp.getMessage().contains(System.Label.DJ_Overlapping_Contracts), true);
        }
    }

    @isTest
    public static void shouldNotUpdateOverlappingContractsTest(){
        Doctor__c fakeDoctor = [SELECT Id, Name FROM Doctor__c WHERE Name = 'Jan K' LIMIT 1];
        Hospital__c fakeHospital = [SELECT Id, Name FROM Hospital__c WHERE Name = 'Fake Hospital' LIMIT 1];
        Contract__c newContract = new Contract__c(Doctor__c = fakeDoctor.Id, Hospital__c = fakeHospital.Id,
                Start_Date__c = Date.newInstance(2023, 1, 17), End_Date__c = Date.newInstance(2023, 1, 19));
        try{
            Test.startTest();
            insert newContract;
        	newContract.Start_Date__c = Date.newInstance(2023, 1, 7);
            Database.SaveResult result = Database.update(newContract, false);
            Test.stopTest();
        }
        catch(System.FinalException exp){
            System.assertEquals(exp.getMessage().contains(System.Label.DJ_Overlapping_Contracts), true);
        }
    }
}