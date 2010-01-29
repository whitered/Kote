package ru.whitered.kote 
{

	/**
	 * Notifier class used as a base for all classes that have to send notifications
	 */
	internal class Notifier 
	{
		/**
		 * Signal that sends notification
		 */
		public const onNotification:Signal = new Signal();
		
		
		
		/**
		 * Send notification
		 * 
		 * @param type Notification type
		 * @param args Notification parameters
		 */
		public function sendNotification(type:NotificationType, ... args):void
		{
			onNotification.dispatch(type, args);
		}
	}
}
