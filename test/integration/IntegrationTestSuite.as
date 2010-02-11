package integration 
{
	import integration.tests.CommandPriorityTest;

	/**
	 * @author whitered
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")] 
	public class IntegrationTestSuite 
	{
		public var testCommandPriority:CommandPriorityTest;
	}
}
