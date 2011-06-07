package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionClassRegistry
	{
		
		function add(actionClass : Class) : void;
		
		function remove(actionClass : Class) : void;
		
		function contains(actionClass : Class) : Boolean;
		
		function containsAction(action : IAction) : Boolean
	}
}
