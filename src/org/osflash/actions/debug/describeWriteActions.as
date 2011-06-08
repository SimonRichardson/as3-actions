package org.osflash.actions.debug
{
	import org.osflash.actions.stream.ActionByteArrayInputStream;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeWriteActions(stream : IActionOutputStream) : XML
	{
		const input : IActionInputStream = new ActionByteArrayInputStream(stream);
		
		const result : XML = <actions/>;
		
		if(input.readBoolean() == true)
			result.@current = input.readUTF();
		
		const total : int = input.readUnsignedInt();
		for(var i : int = 0; i < total; i++)
		{
			const num : int = input.readUnsignedInt();
			const qname : String = input.readUTF();
			const id : String = input.readUTF();
			const active : Boolean = result.@current == id;
			
			const node : XML = <action qname={qname} id={id} active={active}/>;
			
			if(num > 0)
				describeSubWriteActions(input, node, num, active);
			
			result.appendChild(node);
		}
		
		return result;
	}
}

import org.osflash.actions.stream.IActionInputStream;

function describeSubWriteActions(	input : IActionInputStream, 
									node : XML, 
									numNodes : uint, 
									active : Boolean
									) : void
{
	for(var i : int = 0; i < numNodes; i++)
	{
		const subNum : int = input.readUnsignedInt();
		const qname : String = input.readUTF();
		const id : String = input.readUTF();
				
		const subNode : XML = <action qname={qname} id={id} active={active}/>;
				
		if(subNum > 0)
			describeSubWriteActions(input, node, subNum, active);
		
		node.appendChild(subNode);
	}
}