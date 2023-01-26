public with sharing class DJ_AuthenticationTokenGetter {
    

    public static String getToken(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        request.setTimeout(2 * 60 * 1000);
        DJ_Credentials__c login = DJ_Credentials__c.getInstance(UserInfo.getUserId());
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        String body2 = 'grant_type=password' +
                '&client_id=' + login.id__c +
                '&client_secret=' + login.secret__c  +
                '&username=' + login.username__c +
                '&password=' + login.password__c;
        request.setBody(body2);
        HttpResponse response = httpCls.send(request);
        if(response.getStatusCode() == 200){
            Map<String,Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            return (String)resultMap.get('access_token');

        }
        return '';
    }
}