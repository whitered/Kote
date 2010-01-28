package ru.whitered.mvc 
{
	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	public class Mediator extends Notifier
	{
		public const signalSubscribe:Signal = new Signal();
		public const signalUnsubscribe:Signal = new Signal();
		
		private const handlers:Dictionary = new Dictionary();
		
		
		
		public function subscribe(notificationType:NotificationType, handler:Function):Boolean
		{
			if(handlers[notificationType] != null) return false;
			handlers[notificationType] = handler;
			signalSubscribe.dispatch(this, notificationType);
			return true;
		}
		
		
		
		public function unsubscribe(notificationType:NotificationType, handler:Function):Boolean
		{
			if(handlers[notificationType] == null) return false;
			delete handlers[notificationType];
			signalUnsubscribe.dispatch(this, notificationType);
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
			const handler:Function = handlers[notification.type];
			if(handler) handler.apply(this, notification.parameters);
		}
	}
}
