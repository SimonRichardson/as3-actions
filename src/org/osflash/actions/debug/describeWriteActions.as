package org.osflash.actions.debug
{
	import org.osflash.actions.stream.ActionByteArrayInputStream;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeWriteActions(stream : IActionOutputStream) : String
	{
		const input : IActionInputStream = new ActionByteArrayInputStream(stream);
		
		
	}
}
