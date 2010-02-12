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
		 * <p>Signal has arguments:</p>
		 * <ul>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * <li><code>notification:Notification</code> - notification for which the mediator was subscribed</li>
		 * </ul>
		 */
		public const onSubscribe:Signal = new Signal();

		/**
		 * Signal <code>onUnsubscribe</code> is dispatched when the mediator is unsubscribed for a notification
		 * 
		 * <p>Signal has arguments:</p>
		 * <ul>
		 * <li><code>mediator:Mediator</code> - current mediator</li>
		 * <li><code>notification:Notification</code> - notification from which the mediator was unsubscribed</li>
		 * </ul>
		 */
		public const onUnsubscribe:Signal = new Signal();
		
		/**
		 * Signal <code>onAdd</code> is dispatched when the mediator is added to a Facade
		 * 
		 * <p>Signal has arguments:</p>
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
		 * Subscribes the mediator for specified notification 
		 * 
		 * <p>Handler method should accept the same parameters types 
		 * as was specified on notification creation</p>
		 * 
		 * <p>If handler is not specified, notification still can be handled 
		 * by the handleNotification() method</p>
		 * 
		 * @param notification
		 * @param handler shortcut method that will be invoked on the notification
		 * 
		 * @return <code>true</code> if successfully subscribed; <code>false</code> if there is a subscription for given notification type already
		 * 
		 * @see #handleNotification() 
		 */
		public function subscribe(notification:Notification, handler:Function = null):Boolean
		{
			if(handlers[notification] != null) return false;
			handlers[notification] = handler || true;
			onSubscribe.dispatch(this, notification);
			return true;
		}
		
		
		
		/**
		 * Unsubscribes the mediator from a notification
		 * 
		 * @param notification
		 * 
		 * @return <code>true</code> if successfully unsubscribed; <code>false</code> if there was no subscription for that notification type
		 */
		public function unsubscribe(notification:Notification):Boolean
		{
			if(handlers[notification] == null) return false;
			delete handlers[notification];
			onUnsubscribe.dispatch(this, notification);
			return true;
		}
		
		
		
		/**
		 * @return list of notifications the mediator is subscribed to
		 */
		public final function listSubscriptions():Array
		{
			const subscriptions:Array = [];
			for(var s:* in handlers)
			{
				subscriptions[subscriptions.length] = Notification(s);
			}
			return subscriptions;
		}

		
		
		/**
		 * Executed when the mediator receives a notification
		 * 
		 * <p>Override this method to handle unbinded notifications or to work with 
		 * notification object itself instead of its parameters</p>
		 * 
		 * <p>Don't forget to call <code>super.handleNotification(notificationObject)</code> when overriding</p>
		 * 
		 * @param notification Received notification
		 * 
		 * @see Notification
		 */
		public function handleNotification(notificationObject:NotificationObject):void 
		{
			if(handlers[notificationObject.notification] is Function) handlers[notificationObject.notification].apply(this, notificationObject.parameters);
		}
	}
}
