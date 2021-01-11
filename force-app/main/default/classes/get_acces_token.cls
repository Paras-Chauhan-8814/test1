public with sharing class get_acces_token {

    @AuraEnabled
    public static void getAccessToken(string authorizationCode) {
        System.debug('authorizationCode>> '+authorizationCode);

    }

    
}