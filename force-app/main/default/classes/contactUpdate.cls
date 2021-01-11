public with sharing class contactUpdate {
    
    public static void contactAccountApproved(List<Contact> updatedContact) {

        Set<ID> accountIdSet = new Set<ID>();
        List<Account> getAccountData = new List<Account>();
        Map<ID, Account> accountIdVSAccount ;

        try {

            for(contact c : updatedContact) {
    
                if(c.accountID != Null) {
                    
                    accountIdSet.add(c.accountID);
                }
            }
    
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in Class contactUpdate And method "contactAccountApproved" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
            if(accountIdSet.size() > 0) {
    
                accountIdVSAccount = new Map<ID, Account>([SELECT ID, Status__c FROM Account WHERE ID IN: accountIdSet]);
    
                for(Contact obj : updatedContact) {
        
                    if(accountIdVSAccount.get(obj.AccountID).Status__c == 'Approved') {
        
                        obj.addError('Contact Cannot be Updated Because Account Status is Approved');
                    }
                }
            }
        

    }
}