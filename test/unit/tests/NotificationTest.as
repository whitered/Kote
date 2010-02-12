package unit.tests 
{
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.NotificationObject;
	import ru.whitered.kote.Notification;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 * @author whitered
	 */
	public class NotificationTest 
	{
		private const notification:Notification = new Notification("cool notification name");
		
		
		
		[Test]
		public function notification_type_has_name():void
		{
			assertEquals("cool notification name", notification.name);
		}
		
		
		
		[Test]
		public function create_simple_notification():void
		{
			const facade:Facade = new Facade();
			const params:Array = [1, "string", facade];
			const notificationObject:NotificationObject = new NotificationObject(facade, notification, params);
			
			assertStrictlyEquals(facade, notificationObject.facade);
			assertStrictlyEquals(notification, notificationObject.notification);
			assertEquals(3, notificationObject.parameters.length);
			assertEquals(1, notificationObject.parameters[0]);
			assertEquals("string", notificationObject.parameters[1]);
			assertStrictlyEquals(facade, notificationObject.parameters[2]);
		}
		
		
		
		[Test]
		public function modify_notification_params():void
		{
			const notificationObject:NotificationObject = new NotificationObject(new Facade(), notification, null);
			
			notificationObject.parameters = [1, 2, 3];
			
			assertEquals(3, notificationObject.parameters.length);
			assertEquals(1, notificationObject.parameters[0]);
			assertEquals(2, notificationObject.parameters[1]);
			assertEquals(3, notificationObject.parameters[2]);
		}
	}
}
