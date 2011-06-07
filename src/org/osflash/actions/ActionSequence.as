package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionSequence implements IActionSequence, IAction
	{
		
		/**
		 * @private
		 */
		private var _id : String;
		
		/**
		 * @private
		 */
		private var _actions : Vector.<IAction>;

		public function ActionSequence()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function commit() : void
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
		public function revert() : void
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
			return addAt(action, numActions);
		}

		/**
		 * @inheritDoc
		 */
		public function addAt(action : IAction, index : int) : IAction
		{
			if(index < 0) throw new RangeError('Given index is out of range (index=' + index + ')');
			if(index > numActions) throw new RangeError('Given index is outside of dense length');
			
			// Create the children if it was set to null.			
			if(null == _actions) _actions = new Vector.<IAction>();
			
			// If it already exists, throw an error to prevent re-adding.
			if(contains(action)) ActionError.throwError(ActionError.ACTION_ALREADY_EXISTS);
			
			if(index == 0)
				_actions.unshift(action);
			else if(index == numActions)
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
			if(index < 0 || index >= numActions) throw new RangeError('Given index is out of ' + 
									'range (index=' + index + ', numActions=' + numActions + ')');
			return _actions[index];
		}

		/**
		 * @inheritDoc
		 */
		public function getIndex(action : IAction) : int
		{
			if(numActions == 0 || !contains(action)) 
				ActionError.throwError(ActionError.ACTION_DOES_NOT_EXIST);
			
			return _actions.indexOf(action);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(action : IAction) : IAction
		{
			return removeAt(action, numActions - 1);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAt(action : IAction, index : int) : IAction
		{
			if(null == _actions) return null;
			
			if(index < 0 || index >= numActions) throw new RangeError('Given index is out of ' + 
									'range (index=' + index + ', numChildren=' + numActions + ')');
			
			const actions : Vector.<IAction> = _actions.splice(index, 1);
			if(actions.length == 0) ActionError.throwError(ActionError.REMOVE_ACTION_LENGTH_ZERO);
			
			const node : IAction = actions[0];
			if(node != action) 
				ActionError.throwError(ActionError.REMOVE_ACTION_MISMATCH);
			
			if(numActions == 0)
				_actions = null;
			
			return node;
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
		public function get numActions() : int
		{
			return null != _actions ? _actions.length : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id() : String { return _id; }
		public function set id(value : String) : void { _id = value; }
		
		/**
		 * @private
		 */
		actions_namespace function get actions() : Vector.<IAction> { return _actions; }
	}
}
