global class getAccount_From_Urlmapping {
    
    @AuraEnabled
    global static List<Object> callRestApiClass() {
        List<Object> resultList = new List<Object>();

        try{

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            // request.setEndpoint('https://parascaorg1-developer-edition.ap16.force.com/services/apexrest/getAccountList');
            request.setEndpoint('https://chauhanorgpages-developer-edition.ap17.force.com/services/apexrest/getAccounts');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
    
            System.Debug('Status Code>> '+ response.getStatusCode());
            System.Debug('Status res.getBody()>> '+ response.getBody());
            List<Object> acclist = new List<Object>();
            if(response.getStatusCode() == 200) {

                resultList = (List<Object>)JSON.deserializeUntyped(response.getBody());
            }  
        }
        Catch(Exception exp) {

            system.debug('The following exception has occurred in Class "getAccount_From_Urlmapping" method "updateAccount" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return resultList;
    }
    @AuraEnabled
    global static String updateAccount(String name, string phone, String aid , String accountNumber, string annualRevenue) {
        String returnedId ='';

        try{

            String accountNumberAssign = '';
            String numberAssign = '';
            if(accountNumber != NULL) {
                accountNumberAssign = accountNumber;
            }
            if(phone != NULL) {
                numberAssign = phone;
            }
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://chauhanorgpages-developer-edition.ap17.force.com/services/apexrest/getAccounts/'+aid);
            // request.setEndpoint('https://parascaorg1-developer-edition.ap16.force.com/services/apexrest/getAccountList/'+aid);
            request.setMethod('PATCH');
            request.setBody('{ "Name" : "'+name+'", "AccountNumber" : "'+accountNumberAssign+'", "Phone" : "'+numberAssign+'", "AnnualRevenue" : '+annualRevenue+'}');
            HttpResponse response = http.send(request);
    
            System.Debug('Status Code>> '+ response.getStatusCode());
            System.Debug('Status res.getBody()>> '+ response.getBody());
            if(response.getStatusCode() == 200) { 
                returnedId = response.getBody();
                
            }
            
        }
        Catch(Exception exp) {

            system.debug('The following exception has occurred in Class "getAccount_From_Urlmapping" method "updateAccount" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return returnedId; 
    }

    @AuraEnabled
    global static string deleteAccount(String aid){
        String resultReturned = '';
        try {

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://chauhanorgpages-developer-edition.ap17.force.com/services/apexrest/getAccounts/'+aid);
            // request.setEndpoint('https://parascaorg1-developer-edition.ap16.force.com/services/apexrest/getAccountList/'+aid);
            request.setMethod('DELETE');
            HttpResponse response = http.send(request);
            system.debug('Delete response.getBody()'+response.getBody());

            if(response.getStatusCode() == 200) {

                resultReturned = response.getBody();
            }     
        } catch (Exception exp) {
            system.debug('The following exception has occurred in Class "getAccount_From_Urlmapping" method "deleteAccount" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return resultReturned;

    }
}