package ru.whitered.kote 
{

	/**
	 * Notifier class used as a base for all classes that have to send notifications
	 */
	public class Notifier 
	{
		/**
		 * Signal that sends notification
		 */
		public const onNotification:Signal = new Signal();
		
		
		
		/**
		 * Send notification
		 * 
		 * @param notification Notification type
		 * @param args Notification parameters
		 */
		public function sendNotification(notification:Notification, ... args):void
		{
			onNotification.dispatch(notification, args);
		}
	}
}
