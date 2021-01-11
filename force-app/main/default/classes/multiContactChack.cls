public with sharing class multiContactChack {
    
    public static void chackAccountAllowMultiple(List<Contact> conList) {

        Set<ID> accountIDSet = new Set<ID>();
        Map<ID, Account> getAccountData ;
        List<Contact> getAccountRelatedContact = new List<Contact>(); 
        List<Contact> oldAndNewDataBothList = new List<Contact>();
        Map<ID, Integer> accountVSTotleContact = new Map<ID, Integer>();

        oldAndNewDataBothList.addAll(conList);

        try {

            for(Contact c : conlist) {
                if(c.AccountID != Null) {
    
                    accountIDSet.add(c.AccountID);
                }
            }
    
            if(accountIDSet.size()>0) {
    
                getAccountData = new Map<ID, Account>([SELECT ID, Allow_Multiple__c FROM Account WHERE ID IN : accountIDSet]);
                getAccountRelatedContact = [SELECT ID, AccountID FROM Contact WHERE AccountID IN : accountIDSet];
                oldAndNewDataBothList.addAll(getAccountRelatedContact);
    
                for(Contact c : oldAndNewDataBothList) {
    
                    if(accountVSTotleContact.containsKey(c.AccountID)) {
    
                        accountVSTotleContact.put(c.AccountID, accountVSTotleContact.get(c.AccountID) + 1);
                    }
                    else {
    
                        accountVSTotleContact.put(c.AccountID, 1);
                    }
                }
            }
    
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in Class multiContactChack And method "chackAccountAllowMultiple" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
            for(Contact c : conList) {

                if(c.AccountID != null)  {

                    if((getAccountData.get(c.AccountID).Allow_Multiple__c == FALSE) && accountVSTotleContact.get(c.AccountID) > 1) {
        
                        c.addError('The Related Account is Not allow Multiple Contact');
                    }
                }
            }
    
       
    }
}