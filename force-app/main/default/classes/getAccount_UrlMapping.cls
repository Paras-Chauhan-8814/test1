@RestResource(urlMapping = '/getAccount/*')
global without sharing class getAccount_UrlMapping {

    global class wrapperClass{
        public List<Opportunity> opportunityWrapperList;
        public List<Contact> contactWrapperList;
        public List<Account> accountWrapperList;
    }

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
    // @HttpGet
    // global static Account doGet() {
    //     RestRequest req = RestContext.request;
    //     RestResponse res = RestContext.response;
    //     // String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    //     Account result = [SELECT Id, Name, Phone, Website FROM Account Limit 1];
    //     return result;
    // }


    @HttpGet
    global static wrapperClass doGetAccountList() {

        wrapperClass wrapperClassObj = new wrapperClass();

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        // Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        List<Account> result = [SELECT Id, Name, Phone, Website FROM Account Limit 10];
        List<Contact> conList = [SELECT ID, LastName, Name FROM Contact LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name, CloseDate, stageName FROM Opportunity Limit 1];

        wrapperClassObj.opportunityWrapperList = oppList;
        wrapperClassObj.contactWrapperList = conList;
        wrapperClassObj.accountWrapperList = result;

        return wrapperClassObj;
    }
}