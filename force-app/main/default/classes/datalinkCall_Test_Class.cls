@isTest
private class datalinkCall_Test_Class {
    
    @testSetup static void testData() {
        List<Account> accountList = new List<Account>();

        for(integer i=0;i<4;i++){

            account acc = new account();
            acc.Name = 'acc'+i;
            accountList.add(acc);
        }
        insert accountList;

    }

    @isTest static void dataLinkDataInsert() {

        List<Data_Link__c> dataLinkList = new List<Data_Link__c>();
        List<Account> accountList1 = [SELECT ID FROM Account];
        
        for(integer i=0;i<3;i++) {

            Data_Link__c obj1 = new Data_Link__c();
            obj1.DataLink_Production_Installed__c = System.today();
            obj1.Account__c = accountList1[0].ID;
            dataLinkList.add(obj1);
            
            Data_Link__c obj2 = new Data_Link__c();
            obj2.Account__c = accountList1[1].ID;
            dataLinkList.add(obj2);

            Data_Link__c obj3 = new Data_Link__c();
            obj3.DataLink_Production_Uninstalled__c = System.today().addDays(3);
            obj3.Account__c = accountList1[2].ID;
            dataLinkList.add(obj3);
        }
        test.startTest();
                
                insert dataLinkList;

        test.stopTest();

    }

    @isTest static void dataLinkDataUpdate() {
        

        List<Data_Link__c> dataLinkList = new List<Data_Link__c>();
        Account acc = [SELECT ID FROM Account WHERE Name = 'acc3' LIMIT 1];
        for(integer i=0; i<3; i++) {

            Data_Link__c obj = new Data_Link__c();
            obj.Account__c = acc.ID;
            dataLinkList.add(obj);
        }
        if(dataLinkList.size() > 0) {
                
            insert dataLinkList;
        }

        Account acc1 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
        System.assertequals('Sandbox', acc1.Dl_Client__c);

        List<Data_Link__c> dataObj = [SELECT ID, DataLink_Production_Installed__c from Data_Link__c WHERE Account__c =: acc1.ID];
        dataObj[0].DataLink_Production_Installed__c = System.today();

        test.startTest();

        update dataObj;

        test.stopTest();

        Account acc2 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
        System.assertequals('Production', acc2.Dl_Client__c);

        

       // List<Data_Link__c> dataLinkList = new List<Data_Link__c>();
    }
    @isTest static void dataLinkDataDelete() {
        

        List<Data_Link__c> dataLinkList = new List<Data_Link__c>();
        Account acc = [SELECT ID FROM Account WHERE Name = 'acc3' LIMIT 1];
        for(integer i=0; i<3; i++) {

            Data_Link__c obj = new Data_Link__c();
            obj.Account__c = acc.ID;
            dataLinkList.add(obj);
        }

        if(dataLinkList.size() > 0) {
                
            insert dataLinkList;
        }

        Account acc1 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
        system.assertequals('Sandbox', acc1.Dl_Client__c);

        List<Data_Link__c> dataObj = [SELECT ID, DataLink_Production_Installed__c FROM Data_Link__c WHERE Account__c =: acc1.ID limit 1];

        dataObj[0].DataLink_Production_Installed__c = System.today();
        update dataObj;

        Account acc2 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
        System.assertequals('Production', acc2.Dl_Client__c);

        test.startTest();
        delete dataObj;
        
            Account acc3 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
            System.assertequals('Sandbox', acc3.Dl_Client__c);

            List<Data_Link__c> dataObj2 = [SELECT ID, DataLink_Production_Installed__c from Data_Link__c WHERE Account__c = :acc1.ID];

            delete dataObj2;

        test.stopTest();
        Account acc4 = [SELECT ID, Dl_Client__c FROM Account WHERE Name = 'acc3'];
        System.assertequals('blank', acc4.Dl_Client__c);

    }
}