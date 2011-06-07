package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IAction extends IActionTransactions
	{
		
		function get id() : String;
		function set id(value : String) : void;
	}
}
