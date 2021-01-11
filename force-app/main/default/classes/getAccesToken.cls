public without sharing class getAccesToken {
    public getAccesToken() {

    }
    @AuraEnabled
    public static String getAccessToken(string authorizationCode) {

        Jira_Integration__c jiraInte = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Jira'];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse res = new HttpResponse();
        request.setEndpoint('https://auth.atlassian.com/oauth/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"grant_type": "authorization_code","client_id": "'+jiraInte.Client_ID__c+'","client_secret": "'+jiraInte.Client_Secret__c+'","code": "'+authorizationCode+'","redirect_uri": "'+jiraInte.Redirect_Url__c+'"}');

        res = http.send(request);
        Map<String, Object> JsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        string accessToken = String.ValueOf(JsonMap.get('access_token'));
        string refreshToken = String.ValueOf(JsonMap.get('refresh_token'));
          
        string cloudID = getCloudID(accessToken);
        jiraInte.access_token__c = accessToken;
        jiraInte.Refresh_Token__c = refreshToken;
        update jiraInte;

        
        return 'Cloud ID>> '+cloudID+'refreshToken>> '+refreshToken+' Access Token >> '+accessToken;

    }

    @AuraEnabled
    public static String getCloudID(String accessToken) {

        system.debug('Acces token in other class>> ' + accessToken);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint('https://api.atlassian.com/oauth/token/accessible-resources');
        req.setHeader('Authorization',' Bearer '+accessToken+'');
        req.setHeader('Accept','application/json');
        req.setHeader('Content-Type','application/json');
        req.setMethod('GET');

        res = http.send(req);

        List<Object> resultList = (List<Object>) JSON.deserializeUntyped(res.getBody());
        object resultId=(Object)resultList[0];
        Map < String,Object > resultsMap = ( Map < String,Object > ) resultId;

        String cloudID = String.valueOf(resultsMap.get('id'));
        Jira_Integration__c jiraInte = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c FROM Jira_Integration__c WHERE Name =: 'Jira'];
        jiraInte.Cloud_ID__c = cloudID;

        update jiraInte;

        return cloudID;
    }

    @AuraEnabled
    public static string refreshAccessToken(){

        Jira_Integration__c jiraInteData = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Jira'];
        string retun = '';
        try {
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndpoint('https://auth.atlassian.com/oauth/token');
            req.setHeader('Content-Type','application/json');
            req.setMethod('POST');
            req.setBody('{ "grant_type": "refresh_token", "client_id": "'+jiraInteData.Client_ID__c+'", "client_secret": "'+jiraInteData.Client_Secret__c+'", "refresh_token": "'+jiraInteData.Refresh_Token__c+'" }');
            res = http.send(req);

            System.debug('Getting Refresh Access Code From RefreshToken >>> '+ res.getBody());
            
            Map<String, Object> JsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            string accessToken = String.ValueOf(JsonMap.get('access_token'));
            retun = accessToken;
            // string refreshToken = String.ValueOf(JsonMap.get('refresh_token'));
              
            jiraInteData.access_token__c = accessToken;
            update jiraInteData;
    

        } catch (Exception ex) {

            System.debug('Error Message is :- '+ex.getMessage()+'......... Error Line Number is :- '+ ex.getLineNumber());
        }
        return retun;
    }


    @AuraEnabled
    public static string createIssueInJira(){
        try {
            Jira_Integration__c jiraInte = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c FROM Jira_Integration__c WHERE Name =: 'Jira'];

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndpoint('https://api.atlassian.com/ex/jira/'+jiraInte.Cloud_ID__c+'/rest/api/3/issue');
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer '+jiraInte.access_token__c);
            req.setHeader('Content-Type' , 'application/json');
            req.setBody('{"fields": {"project":{"key": "PJ"},"summary": "Created By apex","description": {"type": "doc","version": 1,"content": [{"type": "paragraph","content": [{"type": "text","text": "description"}]}]},"issuetype": {"name": "Task"}}}');

            res = http.send(req);

            system.debug('After Created Issue By apex >> '+res.getBody());

        } catch (Exception ex) {
            
            System.debug('Error Message is :- '+ex.getMessage()+'......... Error Line Number is :- '+ ex.getLineNumber());
        }

        return 'Succesfully';   
    }
    @AuraEnabled
    public static string updateIssueInJira(){
        try {
            Jira_Integration__c jiraInte = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c FROM Jira_Integration__c WHERE Name =: 'Jira'];

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            // req.setEndpoint('https://api.atlassian.com/ex/jira/'+jiraInte.Cloud_ID__c+'/rest/api/3/issue/pj-8');
            req.setEndpoint('https://api.atlassian.com/ex/jira/'+jiraInte.Cloud_ID__c+'/rest/api/3/issue/pj-4/assignee');
            req.setMethod('PUT');
            req.setHeader('Authorization', 'Bearer '+jiraInte.access_token__c);
            req.setHeader('Content-Type' , 'application/json');
            // req.setBody('{"fields": {"project":{"key": "PJ"},"summary": "Updated Pj-8 By ","description": {"type": "doc","version": 1,"content": [{"type": "paragraph","content": [{"type": "text","text": "description"}]}]},"issuetype": {"name": "Task"}}}');
            // req.setBody('{"fields": {"project":{"key": "PJ"},"summary": "Updated Pj-8 By Half Body"}}');
            req.setBody('{"accountId": "5fa0ea64dbf337006cbd4795"}');  //  5fa0ea5722f39900769b444b

            res = http.send(req);

            system.debug('After Created Issue By apex >> '+res.getBody());

        } catch (Exception ex) {
            
            System.debug('Error Message is :- '+ex.getMessage()+'......... Error Line Number is :- '+ ex.getLineNumber());
        }

        return 'Succesfully';   
    }
    @AuraEnabled
    public static string deleteIssueInJira(){
        try {
            Jira_Integration__c jiraInte = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c FROM Jira_Integration__c WHERE Name =: 'Jira'];

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndpoint('https://api.atlassian.com/ex/jira/'+jiraInte.Cloud_ID__c+'/rest/api/3/issue/pj-9');
            req.setMethod('DELETE');
            req.setHeader('Authorization', 'Bearer '+jiraInte.access_token__c);
            req.setHeader('Content-Type' , 'application/json');
            // req.setBody('{"fields": {"project":{"key": "PJ"},"summary": "Updated Pj-8 By ","description": {"type": "doc","version": 1,"content": [{"type": "paragraph","content": [{"type": "text","text": "description"}]}]},"issuetype": {"name": "Task"}}}');

            res = http.send(req);

            system.debug('After Created Issue By apex >> '+res.getBody());

        } catch (Exception ex) {
            
            System.debug('Error Message is :- '+ex.getMessage()+'......... Error Line Number is :- '+ ex.getLineNumber());
        }

        return 'Succesfully';   
    }
}