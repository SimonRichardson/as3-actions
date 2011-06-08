package org.osflash.actions
{
	import org.osflash.actions.debug.describeWriteActions;
	import asunit.framework.IAsync;

	import org.osflash.actions.debug.describeActions;
	import org.osflash.actions.stream.ActionByteArrayOutputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionStringType;
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
			manager.register(ActionStringType);
			manager.register(ActionSequence);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			const action1 : IAction = new ActionIntType();
			manager.dispatch(action1);
			
			const sequence : IActionSequence = new ActionSequence();
			sequence.add(new ActionIntType());
			sequence.add(new ActionStringType());
			sequence.add(new ActionIntType());
			manager.dispatch(sequence);
						
			trace(describeActions(manager));
			
			manager.undo();
			
			trace(describeActions(manager));
			
			manager.redo();
			
			trace(describeActions(manager));
			
			const stream : IActionOutputStream = new ActionByteArrayOutputStream();
			manager.write(stream);
			
			trace(describeWriteActions(stream));
		}
	}
}
