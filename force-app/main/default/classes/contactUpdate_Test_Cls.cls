@isTest
private class contactUpdate_Test_Cls {
    
    @isTest static void approvedAccountContact() {

        Account acc = new Account();
        acc.Name = 'Account';
        acc.Allow_Multiple__c = TRUE;
        acc.Status__c = 'Approved';
        insert acc;

        Contact con = new COntact();
        con.LastName = 'Last';
        con.AccountID = acc.ID;
        insert con;

        Contact conObj = [SELECT ID, LastName FROM Contact LIMIT 1];

        conObj.LastName = 'Name';
        try{

            update conObj;
        }
        Catch(Exception e) {

            System.assert(e.getMessage().contains('Contact Cannot be Updated Because Account Status is Approved'));
        }



    }
}