package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionManager
	{
		
		function register(actionClass : Class) : void;
		
		function unregister(actionClass : Class) : void;
		
		function commit(action : IAction) : void;
		
		function revert(action : IAction) : void;
		
		function undo() : Boolean;
		
		function redo() : Boolean;
		
		function clear() : void;
		
		function get invalidated() : Boolean;
		
		function toString() : String;
	}
}
