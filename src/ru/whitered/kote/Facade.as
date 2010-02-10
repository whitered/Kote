package ru.whitered.kote 
{
	import flash.utils.Dictionary;

	/**
	 * Facade manages mediators, proxies and commands. It is the central part of mvc framework
	 */
	public class Facade extends Notifier
	{
		private const mediatorsMap:Dictionary = new Dictionary();
		private const controllers:Dictionary = new Dictionary();

		private var notificationsQueue:Vector.<Notification>;
		private var notifiers:Dictionary = new Dictionary();

		
		
		/**
		 * Creates an instance of Facade
		 */
		public function Facade() 
		{
			onNotification.addCallback(handleNotification);
		}

		
		
		//----------------------------------------------------------------------
		// proxies
		//----------------------------------------------------------------------
		
		/**
		 * Registers proxy in the facade. Registered proxy can send notifications
		 * 
		 * @param proxy Proxy instance to register
		 */
		public function addProxy(proxy:Proxy):Boolean
		{
			return registerNotifier(proxy);
		}

		
		
		/**
		 * Unregisters proxy from the facade.
		 * 
		 * @param proxy Proxy to remove
		 */
		public function removeProxy(proxy:Proxy):Boolean
		{
			return unregisterNotifier(proxy);
		}

		
		
		/**
		 * Checks if the proxy is registered in facade
		 * 
		 * @param proxy
		 */
		public function hasProxy(proxy:Proxy):Boolean
		{
			return notifiers[proxy] != null;
		}

		
		
		//----------------------------------------------------------------------
		// mediators
		//----------------------------------------------------------------------
		
		/**
		 * Registers mediator in the proxy.
		 * Registered mediator can send and subscribe for notifications
		 * 
		 * @param mediator
		 */
		public function addMediator(mediator:Mediator):Boolean
		{
			if(!registerNotifier(mediator)) return false;
			
			const subscriptions:Vector.<NotificationType> = mediator.listSubscriptions();
			const subscriptionsLength:int = subscriptions.length;
			
			for (var i:int = 0;i < subscriptionsLength;i++)
			{
				subscribeMediator(mediator, subscriptions[i]);
			}
			
			mediator.onSubscribe.addCallback(subscribeMediator);
			mediator.onUnsubscribe.addCallback(unsubscribeMediator);
			
			mediator.onAdd.dispatch(mediator, this);
			
			return true;
		}

		
		
		/**
		 * Removes mediator from the facade
		 * 
		 * @param mediator
		 */
		public function removeMediator(mediator:Mediator):Boolean
		{
			if(!unregisterNotifier(mediator)) return false;
			
			const subscriptions:Vector.<NotificationType> = mediator.listSubscriptions();
			const subscriptionsLength:int = subscriptions.length;
			
			for (var i:int = 0;i < subscriptionsLength;i++)
			{
				unsubscribeMediator(mediator, subscriptions[i]);
			}
			
			mediator.onUnsubscribe.removeCallback(unsubscribeMediator);
			mediator.onSubscribe.removeCallback(subscribeMediator);
			
			mediator.onRemove.dispatch(mediator, this);
			
			return true;
		}

		
		
		/**
		 * Checks if the mediator is already registered in facade
		 * 
		 * @param mediator
		 */
		public function hasMediator(mediator:Mediator):Boolean
		{
			return notifiers[mediator] != null;
		}

		
		
		/**
		 * @private
		 */
		private function subscribeMediator(mediator:Mediator, notificationType:NotificationType):void 
		{
			mediatorsMap[notificationType] ||= new Vector.<Mediator>();
			mediatorsMap[notificationType].push(mediator);
		}

		
		
		/**
		 * @private
		 */
		private function unsubscribeMediator(mediator:Mediator, notificationType:NotificationType):void 
		{
			if(mediatorsMap[notificationType] == null) return;
			const subscribedMediators:Vector.<Mediator> = mediatorsMap[notificationType];
			const index:int = subscribedMediators.indexOf(mediator);
			if(index < 0) return;
			subscribedMediators.splice(index, 1);
			if(subscribedMediators.length == 0) delete mediatorsMap[notificationType];
		}

		
		
		//----------------------------------------------------------------------
		// commands
		//----------------------------------------------------------------------
		
		/**
		 * Binds the command to the notification
		 * 
		 * @param notificationType Notification type 
		 * @param command 
		 * @param priority Priority of the command. Commands with a higher priority will be executed first
		 */
		public function addCommand(notificationType:NotificationType, command:Command, priority:int = 0):Boolean
		{
			const controller:Controller = controllers[notificationType] ||= new Controller();
			return controller.addCommand(command, priority);
		}

		
		
		/**
		 * Unbinds the command from the notification
		 * 
		 * @param notificationType
		 * @param command
		 */
		public function removeCommand(notificationType:NotificationType, command:Command):Boolean
		{
			const controller:Controller = controllers[notificationType];
			if(controller && controller.removeCommand(command))
			{
				// if the last command of the controller was removed:
				if(controller.isEmpty()) delete controllers[notificationType];
				return true;
			}
			else
			{
				return false;
			}
		}

		
		
		//----------------------------------------------------------------------
		// notifications
		//----------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function registerNotifier(notifier:Notifier):Boolean 
		{
			if(notifiers[notifier] != null) return false;
			notifiers[notifier] = true;
			notifier.onNotification.addCallback(handleNotification);
			return true;
		}

		
		
		/**
		 * @private
		 */
		private function unregisterNotifier(notifier:Notifier):Boolean
		{
			if(notifiers[notifier] == null) return false;
			delete notifiers[notifier];
			notifier.onNotification.removeCallback(handleNotification);
			return true;
		}

		
		
		/**
		 * @private
		 */
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

		
		
		/**
		 * @private
		 */
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
