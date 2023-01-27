@IsTest
public with sharing class DJ_ContractProlongationBatchTest {


    @TestSetup
    static  void setup(){
        Doctor__c testDoctor1 = new Doctor__c(First_Name__c='imie', Last_Name__c='nazwisko', Speciality__c='a',
                License_Number__c='a123123', Phone__c='(123) 123-1234', City__c='a', Country__c='a', Street__c='a',
                Postal_Code__c='aaa123', Date_of_Birth__c=Date.valueOf('1990-01-01'), Start_of_career__c=Date.valueOf('2020-01-01'));
        Doctor__c testDoctor2 = new Doctor__c(First_Name__c='imie', Last_Name__c='nazwisko', Speciality__c='a',
                License_Number__c='a123123', Phone__c='(123) 123-1234', City__c='a', Country__c='a', Street__c='a',
                Postal_Code__c='aaa123', Date_of_Birth__c=Date.valueOf('1990-01-01'), Start_of_career__c=Date.valueOf('2020-01-01'));
        Doctor__c testDoctor3 = new Doctor__c(First_Name__c='imie', Last_Name__c='nazwisko', Speciality__c='a',
                License_Number__c='a123123', Phone__c='(123) 123-1234', City__c='a', Country__c='a', Street__c='a',
                Postal_Code__c='aaa123', Date_of_Birth__c=Date.valueOf('1990-01-01'), Start_of_career__c=Date.valueOf('2020-01-01'));
        Doctor__c testDoctor4 = new Doctor__c(First_Name__c='imie', Last_Name__c='nazwisko', Speciality__c='a',
                License_Number__c='a123123', Phone__c='(123) 123-1234', City__c='a', Country__c='a', Street__c='a',
                Postal_Code__c='aaa123', Date_of_Birth__c=Date.valueOf('1990-01-01'), Start_of_career__c=Date.valueOf('2020-01-01'));
        Hospital__c testHospital = new Hospital__c(Name__c='nazwa', No_Ambulances__c=1, Phone_Number__c='(123) 123-1234',
                City__c='a', Country__c='a', Street__c='a', Postal_Code__c='aaa123');
        List<Doctor__c> doctors = new List<Doctor__c>{testDoctor1, testDoctor2, testDoctor3, testDoctor4};
        insert doctors;
        insert testHospital;

        Contract__c test1Contract1 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-01-01'), End_Date__c=Date.valueOf('2023-01-27'),
                Prolongation__c=true, Prolongation_period__c=10);
        Contract__c test1Contract2 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-06-05'), End_Date__c=Date.valueOf('2023-07-05'));
        Contract__c test1Contract3 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-08-05'), End_Date__c=Date.valueOf('2023-09-05'));

        Contract__c test2Contract1 = new Contract__c(Doctor__c=doctors.get(1).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-01-01'), End_Date__c=Date.valueOf('2023-01-27'),
                Prolongation__c=true, Prolongation_period__c=5);
        Contract__c test2Contract2 = new Contract__c(Doctor__c=doctors.get(1).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-06-01'), End_Date__c=Date.valueOf('2023-07-05'));

        Contract__c test3Contract1 = new Contract__c(Doctor__c=doctors.get(2).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-01-01'), End_Date__c=Date.valueOf('2023-01-27'),
                Prolongation__c=true, Prolongation_period__c=5);
        Contract__c test3Contract2 = new Contract__c(Doctor__c=doctors.get(2).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-09-01'), End_Date__c=Date.valueOf('2024-07-05'));

        Contract__c test4Contract1 = new Contract__c(Doctor__c=doctors.get(3).Id, Hospital__c=testHospital.Id,
                Start_Date__c=Date.valueOf('2023-01-01'), End_Date__c=Date.valueOf('2023-01-27'),
                Prolongation__c=true, Prolongation_period__c=5);


        List<Contract__c> contracts = new List<Contract__c>();
        contracts.add(test1Contract1);
        contracts.add(test1Contract2);
        contracts.add(test1Contract3);
        contracts.add(test2Contract1);
        contracts.add(test2Contract2);
        contracts.add(test3Contract1);
        contracts.add(test3Contract2);
        contracts.add(test4Contract1);
        insert contracts;
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
    }


    @IsTest
    static void shouldProlongContractToFirstOverlapWhenTwoOverlaps(){
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 3];
        System.assertEquals(contracts.get(0).End_Date__c.format(), '04/06/2023');
    }


    @IsTest
    static void shouldProlongContractToFirstOverlap(){
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 2 OFFSET 3];
        System.assertEquals(contracts.get(0).End_Date__c.format(), '31/05/2023');
    }


    @IsTest
    static void shouldFullyProlongContractWithoutOverlaps(){
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 2 OFFSET 5];
        System.assertEquals(contracts.get(0).End_Date__c.format(), '27/06/2023');
    }


    @IsTest
    static void shouldFullyProlongContractWithoutOtherContracts(){
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 1 OFFSET 7];
        System.assertEquals(contracts.get(0).End_Date__c.format(), '27/06/2023');
    }
}