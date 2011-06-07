package org.osflash.actions.stream
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionInputOutput
	{
		
		function read(stream : IActionInputStream) : void;
		
		function write(steam : IActionOutputStream) : void;
	}
}
