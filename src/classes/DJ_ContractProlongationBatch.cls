public with sharing class DJ_ContractProlongationBatch implements Database.Batchable<SObject>{

    private final String query = 'SELECT Doctor__c, Hospital__c, Start_Date__c, End_Date__c, Prolongation__c, Position__c,' +
            ' Prolongation_period__c FROM Contract__c ORDER BY Start_Date__c ASC';
    private List<Contract__c> contractsToProlong = new List<Contract__c>();

    public Database.QueryLocator start(Database.BatchableContext context) {
        System.debug('START');
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Contract__c> contracts) {
        System.debug('EXECUTE');
        for(Contract__c contract : contracts){
            //System.debug(contract.End_Date__c.format() + ' ' + System.today().format() + ' ' + contract.Prolongation__c);
            if(contract.End_Date__c.format() == System.today().format() && contract.Prolongation__c == true){
                contractsToProlong.add(contract);
            }
        }
        System.debug('PRE PROLONG ');
        for(Contract__c contract : contractsToProlong){
            System.debug(contract.Start_Date__c + ' ' + contract.End_Date__c  + ' ' + contract.Doctor__c);
        }
        for(Contract__c contract : contractsToProlong){

            contract.End_Date__c = contract.End_Date__c.addMonths((Integer)contract.Prolongation_period__c);

        }
        System.debug('PO PROLONG ');
        for(Contract__c contract : contractsToProlong){
            System.debug(contract.Start_Date__c + ' ' + contract.End_Date__c  + ' ' + contract.Doctor__c);
        }
        DJ_ContractValidationService validationService = new DJ_ContractValidationService(contractsToProlong, false);
        List<DJ_ContractValidationService.DJ_ContractValidationResponse> responses = validationService.validateContracts();
        //System.debug('PO PROLONG ' + responses);
        for(DJ_ContractValidationService.DJ_ContractValidationResponse response : responses){
            System.debug(response.first.Start_Date__c + ' ' + response.first.End_Date__c + ' ' + 'OVERLAPPING' + ' ' +
                    response.second.Start_Date__c + ' ' + response.second.End_Date__c);
            for(Contract__c contract : contractsToProlong){
                if(response.first.Id == contract.Id){
                    contract.End_Date__c = response.second.Start_Date__c.addDays(-1);
                    contract.Prolongation__c = false;

                }
            }
        }
        System.debug('PO VALIDATE ' + contractsToProlong);
        for(Contract__c contract : contractsToProlong){
            System.debug(contract.Start_Date__c + ' ' + contract.End_Date__c + ' ' + contract.Doctor__c);
        }
        update contractsToProlong;
    }

    public void finish(Database.BatchableContext context) {

    }


}