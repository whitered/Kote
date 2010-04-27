package unit.tests 
{
	import org.flexunit.asserts.assertEquals;

	/**
	 * @author whitered
	 */
	public class NotifierTest 
	{
		private var notifier:MyNotifier;
		private var counter:int;

		
		
		[Before]
		public function setUp():void
		{
			notifier = new MyNotifier();
			counter = 0;
		}
		
		
		
		[After]
		public function tearDown():void
		{
			notifier = null;
		}
		
		
		
		[Test]
		public function notifier_dispatches_notification():void
		{
			notifier.onNotification.add(simpleCallback);
			notifier.notify();
			assertEquals(1, counter);
		}

		
		
		private function simpleCallback():void 
		{
			counter++;
		}
	}
}

import ru.whitered.kote.Notifier;




class MyNotifier extends Notifier
{
	public function notify():void
	{
		_onNotification.dispatch();
	}
}
