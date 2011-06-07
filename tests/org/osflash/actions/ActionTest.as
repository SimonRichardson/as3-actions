package org.osflash.actions
{
	import org.osflash.actions.types.ActionIntType;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionTest
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
		public function test_setup() : void
		{
			manager.register(ActionIntType);
			
			const action : IAction = new ActionIntType();
			manager.commit(action);
		}
	}
}
