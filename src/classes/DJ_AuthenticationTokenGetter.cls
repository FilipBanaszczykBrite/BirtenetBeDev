

public with sharing class DJ_AuthenticationTokenGetter {


    public static String getToken(){
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        request.setTimeout(2 * 60 * 1000);

        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        // zmienic na custom metadata types
        request.setBody('grant_type=password' +
                '&client_id=3MVG9vvlaB0y1YsKTNfd8g15CfXSMLR84a53Ey5taEcUMZN8qC3QEM3YJeBlt9EHBjrMmKNEcLxaWPoRTuP4o' +
                '&client_secret=062638B96BE04AD8270B740BAF3B8D2F8B7DA3A84C2F98335FDE86D66666A0D7' +
                '&username=maciej.sojka1@wise-fox-flobac.com' +
                '&password=Slizer1999qDshrFsWWbH9P8188yhgpjibZ');
        HttpResponse response = httpCls.send(request);
        if(response.getStatusCode() == 200){

            Map<String,Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            return (String)resultMap.get('access_token');

        }
        return '';
    }
}