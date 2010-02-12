package unit.tests 
{
	import flash.display.Sprite;
	import org.flexunit.asserts.fail;
	import ru.whitered.kote.Signal;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author whitered
	 */
	public class SignalTest 
	{
		private var signal:Signal;
		private var counter:int;
		private var array:Array;


		[Before]
		public function setUp():void
		{
			signal = new Signal();
			counter = 0; 
		}



		[After]
		public function tearDown():void
		{
			signal.removeAllCallbacks();
			signal = null;
			array = null;
		}
		
		
		
		//----------------------------------------------------------------------
		// tests
		//----------------------------------------------------------------------
		
		[Test]
		public function simple_callback():void
		{
			signal.addCallback(callbackWithCounter);
			signal.dispatch();
			assertEquals(1, counter);
			signal.dispatch();
			assertEquals(2, counter);
		}
		
		
		
		[Test]
		public function dispatch_signal_with_custom_arguments():void
		{
			const sprite:Sprite = new Sprite();
			signal.addCallback(callbackWithArguments);
			signal.dispatch(5, "string", sprite);
			
			assertNotNull(array);
			assertEquals(3, array.length);
			assertEquals(5, array[0]);
			assertEquals("string", array[1]);
			assertStrictlyEquals(sprite, array[2]);
		}
		
		
		
		[Test]
		public function remove_proper_callback():void
		{
			signal.addCallback(callbackWithCounter);
			
			signal.dispatch();
			signal.removeCallback(callbackWithCounter);
			signal.dispatch();
			
			assertEquals(1, counter);
		}

		
		
		[Test]
		public function do_not_remove_wrong_callback():void
		{
			signal.addCallback(callbackWithCounter);
			signal.dispatch();
			signal.removeCallback(callbackWithArguments);
			signal.dispatch();
			
			assertEquals(2, counter);
		}

		
		
		[Test]
		public function remove_all_callbacks():void
		{
			signal.addCallback(callbackWithCounter);
			
			signal.dispatch();
			signal.removeAllCallbacks();
			signal.dispatch();
			
			assertEquals(1, counter);
		}
		
		
		
		[Test]
		public function do_not_add_same_callback_twice():void
		{
			assertTrue(signal.addCallback(callbackWithCounter));
			assertFalse(signal.addCallback(callbackWithCounter));
			assertTrue(signal.removeCallback(callbackWithCounter));
			signal.dispatch();
			assertEquals(0, counter);
		}
		
		
		
		[Test]
		public function removing_non_existing_callback_returns_false():void
		{
			signal.addCallback(callbackThatFails);
			assertTrue(signal.removeCallback(callbackThatFails));
			assertFalse(signal.removeCallback(callbackThatFails));
			signal.dispatch();
		}
		
		
		
		[Test(expects="ArgumentError")]
		public function dispatch_with_wrong_number_of_arguments():void
		{
			signal.addCallback(callbackWithArguments);
			signal.dispatch(1, "string");
		}
		
		
		
		[Test(expects="TypeError")]
		public function dispatch_with_wrong_types_of_arguments():void
		{
			signal.addCallback(callbackWithArguments);
			signal.dispatch(3, "text", "this is not a sprite");
		}
		

		
		
		//----------------------------------------------------------------------
		// callbacks
		//----------------------------------------------------------------------
		
		private function callbackWithArguments(num:int, str:String, sprite:Sprite):void 
		{
			array = [num, str, sprite];
		}

		
		
		private function callbackWithCounter():void
		{
			counter++;
		}
		
		
		
		private function callbackThatFails():void
		{
			fail("This callback should not have been called");
		}
	}
}
