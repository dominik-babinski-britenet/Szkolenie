Http httpObject = new Http();
HttpRequest request = new HttpRequest();

request.setEndpoint('http://www.apexdevnet.com');
request.setMethod('GET');

for(Integer i = 0; i < 101; i++)
{
    HttpResponse response = httpObject.send(request);
}
//