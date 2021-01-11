@RestResource(urlMapping = '/getAccountList/*')

global without sharing class getAccountData_Rest {
    
    @HttpGet
    global static List<Account>  GetAccountList() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        List<Account> acntList = [SELECT ID, Name, AnnualRevenue, AccountNumber, Phone FROM Account LIMIT 100];
        return acntList;
    }

    @HttpPatch
    global static ID updateAccount() {
        RestRequest request = RestContext.request;
        string accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id ,AnnualRevenue, AccountNumber, Phone From Account WHERE Id =: accountId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.tostring());
        System.debug('accc'+accountId);
        for(string fieldname : params.keySet()) {
            thisAccount.put(fieldname, params.get(fieldname));
        }
        update thisAccount;
        return thisAccount.ID;
    }

    @HttpDelete
    global Static string deleteAccount() {

        RestRequest request = RestContext.request;
        string accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id =: accountId];
        DELETE thisAccount;
        return 'Succesfully Delete';
    }
}