package ru.whitered.kote 
{

	/**
	 * NotificationType is used to define a single notification type
	 */
	public class NotificationType 
	{
		private var _name:String;
		
		
		
		/**
		 * Created a notification type
		 * 
		 * @param name Can be useful for debug
		 */
		public function NotificationType(name:String = null) 
		{
			this._name = name;
		}
		
		
		
		/**
		 * Readable name specified on creation
		 */
		public function get name():String
		{
			return _name;
		}
		
		
		
		/**
		 * @return Name specified on creation or null
		 */
		public function toString():String {
			return name || "[NotificationType]";
		}
	}
}
