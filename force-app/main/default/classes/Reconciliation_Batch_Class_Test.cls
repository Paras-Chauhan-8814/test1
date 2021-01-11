@isTest
private class Reconciliation_Batch_Class_Test {


    @testSetup static void testSetup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        List<Contact> testCont = new List<Contact>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'Test'+i));
        }
        insert testAccts;
        
        for(Account a : testAccts) {
            testCont.add(new Contact(LastName = 'Con', firstName = a.Name, AccountID = a.ID));
        }
        insert testCont;

        User usr = new User();
        usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' limit 1].Id;                   
        usr.LastName = 'Test';
        usr.Email = 'test@test.com';
        usr.Username = 'test@test.com' + System.currentTimeMillis();
        usr.CompanyName = 'Salesforce';
        usr.Title = 'Title';
        usr.Alias = 'Roger';
        usr.IsActive = true;
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        insert usr;
        System.debug('user new >>'+usr);
        

    }

    @isTest
    public static void Reconciliation_Batch_Class_Test_Method() {

        //Status_p__c, OwnerId, Source_p__c, Account_lr__c
        User u = [SELECT Id FROM User WHERE Email = 'test@test.com'];
        System.debug('User List >>'+u);
        List<Account> actList = [SELECT Id FROM Account];

        List<Reconciliation__c> reconList = new List<Reconciliation__c>();
        Reconciliation__c obj1 = new Reconciliation__c();
        obj1.Source_p__c = 'Online';
        obj1.Status_p__c = 'New';
        obj1.Account_lr__c = actList[0].ID;
        obj1.OwnerId = u.ID;
        reconList.add(obj1);

        Reconciliation__c obj2 = new Reconciliation__c();
        obj2.Source_p__c = 'Email';
        obj2.Status_p__c = 'New Pending';
        obj2.Account_lr__c = actList[1].ID;
        obj2.OwnerId = u.ID;
        reconList.add(obj2);

        if(reconList.size() > 0) {

            insert reconList;
        }

        test.startTest();

        Reconciliation_Batch_Class obj = new Reconciliation_Batch_Class();
        ID batchprocessid = Database.executeBatch(obj);

        test.stopTest();

        List<Account> chackAcc = [SELECT ID FROM Account];
        List<Contact> chackContact = [SELECT ID FROM Contact];
        List<Reconciliation__c> chackRecon = [SELECT ID FROM Reconciliation__c];
        List<User> chackUser = [SELECT ID, isActive FROM User WHERE Email = 'test@test.com'];

        System.AssertEquals(1, chackAcc.size(), 'Account not Deleted');
        System.AssertEquals(1, chackContact.size(), 'Contact not Deleted');
        System.AssertEquals(1, chackRecon.size(), 'Reconciliation not Deleted');
        System.AssertEquals(False, chackUser[0].isActive, 'User not De-Activated');

    }
}
