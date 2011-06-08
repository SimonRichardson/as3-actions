package org.osflash.actions.stream
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionIOStream
	{
		
		function read(stream : IActionInputStream) : void;
		
		function write(stream : IActionOutputStream) : void;
	}
}
