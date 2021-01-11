public with sharing class twillio_class {
  
    @AuraEnabled
    public static String twillioSendSms(string body, string fromNumber, string toNumber) {

        System.debug('body >>'+body+' from >> '+ fromNumber + 'to >> '+toNumber);
        //String body = 'Sending Sms Via Twilio';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setMethod('POST');
        req.setEndPoint('https://api.twilio.com/2010-04-01/Accounts/ACe772415da1b11eee6c13d98db97fae22/Messages.json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf('ACe772415da1b11eee6c13d98db97fae22'+':'+'19f63238b31a47315c927af2526213ce')));
        req.setBody('To='+EncodingUtil.urlEncode('+91'+toNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode('+12058511973','UTF-8')+'&Body='+body);
        res = http.send(req);
        system.debug('Returned Body >> ' + res.getBody());
        //req.setHeader('$ACe772415da1b11eee6c13d98db97fae22','$19f63238b31a47315c927af2526213ce');
        
        // req.setEndPoint('https://api.twilio.com/2010-04-01/Accounts/$ACe772415da1b11eee6c13d98db97fae22/SMS/Messages.json');
        // req.setHeader('$ACe772415da1b11eee6c13d98db97fae22','$19f63238b31a47315c927af2526213ce');
        // req.setBody('"Body = This is the Body?","From=+12058511973","To=+917988791934"');
        // req.setHeader('$ACe772415da1b11eee6c13d98db97fae22','$19f63238b31a47315c927af2526213ce');

        return 'Succesfully';
    }
}

//(205) 851-1973
//+12058511973
//twillio_class.twillioSendSms('hey','yeie','isod');