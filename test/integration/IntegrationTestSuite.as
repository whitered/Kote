package integration 
{
	import integration.tests.NotificationQueueTest;
	import integration.tests.CommandPriorityTest;

	/**
	 * @author whitered
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")] 
	public class IntegrationTestSuite 
	{
		public var commandPriorityTest:CommandPriorityTest;
		public var notificationQueueTest:NotificationQueueTest;
	}
}
