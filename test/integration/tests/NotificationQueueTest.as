package integration.tests
{
	import org.hamcrest.collection.array;
	import org.hamcrest.assertThat;
	import ru.whitered.kote.Notification;
	import ru.whitered.kote.Facade;

	/**
	 * @author whitered
	 */
	public class NotificationQueueTest
	{
		private var facade:Facade;
		
		private const noteA:Notification = new Notification("note A");
		private const noteB:Notification = new Notification("note B");

		//----------------------------------------------------------------------
		// initializers
		//----------------------------------------------------------------------
		[Before]
		public function setUp():void
		{
			facade = new Facade();
		}
		
		
		
		[After]
		public function tearDown():void
		{
			facade = null;
		}
		
		
		
		//----------------------------------------------------------------------
		// tests
		//----------------------------------------------------------------------
		/**
		 * In classical PureMVC when a command for notification A sends notificatoin B 
		 * then any mediator subscribed for both the notifications
		 * will receive notification B first and notification A second
		 * 
		 * In Kote when a command for notification A sends notification B
		 * then notification B will be queued and sent after the notification A run its whole way
		 * so mediator will receive notification B after notification A  
		 */
		[Test]
		public function notification_sent_by_command_should_be_queued():void
		{
			const command:SendNotificationCommand = new SendNotificationCommand();
			
			const mediator:RegistryMediator = new RegistryMediator();
			mediator.subscribe(noteA);
			mediator.subscribe(noteB);
			
			facade.addMediator(mediator);
			facade.addCommand(noteA, command);
			
			facade.sendNotification(noteA, noteB);
			
			assertThat(mediator.registry, array(noteA, noteB));
		}
		
		
		
		//----------------------------------------------------------------------
		//
		//----------------------------------------------------------------------
	}
}

import ru.whitered.kote.NotificationObject;
import ru.whitered.kote.Mediator;
import ru.whitered.kote.Notification;
import ru.whitered.kote.Command;




class SendNotificationCommand extends Command
{
	public function run(notification:Notification):void
	{
		sendNotification(notification);
	}
}


class RegistryMediator extends Mediator
{
	public var registry:Array = [];

	
	
	override public function handleNotification(notificationObject:NotificationObject):void 
	{
		super.handleNotification(notificationObject);
		registry.push(notificationObject.notification);
	}
}
