

public with sharing class DJ_ContractProlongationService {

    public static Set<String> prolongContracts(List<Contract__c> contractsToProlong){
        Set<String>  contractsNames = new Set<String>();
        for(Contract__c contract : contractsToProlong){
            contract.End_Date__c = contract.End_Date__c.addMonths((Integer)contract.Prolongation_period__c);
        }
        DJ_ContractValidationService validationService = new DJ_ContractValidationService(contractsToProlong, false);
        List<DJ_ContractValidationService.DJ_ContractValidationResponse> responses = validationService.validateContracts();
        for(DJ_ContractValidationService.DJ_ContractValidationResponse response : responses){
            for(Contract__c contract : contractsToProlong){
                if(response.first.Id == contract.Id){
                    contract.End_Date__c = response.second.Start_Date__c.addDays(-1);
                }
            }
        }
        for(Contract__c contract : contractsToProlong){
            contract.Prolongation__c = false;
            contractsNames.add(contract.Id + '->' + contract.End_Date__c);
        }
        update contractsToProlong;
        return contractsNames;
    }
}