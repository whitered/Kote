package ru.whitered.kote 
{

	/**
	 * @author whitered
	 */
	public final class Notification 
	{
		private var _facade:Facade;
		private var notificationType:NotificationType;
		private var params:Array;

		
		
		public function Notification(facade:Facade, notificationType:NotificationType, params:Array) 
		{
			this._facade = facade;
			this.notificationType = notificationType;
			this.params = params;
		}
		
		
		
		public function get facade():Facade
		{
			return _facade;
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
