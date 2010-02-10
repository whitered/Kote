package ru.whitered.kote
{

	/**
	 * Signal presents a single event type
	 */
	public class Signal 
	{
		private var callbacks:Array;
		
		
		
		/**
		 * Calls all registered callbacks with given arguments
		 */
		public function dispatch(... args):void
		{
			if(!callbacks) return;
			const snapshot:Array = callbacks.concat();
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
