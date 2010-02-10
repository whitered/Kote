package unit 
{
	import unit.tests.MediatorTest;
	import unit.tests.CommandTest;
	import unit.tests.NotifierTest;
	import unit.tests.NotificationTest;
	import unit.tests.SignalTest;

	/**
	 * @author whitered
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")] 
	public class UnitTestsSuite 
	{
		public var signalTest:SignalTest;
		public var notificationTest:NotificationTest;
		public var notifierTest:NotifierTest;
		public var commandTest:CommandTest;
		public var mediatorTest:MediatorTest;
	}
}
