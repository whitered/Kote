package ru.whitered.signaller 
{

	/**
	 * @author whitered
	 */
	public interface ISignal 
	{
		function add(callback:Function):Boolean;
		function remove(callback:Function):Boolean;
	}
}
