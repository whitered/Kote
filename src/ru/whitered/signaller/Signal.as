package ru.whitered.signaller
{
	/**
	 * Signal in an event that can be listened
	 */
	public class Signal implements ISignal
	{
		private var callbacks:Vector.<Function>;
		
		private var callbacksInUse:Boolean = false;
		
		
		
		/**
		 * Registers callback
		 * 
		 * @param callback
		 */
		public function add(callback:Function):Boolean
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
				callbacks = Vector.<Function>([callback]);
			}
			return true;
		}
		
		
		
		/**
		 * Unregisters callback
		 * 
		 * @param callback
		 */
		public function remove(callback:Function):Boolean
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
		 * @internal
		 * 
		 * Calls all registered callbacks with given arguments
		 */
		internal function dispatch(args:Array):void
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
			
			const snapshot:Vector.<Function> = callbacks;
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
		 * @internal
		 * 
		 * Removes all the callbacks
		 */
		internal function clean():void
		{
			callbacks = null;
		}
	}
}
