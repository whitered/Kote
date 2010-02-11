package integration.tests 
{
	import ru.whitered.kote.Command;
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Notification;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	/**
	 * @author whitered
	 */
	public class CommandPriorityTest 
	{
		private var facade:Facade;
		private const notification:Notification = new Notification("note");
		
		
		
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
		
		
		
		[Test]
		public function commands_with_same_priority_are_executed_consecutively():void
		{
			const cmd1:Command = new CustomCommand("cmd 1");
			const cmd2:Command = new CustomCommand("cmd 2");
			const cmd3:Command = new CustomCommand("cmd 3");
			
			facade.addCommand(notification, cmd1);
			facade.addCommand(notification, cmd2);
			facade.addCommand(notification, cmd3);
			
			const registry:Array = [];
			
			facade.sendNotification(notification, registry);
			
			assertThat(registry, array(cmd1, cmd2, cmd3));
		}
		
		
		
		[Test]
		public function commands_are_executed_in_reverse_priority_order():void
		{
			const cmd1:Command = new CustomCommand("cmd 1");
			const cmd2:Command = new CustomCommand("cmd 2");
			const cmd3:Command = new CustomCommand("cmd 3");
			
			facade.addCommand(notification, cmd1, 1);
			facade.addCommand(notification, cmd2, -1);
			facade.addCommand(notification, cmd3, 0);
			
			const registry:Array = [];
			
			facade.sendNotification(notification, registry);
			
			assertThat(registry, array(cmd1, cmd3, cmd2));
		}
	}
}

import ru.whitered.kote.Command;




class CustomCommand extends Command
{
	private var name:String;
	
	
	
	public function CustomCommand(name:String) 
	{
		this.name = name;
	}

	
	
	public function run(registry:Array):void
	{
		registry.push(this);
	}
	
	
	
	public function toString():String 
	{
		return name;
	}
}
