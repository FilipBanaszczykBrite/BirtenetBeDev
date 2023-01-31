public with sharing class DJ_ContractsValidationTriggerHandler implements DJ_TriggerHandler {

    private DJ_ContractValidationService conValService;

    public void beforeInsert(List<SObject> newRecords) {
        conValService = new DJ_ContractValidationService(newRecords, true);
        conValService.validateContracts();
    }

    
    public void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        conValService = new DJ_ContractValidationService(newRecords, true);
        conValService.validateContracts();
    } 

    
    public void beforeDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
        
    }

    
    public void afterInsert(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
        
    }

    
    public void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        
    }

    
    public void afterDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
        
    }

    
    public void afterUndelete(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
        
    }
}