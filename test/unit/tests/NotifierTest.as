package unit.tests 
{
	import org.flexunit.asserts.assertEquals;
	import ru.whitered.kote.Notifier;

	/**
	 * @author whitered
	 */
	public class NotifierTest 
	{
		private var notifier:Notifier;
		private var counter:int;

		
		
		[Before]
		public function setUp():void
		{
			notifier = new Notifier();
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
			notifier.onNotification.addCallback(simpleCallback);
			notifier.onNotification.dispatch();
			assertEquals(1, counter);
		}

		
		
		private function simpleCallback():void 
		{
			counter++;
		}
	}
}
