package org.osflash.actions
{
	import org.osflash.actions.stream.ActionByteArrayOutputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import asunit.framework.IAsync;
	import org.osflash.actions.debug.describeActions;
	import org.osflash.actions.types.ActionIntType;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionTest
	{
		
		[Inject]
		public var async : IAsync;
		
		protected var manager : IActionManager;
				
		[Before]
		public function setUp():void
		{
			manager = new ActionManager();
		}
		
		[After]
		public function tearDown():void
		{
			manager.clear();
			manager = null;
		}
		
		[Test]
		public function test_setup() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionSequence);
			
			const action : IAction = new ActionIntType();
			manager.dispatch(action);
			
			const sequence : IActionSequence = new ActionSequence();
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			manager.dispatch(sequence);
						
			trace(describeActions(manager));
			
			manager.undo();
			
			trace(describeActions(manager));
			
			manager.redo();
			
			trace(describeActions(manager));
			
			const stream : IActionOutputStream = new ActionByteArrayOutputStream();
			manager.write(stream);
			
		}
	}
}
