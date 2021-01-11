global without sharing class google_access_token {


    @AuraEnabled
    global static string getAuthorizationCode(String authorizationCode){

        system.debug('authorizationCode >> '+authorizationCode);

        Jira_Integration__c googleIntegrationList = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Google'];
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndPoint('https://oauth2.googleapis.com/token');
        req.setMethod('POST');
        req.setHeader('Content-Type',' application/x-www-form-urlencoded');
        req.setBody('code='+authorizationCode+'&client_id='+googleIntegrationList.Client_ID__c+'&client_secret='+googleIntegrationList.Client_Secret__c+'&redirect_uri='+googleIntegrationList.Redirect_Url__c+'&grant_type=authorization_code');

        res = http.send(req);

        string dataReturns = res.getBody();
        system.debug('dataReturns>> '+dataReturns);
        Map<String, Object> JsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        string accessToken = String.ValueOf(JsonMap.get('access_token'));
        string refreshToken = String.ValueOf(JsonMap.get('refresh_token'));

        system.debug('refreshToken>>  '+refreshToken+'refreshToken.length() >>'+refreshToken.length());
        googleIntegrationList.access_token__c = accessToken;
        if(refreshToken.length() > 0) {

            googleIntegrationList.Refresh_Token__c = refreshToken;
        }
        update googleIntegrationList;
          
        // system.debug('Res.getBody Returns This >> ' + dataReturns);
        system.debug('refreshToken  >> ' + refreshToken);
        return res.getBody();
    }

    @AuraEnabled
    global static Map<string, String> getGoogleData(){

        List<String> fileList = new List<String>();
        Map<String,String> fileIdVSNameMap=new Map<String,String>();
        Map<String, String> fileIdAndNameMap;


        Jira_Integration__c googleIntegrationList = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Google'];
        string driveData = '';
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            // req.setEndPoint('https://www.googleapis.com/drive/v2/files/19ZFvkKBASjpK-ps0Nt1wynwdJ9TfHWut/children');  ///Picturs
            // req.setEndPoint('https://www.googleapis.com/drive/v2/files/1_GC3-t_PsMXJDUKGvQyiP3sreSrHDGy0/children');  ///projectDynaicScreen Files
            req.setEndPoint('https://www.googleapis.com/drive/v2/files/1Agy_pA-lymmj05lNShw-MszgcOMMylIi/children');  ///opportunity last transaction
            // req.setEndPoint('https://www.googleapis.com/drive/v2/files/1RjGNMjVHfIK0BTyVrxkJBFxxDoD6Ahjb/children');  ///1PIHa2hPthCO28pjkTYJzfMAhOpEVhgUC/children
            req.setMethod('GET');
            req.setHeader('Content-Type',' application/x-www-form-urlencoded');
            req.setHeader('Authorization',' Bearer '+googleIntegrationList.access_token__c);

            res = http.send(req);
            driveData = res.getBody();
            JSONParser parser = JSON.createParser(res.getBody());
            // System.debug('Response from req.getBody() Email>> parser >>'+ parser);
            //System.debug('Response from req.getBody() Email>> driveData >>'+ driveData);

            while(parser.nextToken() != null) 
            {
                // System.debug('JSONToken.FIELD_NAME >>'+ JSONToken.FIELD_NAME);
                // System.debug('parser.getCurrentToken() >>'+ parser.getCurrentToken());
                // System.debug('parser.getText() >>'+ parser.getText());

                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'id')) 
                {
                    parser.nextToken();
                    fileList.add(parser.getText());
                }
            }
            //System.debug('FileList  >> '+fileList);
            fileIdAndNameMap = allFilesData();

            for(String s : fileList) {
                fileIdVSNameMap.put(s, fileIdAndNameMap.get(s));
            }
            System.debug('fileIdVSNameMap >> '+fileIdVSNameMap);

        } catch (Exception exp) {
            system.debug('The following exception has occurred in Class "google_access_token" method "allFilesData" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        // return fileIdVSNameMap; // folder related data returns.
        return fileIdAndNameMap;// All data returns
    }

    @AuraEnabled
    public static Map<string, String> allFilesData(){

        Map<String,String> FilePropertiesDetails=new Map<String,String>();

        Jira_Integration__c googleIntegrationList = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Google'];
        try {

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndPoint('https://www.googleapis.com/drive/v3/files');  ///1PIHa2hPthCO28pjkTYJzfMAhOpEVhgUC/children
            req.setMethod('GET');
            req.setHeader('Content-Type',' application/x-www-form-urlencoded');
            req.setHeader('Authorization',' Bearer '+googleIntegrationList.access_token__c);

            res = http.send(req);
            //System.debug('Body data name'+res.getBody());
            JSONParser parserData = JSON.createParser(res.getBody());
            while(parserData.nextToken() != null) {

                //system.debug('parser.getCurrentToken()>> '+parserData.getText());
                String FileName='';
                String FileId='';
                if ( parserData.getCurrentToken() == JSONToken.FIELD_NAME) 
                {
                    if(parserData.getText() == 'id' ) {

                        parserData.nextToken();
                        FileId = parserData.getText();
                    }
                    parserData.nextToken();
                    if(parserData.getText() == 'name') {
                        parserData.nextToken();
                        FileName = parserData.getText();
                    }
                    FilePropertiesDetails.put(Fileid, Filename);
                }
            }
            system.debug('FilePropertiesDetails >>'+FilePropertiesDetails);
            
            
        } catch (Exception exp) {
            system.debug('The following exception has occurred in Class "google_access_token" method "allFilesData" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return FilePropertiesDetails;
    }


    @AuraEnabled
    public static string createFolder(String name){
        Jira_Integration__c googleIntegrationList = [SELECT ID, Redirect_Url__c, Client_ID__c, Client_Secret__c, access_token__c, Refresh_Token__c FROM Jira_Integration__c WHERE Name =: 'Google'];
        try {
            System.debug('name>> '+name);

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();

                req.setMethod('POST');  
                req.setEndpoint('https://www.googleapis.com/drive/v3/files');   
                req.setHeader('Authorization', 'Bearer '+googleIntegrationList.access_token__c);  
                req.setHeader('content-type', 'application/json');  
                String body = '{"name" : "'+name+'","mimeType" : "application/vnd.google-apps.folder"}';  
                req.setTimeout(60*1000);   
                req.setBody(body);  
                res = http.send(req);    
                System.debug('===== Response==='+ res.getBody());
                
                Map < String,Object > resultsMap = ( Map < String,Object > ) JSON.deserializeUntyped(res.getBody());
                system.debug('folder key vs name >>> '+resultsMap);
                List<Google_Drive_Folder__c> gFolder=new List<Google_Drive_Folder__c>();
                Google_Drive_Folder__c gFolderObj=new Google_Drive_Folder__c();               
                    if(resultsMap.get('id') != null){
                        gFolderObj.Id__c=String.valueOf(resultsMap.get('id'));
                    }

                    if(resultsMap.get('name') != null){
                        gFolderObj.Name=String.valueOf(resultsMap.get('name'));
                    }
                    gFolder.add(gFolderObj);
                    Database.upsert(gFolder, false);
                } catch (Exception exp) {
            system.debug('The following exception has occurred in Class "google_access_token" method "createFolder" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return 'string';
    }

    // @AuraEnabled
    // public static string uploadFile(){
    //     try {
            
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }


}

//req.setBody('{"id": 8814 , "message": {"to" : akash.chauhan@cloudanalogy.com, "from" : paras.chauhan@cloudanalogy.com, "Subject" :  draft Message}}');