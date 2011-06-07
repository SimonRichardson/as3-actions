package org.osflash.actions
{
	import org.osflash.actions.stream.IActionInputOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionManager extends IActionInputOutput
	{
		
		function registerAction(actionClass : Class) : void;
		
		function unregisterAction(actionClass : Class) : void; 
		
		function undo() : Boolean;
		
		function redo() : Boolean;
		
		function clear() : void;
		
		function toString() : String;
	}
}
