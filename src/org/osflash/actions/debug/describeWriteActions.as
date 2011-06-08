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
			const num : uint = input.readUnsignedInt();
			const qname : String = input.readUTF();
			const id : String = input.readUTF();
			
			const active : Boolean = result.@current == id;
			
			const node : XML = <action qname={qname} id={id} active={active}/>;
			
			const properties : XML = describeProperties(input);
			node.appendChild(properties);
			
			if(num > 0)
				describeSubWriteActions(input, node, num, active);
			
			result.appendChild(node);
		}
		
		return result;
	}
}
import org.osflash.actions.stream.ActionStreamTypes;
import org.osflash.actions.stream.IActionInputStream;

import flash.errors.IllegalOperationError;

function describeSubWriteActions(	input : IActionInputStream, 
									node : XML, 
									numNodes : uint, 
									active : Boolean
									) : void
{
	for(var i : int = 0; i < numNodes; i++)
	{
		const subNum : uint = input.readUnsignedInt();
		const qname : String = input.readUTF();
		const id : String = input.readUTF();
		
		const subNode : XML = <action qname={qname} id={id} active={active}/>;
		
		// TODO : workout how to retrieve properties from this, as we'll store more and more.
		const properties : XML = describeProperties(input);
		subNode.appendChild(properties);
				
		if(subNum > 0)
			describeSubWriteActions(input, node, subNum, active);
		
		node.appendChild(subNode);
	}
}

function describeProperties(input : IActionInputStream) : XML
{
	const result : XML = <properties/>;
	
	var index : int = input.readUnsignedInt();
	while(--index > -1)
	{
		switch(input.nextType)
		{
			case ActionStreamTypes.UTF: 
				result.appendChild(<property value={input.readUTF()}/>); 
				break;
			case ActionStreamTypes.INT: 
				result.appendChild(<property value={input.readInt()}/>); 
				break;
			case ActionStreamTypes.UINT: 
				result.appendChild(<property value={input.readUnsignedInt()}/>);
				break;
			case ActionStreamTypes.FLOAT: 
				result.appendChild(<property value={input.readFloat()}/>); 
				break;
			case ActionStreamTypes.BOOLEAN: 
				result.appendChild(<property value={input.readBoolean()}/>); 
				break;
			case ActionStreamTypes.EOF:
				// Ignore EOF
				break;
			default: 
				throw new IllegalOperationError();
				break;
		}
	}
	
	return result;
}