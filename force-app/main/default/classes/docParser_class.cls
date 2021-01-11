public with sharing class docParser_class {
    
    public Static String getParserID(){
        String objectID ='';
        List<String> idList = new List<String>();
        List<DocParser__c> DocParserList = new List<DocParser__c>();
        Map<string, String> parseObjectMapCombined = new Map<string, String>();

        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setMethod('GET');
            req.setEndpoint('https://api.docparser.com/v1/parsers');
            req.setHeader('api_key','b3eec48263fcb34ba553ccbeea6a88ce36d4149f');
            res = Http.send(req);
    
            system.debug('Returned Body of Response >>'+res.getBody());
    
            List<Object> parseObjectList = (List<Object>) JSON.deserializeUntyped(res.getBody());
            Map<string, Object> parseObjectMap ;

            for(Object o : parseObjectList) {
                parseObjectMap = (Map<String, Object>) o;
                // parseObjectMapCombined.put(String.valueOf(parseObjectMap.get('id')), String.valueOf(parseObjectMap.get('label')));
                // idList.add(String.valueOf(parseObjectMap.get('id')));
                DocParser__c obj = new DocParser__c();
                obj.Name = String.valueOf(parseObjectMap.get('label'));
                obj.id__c = String.valueOf(parseObjectMap.get('id'));
                DocParserList.add(obj);
            }

            // for(String s : idList) {
            // }
            if(DocParserList.size() > 0) {
                insert DocParserList;
                system.debug('DocParser inserted'+DocParserList);
            }
        }
        Catch(Exception exp) {
            system.debug('The following exception has occurred in Class "docParser_class" method "getParserID" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        return objectID;
    }

    public static void uploadDocument() {

            DocParser__c DocParserList = [SELECT ID, Name, ID__c FROM  DocParser__c LIMIT 1];

            Attachment objPDF = [SELECT ID,Name,Body FROM Attachment LIMIT 1]; 
        system.debug('DocParserList'+DocParserList);
        system.debug('objPDF'+objPDF);
            String strApiKey = 'b3eec48263fcb34ba553ccbeea6a88ce36d4149f';
            String strParserId = DocParserList.ID__c;
            String strTargetURL = 'https://api.docparser.com/v1/document/upload/' + strParserId + '?remote_id='+objPDF.Id;
            String strSeparationKey = 'A_RANDOM_STRING';

            // assemble the body payload
            String strHeader = '--' + strSeparationKey + '\nContent-Disposition: form-data; name="file"; filename="' + objPDF.Name + '"\nContent-Type: application/octet-stream\n\n';
            String strBody = EncodingUtil.base64Encode(objPDF.Body);
            String strFooter = '\n--' + strSeparationKey + '--';

            String strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
            while(strHeaderEncoded.endsWith('=')) {
            strHeader+=' ';
            strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
            }
            String strBodyEncoded = strBody;
            String strFooterEncoded = EncodingUtil.base64Encode(Blob.valueOf(strFooter));

            Blob blobBody = null;
            String last4Bytes = strBodyEncoded.substring(strBodyEncoded.length()-4,strBodyEncoded.length());

            if(last4Bytes.endsWith('=')) {
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest objHttpRequest = New HttpRequest();
            objHttpRequest.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = objHttpRequest.getBody()+strFooter;
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded.substring(0,strBodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
            } else {
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded+strFooterEncoded);
            }

            if(blobBody.size()>3000000) {
            // throw new CustomException('File size limit is 3 MBytes');
            system.debug('File size limit is 3 MBytes');
            }else{
            system.debug('blobBody.size()'+blobBody.size());
            }

            // send out the request
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'multipart/form-data; boundary=' + strSeparationKey);
            req.setHeader('Authorization', 'Basic ' + strApiKey);
            req.setMethod('POST');
            req.setEndpoint(strTargetURL);
            req.setBodyAsBlob(blobBody);
            req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
            Http http = New Http();
            HTTPResponse res = http.send(req);
            system.debug('res'+res.getBody());
    }

}