package org.osflash.actions
{
	import asunit.asserts.assertNull;
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertFalse;
	import asunit.asserts.assertTrue;

	import org.osflash.actions.types.ActionBooleanType;
	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionUIntType;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManagerUndoRedoTest
	{
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
		public function verify_undo_with_no_actions_returns_false() : void
		{
			const result : Boolean = manager.undo();
			assertFalse('IActionManager undo should return false', result);
		}
		
		[Test]
		public function verify_redo_with_no_actions_returns_false() : void
		{
			const result : Boolean = manager.redo();
			assertFalse('IActionManager redo should return false', result);
		}
		
		[Test]
		public function verify_undo_with_1_action_returns_true() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			const result : Boolean = manager.undo();
			assertTrue('IActionManager undo should return true', result);
		}
		
		[Test]
		public function verify_undo_with_1_action_current_is_null() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			manager.undo();
			assertNull('IActionManager current should be null', manager.current);
		}
		
		[Test]
		public function verify_redo_with_1_action_returns_false() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			const result : Boolean = manager.redo();
			assertFalse('IActionManager redo should return false', result);
		}
		
		[Test]
		public function verify_redo_with_1_action_current_should_be_action0() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			manager.dispatch(action0);
			
			manager.redo();
			assertEquals('IActionManager current should be action0', manager.current, action0);
		}
		
		[Test]
		public function verify_current_is_last_dispatched() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionUIntType);
			manager.register(ActionBooleanType);
			
			const action0 : IAction = new ActionBooleanType();
			const action1 : IAction = new ActionIntType();
			const action2 : IAction = new ActionIntType();
			const action3 : IAction = new ActionBooleanType();
			const action4 : IAction = new ActionUIntType();
			
			manager.dispatch(action0);
			manager.dispatch(action1);
			manager.dispatch(action2);
			manager.dispatch(action3);
			manager.dispatch(action4);
			
			assertEquals('IActionManager current should equal last dispatch', 
																manager.current, 
																action4
																);
		}
	}
}
