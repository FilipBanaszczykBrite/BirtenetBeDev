public with sharing class DJ_ContractProlongationBatch implements Database.Batchable<SObject>, Database.Stateful{

    private final String query = 'SELECT Doctor__c, Hospital__c, Start_Date__c, End_Date__c, Prolongation__c, Position__c,' +
            ' Prolongation_period__c FROM Contract__c WHERE Prolongation__c = true ORDER BY Start_Date__c ASC';
    private Set<String> contractsNames = new Set<String>();

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }


    public void execute(Database.BatchableContext context, List<Contract__c> contractsToProlong) {
        contractsNames = DJ_ContractProlongationService.prolongContracts(contractsToProlong);
    }


    public void finish(Database.BatchableContext param1) {
        sendContractsEmail();
    }


    private void sendContractsEmail(){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId( UserInfo.getUserId() );
        message.subject = 'Prolonged contracts';
        message.setSaveAsActivity(false);
        message.plainTextBody = generateEmailBody();
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
    }


    private String generateEmailBody(){
        String result = '';
        for(String name : contractsNames){
            result += '-' + name + '\n';
        }
        return result;
    }
}