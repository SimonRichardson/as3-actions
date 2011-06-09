package org.osflash.actions
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;

	import flash.errors.IllegalOperationError;
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
		
		/**
		 * @private
		 */
		private const _orphanedSignal : ISignal = new Signal(Vector.<IAction>);
		
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
			
			// Locate current
			var orphaned : Vector.<IAction>;
			if(null == _current)
			{
				// trash the whole stack?
				if(_actions.length > 0)
				{
					orphaned = _actions.concat();
					_actions.length = 0;
					orphanedSignal.dispatch(orphaned.reverse());
				}
			}
			else if(_actions[0] != _current)
			{
				// Only change if we're not at the head of the stack, as there is no need!
				var index : int = _actions.length;
				while(--index > -1)
				{
					const item : IAction = _actions[index];
					if(item == _current)
						break;
				}
				
				if(index < 0 || index > _actions.length)
					throw new IllegalOperationError('Removing future nodes error');
				
				orphaned = _actions.splice(0, index);
				orphanedSignal.dispatch(orphaned.reverse());
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
			
			commitSignal.dispatch(action);
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
			
			revertSignal.dispatch(action);
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
			
			// Set the current position
			if(index >= _actions.length)
			{
				_current = null;
			}
			else
			{
				const item : IAction = _actions[index];
				_current = item;
				
				while(index < total)
				{
					revert(_actions[index]);
					index++;
				}
			}
			
			if(invalidated) 
				changeSignal.dispatch(_current);
						
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
			
			const index : int = (null == _current) ? total - 1 : _actions.indexOf(_current) - 1;
			const item : IAction = _actions[index];
			commit(item);
				
			_current = item;
				
			if(invalidated) changeSignal.dispatch(_current);
				
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			_actions.length = 0;
			_current = null;
			_savePointer = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function read(stream : IStreamInput) : void
		{
			if(null == _registry)
				ActionError.throwError(ActionError.INVALID_ACTION_CLASS_REGISTRY);
			
			if(_actions.length > 0)
				ActionError.throwError(ActionError.ACTIONS_ALREADY_EXIST);
			
			const valid : Boolean = stream.readBoolean();
			if(valid)
			{
				const currentID : String = stream.readUTF();
				// TODO : validate id here.
			}
			
			const total : uint = stream.readUnsignedInt();
			for(var i : int = 0; i<total; i++)
			{
				// create a new action from the registry
				const currentPosition : uint = stream.position;
				
				// Read in the qname
				const qname : String = stream.readUTF();
				
				// Reset the position
				stream.position = currentPosition;
				
				// We now have the action
				const action : IAction = _registry.create(qname);
				if(action is IActionSequence)
				{
					const sequence : IActionSequence = IActionSequence(action);
					sequence.registry = _registry;
				}
				
				action.read(stream);
				
				_actions.push(action);
				
				// Store the current action
				if(action.id == currentID)
					_current = action;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function write(stream : IStreamOutput) : void
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
		public function describe(stream : IStreamOutput) : void
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
		public function get length() : int { return _actions.length; }
		
		/**
		 * @inheritDoc
		 */
		public function get current() : IAction { return _current; }
		
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
		 * @private
		 */
		public function get orphanedSignal() : ISignal { return _orphanedSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return "[ActionManager]";
		}
	}
}
