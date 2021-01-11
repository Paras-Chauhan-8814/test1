public with sharing class accountUpdate {
    
    public static void stopAccountUpdation(List<Account> accList, Map<ID, Account> mapAccount) {

        try{
            for(Account a : accList) {
                if((a.Status__c == 'Approved') && (a.Name != mapAccount.get(a.ID).Name)) {

                    a.addError('You Cannot Change Account Name Because Status Is Approved');
                }
            }
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in Class accountUpdate method "stopAccountUpdation" : ' + exp.getMessage() +
                        ' at Line no: ' + exp.getLineNumber());

                        

        }
    }

    public static void createDefaultContact(Map<ID, Account> accMap) {

        List<Contact> createContactList = new List<Contact>();

        try {

            for(Account a : accMap.Values()) {
    
                if(a.Number_Of_Contacts__c > 1 && a.Allow_Multiple__c == FALSE) {

                    a.addError('Please Do Chak Allow Multiple Option');
                }
                else {

                    for(integer i=0; i<a.Number_Of_Contacts__c; i++) {
                        Contact con = new Contact();
                        con.LastName = a.Name;
                        Con.FirstName = 'con';
                        Con.AccountID = a.ID;
                        createContactList.add(con);
                    }
                }
            }
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in Class accountUpdate method "createDefaultContact" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
            if(createContactList.size() > 0) {
    
                insert createContactList;
            }
        
        }

    public static void deleteDefaultContact(Map<ID, Account> accNewMap, Map<ID, Account> accOldMap) {

        List<Contact> createContactList = new List<Contact>();
        List<Contact> deleteContactList = new List<Contact>();
        List<Contact> getAccountRelatedContact = new List<Contact>();
        Set<ID> accountIDSet = new Set<ID>();
        Map<ID, Decimal> accountIdVSTotleContactDelete = new Map<ID, Decimal>();
        Decimal currentNumberOFContact = 0;
        Decimal oldvalueNumberOFContact = 0;
        Decimal difference = 0;

        // try{

        for(Account a : accNewMap.Values()) {

            if(accOldMap.get(a.ID).Number_Of_Contacts__c != NULL) {

                oldvalueNumberOFContact = accOldMap.get(a.ID).Number_Of_Contacts__c;
            }

            if(a.Number_Of_Contacts__c != NULL) {

                currentNumberOFContact = a.Number_Of_Contacts__c;
            }
           
            difference = currentNumberOFContact - oldvalueNumberOFContact;
            if((difference > 1 && (a.Allow_Multiple__c == False)) || (accOldMap.get(a.ID).Number_Of_Contacts__c > 1) && difference > 0) {

                a.addError('Please Do Chak Allow Multiple Option');
            }
            else if(difference > 0) {
                for(integer i=0; i<difference; i++) {
                    Contact con = new Contact();
                    con.LastName = a.Name;
                    con.FirstName = 'con'+i;
                    con.AccountID = a.ID;
                    createContactList.add(con);
                }
            }
            else if(difference < 0){

                accountIDSet.add(a.ID);
                accountIdVSTotleContactDelete.put(a.ID, difference * -1);
            }
        }

        if(createContactList.size() > 0) {

            insert createContactList;
        }

        if(accountIDSet.size() > 0) {

            getAccountRelatedContact = [SELECT ID, AccountID FROM Contact WHERE AccountID IN: accountIDSet];
    
            for(Contact c : getAccountRelatedContact) {
    
                if(accountIdVSTotleContactDelete.get(c.AccountID) > 0) {
    
                    deleteContactList.add(c);
                    accountIdVSTotleContactDelete.put(c.AccountID, accountIdVSTotleContactDelete.get(c.AccountID) - 1);
                }
            }
            if(deleteContactList.size() > 0) {
    
                delete deleteContactList;
            }
        }
    // }
    // Catch(Exception exp) {
    //     system.debug('The following exception has occurred in Class accountUpdate method "deleteDefaultContact" : ' + exp.getMessage() +
    //                  ' at Line no: ' + exp.getLineNumber());
    // }

        
    }
}