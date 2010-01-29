package ru.whitered.kote 
{
	import flash.utils.Dictionary;

	/**
	 * Mediators are used to manage parts of the application's view model.
	 */
	public class Mediator extends Notifier
	{
		/**
		 * Signal <code>onSubscribe</code> is dispatched when the mediator is subscribed for a notification
		 * 
		 * Signal has arguments: 
		 * <ul>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * <li><code>notificationType:NotificationType</code> - notification for which the mediator was subscribed</li>
		 * </ul>
		 */
		public const onSubscribe:Signal = new Signal();

		/**
		 * Signal <code>onUnsubscribe</code> is dispatched when the mediator is unsubscribed for a notification
		 * 
		 * Signal has arguments: 
		 * <ul>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * <li><code>notificationType:NotificationType</code> - notification from which the mediator was unsubscribed</li>
		 * </ul>
		 */
		public const onUnsubscribe:Signal = new Signal();
		
		/**
		 * Signal <code>onAdd</code> is dispatched when the mediator is added to a Facade
		 * 
		 * Signal has arguments:
		 * <ul>
		 * <li><code>facade:Facade</code> - facade that has added the mediator</li>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * </ul>
		 */
		public const onAdd:Signal = new Signal();
		
		/**
		 * Signal <code>onRemove</code> is dispatched when the mediator is removed from a Facade
		 * 
		 * <p>Signal has arguments:</p>
		 * <ul>
		 * <li><code>facade:Facade</code> - facade that has removed the mediator</li>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * </ul>
		 */
		public const onRemove:Signal = new Signal();
		
		
		private const handlers:Dictionary = new Dictionary();
		
		
		
		/**
		 * Subscribes the mediator for specified notification type
		 * 
		 * @param notificationType
		 * @param handler shortcut method that will be invoked on the notification
		 * This method should accept the same parameters types as was specified on notification sending
		 * 
		 * <p>If handler is not specified, notification still can be handled by the handleNotification() method</p>
		 * 
		 * @return <code>true</code> if successfully subscribed; <code>false</code> if there is a subscription for given notification type already
		 * 
		 * @see handleNotification() 
		 */
		public function subscribe(notificationType:NotificationType, handler:Function = null):Boolean
		{
			if(handlers[notificationType] != null) return false;
			handlers[notificationType] = handler || true;
			onSubscribe.dispatch(this, notificationType);
			return true;
		}
		
		
		
		/**
		 * Unsubscribes the mediator from a notification type
		 * 
		 * @param notificationType
		 * 
		 * @return <code>true</code> if successfully unsubscribed; <code>false</code> if there was no subscription for that notification type
		 */
		public function unsubscribe(notificationType:NotificationType):Boolean
		{
			if(handlers[notificationType] == null) return false;
			delete handlers[notificationType];
			onUnsubscribe.dispatch(this, notificationType);
			return true;
		}
		
		
		
		/**
		 * @return list of notification types the mediator is subscribed to
		 */
		public final function listSubscriptions():Vector.<NotificationType>
		{
			const subscriptions:Vector.<NotificationType> = new Vector.<NotificationType>();
			for(var s:* in handlers)
			{
				subscriptions[subscriptions.length] = NotificationType(s);
			}
			return subscriptions;
		}

		
		
		/**
		 * Executed when the mediator receives a notification
		 * 
		 * <p>Override this method to handle unbinded notifications or to work with 
		 * notification object itself instead of its parameters</p>
		 * 
		 * <p>Don't forget to call <code>super.handleNotification(notification)</code> when overriding</p>
		 */
		public function handleNotification(notification:Notification):void 
		{
			if(handlers[notification.type] is Function) handlers[notification.type].apply(this, notification.parameters);
		}
	}
}
