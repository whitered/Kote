package unit.tests 
{
	import ru.whitered.kote.Signal;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	import flash.display.Sprite;

	/**
	 * @author whitered
	 */
	public class SignalTest 
	{
		private var signal:Signal;
		private var counter:int;
		private var args:Array;
		


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
			args = null;
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
			
			assertThat(args, array(5, "string", sprite));
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
		
		
		
		[Test]
		public function callback_added_by_another_callback_will_not_be_executed_in_this_time():void
		{
			signal.addCallback(callbackThatModifiesCallbacks);
			signal.dispatch(signal, [callbackThatModifiesCallbacks], [callbackWithCounter]);
			
			assertEquals(0, counter);
			
			signal.dispatch();
			
			assertEquals(1, counter);
			
		}
		
		
		[Test]
		public function callback_removed_by_another_callback_still_will_be_executed_in_this_time():void
		{
			signal.addCallback(callbackThatModifiesCallbacks);
			signal.addCallback(callbackWithCounter);
			
			signal.dispatch(signal, [callbackWithCounter], null);
			
			assertEquals("CallbackWithCounter was in list on the moment of dispatch()", 1, counter);
			
			signal.removeCallback(callbackThatModifiesCallbacks);
			signal.dispatch();
			
			assertEquals("CallbackWithCounter should be removed and signal should contain no callbacks", 1, counter);
		}
		
		
		
		[Test]
		public function redispatch_and_remove_callbacks_do_not_modify_current_callbacks_list():void
		{
			var redispatched:Boolean = false;
			const callback:Function = function():void
			{
				if(!redispatched)
				{
					redispatched = true;
					signal.dispatch();
					signal.removeCallback(callbackWithCounter);
					signal.addCallback(callbackThatFails);
				}
			};
			signal.addCallback(callback);
			signal.addCallback(callbackWithCounter);
			
			signal.dispatch();
			
			assertEquals(2, counter);
		}
		//----------------------------------------------------------------------
		// callbacks
		//----------------------------------------------------------------------
		
		private function callbackWithArguments(num:int, str:String, sprite:Sprite):void 
		{
			args = [num, str, sprite];
		}

		
		
		private function callbackWithCounter(... args):void
		{
			counter++;
		}
		
		
		
		private function callbackThatFails(... args):void
		{
			fail("This callback should not have been called");
		}
		
		
		
		private function callbackThatModifiesCallbacks(signal:Signal, callbacksToRemove:Array, callbacksToAdd:Array):void
		{
			var callback:Function;
			
			for each (callback in callbacksToRemove)
			{
				signal.removeCallback(callback);
			}
			
			
			for each (callback in callbacksToAdd)
			{
				signal.addCallback(callback);
			}
		}
	}
}
