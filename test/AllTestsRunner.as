package  
{
	import integration.IntegrationTestSuite;
	import unit.UnitTestSuite;

	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

	/**
	 * @author whitered
	 */
	[SWF(width="800",height="600",frameRate="120",backgroundColor="#000000")]
	public class AllTestsRunner extends Sprite 
	{
		public function AllTestsRunner() 
		{
			const core:FlexUnitCore = new FlexUnitCore();
			core.addListener(new CIListener());
			core.run(UnitTestSuite, IntegrationTestSuite);
		}
	}
}
