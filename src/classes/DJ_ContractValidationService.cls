public with sharing class DJ_ContractValidationService {

    public List<Contract__c> newContracts = new List<Contract__c>();
    public List<Contract__c> allContracts = new List<Contract__c>();
    public Set<Id> doctorsIds = new Set<Id>();

    public DJ_ContractValidationService(List<Contract__c> newContracts){
        this.newContracts = newContracts;
    }


    public void validateContracts(){
        getDoctorsIds();
        getContractsForDoctors();
        for(Contract__c contract : newContracts){
            if(!validateContractsForDoctor(contract, getDoctorsContracts(contract.Doctor__c))){
                
            }
        }
    }

    @TestVisible
    private void getDoctorsIds(){
        for(Contract__c contract : this.newContracts){
            this.doctorsIds.add(contract.Doctor__c);
        }
    }


    private void getContractsForDoctors(){
        allContracts = [SELECT Name, Start_Date__c, End_Date__c, Hospital__c, Doctor__c FROM Contract__c WHERE Doctor__c IN :doctorsIds];
        for(Contract__C contract : newContracts){
            allContracts.add(contract);
        }
    }

    @TestVisible
    private List<Contract__c> getDoctorsContracts(Id doctorId){
        List<Contract__c> doctorsContracts = new List<Contract__c>();
        for(Contract__c contract : allContracts){
            if(contract.Doctor__c == doctorId){
                doctorsContracts.add(contract);
            }
        }
        return doctorsContracts;
    }


    private Boolean validateContractsForDoctor(Contract__c newContract, List<Contract__c> contracts){
        Map<Id, List<Contract__c>> contractsByHospitals = mapContractsByHospitals(contracts);
        for(Id hospitalId : contractsByHospitals.keySet()){
            if(areHospitalContractsOverlapping(newContract, contractsByHospitals.get(hospitalId))){
                return false;
            }
        }
        return true;
    }


    @TestVisible
    private Map<Id, List<Contract__c>> mapContractsByHospitals(List<Contract__c> contracts){
        Map<Id, List<Contract__c>> contractsByHospitals = new Map<Id, List<Contract__c>>();
        List<Contract__c> contractsForHospital;
        for(Contract__c contract : contracts){
            if(contractsByHospitals.containsKey(contract.Hospital__c)){
                contractsByHospitals.get(contract.Hospital__c).add(contract);
            }
            else{
                contractsForHospital = new List<Contract__c>();
                contractsForHospital.add(contract);
                contractsByHospitals.put(contract.Hospital__c, contractsForHospital);
            }
        }
        return contractsByHospitals;
    }

    @TestVisible
    private Boolean areHospitalContractsOverlapping(Contract__c newContract, List<Contract__c> contracts){
            for(Contract__c contract : contracts){
            	if(datesOverlap(newContract, contract) && newContract.Id != contract.Id){
                	String params = 'Overlapping contract: ' + contract.Name + ' ' +
                        contract.Start_Date__c.format() + ' - ' + contract.End_Date__c.format();
                	newContract.addError(System.Label.DJ_Overlapping_Contracts + ' ' + params); 
                }
            }
        return false;
    }


    @TestVisible
    private Boolean datesOverlap(Contract__c newCon, Contract__c con){
        if(newCon.Start_Date__c >= con.Start_Date__c
                && con.End_Date__c >= newCon.Start_Date__c){
            return true;
        }
        if(newCon.Start_Date__c <= con.Start_Date__c
                && newCon.End_Date__c >= con.Start_Date__c){
            return true;
        }
        return false;
    }
}