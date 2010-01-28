package ru.whitered.mvc 
{

	/**
	 * @author whitered
	 */
	public class Notification 
	{
		private var notificationType:NotificationType;
		private var params:Array;

		
		
		public function Notification(notificationType:NotificationType, params:Array) 
		{
			this.notificationType = notificationType;
			this.params = params;
		}
		
		
		
		public function get type():NotificationType
		{
			return notificationType;
		}
		
		
		
		public function get parameters():Array
		{
			return params;
		}
		
		
		
		public function set parameters(value:Array):void
		{
			params = value;
		}
	}
}
