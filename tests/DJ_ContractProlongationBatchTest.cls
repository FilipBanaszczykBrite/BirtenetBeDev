@IsTest
public with sharing class DJ_ContractProlongationBatchTest {


    @TestSetup
    static  void setup(){
        Hospital__c testHospital = new Hospital__c(Name__c='nazwa', No_Ambulances__c=1, Phone_Number__c='(123) 123-1234',
                City__c='a', Country__c='a', Street__c='a', Postal_Code__c='aaa123');
        List<Doctor__c> doctors =DJ_FakeDoctorGenerator.generateDoctors(4);
        insert doctors;
        insert testHospital;

        Contract__c test1Contract1 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(-1), End_Date__c=System.today(),
                Prolongation__c=true, Prolongation_period__c=10);
        Contract__c test1Contract2 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(6), End_Date__c=System.today().addMonths(7));
        Contract__c test1Contract3 = new Contract__c(Doctor__c=doctors.get(0).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(8), End_Date__c=System.today().addMonths(9));

        Contract__c test2Contract1 = new Contract__c(Doctor__c=doctors.get(1).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(-1), End_Date__c=System.today(),
                Prolongation__c=true, Prolongation_period__c=6);
        Contract__c test2Contract2 = new Contract__c(Doctor__c=doctors.get(1).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(4), End_Date__c=System.today().addMonths(5));

        Contract__c test3Contract1 = new Contract__c(Doctor__c=doctors.get(2).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(-1), End_Date__c=System.today(),
                Prolongation__c=true, Prolongation_period__c=5);
        Contract__c test3Contract2 = new Contract__c(Doctor__c=doctors.get(2).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(7), End_Date__c=System.today().addMonths(8));

        Contract__c test4Contract1 = new Contract__c(Doctor__c=doctors.get(3).Id, Hospital__c=testHospital.Id,
                Start_Date__c=System.today().addMonths(-1), End_Date__c=System.today(),
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
    }


    @IsTest
    static void shouldProlongContractToFirstOverlapWhenTwoOverlaps(){
        Test.startTest();
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 3];
        System.assertEquals(contracts.get(0).End_Date__c, System.today().addMonths(6).addDays(-1));
    }


    @IsTest
    static void shouldProlongContractToFirstOverlap(){
        Test.startTest();
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 2 OFFSET 3];
        System.assertEquals(contracts.get(0).End_Date__c, System.today().addMonths(4).addDays(-1));
    }


    @IsTest
    static void shouldFullyProlongContractWithoutOverlaps(){
        Test.startTest();
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 2 OFFSET 5];
        System.assertEquals(contracts.get(0).End_Date__c, System.today().addMonths(5));
    }


    @IsTest
    static void shouldFullyProlongContractWithoutOtherContracts(){
        Test.startTest();
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contract__c> contracts = [SELECT End_Date__c, Start_Date__c, Prolongation__c, Prolongation_period__c, Id, Doctor__c, Hospital__c FROM Contract__c LIMIT 1 OFFSET 7];
        System.assertEquals(contracts.get(0).End_Date__c, System.today().addMonths(5));
    }
}