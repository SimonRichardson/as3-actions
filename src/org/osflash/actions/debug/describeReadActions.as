package org.osflash.actions.debug
{
	import org.osflash.stream.IStreamInput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeReadActions(stream : IStreamInput) : XML
	{
		const result : XML = <actions/>;
		
		if(stream.readBoolean() == true)
			result.@current = stream.readUTF();
		
		const total : int = stream.readUnsignedInt();
		for(var i : int = 0; i < total; i++)
		{
			const qname : String = stream.readUTF();
			const id : String = stream.readUTF();
			const num : uint = stream.readUnsignedInt();
			
			const active : Boolean = result.@current == id;
			
			const node : XML = <action qname={qname} id={id} active={active}/>;
			
			const properties : XML = describeProperties(stream);
			node.appendChild(properties);
			
			if(num > 0)
				describeSubWriteActions(stream, node, num, active);
			
			result.appendChild(node);
		}
		
		return result;
	}
}
import org.osflash.stream.IStreamInput;
import org.osflash.stream.StreamTypes;

import flash.errors.IllegalOperationError;

function describeSubWriteActions(	stream : IStreamInput, 
									node : XML, 
									numNodes : uint, 
									active : Boolean
									) : void
{
	for(var i : int = 0; i < numNodes; i++)
	{
		const qname : String = stream.readUTF();
		const id : String = stream.readUTF();
		const subNum : uint = stream.readUnsignedInt();
		
		const subNode : XML = <action qname={qname} id={id} active={active}/>;
		
		const properties : XML = describeProperties(stream);
		subNode.appendChild(properties);
		
		if(subNum > 0)
			describeSubWriteActions(stream, subNode, subNum, active);
		
		node.appendChild(subNode);
	}
}

function describeProperties(stream : IStreamInput) : XML
{
	const result : XML = <properties/>;
	
	var index : int = stream.readUnsignedInt();
	while(--index > -1)
	{
		switch(stream.nextType)
		{
			case StreamTypes.UTF: 
				result.appendChild(<property value={stream.readUTF()}/>); 
				break;
			case StreamTypes.INT: 
				result.appendChild(<property value={stream.readInt()}/>); 
				break;
			case StreamTypes.UINT: 
				result.appendChild(<property value={stream.readUnsignedInt()}/>);
				break;
			case StreamTypes.FLOAT: 
				result.appendChild(<property value={stream.readFloat()}/>); 
				break;
			case StreamTypes.BOOLEAN: 
				result.appendChild(<property value={stream.readBoolean()}/>); 
				break;
			case StreamTypes.EOF:
				// Ignore EOF
				break;
			default: 
				throw new IllegalOperationError();
				break;
		}
	}
	
	return result;
}