package ru.whitered.kote 
{

	/**
	 * @author whitered
	 */
	public class NotificationType 
	{
		private var name:String;
		
		
		
		public function NotificationType(name:String = null) 
		{
			this.name = name;
		}
		
		
		
		public function toString():String {
			return name || "[NotificationType]";
		}
	}
}
