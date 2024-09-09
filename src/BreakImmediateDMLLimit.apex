Immediate_Event__e event = new Immediate_Event__e();

for(Integer i = 0; i<151; i++)
{
    EventBus.publish(event);
}