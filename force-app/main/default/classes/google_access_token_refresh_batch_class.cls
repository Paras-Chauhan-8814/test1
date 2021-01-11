public class google_access_token_refresh_batch_class implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{

    
    public Database.QueryLocator start(Database.BatchableContext BC){
        string name = 'SELECT ID, Redirect_Url__c, Name, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c';
        return Database.getQueryLocator(name);

    }
    
    public void execute(Database.BatchableContext BC, List<Jira_Integration__c> googleDataList){
try{

    List<Jira_Integration__c> googleData = new List<Jira_Integration__c>();
    for(Jira_Integration__c obj : googleDataList) {
        if(obj.Name == 'Google' ) {
            googleData.add(obj);
        }
    }
    
    System.debug('googleData>>  '+googleData[0].Name);
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
        req.setEndPoint('https://oauth2.googleapis.com/token');
        req.setMethod('POST');
        req.setHeader('Content-Type',' application/x-www-form-urlencoded');
        req.setBody('client_id='+googleData[0].Client_ID__c+'&client_secret='+googleData[0].Client_Secret__c+'&refresh_token='+googleData[0].Refresh_Token__c+'&grant_type=refresh_token');

        res = http.send(req);

            System.debug('Getting Refresh Access Code From RefreshToken >>> '+ res.getBody());
            
            Map<String, Object> JsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            string accessToken = String.ValueOf(JsonMap.get('access_token'));
            
            googleData[0].access_token__c = accessToken;
            update googleData;
        }
        catch(Exception e) {
            system.debug('error'+e.getMessage() +'Line No '+e.getLineNumber());
        }
    }
    public void finish(Database.BatchableContext BC){

        System.debug('Access token Succesfully refreshed');
    }
    }