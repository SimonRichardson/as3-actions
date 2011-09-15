package org.osflash.actions
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertEqualsArrays;
	import asunit.framework.IAsync;

	import org.osflash.actions.types.ActionBooleanType;
	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionUIntType;
	import org.osflash.actions.types.ActionUtfType;
	import org.osflash.signals.ISlot;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManagerDispatchInsertionTest
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
		public function verify_actions_length_after_dispatch_then_undo_then_dispatch_should_equal_3() : void
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
			
			manager.undo();
			manager.undo();
			manager.undo();
			
			const action5 : IAction = new ActionBooleanType();
			const action6 : IAction = new ActionUIntType();
			
			manager.dispatch(action5);
			manager.dispatch(action6);
			
			assertEquals('IActionManager length should equal 4', 4, manager.length);
		}
		
		[Test]
		public function verify_orphanedSignal_for_correct_orphaned_actions() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionUIntType);
			manager.register(ActionUtfType);
			manager.register(ActionBooleanType);
			
			const action0 : IAction = new ActionBooleanType();
			const action1 : IAction = new ActionUtfType();
			const action2 : IAction = new ActionIntType();
			const action3 : IAction = new ActionBooleanType();
			const action4 : IAction = new ActionUIntType();
			
			manager.orphanedSignal.add(async.add(verifyOrphanedActionsShouldEqual3, 500));
			
			const callback : Function = async.add(verifyOrphanedActionsShouldEqualArray, 500);
			const binding : ISlot = manager.orphanedSignal.add(callback);
			binding.params = [action2, action3, action4];
			
			manager.dispatch(action0);
			manager.dispatch(action1);
			manager.dispatch(action2);
			manager.dispatch(action3);
			manager.dispatch(action4);
			
			manager.undo();
			manager.undo();
			manager.undo();
			
			const action5 : IAction = new ActionBooleanType();
			const action6 : IAction = new ActionUIntType();
			
			manager.dispatch(action5);
			manager.dispatch(action6);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqual3(actions : Vector.<IAction>) : void
		{
			assertEquals('Orphaned actions length should be 3', 3, actions.length);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqualArray(	actions : Vector.<IAction>, 
																action0 : IAction,
																action1 : IAction,
																action2 : IAction
																) : void
		{
			assertEqualsArrays('Orphaned actions length should equal', 
																[action0, action1, action2], 
																[actions[0], actions[1], actions[2]]
																);
		}
		
		[Test]
		public function verify_actions_length_after_dispatch_then_undo_all_then_dispatch_should_equal_2() : void
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
			
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			
			const action5 : IAction = new ActionBooleanType();
			const action6 : IAction = new ActionUIntType();
			
			manager.dispatch(action5);
			manager.dispatch(action6);
			
			assertEquals('IActionManager length should equal 2', 2, manager.length);
		}
		
		[Test]
		public function verify_orphanedSignal_for_correct_orphaned_actions_with_full_removal() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionUIntType);
			manager.register(ActionUtfType);
			manager.register(ActionBooleanType);
			
			const action0 : IAction = new ActionBooleanType();
			const action1 : IAction = new ActionUtfType();
			const action2 : IAction = new ActionIntType();
			const action3 : IAction = new ActionBooleanType();
			const action4 : IAction = new ActionUIntType();
			
			manager.orphanedSignal.add(async.add(verifyOrphanedActionsShouldEqual5, 500));
			
			const callback : Function = async.add(verifyAllOrphanedActionsShouldEqualArray, 500);
			const binding : ISlot = manager.orphanedSignal.add(callback);
			binding.params = [action0, action1, action2, action3, action4];
			
			manager.dispatch(action0);
			manager.dispatch(action1);
			manager.dispatch(action2);
			manager.dispatch(action3);
			manager.dispatch(action4);
			
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			
			const action5 : IAction = new ActionBooleanType();
			const action6 : IAction = new ActionUIntType();
			
			manager.dispatch(action5);
			manager.dispatch(action6);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqual5(actions : Vector.<IAction>) : void
		{
			assertEquals('Orphaned actions length should be 5', 5, actions.length);
		}
		
		/**
		 * @private
		 */
		private function verifyAllOrphanedActionsShouldEqualArray(	actions : Vector.<IAction>, 
																	action0 : IAction,
																	action1 : IAction,
																	action2 : IAction,
																	action3 : IAction,
																	action4 : IAction
																	) : void
		{
			assertEqualsArrays('Orphaned actions length should equal', 
										[action0, action1, action2, action3, action4], 
										[actions[0], actions[1], actions[2], actions[3], actions[4]]
										);
		}
		
		[Test]
		public function verify_orphanedSignal_for_correct_orphaned_actions_with_mutliple_removals() : void
		{
			manager.register(ActionIntType);
			manager.register(ActionUIntType);
			manager.register(ActionUtfType);
			manager.register(ActionBooleanType);
			
			const action0 : IAction = new ActionBooleanType();
			const action1 : IAction = new ActionUtfType();
			const action2 : IAction = new ActionIntType();
			const action3 : IAction = new ActionBooleanType();
			const action4 : IAction = new ActionUIntType();
			
			const callback0 : Function = async.add(verifyOrphanedActionsShouldEqual2, 500);
			manager.orphanedSignal.add(callback0);
			
			const callback1 : Function = async.add(verifyOrphanedActionsShouldEqualArray2, 500);
			const binding0 : ISlot = manager.orphanedSignal.add(callback1);
			binding0.params = [action3, action4];
			
			manager.dispatch(action0);
			manager.dispatch(action1);
			manager.dispatch(action2);
			manager.dispatch(action3);
			manager.dispatch(action4);
			
			manager.undo();
			manager.undo();
			
			const action5 : IAction = new ActionBooleanType();
			const action6 : IAction = new ActionUIntType();
			
			manager.dispatch(action5);
			manager.dispatch(action6);
			
			manager.orphanedSignal.remove(callback0);
			manager.orphanedSignal.remove(callback1);
			
			const callback2 : Function = async.add(verifyOrphanedActionsShouldEqual4, 500);
			manager.orphanedSignal.add(callback2);
			
			const callback3 : Function = async.add(verifyOrphanedActionsShouldEqualArray4, 500);
			const binding1 : ISlot = manager.orphanedSignal.add(callback3);
			binding1.params = [action1, action2, action5, action6];
			
			manager.undo();
			manager.undo();
			manager.undo();
			manager.undo();
			
			const action7 : IAction = new ActionBooleanType();
			const action8 : IAction = new ActionBooleanType();
			const action9 : IAction = new ActionBooleanType();
			
			manager.dispatch(action7);
			manager.dispatch(action8);
			manager.dispatch(action9);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqual2(actions : Vector.<IAction>) : void
		{
			assertEquals('Orphaned actions length should be 2', 2, actions.length);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqualArray2(	actions : Vector.<IAction>, 
																	action0 : IAction,
																	action1 : IAction
																	) : void
		{
			assertEqualsArrays('Orphaned actions length should equal', 
																	[action0, action1], 
																	[actions[0], actions[1]]
																	);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqual4(actions : Vector.<IAction>) : void
		{
			assertEquals('Orphaned actions length should be 4', 4, actions.length);
		}
		
		/**
		 * @private
		 */
		private function verifyOrphanedActionsShouldEqualArray4(	actions : Vector.<IAction>, 
																	action0 : IAction,
																	action1 : IAction,
																	action2 : IAction,
																	action3 : IAction
																	) : void
		{
			assertEqualsArrays('Orphaned actions length should equal', 
													[action0, action1, action2, action3], 
													[actions[0], actions[1], actions[2], actions[3]]
													);
		}
		
	}
}
