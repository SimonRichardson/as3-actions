package org.osflash.actions
{
	import org.osflash.stream.IStreamIO;
	import org.osflash.stream.IStreamOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IAction extends IActionTransactions, IStreamIO
	{
		
		function describe(stream : IStreamOutput) : void;
		
		function get id() : String;
		function set id(value : String) : void;
		
		function get qname() : String;
	}
}
