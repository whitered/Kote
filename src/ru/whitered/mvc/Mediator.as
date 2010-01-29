package ru.whitered.mvc 
{
	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	public class Mediator extends Notifier
	{
		public const signalSubscribed:Signal = new Signal();
		public const signalUnsubscribed:Signal = new Signal();
		
		public const signalAdded:Signal = new Signal();
		public const signalRemoved:Signal = new Signal();
		
		private const handlers:Dictionary = new Dictionary();
		
		
		
		public function subscribe(notificationType:NotificationType, handler:Function = null):Boolean
		{
			if(handlers[notificationType] != null) return false;
			handlers[notificationType] = handler || true;
			signalSubscribed.dispatch(this, notificationType);
			return true;
		}
		
		
		
		public function unsubscribe(notificationType:NotificationType, handler:Function = null):Boolean
		{
			if(handlers[notificationType] == null) return false;
			delete handlers[notificationType];
			signalUnsubscribed.dispatch(this, notificationType);
			return true;
		}
		
		
		
		public function listSubscriptions():Vector.<NotificationType>
		{
			const subscriptions:Vector.<NotificationType> = new Vector.<NotificationType>();
			for(var s:* in handlers)
			{
				subscriptions[subscriptions.length] = NotificationType(s);
			}
			return subscriptions;
		}

		
		
		public function handleNotification(notification:Notification):void 
		{
			if(handlers[notification.type] is Function) handlers[notification.type].apply(this, notification.parameters);
		}
	}
}
