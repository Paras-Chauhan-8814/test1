global with sharing class get_authorization_from_jira {
    
    global static void getAuthorizationCode() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        // request.setEndpoint('https://chauhanorgpages-developer-edition.ap17.force.com/services/apexrest/getAccounts');
        // request.setEndpoint('https://jira-paras-org.atlassian.net/authorize?audience=api.atlassian.com&client_id=hxKsJUvD6f1v77l2wjGeB8H3BwiBM72a&scope=offline_access%read%3Ajira-work%manage:jira-project%manage:jira-configuration%read:jira-user%write:jira-work%manage:jira-data-provider&response_type=code&redirect_uri=https://getpostman.com/oauth2/callback&prompt=consent');

        // request.setEndpoint('https://jira-paras-org.atlassian.net/authorize?audience=api.atlassian.com&client_id=hxKsJUvD6f1v77l2wjGeB8H3BwiBM72a&scope=offline_access%read:jira-work%manage:jira-project%manage:jira-configuration%read:jira-user%write:jira-work%manage:jira-data-provider&response_type=code&redirect_uri=https://getpostman.com/oauth2/callback&prompt=consent');
        
        request.setEndpoint('https://jira-paras-org.atlassian.net/authorize?audience=api.atlassian.com&client_id=hxKsJUvD6f1v77l2wjGeB8H3BwiBM72a&scope=offline_access%20read%3Ajira-work%20manage%3Ajira-project%20manage%3Ajira-configuration%20read%3Ajira-user%20write%3Ajira-work%20manage%3Ajira-data-provider&redirect_uri=https%3A%2F%2Fgetpostman.com%2Foauth2%2Fcallback&state=${YOUR_USER_BOUND_VALUE}&response_type=code&prompt=consent');
        request.setMethod('GET');

        response = http.send(request);

        System.Debug('Status Code>> '+ response.getStatusCode());
        System.Debug('Status res.getBody()>> '+ response.getBody());
    }

}