package org.osflash.actions
{
	import org.osflash.actions.stream.ActionByteArrayInputStream;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.debug.describeWriteActions;
	import asunit.framework.IAsync;

	import org.osflash.actions.debug.describeActions;
	import org.osflash.actions.stream.ActionByteArrayOutputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionUtfType;
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
			manager.register(ActionUtfType);
			manager.register(ActionSequence);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			const action1 : IAction = new ActionIntType();
			manager.dispatch(action1);
			
			const sequence : IActionSequence = new ActionSequence();
			sequence.add(new ActionIntType());
			sequence.add(new ActionUtfType());
			sequence.add(new ActionIntType());
			
			const sequence1 : IActionSequence = new ActionSequence();
			sequence1.add(new ActionIntType());
			sequence1.add(new ActionUtfType());
			sequence.add(sequence1);
			
			manager.dispatch(sequence);
						
			trace(describeActions(manager));
			
			manager.undo();
			
			trace(describeActions(manager));
			
			manager.redo();
			
			trace(describeActions(manager));
			
			manager.undo();
			manager.undo();
			
			trace(describeActions(manager));
			
			const outStream0 : IActionOutputStream = new ActionByteArrayOutputStream();
			manager.write(outStream0);
			
			trace(describeWriteActions(outStream0));
			
			manager.clear();
			
			trace(describeActions(manager));
			
			const inStream : IActionInputStream = new ActionByteArrayInputStream(outStream0);
			manager.read(inStream);
			
			trace(describeActions(manager));
			
			const outStream1 : IActionOutputStream = new ActionByteArrayOutputStream();
			manager.write(outStream1);
			trace(describeWriteActions(outStream1));
		}
	}
}
