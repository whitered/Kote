package ru.whitered.mvc 
{

	/**
	 * @author whitered
	 */
	internal class Notifier 
	{
		public const signalNotification:Signal = new Signal();
		
		
		
		public function sendNotification(type:NotificationType, ... args):void
		{
			signalNotification.dispatch(type, args);
		}
	}
}
