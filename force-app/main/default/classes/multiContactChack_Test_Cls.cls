@isTest
private class multiContactChack_Test_Cls {
    
    @isTest static void chackMulti() {

        List<Contact> conList = new List<Contact>();
        Account acc = new Account();
        acc.Name = 'Account';
        insert acc;

        Account acc1 = new Account();
        acc1.Name = 'Account';
        acc1.Allow_Multiple__c = TRUE;
        insert acc1;

        for(Integer i=0;i<3;i++) {

            Contact con = new Contact();
            con.LastName = 'Last';
            con.AccountID = acc.ID;
            conList.add(con);
        }
        if(conList.size() > 0) {

            try{

                insert conList;
            }
            Catch(Exception e){
                    System.Assert(e.getMessage().Contains('Related Account is Not allow Multiple Contact'));
            }
        }


    }
}