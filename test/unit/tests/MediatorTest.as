package unit.tests 
{
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Mediator;
	import ru.whitered.kote.Notification;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	public class MediatorTest 
	{
		private var counters:Dictionary;
		private var totalCallbacksCalled:int;
		private var lastArguments:Array;
		
		private var facade:Facade;
		private var mediator:CustomMediator;
		private const notification:Notification = new Notification();



		[Before]
		public function setUp():void
		{
			counters = new Dictionary();
			counters[onAdd] = 0;
			counters[onRemove] = 0;
			counters[onSubscribe] = 0;
			counters[onUnsubscribe] = 0;
			totalCallbacksCalled = 0;
			lastArguments = null;
			
			facade = new Facade();
			mediator = new CustomMediator();
			
			mediator.onSubscribe.add(onSubscribe);
			mediator.onUnsubscribe.add(onUnsubscribe);
			mediator.onAdd.add(onAdd);
			mediator.onRemove.add(onRemove);
		}



		[After]
		public function tearDown():void
		{
			mediator = null;
			facade = null;
			
			lastArguments = null;
			counters = null;
		}



		//----------------------------------------------------------------------
		// tests
		//----------------------------------------------------------------------
		
		[Test]
		public function dispatch_onSubscribe_signal():void
		{
			mediator.subscribe(notification);
			
			assertEquals(1, totalCallbacksCalled);
			assertEquals(1, counters[onSubscribe]);
			assertThat(lastArguments, array(mediator, notification));
		}




		[Test]
		public function dispatch_onUnsubscribe_signal():void
		{
			mediator.subscribe(notification);
			mediator.unsubscribe(notification);
			
			assertEquals(2, totalCallbacksCalled);
			assertEquals(1, counters[onUnsubscribe]);
			assertThat(lastArguments, array(mediator, notification));
		}



		[Test]
		public function dispatch_onAdd_signal():void
		{
			facade.addMediator(mediator);
			
			assertEquals(1, totalCallbacksCalled);
			assertEquals(1, counters[onAdd]);
			assertThat(lastArguments, array(mediator, facade));
		}




		[Test]
		public function dispatch_onRemove_signal():void
		{
			facade.addMediator(mediator);
			facade.removeMediator(mediator);
			
			assertEquals(2, totalCallbacksCalled);
			assertEquals(1, counters[onRemove]);
			assertThat(lastArguments, array(mediator, facade));
		}
		
		
		
		[Test]
		public function subscribe_with_default_hanler():void
		{
			var result:Boolean = mediator.subscribe(notification);
			
			assertTrue(result);
			assertEquals(notification, mediator.listSubscriptions()[0]);
		}
		
		
		
		[Test]
		public function subscribe_with_custom_handler():void
		{
			var result:Boolean = mediator.subscribe(notification, mediator.handleObject);
			
			assertTrue(result);
			assertEquals(notification, mediator.listSubscriptions()[0]);
		}
		
		
		
		[Test]
		public function do_not_subscribe_twice_for_the_same_notification():void
		{
			assertTrue(mediator.subscribe(notification));
			assertFalse(mediator.subscribe(notification, mediator.handleObject));
			
			assertEquals(1, mediator.listSubscriptions().length);
		}
		
		
		
		[Test]
		public function unsubscribe():void
		{
			mediator.subscribe(notification);
			var result:Boolean = mediator.unsubscribe(notification);
			
			assertTrue(result);
			assertEquals(0, mediator.listSubscriptions().length);
		}
		
		
		
		[Test]
		public function unsubscribe_returns_false_if_not_subscribed():void
		{
			assertFalse(mediator.unsubscribe(notification));
		}
		
		
		
		[Test]
		public function list_subscriptions():void
		{
			const note1:Notification = new Notification("note 1");
			const note2:Notification = new Notification("note 2");
			const note3:Notification = new Notification("note 3");
			
			mediator.subscribe(note1);
			mediator.subscribe(note2);
			mediator.subscribe(note3);
			
			assertEquals(3, mediator.listSubscriptions().length);
			assertTrue(mediator.listSubscriptions().indexOf(note1) >= 0);
			assertTrue(mediator.listSubscriptions().indexOf(note2) >= 0);
			assertTrue(mediator.listSubscriptions().indexOf(note3) >= 0);
		}
		
		
		
		[Test]
		public function handleNotifications_calls_handlers():void
		{
			const note1:Notification = new Notification();
			const note2:Notification = new Notification();
			
			mediator.subscribe(note1);
			mediator.subscribe(note2, mediator.handleObject);
			
			facade.addMediator(mediator);
			
			facade.sendNotification(note1);
			facade.sendNotification(note2, {});
			
			assertEquals(1, mediator.customHandlerCounter);
			assertEquals(2, mediator.allHandlersCounter);
		}
		
		
		
		[Test]
		public function mediator_custom_handler_accepts_notification_parameters_as_arguments():void
		{
			mediator.subscribe(notification, mediator.handleObject);
			
			const object:Object = {}; 
			
			facade.addMediator(mediator);
			facade.sendNotification(notification, object);
			
			assertStrictlyEquals(object, mediator.receivedObject);
		}
		
		
		
		//----------------------------------------------------------------------
		// callbacks
		//----------------------------------------------------------------------
		
		private function onSubscribe(mediator:Mediator, notificationType:Notification):void
		{
			counters[onSubscribe]++;
			totalCallbacksCalled++;
			lastArguments = arguments;
		}
		
		
		
		private function onUnsubscribe(mediator:Mediator, notificationType:Notification):void
		{
			counters[onUnsubscribe]++;
			totalCallbacksCalled++;
			lastArguments = arguments;
		}

		
		
		private function onAdd(mediator:Mediator, facade:Facade):void
		{
			counters[onAdd]++;
			totalCallbacksCalled++;
			lastArguments = arguments;
		}

		
		
		private function onRemove(mediator:Mediator, facade:Facade):void
		{
			counters[onRemove]++;
			totalCallbacksCalled++;
			lastArguments = arguments;
		}
	}
}

import ru.whitered.kote.Mediator;
import ru.whitered.kote.NotificationObject;




class CustomMediator extends Mediator
{
	public var customHandlerCounter:int = 0; 
	public var allHandlersCounter:int = 0;
	public var receivedObject:Object = null;

	
	
	override public function handleNotification(notificationObject:NotificationObject):void 
	{
		super.handleNotification(notificationObject);
		allHandlersCounter++;
	}

	
	
	public function handleObject(object:Object):void
	{
		customHandlerCounter++;
		receivedObject = object;
	}
}
