package ru.whitered.kote
{

	/**
	 * @author whitered
	 */
	public class Signal 
	{
		private var listeners:Vector.<Function>;
		
		
		
		public function dispatch(... args):void
		{
			if(!listeners) return;
			const snapshot:Vector.<Function> = listeners.concat();
			const numListeners:int = snapshot.length;
			
			var i:int;
			if(args.length == 0)
			{
				for (i = 0;i < numListeners;i++)
				{
					snapshot[i]();
				}
			}
			else
			{
				for (i = 0;i < numListeners;i++)
				{
					snapshot[i].apply(null, args);
				}
			}
		}

		
		
		public function addListener(listener:Function):void
		{
			if(listeners)
			{
				if(listeners.indexOf(listener) >= 0) throw new Error("The listener is already registered");
				listeners[listeners.length] = listener;
			}
			else
			{
				listeners = Vector.<Function>([listener]);
			}
		}
		
		
		
		public function removeListener(listener:Function):Boolean
		{
			if(!listeners) return false;
			const index:int = listeners.indexOf(listener);
			if(index < 0) return false; 
			listeners.splice(index, 1);
			return true;
		}
		
		
		
		public function removeAllListeners():void
		{
			listeners = null;
		}
	}
}
