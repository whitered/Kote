package ru.whitered.mvc 
{
	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	internal final class Controller extends Notifier
	{
		private const commands:Vector.<Command> = new Vector.<Command>();
		private const priorities:Dictionary = new Dictionary();
		
		
		
		/**
		 * @return true if command was added successfully
		 */
		public function addCommand(command:Command, priority:int):Boolean
		{
			if(priorities[command] != null) return false;
			
			// insert command in list according to its priority
			var index:int = commands.length;
			
			while(index > 0)
			{
				if(priorities[commands[index - 1]] >= priority) break;
				index--;
			}
			
			commands.splice(index, 0, command);
			priorities[command] = priority;
			
			return true;
		}
		
		
		
		/**
		 * @return true if command was removed successfully
		 */
		public function removeCommand(command:Command):Boolean
		{
			if(priorities[command] == null) return false;
			
			const index:int = commands.indexOf(command);
			if(index < 0) return false;
			
			commands.splice(index, 1);
			delete priorities[command];
			
			return true;
		}
		
		
		
		public function isEmpty():Boolean
		{
			return commands.length == 0;
		}

		
		
		/**
		 * this method executes all the commands in the list
		 * if one of them aborted then all trailing commands will be skipped
		 * 
		 * @return false if one of the commands aborted
		 */
		public function execute(notification:Notification, notificationListener:Function):Boolean
		{
			const commandsLength:int = commands.length;
			var command:Command;
			var result:Boolean;
			for (var i:int = 0;i < commandsLength; i++)
			{
				command = commands[i];
				command.signalNotification.addListener(notificationListener);
				result = command.execute(notification);
				command.signalNotification.removeListener(notificationListener);
				if(!result) return false;
			}
			
			return true;
		}
	}
}
