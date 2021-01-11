@isTest
private class accountUpdate_Test_Class {
    
    @testSetup static void testData() {

        Account acc = new Account();
        acc.Name = 'Acc';
        Insert acc;

    }


    @isTest static void stopAccountUpdation() {

        Account accObj = [SELECT ID ,Status__C FROM Account LIMIT 1];

        accObj.Status__C = 'Approved';
        Update accObj;

        Account accObj1 = [SELECT ID, Name, Status__C FROM Account LIMIT 1];
        accObj1.Name = 'Update';

        try{

            Update accObj1;
        }
        Catch(Exception e) {

            System.Assert(e.getMessage().Contains('You Cannot Change Account Name Because Status Is Approved'));
        }
    }

    @isTest static void createDefaultContact() {

        Account accObj = new Account();
        accObj.Name = 'Account';
        accObj.Number_OF_Contacts__c = 5;

        try{
            insert accObj;
        }
        Catch(Exception e) {

            System.Assert(e.getMessage().Contains('Please Do Chak Allow Multiple Option'));
        }

        Account accObj1 = new Account();
        accObj1.Name = 'Account1';
        accObj1.Number_OF_Contacts__c = 5;
        accObj1.Allow_Multiple__C = TRUE;

        Insert accObj1;

        List<Contact> conList = [SELECT ID FROM Contact ];
        system.assertEquals(5, conList.Size(), '5 Contact Created Succesfully');
        
    }

    @isTest static void deleteDefaultContact() {

        Account accObj = [SELECT ID ,Status__C , Number_OF_Contacts__c FROM Account LIMIT 1];
        accObj.Number_OF_Contacts__c = 5;

        try{
            Update accObj;
        }
        Catch(Exception e) {

            System.Assert(e.getMessage().Contains('Please Do Chak Allow Multiple Option'));
        }

        Account accObj1 = [SELECT ID, Name, Status__C , Number_OF_Contacts__c, Allow_Multiple__C FROM Account LIMIT 1];
        accObj1.Number_OF_Contacts__c = 5;
        accObj1.Allow_Multiple__C = TRUE;

        Update accObj1;

        List<Contact> conList = [SELECT ID FROM Contact ];
        System.assertEquals(5, conList.Size(), '5 Contact Not Created Succesfully');

        Account accObj2 = [SELECT ID, Name, Status__C , Number_OF_Contacts__c, Allow_Multiple__C FROM Account LIMIT 1];
        accObj2.Number_OF_Contacts__c = 2;
        accObj2.Allow_Multiple__C = TRUE;

        Update accObj2;

        List<Contact> conList1 = [SELECT ID FROM Contact ];
        System.assertEquals(2, conList1.Size(), '3 Contact Not Deleted Succesfully');
        
    }
}