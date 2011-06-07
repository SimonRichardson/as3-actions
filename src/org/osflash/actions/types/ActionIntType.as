package org.osflash.actions.types
{
	import org.osflash.actions.Action;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionIntType extends Action
	{
		
		private var _int : int;

		public function ActionIntType(value : int)
		{
			_int = value;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function commit() : void
		{
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function revert() : void
		{
		}
	}
}
