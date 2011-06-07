package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManager implements IActionManager
	{
		
		/**
		 * @private
		 */
		private var _actions : Vector.<IAction>;
		
		/**
		 * @private
		 */		
		private var _registry : IActionClassRegistry;
		
		public function ActionManager(registry : IActionClassRegistry = null)
		{
			_actions = new Vector.<IAction>();
			_registry = registry || new ActionClassRegistry();
		}
		
		/**
		 * @inheritDoc
		 */
		public function register(actionClass : Class) : void
		{
			_registry.add(actionClass);
		}
		
		/**
		 * @inheritDoc
		 */
		public function unregister(actionClass : Class) : void
		{
			_registry.remove(actionClass);
		}
		
		/**
		 * Commit a action to the manager, this will commit it to the history.
		 * 
		 * @param action IAction to commit
		 */
		public function commit(action : IAction) : void
		{
		}
	
		/**
		 * Revert a action on the manager, this will revert it from the history.
		 * 
		 * @param action IAction to revert
		 */
		public function revert(action : IAction) : void
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
			_actions.length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get invalidated() : Boolean
		{
			return false;
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
