package ru.whitered.kote 
{

	/**
	 * Notification represents an event type in application 
	 */
	public class Notification 
	{
		private var _name:String;
		
		
		
		/**
		 * Create a notification
		 * 
		 * @param name Can be useful for debug
		 */
		public function Notification(name:String = null) 
		{
			this._name = name;
		}
		
		
		
		/**
		 * Name of the notification
		 */
		public function get name():String
		{
			return _name;
		}
		
		
		
		/**
		 * @return Name specified on creation
		 */
		public function toString():String {
			return name || "[NotificationType]";
		}
	}
}
