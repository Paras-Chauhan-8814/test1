public class Reconciliation_Batch_Class implements Database.batchable<sObject>,Database.AllowsCallouts, Database.Stateful{

    public List<User> userList;
    public List<String> stringList= new List<String>();
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('SELECT ID, CreatedDate, LastModifiedDate, Status_p__c, OwnerId, Source_p__c, Account_lr__c FROM Reconciliation__c LIMIT 10000');
    }   
    
    public void execute(Database.BatchableContext BC, List<Reconciliation__c> reconciliationList){
        Savepoint sp = Database.setSavepoint();
        
        Integer dayDifference = 0;
        Long modifyDifference = 0;
        Set<ID> accountIDSet = new Set<ID>();
        Set<ID> ownerIDSet = new Set<ID>();
        List<Account> accountListDelete = new List<Account>();
        List<Contact> contactListDelete = new List<Contact>();
        List<Reconciliation__c> reconciliationListDeleted = new List<Reconciliation__c>();
        //date currentTime = DateTime.date();
        Reconciliation_MD__mdt customDataList = [SELECT ID, Delete_Period__c,
                                                     Delete_Window__c, Source__c, 
                                                     Status__c FROM Reconciliation_MD__mdt 
                                                     WHERE Label = 'Reconciliation Record' LIMIT 1];

        try {

            for(Reconciliation__c obj : reconciliationList) {
    
                // Date Difference
                // date createdDateType = obj.CreatedDate.Date();
                dayDifference = obj.CreatedDate.Date().daysBetween(dateTime.now().date());
                System.debug('myDateTime.date() >>'+ dateTime.now().date());
                System.debug('obj.CreatedDate.Date() >>'+ obj.CreatedDate.Date());
                System.debug('dayDifference >>'+ dayDifference);
    
    
                //modifiedTime Difference
                modifyDifference = ((((System.now().getTime() - obj.lastModifiedDate.getTime())/1000)/60)/60);
    
                if((dayDifference >= integer.valueOf(customDataList.Delete_Period__c)) && 
                                    (integer.valueOf(modifyDifference) >= integer.valueOf(customDataList.Delete_Window__c)) &&
                                    (customDataList.Status__c.contains(obj.Status_p__c)) && 
                                    (customDataList.Source__c.contains(obj.Source_p__c))) {
    
                    System.debug('COndition Met');
                    if(obj.Account_lr__c != Null) {
    
                        accountIDSet.add(obj.Account_lr__c);
                    }
                    ReconciliationListDeleted.add(obj);
                    ownerIDSet.add(obj.OwnerId);
                }
            }

            userList = [SELECT ID, isActive FROM User WHERE ID IN : ownerIDSet];
            accountListDelete = [SELECT ID FROM Account WHERE ID IN : accountIDSet];
            contactListDelete = [SELECT ID, Name FROM Contact WHERE AccountID IN : accountIDSet];
            if(contactListDelete.size() > 0) {
                
                System.debug('contactListDelete >>'+contactListDelete);
                Database.DeleteResult[] deleteResutltList1 = Database.delete(contactListDelete, false);
            }
            if(accountListDelete.size() > 0) {
                
                System.debug('accountListDelete >>'+accountListDelete);
                Database.DeleteResult[] deleteResutltList2 = Database.delete(accountListDelete, false);
                for(Database.DeleteResult d : deleteResutltList2)  
                {
                    if (d.isSuccess()) {
                        System.debug('Successfully deleted Account with ID: ' + d.getId());
                    }
                    else {
                        for(Database.Error er : d.getErrors()) {

                            stringList.add(er.getFields()[0]);
                            System.debug('The following error has occurred.');                    
                            System.debug(er.getStatusCode() + ': ' + er.getMessage());
                            System.debug('Account fields that affected this error: ' + er.getFields());
                        }
                    }
                }
            }
            if(ReconciliationListDeleted.size() > 0) { //COndition Changed when Real Working < to > ;
                    
                System.debug('ReconciliationListDeleted >>'+ReconciliationListDeleted);
                Database.DeleteResult[] deleteResutltList = Database.delete(ReconciliationListDeleted, false);
                
                for(Database.DeleteResult d : deleteResutltList)  
                {
                    if (d.isSuccess()) {
                        System.debug('Successfully deleted Reconciliation with ID: ' + d.getId());
                    }
                    else {
                        for(Database.Error er : d.getErrors()) {

                            stringList.add(er.getFields()[0]);
                            System.debug('The following error has occurred.');                    
                            System.debug(er.getStatusCode() + ': ' + er.getMessage());
                            System.debug('Reconciliation fields that affected this error: ' + er.getFields());
                        }
                    }
                }
            }
        }
        Catch (Exception exp) {
        
            Database.rollback(sp);

            system.debug('The following exception has occurred in Class "Reconciliation_Batch_Class" : ' + exp.getMessage() +
                        ' at Line no: ' + exp.getLineNumber());
        }   
        if(stringList.size() > 0) {
            Database.rollback(sp);
        }
    }

        public void finish(Database.BatchableContext BC){ 

            System.debug('userList >>>'+userList);
            if(stringList.size() <= 0) {

                //Reconciliation_Apex_For_Delete_Records.deleteRecordsMethod(userList2);
                System.enqueueJob(new Reconciliation_Queueable_for_user(userList));
            }
            else{
                system.debug('Error in Deleting Data');
            }
        }
    } 
    

/*

Reconciliation_Batch_Class obj = new Reconciliation_Batch_Class();
ID batchprocessid = Database.executeBatch(obj);


System.debug('DateTime.date() >>'+DateTime.now().date());
System.debug('DateTime.date() Time>>'+DateTime.now());
*/