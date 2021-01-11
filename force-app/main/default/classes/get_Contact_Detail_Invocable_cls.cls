public with sharing class get_Contact_Detail_Invocable_cls {
    @InvocableMethod(label = 'My Contact Detail')
    public static List<Contact>  getAccountInformation(List<String> nameInput) {

        List<Contact> accList = [SELECT ID, LastName, FirstName, Email, MailingCountry, Phone FROM Contact WHERE Name IN : nameInput];
        return accList;
    }
}