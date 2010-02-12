package ru.whitered.kote 
{

	/**
	 * NotificationObject class is used to store facade and parameters for specific notification dispatching
	 */
	public final class NotificationObject 
	{
		private var _facade:Facade;
		private var _notification:Notification;
		private var _parameters:Array;

		
		
		public function NotificationObject(facade:Facade, notification:Notification, parameters:Array) 
		{
			this._facade = facade;
			this._notification = notification;
			this._parameters = parameters;
		}
		
		
		
		public function get facade():Facade
		{
			return _facade;
		}
		
		
		
		public function get notification():Notification
		{
			return _notification;
		}
		
		
		
		public function get parameters():Array
		{
			return _parameters;
		}
		
		
		
		public function set parameters(value:Array):void
		{
			_parameters = value;
		}
	}
}
