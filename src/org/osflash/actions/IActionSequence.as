package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionSequence extends IAction
	{
		
		function add(action : IAction) : IAction;
		
		function addAt(action : IAction, index : int) : IAction;
		
		function getAt(index : int) : IAction;
		
		function getIndex(action : IAction) : int;
		
		function remove(action : IAction) : IAction;
		
		function removeAt(index : int) : IAction;
		
		function removeAll() : void;
		
		function contains(action : IAction) : Boolean;
		
		function find(id : String) : IAction;
		
		function get length() : int;
		
		function get registry() : IActionClassRegistry;
		function set registry(value : IActionClassRegistry) : void;
	}
}
