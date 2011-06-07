package org.osflash.actions
{
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManager implements IActionManager
	{

		public function ActionManager()
		{
		}
		
		/**
		 * Commit a action to the manager, this will commit it to the history.
		 * 
		 * @param action IAction to commit
		 */
		public function commit() : void
		{
		}
	
		/**
		 * Revert a action on the manager, this will revert it from the history.
		 * 
		 * @param action IAction to revert
		 */
		public function revert() : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function read(stream : IActionInputStream) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function write(steam : IActionOutputStream) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function undo() : Boolean
		{
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redo() : Boolean
		{
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return "[ActionManager]";
		}
	}
}
