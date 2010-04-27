package ru.whitered.kote 
{
	import ru.whitered.signaller.Signal;
	import ru.whitered.signaller.Signaller;

	/**
	 * Notifier class used as a base for all classes that have to send notifications
	 */
	public class Notifier 
	{
		/**
		 * Signal that sends notification
		 */
		protected const _onNotification:Signaller = new Signaller();
		public const onNotification:Signal = _onNotification.signal;

		
		
		/**
		 * Send notification
		 * 
		 * @param notification Notification type
		 * @param args Notification parameters
		 */
		public function sendNotification(notification:Notification, ... args):void
		{
			_onNotification.dispatch(notification, args);
		}
	}
}
