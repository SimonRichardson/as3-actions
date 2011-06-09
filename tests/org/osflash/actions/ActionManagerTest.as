package org.osflash.actions
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertFalse;

	import org.osflash.actions.types.ActionBooleanType;
	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionUIntType;
	import org.osflash.actions.types.ActionUtfType;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManagerTest
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
		public function verify_invalidated_is_false() : void
		{
			assertFalse('IActionManager invalidated status should be false', manager.invalidated);
		}
		
		[Test]
		public function verify_length_is_zero() : void
		{
			assertEquals('IActionManager length should be zero', 0, manager.length);	
		}
		
		[Test(expects="org.osflash.actions.ActionError")]
		public function verify_ActionError_is_thrown_when_adding_without_registering() : void
		{
			manager.dispatch(new ActionIntType());
			
			assertEquals('IActionManager length should be zero', 0, manager.length);
		}
		
		[Test]
		public function verify_length_is_1_after_add() : void
		{
			manager.register(ActionIntType);
			
			manager.dispatch(new ActionIntType());
			
			assertEquals('IActionManager length should be one', 1, manager.length);
		}
		
		[Test]
		public function verify_length_is_2_after_add() : void
		{
			manager.register(ActionIntType);
			
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			
			assertEquals('IActionManager length should be two', 2, manager.length);
		}
		
		[Test]
		public function verify_length_is_5_after_add() : void
		{
			manager.register(ActionIntType);
			
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			
			assertEquals('IActionManager length should be five', 5, manager.length);
		}
		
		[Test(expects="org.osflash.actions.ActionError")]
		public function verify_ActionError_is_thrown_when_adding_and_adding_without_registering() : void
		{
			manager.register(ActionIntType);
			
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionUtfType());
			manager.dispatch(new ActionIntType());
			
			assertEquals('IActionManager length should be three', 3, manager.length);
		}
		
		[Test]
		public function verify_length_is_5_after_adding_different_actions() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionUIntType);
			manager.register(ActionUtfType);
			
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionIntType());
			manager.dispatch(new ActionUIntType());
			manager.dispatch(new ActionUtfType());
			manager.dispatch(new ActionUIntType());
			
			assertEquals('IActionManager length should be five', 5, manager.length);
		}
		
		[Test]
		public function add_1_then_verify_current_is_same_as_last_dispatch() : void
		{
			manager.register(ActionIntType);
			
			const action : IAction = new ActionIntType();
			manager.dispatch(action);
			
			assertEquals('IActionManager current should equal last dispatch', 
																manager.current, 
																action
																);
		}
		
		[Test]
		public function add_2_then_verify_current_is_same_as_last_dispatch() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			const action1 : IAction = new ActionIntType();
			
			manager.dispatch(action0);
			manager.dispatch(action1);
			
			assertEquals('IActionManager current should equal last dispatch', 
																manager.current, 
																action1
																);
		}
		
		[Test]
		public function add_5_then_verify_current_is_same_as_last_dispatch() : void
		{
			manager.register(ActionIntType);
			
			const action0 : IAction = new ActionIntType();
			const action1 : IAction = new ActionIntType();
			const action2 : IAction = new ActionIntType();
			const action3 : IAction = new ActionIntType();
			const action4 : IAction = new ActionIntType();
			
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
		
		[Test]
		public function add_different_actions_then_verify_current_is_same_as_last_dispatch() : void
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
