package org.osflash.actions
{
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionSequence extends Action implements IActionSequence
	{
				
		/**
		 * @private
		 */
		private var _actions : Vector.<IAction>;
		
		/**
		 * @private
		 */
		private var _registry : IActionClassRegistry;

		public function ActionSequence()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function commit() : void
		{
			if(null == _actions)
				ActionError.throwError(ActionError.NO_ACTIONS_ADDED_IN_SEQUENCE);
				
			const total : int = _actions.length;
			for(var i : int = 0; i<total; i++)
			{
				const action : IAction = _actions[i];
				action.commit();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function revert() : void
		{
			if(null == _actions)
				ActionError.throwError(ActionError.NO_ACTIONS_ADDED_IN_SEQUENCE);
				
			const total : int = _actions.length;
			for(var i : int = 0; i<total; i++)
			{
				const action : IAction = _actions[i];
				action.revert();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function add(action : IAction) : IAction
		{
			return addAt(action, length);
		}

		/**
		 * @inheritDoc
		 */
		public function addAt(action : IAction, index : int) : IAction
		{
			if(index < 0) throw new RangeError('Given index is out of range (index=' + index + ')');
			if(index > length) throw new RangeError('Given index is outside of dense length');
			
			// Create the children if it was set to null.			
			if(null == _actions) _actions = new Vector.<IAction>();
			
			// If it already exists, throw an error to prevent re-adding.
			if(contains(action)) ActionError.throwError(ActionError.ACTION_ALREADY_EXISTS);
			
			if(index == 0)
				_actions.unshift(action);
			else if(index == length)
				_actions.push(action);
			else
				_actions.splice(index, 1, action);
			
			return action;
		}

		/**
		 * @inheritDoc
		 */
		public function getAt(index : int) : IAction
		{
			if(index < 0 || index >= length) throw new RangeError('Given index is out of ' + 
									'range (index=' + index + ', numActions=' + length + ')');
			return _actions[index];
		}

		/**
		 * @inheritDoc
		 */
		public function getIndex(action : IAction) : int
		{
			if(length == 0 || !contains(action)) 
				ActionError.throwError(ActionError.ACTION_DOES_NOT_EXIST);
			
			return _actions.indexOf(action);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(action : IAction) : IAction
		{
			const index : int = getIndex(action);
			if(index < 0) return null;
			return removeAt(index);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAt(index : int) : IAction
		{
			if(null == _actions) return null;
			
			if(index < 0 || index >= length) throw new RangeError('Given index is out of ' + 
									'range (index=' + index + ', numChildren=' + length + ')');
			
			const actions : Vector.<IAction> = _actions.splice(index, 1);
			if(actions.length == 0) ActionError.throwError(ActionError.REMOVE_ACTION_LENGTH_ZERO);
			
			const node : IAction = actions[0];
			if(null == node) 
				ActionError.throwError(ActionError.REMOVE_ACTION_MISMATCH);
			
			if(length == 0)
				_actions = null;
			
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll() : void
		{
			while(null != _actions && _actions.length)
			{
				removeAt(_actions.length - 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function contains(action : IAction) : Boolean
		{
			return null != _actions ? _actions.indexOf(action) >= 0 : false;
		}
			
		/**
		 * @inheritDoc
		 */
		public function find(id : String) : IAction
		{
			if(null == _actions) return null;
			
			var index : int = _actions.length;
			while(--index > -1)
			{
				const action : IAction = _actions[index];
				if(action.id == id) return action;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */	
		final override public function read(stream : IActionInputStream) : void
		{
			if(null == registry)
				ActionError.throwError(ActionError.INVALID_ACTION_CLASS_REGISTRY);
			
			const qname : String = stream.readUTF();
			const id : String = stream.readUTF();
			const numChildren : uint = stream.readUnsignedInt();
			const numProperties : uint = stream.readUnsignedInt();
			
			if(qname != qname || numProperties != 0)
				ActionError.throwError(ActionError.INVALID_INPUT_STREAM);
				
			this.id = id;
			
			for(var i : int = 0; i < numChildren; i++)
			{
				// create a new action from the registry
				const currentPosition : uint = stream.position;
				
				// Read in the qname
				const actionQName : String = stream.readUTF();
				
				// Reset the position
				stream.position = currentPosition;
				
				// We now have the action
				const action : IAction = _registry.create(actionQName);
				if(action is IActionSequence)
				{
					const sequence : IActionSequence = IActionSequence(action);
					sequence.registry = registry;
				}
				action.read(stream);
				
				add(action);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function write(stream : IActionOutputStream) : void
		{
			const total : int = _actions.length;
			
			stream.writeUTF(qname);
			stream.writeUTF(id);
			stream.writeUnsignedInt(total);
			stream.writeUnsignedInt(0);
			
			for(var i : int = 0; i < total; i++)
			{
				const action : IAction = _actions[i];
				action.write(stream);
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function describe(stream : IActionOutputStream) : void
		{
			const total : int = _actions.length;
			
			stream.writeUTF(qname);
			stream.writeUTF(id);
			stream.writeUnsignedInt(total);
			stream.writeUnsignedInt(0);
			
			for(var i : int = 0; i < total; i++)
			{
				const action : IAction = _actions[i];
				action.describe(stream);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get length() : int
		{
			return null != _actions ? _actions.length : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get registry() : IActionClassRegistry { return _registry; }
		public function set registry(value : IActionClassRegistry) : void 
		{
			if(null == value)
				throw new ArgumentError('Given value can not be null');
				
			_registry = value;
		}
				
		/**
		 * @private
		 */
		actions_namespace function get actions() : Vector.<IAction> { return _actions; }
	}
}
