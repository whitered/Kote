package ru.whitered.kote 
{

	/**
	 * Commands used to execute application controller's actions
	 * 
	 * <p>If <code>run</code> method is defined it will be executed automatically 
	 * with the notification's parameters as arguments. The return value of the
	 * <code>run</code> method is ignored</p>
	 */
	public class Command extends Notifier 
	{
		private var _notificationObject:NotificationObject;
		
		
		
		/**
		 * Invokes when the command is executed
		 * 
		 * <p>Override this method if you need to operate the notification 
		 * instance instead of its parameters or to abort the notification.
		 * Be sure to call <code>super.execute(notification)</code> in the 
		 * overrided method</p>  
		 * 
		 * <p>To abort the notification flow just return <code>false</code>.
		 * No more commands will be executed and no mediators receive the 
		 * notification is this case.</p>
		 * 
		 * @return <code>true</code> to resume notification flow
		 */
		public function execute(notificationObject:NotificationObject):Boolean
		{
			if(hasOwnProperty("run") && this["run"] is Function)
			{
				_notificationObject = notificationObject;
				this["run"].apply(this, notificationObject.parameters);
				_notificationObject = null;
			}
			return true;
		}
		
		
		
		/**
		 * notificationObject is only accessible in run() method
		 */
		public function get notificationObject():NotificationObject
		{
			return _notificationObject;
		}
	}
}
