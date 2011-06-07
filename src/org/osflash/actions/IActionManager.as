package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionManager extends IActionTransactions
	{
		
		function undo() : Boolean;
		
		function redo() : Boolean;
		
		function clear() : void;
		
		function toString() : String;
	}
}
