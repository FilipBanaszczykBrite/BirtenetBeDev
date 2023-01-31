public with sharing class DJ_ContractBatchSchedule implements Schedulable{

    public void execute(SchedulableContext param1) {
        DJ_ContractProlongationBatch batch = new DJ_ContractProlongationBatch();
        Database.executeBatch(batch);
    }
}