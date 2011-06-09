package org.osflash.actions.debug
{
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;
	import org.osflash.stream.types.bytearray.StreamByteArrayInput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeWriteActions(stream : IStreamOutput) : XML
	{
		const input : IStreamInput = new StreamByteArrayInput(stream);
		return describeReadActions(input);
	}
}
