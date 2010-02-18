package ru.whitered.kote
{

	/**
	 * Signal presents a single event type
	 */
	public class Signal 
	{
		private var callbacks:Array;
		
		private var callbacksInUse:Boolean = false;
		
		
		
		/**
		 * Calls all registered callbacks with given arguments
		 */
		public function dispatch(... args):void
		{
			if(!callbacks) return;
			
			if(callbacksInUse)
			{
				callbacks = callbacks.slice();
			}
			else
			{
				callbacksInUse = true;
			}
			
			const snapshot:Array = callbacks;
			const numCallbacks:int = snapshot.length;
			
			var i:int;
			if(args.length == 0)
			{
				for (i = 0;i < numCallbacks;i++)
				{
					snapshot[i]();
				}
			}
			else
			{
				for (i = 0;i < numCallbacks;i++)
				{
					snapshot[i].apply(null, args);
				}
			}
			
			callbacksInUse = false;
		}

		
		
		/**
		 * Registers callback
		 * 
		 * @param callback
		 */
		public function addCallback(callback:Function):Boolean
		{
			
			if(callbacks)
			{
				if(callbacksInUse)
				{
					callbacks = callbacks.slice();
					callbacksInUse = false;
				}
				
				if(callbacks.indexOf(callback) >= 0) return false;
				callbacks[callbacks.length] = callback;
			}
			else
			{
				callbacks = [callback];
			}
			return true;
		}
		
		
		
		/**
		 * Unregisters specified callback
		 * 
		 * @param callback
		 */
		public function removeCallback(callback:Function):Boolean
		{
			if(!callbacks) return false;
			const index:int = callbacks.indexOf(callback);
			if(index < 0) return false; 

			if(callbacksInUse)
			{
				callbacks = callbacks.slice();
				callbacksInUse = false;
			}
				
			callbacks.splice(index, 1);
			return true;
		}
		
		
		
		/**
		 * Removes all the callbacks
		 */
		public function removeAllCallbacks():void
		{
			callbacks = null;
		}
	}
}
