package ru.whitered.mvc 
{
	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	public class Facade 
	{
		private const mediatorsMap:Dictionary = new Dictionary();
		private const controllers:Dictionary = new Dictionary();
		
		private var notificationsQueue:Vector.<Notification>;
		private var notifiers:Dictionary = new Dictionary();

		
		
		
		//----------------------------------------------------------------------
		// proxies
		//----------------------------------------------------------------------
		
		public function addProxy(proxy:Proxy):void
		{
			registerNotifier(proxy);
		}
		
		
		
		public function removeProxy(proxy:Proxy):void
		{
			unregisterNotifier(proxy);
		}
		
		
		
		public function hasProxy(proxy:Proxy):Boolean
		{
			return notifiers[proxy] != null;
		}
		
		
		
		//----------------------------------------------------------------------
		// mediators
		//----------------------------------------------------------------------
		
		public function addMediator(mediator:Mediator):void
		{
			if(!registerNotifier(mediator)) return;
			
			const subscriptions:Vector.<NotificationType> = mediator.listSubscriptions();
			const subscriptionsLength:int = subscriptionsLength;
			
			for (var i:int = 0; i < subscriptionsLength; i++)
			{
				subscribeMediator(mediator, subscriptions[i]);
			}
			
			mediator.signalSubscribed.addListener(subscribeMediator);
			mediator.signalUnsubscribed.addListener(unsubscribeMediator);
			
			mediator.signalAdded.dispatch(this);
		}

		
		
		public function removeMediator(mediator:Mediator):void
		{
			if(!unregisterNotifier(mediator)) return;
			
			const subscriptions:Vector.<NotificationType> = mediator.listSubscriptions();
			const subscriptionsLength:int = subscriptions.length;
			
			for (var i:int = 0;i < subscriptionsLength;i++)
			{
				unsubscribeMediator(mediator, subscriptions[i]);
			}
			
			mediator.signalUnsubscribed.removeListener(unsubscribeMediator);
			mediator.signalSubscribed.removeListener(subscribeMediator);
			
			mediator.signalRemoved.dispatch(this);
		}
		
		
		
		public function hasMediator(mediator:Mediator):Boolean
		{
			return notifiers[mediator] != null;
		}

		
		
		private function subscribeMediator(mediator:Mediator, notificationType:NotificationType):void 
		{
			mediatorsMap[notificationType] ||= new Vector.<Mediator>;
			mediatorsMap[notificationType].push(mediator);
		}

		
		
		private function unsubscribeMediator(mediator:Mediator, notificationType:NotificationType):void 
		{
			const subscribedMediators:Vector.<Mediator> = mediatorsMap[notificationType];
			if(!subscribedMediators) return;
			const index:int = subscribedMediators.indexOf(mediator);
			if(index < 0) return;
			subscribedMediators.splice(index, 1);
			if(subscribedMediators.length == 0) delete mediatorsMap[notificationType];
		}
		
		
		
		//----------------------------------------------------------------------
		// commands
		//----------------------------------------------------------------------
		
		public function addCommand(notificationType:NotificationType, command:Command, priority:int = 0):void
		{
			const controller:Controller = controllers[notificationType] ||= new Controller();
			controller.addCommand(command, priority);
		}

		
		
		public function removeCommand(notificationType:NotificationType, command:Command):void
		{
			const controller:Controller = controllers[notificationType];
			if(controller && controller.removeCommand(command) && controller.isEmpty())
			{
				// if the last command of the controller was removed
				delete controllers[notificationType];
			}
		}

		
		
		//----------------------------------------------------------------------
		// notifications
		//----------------------------------------------------------------------
		
		
		private function registerNotifier(notifier:Notifier):Boolean 
		{
			if(notifiers[notifier] != null) return false;
			notifiers[notifier] = true;
			notifier.signalNotification.addListener(handleNotification);
			return true;
		}
		
		
		
		private function unregisterNotifier(notifier:Notifier):Boolean
		{
			if(notifiers[notifier] == null) return false;
			delete notifiers[notifier];
			notifier.signalNotification.removeListener(handleNotification);
			return true;
		}

		
		
		private function handleNotification(notificationType:NotificationType, params:Array):void 
		{
			const notification:Notification = new Notification(this, notificationType, params);
			
			// if there is a processing notification already:
			if(notificationsQueue)
			{
				notificationsQueue.push(notification);
				return;
			}
			
			notificationsQueue = Vector.<Notification>([notification]);
			
			// the queue can be replenished while a notification is processed
			for (var i:int = 0;i < notificationsQueue.length;i++)
			{
				processNotification(notificationsQueue[i]);
			}
			
			notificationsQueue = null;
		}

		
		
		private function processNotification(notification:Notification):void
		{
			const notificationType:NotificationType = notification.type;
			
			// execute commands and abort if one of them returned 'false':
			const controller:Controller = controllers[notificationType];
			if(controller && !controller.execute(notification, handleNotification)) return;
			
			const subscribedMediators:Vector.<Mediator> = mediatorsMap[notificationType];
			if(!subscribedMediators) return;
			
			for (var i:int = 0;i < subscribedMediators.length;i++)
			{
				subscribedMediators[i].handleNotification(notification);
			}
		}
	}
}
