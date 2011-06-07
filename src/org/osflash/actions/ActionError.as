package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public final class ActionError
	{

		public static const NO_ACTIONS_ADDED_IN_SEQUENCE : int = 0x01;

		public static const ACTION_ALREADY_EXISTS : int = 0x02;

		public static const ACTION_DOES_NOT_EXIST : int = 0x03;

		public static const REMOVE_ACTION_LENGTH_ZERO : int = 0x04;

		public static const REMOVE_ACTION_MISMATCH : int = 0x05;

		public function ActionError(message : String)
		{
			super(message);
		}
		
		/**
		 * Get the type of error as a string representation using the type of error.
		 * 
		 * @param type of ActionError
		 * @return String representation of the error.
		 */
		public static function getType(type : int) : String
		{
			switch(type)
			{
				case NO_ACTIONS_ADDED_IN_SEQUENCE:
					return 'noActionsAddedInSequence';
				case ACTION_ALREADY_EXISTS:
					return 'actionAlreadyExists';
				case ACTION_DOES_NOT_EXIST:
					return 'actionDoesNotExist';
				case REMOVE_ACTION_LENGTH_ZERO:
					return 'removeActionLengthZero';
				case REMOVE_ACTION_MISMATCH:
					return 'removeActionMismatch';
				default:
					throw new ArgumentError('Given argument is Unknown.');  
			}
		}
		
		/**
		 * Throws an ActionError for the corresponding type. This method does all the error 
		 * handling, including throwing.
		 * 
		 * @param type is Type of ActionError.
		 */
		public static function throwError(type : int) : void
		{
			switch(type)
			{
				case NO_ACTIONS_ADDED_IN_SEQUENCE:
					throw new ActionError('No actions added in sequence');
					break;
				case ACTION_ALREADY_EXISTS:
					throw new ActionError('Action already exists in the current IActionSequence');
					break;
				case ACTION_DOES_NOT_EXIST:
					throw new ActionError('Action does not exist in the current IActionSequence');
					break;
				case REMOVE_ACTION_LENGTH_ZERO:
					throw new ActionError('Error type to remove a node, where nodes length ' + 
																						'is zero');
					break;
				case REMOVE_ACTION_MISMATCH:
					throw new ActionError('Error trying to remove a action, that does not ' +
														 			'correspond to given action');
					break;
				default:
					throw new ArgumentError('Given argument is Unknown');
			}
		}
	}
}
