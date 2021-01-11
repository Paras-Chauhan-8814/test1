trigger AccountCreateEventTrigger on Account_Create_Event__e (after insert) {

    List<Contact> conList = new List<Contact>();

    // Account acc1 = new Account();
    // acc1.Name = 'Event3 1';
    // insert acc1;
    system.debug('PE Trigger Called >>');
    for(Account_Create_Event__e e : trigger.new) {
        system.debug(e);
        Contact con = new Contact();
        con.lastName = 'Contact';
        con.firstName = 'P E';
        con.OwnerID = e.User_Id__c;
        // insert acc;
        conList.add(con);  
    }
    if(conList.size() > 0) {

        system.debug('Before Insert' +conList);
        insert conList;
        system.debug('After INsert' + conList);
    }
}