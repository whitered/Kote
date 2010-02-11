package  
{
	import integration.IntegrationTestSuite;

	import unit.UnitTestSuite;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;
	
	/*FDT_IGNORE*//* begin */
	CONFIG::cilistener {
		import org.flexunit.listeners.CIListener;
	}
	/*FDT_IGNORE*//* end */
	
	
	/**
	 * @author whitered
	 */
	[SWF(width="800",height="600",frameRate="120",backgroundColor="#000000")]
	public class AllTestsRunner extends Sprite 
	{
		public function AllTestsRunner() 
		{
			const core:FlexUnitCore = new FlexUnitCore();
			
			/*FDT_IGNORE*//* begin */
			CONFIG::cilistener {
				core.addListener(new CIListener());
			}
			/*FDT_IGNORE*//* end */
			
			core.addListener(new TraceListener());
			core.run(UnitTestSuite, IntegrationTestSuite);
		}
	}
}
