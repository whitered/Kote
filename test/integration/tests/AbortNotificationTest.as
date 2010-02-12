package integration.tests
{
	import ru.whitered.kote.Command;
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Mediator;
	import ru.whitered.kote.Notification;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	/**
	 * @author whitered
	 */
	public class AbortNotificationTest
	{
		private var facade:Facade;
		private const note:Notification = new Notification();

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
		[Test]
		public function command_aborts_notification_by_returning_false():void
		{
			const registry:Array = [];
			const cmd:Command = new RegistryCommand();
			const abortCmd:Command = new AbortCommand();
			const mediator:Mediator = new RegistryMediator(registry);
			
			mediator.subscribe(note);
			
			facade.addCommand(note, cmd);
			facade.addCommand(note, abortCmd, 1);
			facade.addMediator(mediator);
			
			facade.sendNotification(note, registry);
			
			assertThat(registry, array(abortCmd));
		}	
		
		
		//----------------------------------------------------------------------
		//
		//----------------------------------------------------------------------
	}
}

import ru.whitered.kote.Command;
import ru.whitered.kote.Mediator;
import ru.whitered.kote.NotificationObject;




class RegistryCommand extends Command
{
	override public function execute(notification:NotificationObject):Boolean 
	{
		return super.execute(notification);
	}
	
	
	
	public function run(registry:Array):void
	{
		registry.push(this);
	}
}



class AbortCommand extends RegistryCommand
{

	override public function execute(notification:NotificationObject):Boolean 
	{
		super.execute(notification);
		return false;
	}
}



class RegistryMediator extends Mediator
{
	private var registry:Array;

	
	
	public function RegistryMediator(registry:Array) 
	{
		this.registry = registry;
	}

	
	
	override public function handleNotification(notificationObject:NotificationObject):void 
	{
		super.handleNotification(notificationObject);
		registry.push(this);
	}
}
