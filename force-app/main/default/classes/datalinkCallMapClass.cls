public class datalinkCallMapClass {
   
    public static void method1(List<Data_Link__c> Datalinklist) {

        set<ID> AccountIDSet = new set<ID>();
        Map<ID, List<Data_Link__c>> AccountVSDataLinkRecordsMap = new Map<ID, List<Data_Link__c>>();
        Map<ID, String> AccountVSDlClientPicklistValue = new Map<ID, String>();
        map<ID, Integer> AccountVSDlCounts = new Map<ID,Integer>();
        Boolean Sandbox = false;
        Boolean Production = false;
        integer Productioncount = 0;
        integer count = 0;
        integer count0 = 0;
        Boolean Former = false;
        integer count1 = 0;

        for(Data_Link__c d : Datalinklist) {

            AccountIDSet.add(d.Account__c);
        }

        if(AccountIDSet.size()>0) {

            List<Data_Link__c> oldDataLinklist = [SELECT ID, Account__c, DataLink_Production_Installed__c,  DataLink_Production_Uninstalled__c, 
                                                    DataLink_Sandbox_Uninstalled__c FROM  Data_Link__c WHERE Account__c IN : AccountIDSet];
        
            if(oldDataLinklist.size()> 0) {

                // Traverse on Old data
                for(Data_Link__c obj : oldDataLinklist) {

                    if(!AccountVSDataLinkRecordsMap.containsKey(obj.Account__c)) {

                        AccountVSDataLinkRecordsMap.put(obj.Account__c, new List<Data_Link__c>());
                        AccountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                    }
                    else {

                        AccountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                    }
                }
            }
        }
              system.debug('AccountVSDataLinkRecordsMap'+AccountVSDataLinkRecordsMap);


            //traverse on new Data
            for(Data_Link__c obj : Datalinklist) {
            
            //set Account id Account is Production
            if((obj.DataLink_Production_Installed__c != NULL) && (obj.DataLink_Production_Uninstalled__c == null)) {

                    Production = true ;
                    if(!AccountVSDlCounts.containsKey(obj.Account__c)) {
                        AccountVSDlCounts.put(obj.Account__c,1);
                    }
                    else {
                        AccountVSDlCounts.put(obj.Account__c, AccountVSDlCounts.get(obj.Account__c)+1);
                    }
                    count0 += 1;
            }

            //set Account id Account is Sandbox
            if((obj.DataLink_Production_Installed__c == NULL) && (obj.DataLink_Production_Uninstalled__c == null)) {
        
                Sandbox = true;
            }
            else {
                count = 1;
            }

            if((obj.DataLink_Sandbox_Uninstalled__c != NULL) || (obj.DataLink_Production_Uninstalled__c != null)) {
        
                Former = true;
            }
            else {
                count1 = 1;
            }

            if(AccountVSDataLinkRecordsMap.ContainsKey(obj.Account__c)) {

                for(Data_Link__c obj1 : AccountVSDataLinkRecordsMap.get(obj.Account__c)) {

                    //condition for Production
                    if((obj1.DataLink_Production_Installed__c != NULL) && (obj1.DataLink_Production_Uninstalled__c == null)) {

                        Production = true ;
                        if(obj.ID != null) {
                            if(obj.ID != obj1.ID) {
                                count0 += 1;
                                if(!AccountVSDlCounts.containsKey(obj.Account__c)) {
                                    AccountVSDlCounts.put(obj.Account__c,1);
                                }
                                else {
                                    AccountVSDlCounts.put(obj.Account__c, AccountVSDlCounts.get(obj.Account__c)+1);
                                }
                            }
                        }
                        else{
                            count0 += 1;
                            if(!AccountVSDlCounts.containsKey(obj.Account__c)) {
                                AccountVSDlCounts.put(obj.Account__c,1);
                            }
                            else {
                                AccountVSDlCounts.put(obj.Account__c, AccountVSDlCounts.get(obj.Account__c)+1);
                            }
                        }
                    }

                    //condition for Sandbox
                        if((obj1.DataLink_Production_Installed__c == NULL) && (obj1.DataLink_Production_Uninstalled__c == null)) {
                            Sandbox = true;
                        }
                        else {
                            if(obj.ID != null) {
                                if(obj.ID != obj1.ID) {
                                        count = 1;
                                }
                            }
                            else{
                                count = 1;
                            }
                        }

                        //Condition for formar
                        if((obj1.DataLink_Sandbox_Uninstalled__c != NULL) || (obj1.DataLink_Production_Uninstalled__c != null)) {
                            former = true;
                        }
                        else {
                            if(obj.ID != null) {
                                if(obj.ID != obj1.ID) {
                                    count1 = 1;
                                }
                            }
                            else {
                                count1 = 1;
                            }
                        }
                }
            }

            //Add new Values in Map
            if(!AccountVSDataLinkRecordsMap.containsKey(obj.Account__c)) {

                    AccountVSDataLinkRecordsMap.put(obj.Account__c, new List<Data_Link__c>());
                    AccountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                }
                else {

                    AccountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                }
            
            //condition for Production
            if((Production == true) && (count0 > 0)) {
                AccountVSDlClientPicklistValue.put(obj.Account__c,'Production');
            }

            //condition for Sandbox
            if((Sandbox == true) && (count != 1)) {
                AccountVSDlClientPicklistValue.put(obj.Account__c,'Sandbox');
            }

            //condition for former
            if((Former == true) && (count1 != 1)) {
                AccountVSDlClientPicklistValue.put(obj.Account__c,'former');
            }

            //condition for Blank
            if(!AccountVSDlClientPicklistValue.containsKey(obj.Account__c)) {
                AccountVSDlClientPicklistValue.put(obj.Account__c,'Blank');
            }



        }



        set<ID> AccountidsetUpdate = new set<ID>();
        List<Account> acclist = new List<Account>();

        Map<ID, Account> AccRelatedDataLink = new Map<ID,Account>([SELECT ID,Dl_Client__c From Account WHERE ID IN: AccountIDSet]);
        for(Account a: AccRelatedDataLink.values()) {
            if(AccountVSDlClientPicklistValue.get(a.ID) == 'Production'){
                a.Dl_Client__c =  AccountVSDlClientPicklistValue.get(a.ID);
                a.DL_of_Installs__c =count0;
                system.debug('Count0'+count0);
                system.debug('Account map COunt'+AccountVSDlCounts.get(a.ID));
            }
            else {

                a.Dl_Client__c =  AccountVSDlClientPicklistValue.get(a.ID);
            }
            acclist.add(a);
                
        }

        if(acclist.size()>0) {
            
            update acclist;
        }
    }
}