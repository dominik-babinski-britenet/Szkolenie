Messaging.PushNotification message = new Messaging.PushNotification();
Map<String, Object> payload = Messaging.PushNotificationPayload.apple('Test push','', null, null);

message.setPayload(payload);

for(Integer i = 0; i < 11; i++)
{
    message.send('Test_App', new Set<String>());
}