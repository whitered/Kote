package unit 
{
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
	}
}
