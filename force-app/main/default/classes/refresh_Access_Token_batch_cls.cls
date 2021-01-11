public class refresh_Access_Token_batch_cls implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID, Redirect_Url__c, Name, Client_ID__c, Client_Secret__c, access_token__c, Cloud_ID__c, Refresh_Token__c FROM Jira_Integration__c');

    }
    
    public void execute(Database.BatchableContext BC, List<Jira_Integration__c> jiraInteDataList){

        List<Jira_Integration__c> jiraInteData = new List<Jira_Integration__c>();
        for(Jira_Integration__c obj : jiraInteDataList) {
            if(obj.Name == 'Jira' ) {
                jiraInteData.add(obj);
            }
        }
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndpoint('https://auth.atlassian.com/oauth/token');
            req.setHeader('Content-Type','application/json');
            req.setMethod('POST');
            req.setBody('{ "grant_type": "refresh_token", "client_id": "'+jiraInteData[0].Client_ID__c+'", "client_secret": "'+jiraInteData[0].Client_Secret__c+'", "refresh_token": "'+jiraInteData[0].Refresh_Token__c+'" }');
            res = http.send(req);

            System.debug('Getting Refresh Access Code From RefreshToken >>> '+ res.getBody());
            
            Map<String, Object> JsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            string accessToken = String.ValueOf(JsonMap.get('access_token'));
              
            jiraInteData[0].access_token__c = accessToken;
            update jiraInteData;
    }
    public void finish(Database.BatchableContext BC){

        System.debug('Access token Succesfully refreshed');
    }
    }