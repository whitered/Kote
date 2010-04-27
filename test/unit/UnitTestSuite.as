package unit 
{
	import unit.tests.CommandTest;
	import unit.tests.FacadeTest;
	import unit.tests.MediatorTest;
	import unit.tests.NotificationTest;
	import unit.tests.NotifierTest;

	/**
	 * @author whitered
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")] 
	public class UnitTestSuite 
	{
		public var notificationTest:NotificationTest;
		public var notifierTest:NotifierTest;
		public var commandTest:CommandTest;
		public var mediatorTest:MediatorTest;
		public var facadeTest:FacadeTest;
	}
}
