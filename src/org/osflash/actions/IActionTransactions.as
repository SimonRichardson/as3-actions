package org.osflash.actions
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionTransactions
	{
		
		function commit() : void;
		
		function revert() : void;
	}
}
