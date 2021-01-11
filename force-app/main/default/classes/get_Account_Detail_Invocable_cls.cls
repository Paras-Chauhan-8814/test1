public with sharing class get_Account_Detail_Invocable_cls {
 
    @InvocableMethod(label = 'My Account Detail')
    public static List<Account>  getAccountInformation(List<String> nameInput) {

        List<Account> accList = [SELECT ID, Name, Accountnumber, Phone, AnnualRevenue FROM Account WHERE Name IN : nameInput];
        return accList;
    }
}