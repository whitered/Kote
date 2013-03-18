package ru.whitered.signaller 
{

	/**
	 * Signaller is a wrapper on Signal that can dispatch signals
	 */
	public class Signaller implements ISignal
	{
		private const _signal:Signal = new Signal();

		
		
		public function get signal():Signal
		{
			return _signal;
		}
		
		
		
		public function dispatch(... args):void
		{
			_signal.dispatch(args);
		}
		
		
		
		public function clean():void
		{
			_signal.clean();
		}
		
		
		
		public function add(callback:Function):Boolean
		{
			return _signal.add(callback);
		}
		
		
		
		public function remove(callback:Function):Boolean
		{
			return _signal.remove(callback);
		}
	}
}
