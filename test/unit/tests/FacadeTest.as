package unit.tests 
{
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import ru.whitered.kote.Proxy;
	import ru.whitered.kote.Command;
	import ru.whitered.kote.Facade;
	import ru.whitered.kote.Mediator;
	import ru.whitered.kote.Notification;


	/**
	 * @author whitered
	 */
	public class FacadeTest 
	{
		private const notificationType:Notification = new Notification();
		
		private var facade:Facade;
		private var proxy:Proxy;
		private var mediator:Mediator;
		private var command:Command;
		
		
		
		[Before]
		public function setUp():void
		{
			facade = new Facade();
			proxy = new Proxy();
			mediator = new Mediator();
			command = new Command();
		}
		
		
		
		[After]
		public function tearDown():void
		{
			command = null;
			mediator = null;
			proxy = null;
			facade = null;
		}
		
		
		
		//----------------------------------------------------------------------
		// tests
		//----------------------------------------------------------------------
		
		[Test]
		public function add_proxy():void
		{
			assertTrue(facade.addProxy(proxy));
			assertTrue(facade.hasProxy(proxy));
		}
		
		
		
		[Test]
		public function add_proxy_twice():void
		{
			assertTrue(facade.addProxy(proxy));
			assertFalse(facade.addProxy(proxy));
		}
		
		
		
		[Test]
		public function remove_proxy():void
		{
			facade.addProxy(proxy);
			assertTrue(facade.removeProxy(proxy));
			assertFalse(facade.hasProxy(proxy));
		}
		
		
		
		[Test]
		public function do_not_remove_unregistered_proxy():void
		{
			assertFalse(facade.removeProxy(proxy));
		}
		
		
		
		[Test]
		public function has_proxy():void
		{
			assertFalse(facade.hasProxy(proxy));
			facade.addProxy(proxy);
			assertTrue(facade.hasProxy(proxy));
		}
		
		
		
		[Test]
		public function add_mediator():void
		{
			assertTrue(facade.addMediator(mediator));
			assertTrue(facade.hasMediator(mediator));
		}
		
		
		
		[Test]
		public function add_mediator_twice():void
		{
			facade.addMediator(mediator);
			assertFalse(facade.addMediator(mediator));
		}
		
		
		
		[Test]
		public function remove_mediator():void
		{
			facade.addMediator(mediator);
			assertTrue(facade.removeMediator(mediator));
			assertFalse(facade.hasMediator(mediator));
		}
		
		
		
		[Test]
		public function do_not_remove_unregistered_mediator():void
		{
			assertFalse(facade.removeMediator(mediator));
		}
		
		
		
		[Test]
		public function has_mediator():void
		{
			assertFalse(facade.hasMediator(mediator));
			facade.addMediator(mediator);
			assertTrue(facade.hasMediator(mediator));
		}
		
		
		
		[Test]
		public function add_command():void
		{
			assertTrue(facade.addCommand(notificationType, command));
		}
		
		
		
		[Test]
		public function do_not_add_command_for_same_notification_twice():void
		{
			assertTrue(facade.addCommand(notificationType, command));
			assertFalse(facade.addCommand(notificationType, command));
		}
		
		
		
		
		[Test]
		public function remove_command():void
		{
			facade.addCommand(notificationType, command);
			assertTrue(facade.removeCommand(notificationType, command));
		}
		
		
		
		
		[Test]
		public function do_not_remove_unregistered_command():void
		{
			facade.addCommand(notificationType, command);
			assertFalse(facade.removeCommand(notificationType, new Command()));
		}
		
		
		
		[Test]
		public function do_not_remove_command_with_wrong_notification():void
		{
			facade.addCommand(notificationType, command);
			assertFalse(facade.removeCommand(new Notification(), command));
		}
		
		
		
	}
}
