package org.osflash.actions
{
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionManager implements IActionManager
	{
		
		/**
		 * @private
		 */
		private var _current : IAction;
		
		/**
		 * @private
		 */
		private var _savePointer : IAction;
		
		/**
		 * @private
		 */
		private var _actions : Vector.<IAction>;
				
		/**
		 * @private
		 */		
		private var _registry : IActionClassRegistry;
		
		/**
		 * @private
		 */
		private const _commitSignal : ISignal = new Signal(IAction);
		
		/**
		 * @private
		 */
		private const _changeSignal : ISignal = new Signal(IAction, IAction);
		
		/**
		 * @private
		 */
		private const _revertSignal : ISignal = new Signal(IAction);
		
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
		 * @inheritDoc
		 */
		public function dispatch(action : IAction) : void
		{
			if(null == action) throw new ArgumentError('Given value can not be null');
			
			commit(action);
			
			var index : int = _actions.length;
			while(--index > -1)
			{
				const item : IAction = _actions[index];
				if(item == _current)
					continue;
				
				_actions.splice(index, 1);
			}
			
			_actions.unshift(action);
			_current = action;
			
			if(invalidated) _changeSignal.dispatch(_current);
		}
		
		/**
		 * Commit a action to the manager, this will commit it to the history.
		 * 
		 * @param action IAction to commit
		 */
		public function commit(action : IAction) : void
		{
			if(!_registry.containsAction(action))
				ActionError.throwError(ActionError.ACTION_CLASS_DOES_NOT_EXIST);
			
			action.commit();
			
			_commitSignal.dispatch(action);
		}
	
		/**
		 * Revert a action on the manager, this will revert it from the history.
		 * 
		 * @param action IAction to revert
		 */
		public function revert(action : IAction) : void
		{
			if(!_registry.containsAction(action))
				ActionError.throwError(ActionError.ACTION_CLASS_DOES_NOT_EXIST);
			
			action.revert();
			
			_revertSignal.dispatch(action);
		}
		
		/**
		 * @inheritDoc
		 */
		public function undo() : Boolean
		{
			const total : int = _actions.length;
			const action : IAction = _current;

			if(null == action || total == 0) return false;
			
			// Revert the current one
			revert(_current);
			
			// Revert the previous items
			var index : int = _actions.indexOf(_current);
			index = index < 0 ? 0 : index + 1;
			
			while(index < total)
			{
				const item : IAction = _actions[index];
				
				revert(item);
				
				_current = item;
				
				if(invalidated) _changeSignal.dispatch(_current);
				
				index++;
			}
						
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redo() : Boolean
		{
			const total : int = _actions.length;
			if(total == 0) return false;
			
			// Current could be null, but that would be a case of (IAction == null) == false
			if(_actions[0] == _current) return false;
			
			const index : int = (null == _current) ? total : _actions.indexOf(_current);
			const item : IAction = _actions[index];
			
			commit(item);
			
			_current = item;
				
			if(invalidated) _changeSignal.dispatch(_current);
				
			return true;
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
		public function read(stream : IActionInputStream) : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function write(stream : IActionOutputStream) : void
		{
			// Writes the rest of the actions
			const total : int = _actions.length;
			
			const valid : Boolean = (null != _current);
			stream.writeBoolean(valid);
			
			// Write the current id, if there is one
			if(valid)
				stream.writeUTF(_current.id);
			
			stream.writeUnsignedInt(total);
			
			for(var i : int = 0; i<total; i++)
			{
				const action : IAction = _actions[i];
				action.write(stream);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function describe(stream : IActionOutputStream) : void
		{
			// Writes the rest of the actions
			const total : int = _actions.length;
			
			const valid : Boolean = (null != _current);
			stream.writeBoolean(valid);
			
			// Write the current id, if there is one
			if(valid)
				stream.writeUTF(_current.id);
			
			stream.writeUnsignedInt(total);
			
			for(var i : int = 0; i<total; i++)
			{
				const action : IAction = _actions[i];
				action.describe(stream);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get invalidated() : Boolean 
		{ 
			return null != _savePointer && _current != _savePointer;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function get commitSignal() : ISignal { return _commitSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get changeSignal() : ISignal { return _changeSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get revertSignal() : ISignal { return _revertSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return "[ActionManager]";
		}
	}
}
