public class PublishRefreshComponent {

     @InvocableMethod(label='Publish Refresh Component Event' description='Publishes the RefreshComponentEvent platform event.')
    public static void publishEvent() {
        // Just need one trigger to invoke the event
       

        // Publish the event
         RefreshComponentEvent__e evt = new RefreshComponentEvent__e();
        Database.SaveResult result = EventBus.publish(evt);

        if (!result.isSuccess()) {
            System.debug('Failed to publish event: ' + result.getErrors()[0].getMessage());
        }
    }

   
}