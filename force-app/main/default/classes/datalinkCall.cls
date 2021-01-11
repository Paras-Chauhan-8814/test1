public class datalinkCall {
   
    public static void dataLinkAccountUpdate(List<Data_Link__c> dataLinkList,string action) {

        Set<ID> accountIDSet = new Set<ID>();
        Set<ID> dataLinkIDSet = new Set<ID>();
        Map<ID, String> accountVSDlClientPicklistValue = new Map<ID, String>();
        Map<ID, List<Data_Link__c>> accountVSDataLinkRecordsMap = new Map<ID, List<Data_Link__c>>();
        Map<ID, Integer> accountVSDlCounts = new Map<ID,Integer>();
        List<Data_Link__c> oldDataLinklist = new List<Data_Link__c>();
        List<Data_Link__c> newOldDataTogether = new List<Data_Link__c>();
        List<Account> acclist = new List<Account>();
        Boolean sandbox = false;
        Boolean production = false;
        Boolean former = false;
        Integer count0 = 0;
        Integer count = 0;
        Integer count1 = 0;

        //List<Data_Link__c> newDataLinkList = new List<Data_Link__c>();
        // set<ID> AccountidsetUpdate = new set<ID>();


        try{

            for(Data_Link__c d : dataLinkList) {
               // newDataLinkList.add(d);
                accountIDSet.add(d.Account__c);
                if(action == 'Update' || action == 'Delete') { 

                    dataLinkIDSet.add(d.ID);
                }
            }
            
            if(accountIDSet.size()>0) {

                // if(action == 'Update' || action == 'Delete') {

                    oldDataLinklist =  [SELECT ID, Account__c, DataLink_Production_Installed__c,  DataLink_Production_Uninstalled__c, DataLink_Sandbox_Uninstalled__c FROM  Data_Link__c WHERE Account__c IN : accountIDSet AND ID NOT IN : dataLinkIDSet];
                // }
                // else {

                //     oldDataLinklist = [SELECT ID, Account__c, DataLink_Production_Installed__c,  DataLink_Production_Uninstalled__c,  DataLink_Sandbox_Uninstalled__c FROM  Data_Link__c WHERE Account__c IN : accountIDSet];
                // }

                if(action != 'Delete') {
                    
                    newOldDataTogether.addAll(datalinklist);
                }
                newOldDataTogether.addAll(oldDataLinklist);
    
    
                    for(Data_Link__c obj : newOldDataTogether) {
    
                        if(!accountVSDataLinkRecordsMap.containsKey(obj.Account__c)) {
    
                            accountVSDataLinkRecordsMap.put(obj.Account__c, new List<Data_Link__c>());
                            accountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                        }
                        else {
    
                            accountVSDataLinkRecordsMap.get(obj.Account__c).add(obj);
                        }
                    }
    
            }
    
                for(Data_Link__c obj : dataLinkList) {
    
                    production = false;
                    sandbox = false;
                    former = false;
                    count0 = 0;
                    count = 0;
                    count1 = 0;
    
                    if(accountVSDataLinkRecordsMap.containsKey(obj.Account__c)) {
    
                        for(Data_Link__c obj1 : accountVSDataLinkRecordsMap.get(obj.Account__c)) {
        
                            //condition for Production
                            if((obj1.DataLink_Production_Installed__c != NULL) && (obj1.DataLink_Production_Uninstalled__c == null)) {
            
                                Production = true ;
                                count0 += 1;
                            }
            
                            //condition for Sandbox
                            if((obj1.DataLink_Production_Installed__c == NULL) && (obj1.DataLink_Production_Uninstalled__c == null)) {
                                Sandbox = true;
                            }
                            else {
                                    count = 1;
                            }
            
                            //Condition for formar
                            if((obj1.DataLink_Sandbox_Uninstalled__c != NULL) || (obj1.DataLink_Production_Uninstalled__c != null)) {
                                former = true;
                            }
                            else {
                                    count1 = 1;
                            }
            
                        }
                    }
                    
                        //condition for Production
                        if((production == true) && (count0 > 0)) {
                            accountVSDlClientPicklistValue.put(obj.Account__c, 'Production');
                            accountVSDlCounts.put(obj.Account__c, count0);
                        }
        
                        //condition for Sandbox
                        else if((sandbox == true) && (count < 1)) {
                            accountVSDlClientPicklistValue.put(obj.Account__c, 'Sandbox');
                            accountVSDlCounts.put(obj.Account__c, count0);
                        }
        
                        //condition for former
                        else if((former == true) && (count1 < 1)) {
                            accountVSDlClientPicklistValue.put(obj.Account__c, 'former');
                            accountVSDlCounts.put(obj.Account__c, count0);
                        }
        
                        //condition for Blank
                        else {
                            accountVSDlClientPicklistValue.put(obj.Account__c, 'Blank');
                            accountVSDlCounts.put(obj.Account__c, count0);
                        }
                }
                //system.debug();
                Map<ID, Account> accRelatedDataLink = new Map<ID,Account>([SELECT ID, Dl_Client__c, DL_of_Installs__c From Account WHERE ID IN: accountIDSet]);
        
                for(Account a: accRelatedDataLink.values()) {
        
                    a.Dl_Client__c =  accountVSDlClientPicklistValue.get(a.ID);
                    a.DL_of_Installs__c =accountVSDlCounts.get(a.ID);
                
                    acclist.add(a);
                        
                }
        
                if(acclist.size()>0) {
                    
                    update acclist;
                }
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in method "appointmentConditions" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }

    }
}