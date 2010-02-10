package unit.tests 
{
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Notification;
	import ru.whitered.kote.NotificationType;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 * @author whitered
	 */
	public class NotificationTest 
	{
		private const notificationType:NotificationType = new NotificationType("cool notification name");
		
		
		
		[Test]
		public function notification_type_has_name():void
		{
			assertEquals("cool notification name", notificationType.name);
		}
		
		
		
		[Test]
		public function create_simple_notification():void
		{
			const facade:Facade = new Facade();
			const params:Array = [1, "string", facade];
			const notification:Notification = new Notification(facade, notificationType, params);
			
			assertStrictlyEquals(facade, notification.facade);
			assertStrictlyEquals(notificationType, notification.type);
			assertEquals(3, notification.parameters.length);
			assertEquals(1, notification.parameters[0]);
			assertEquals("string", notification.parameters[1]);
			assertStrictlyEquals(facade, notification.parameters[2]);
		}
		
		
		
		[Test]
		public function modify_notification_params():void
		{
			const notification:Notification = new Notification(new Facade(), notificationType, null);
			
			notification.parameters = [1, 2, 3];
			
			assertEquals(3, notification.parameters.length);
			assertEquals(1, notification.parameters[0]);
			assertEquals(2, notification.parameters[1]);
			assertEquals(3, notification.parameters[2]);
		}
	}
}
