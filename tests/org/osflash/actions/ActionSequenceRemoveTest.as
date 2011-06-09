package org.osflash.actions
{
	import asunit.asserts.assertEquals;

	import org.osflash.actions.types.ActionIntType;
	import org.osflash.actions.types.ActionUIntType;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionSequenceRemoveTest
	{
		protected var sequence : IActionSequence;
				
		[Before]
		public function setUp():void
		{
			sequence = new ActionSequence();
		}
		
		[After]
		public function tearDown():void
		{
			sequence.removeAll();
			sequence = null;
		}
		
		[Test]
		public function add_1_removeAt_0_sequence_length_is_0() : void
		{
			sequence.add(new ActionIntType());
			sequence.removeAt(0);
			
			assertEquals('IActionSeqence length is 0', 0, sequence.length);
		}
		
		[Test]
		public function add_2_removeAt_0_sequence_length_is_1() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.removeAt(0);
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test]
		public function add_2_removeAt_1_sequence_length_is_1() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.removeAt(1);
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test(expects="RangeError")]
		public function add_2_removeAt_2_sequence_length_is_2() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.removeAt(2);
			
			assertEquals('IActionSeqence length is 2', 2, sequence.length);
		}
		
		[Test]
		public function add_10_removeAll_sequence_length_is_0() : void
		{
			for(var i : int = 0; i<10; i++)
			{
				sequence.add(new ActionIntType());
			}
			
			sequence.removeAll();
			
			assertEquals('IActionSeqence length is 0', 0, sequence.length);
		}
		
		[Test]
		public function add_2_remove_action0_sequence_length_is_1() : void
		{
			const action0 : IAction = new ActionIntType();
			const action1 : IAction = new ActionUIntType();
			
			sequence.add(action0);
			sequence.add(action1);
			sequence.remove(action0);
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test]
		public function add_2_remove_action0_verify_sequence_at_0() : void
		{
			const action0 : IAction = new ActionIntType();
			const action1 : IAction = new ActionUIntType();
			
			sequence.add(action0);
			sequence.add(action1);
			
			sequence.remove(action0);
			
			assertEquals('IActionSeqence getAt(0) is action1', action1, sequence.getAt(0));
		}
		
		[Test]
		public function add_2_remove_action1_verify_sequence_at_0() : void
		{
			const action0 : IAction = new ActionIntType();
			const action1 : IAction = new ActionUIntType();
			
			sequence.add(action0);
			sequence.add(action1);
			
			sequence.remove(action1);
			
			assertEquals('IActionSeqence getAt(0) is action0', action0, sequence.getAt(0));
		}
	}
}
