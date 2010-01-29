package ru.whitered.kote 
{

	/**
	 * @author whitered
	 */
	public class Command extends Notifier 
	{
		public function execute(notification:Notification):Boolean
		{
			if(hasOwnProperty("run") && this["run"] is Function)
			{
				this["run"].apply(this, notification.parameters);
			}
			return true;
		}
	}
}
