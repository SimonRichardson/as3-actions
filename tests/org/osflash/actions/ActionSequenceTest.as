package org.osflash.actions
{
	import org.osflash.actions.types.ActionIntType;
	import asunit.asserts.assertEquals;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionSequenceTest
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
		public function verify_sequence_length_is_0() : void
		{
			assertEquals('IActionSeqence length is 0', 0, sequence.length);
		}
		
		[Test]
		public function add_1_sequence_length_is_1() : void
		{
			sequence.add(new ActionIntType());
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test]
		public function add_2_sequence_length_is_2() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			
			assertEquals('IActionSeqence length is 2', 2, sequence.length);
		}
		
		[Test(expects="RangeError")]
		public function addAt_2_throws_error() : void
		{
			sequence.addAt(new ActionIntType(), 2);
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test]
		public function addAt_0_sequence_length_is_1() : void
		{
			sequence.addAt(new ActionIntType(), 0);
			
			assertEquals('IActionSeqence length is 1', 1, sequence.length);
		}
		
		[Test]
		public function add_twice_then_addAt_2_sequence_length_is_3() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.addAt(new ActionIntType(), 2);
			
			assertEquals('IActionSeqence length is 3', 3, sequence.length);
		}
		
		[Test]
		public function add_twice_then_addAt_0_sequence_length_is_3() : void
		{
			sequence.add(new ActionIntType());
			sequence.add(new ActionIntType());
			sequence.addAt(new ActionIntType(), 0);
			
			assertEquals('IActionSeqence length is 3', 3, sequence.length);
		}
	}
}
