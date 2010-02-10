package unit.tests 
{
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Notification;
	import ru.whitered.kote.NotificationType;

	import org.flexunit.asserts.assertTrue;

	/**
	 * @author whitered
	 */
	public class CommandTest 
	{
		
		[Test]
		public function command_should_call_run_method():void
		{
			const command:CustomCommand = new CustomCommand();
			const object:Object = {};
			const result:Boolean = command.execute(new Notification(new Facade(), new NotificationType(), [object]));
			
			assertTrue(result);
			assertTrue(object.processed);
		}
	}
}

import ru.whitered.kote.Command;




class CustomCommand extends Command
{
	public function run(object:Object):void
	{
		object.processed = true;
	}
}
