package org.osflash.actions.debug
{
	import org.osflash.actions.IActionManager;
	import org.osflash.actions.stream.ActionByteArrayInputStream;
	import org.osflash.actions.stream.ActionByteArrayOutputStream;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeActions(manager : IActionManager) : XML
	{
		const output : IActionOutputStream = new ActionByteArrayOutputStream();
		manager.describe(output);
		
		const input : IActionInputStream = new ActionByteArrayInputStream(output);
		
		const result : XML = <actions/>;
		
		if(input.readBoolean() == true)
			result.@current = input.readUTF();
		
		const total : int = input.readUnsignedInt();
		for(var i : int = 0; i < total; i++)
		{
			const num : int = input.readUnsignedInt();
			const item : String = input.readUTF();
			const itemActive : Boolean = result.@current == item;
			
			const node : XML = <action id={item} active={itemActive}/>;
			
			if(num > 0)
				describeSubActions(input, node, num, result.@current == item);
			
			result.appendChild(node);
		}
		
		return result;
	}
}

import org.osflash.actions.stream.IActionInputStream;

function describeSubActions(	stream : IActionInputStream, 
								node : XML, 
								numNodes : uint, 
								active : Boolean
								) : void
{
	for(var j : int = 0; j < numNodes; j++)
	{
		const subNum : int = stream.readUnsignedInt();
		const subItem : String = stream.readUTF();
				
		const subNode : XML = <action id={subItem} active={active}/>;
				
		if(subNum > 0)
			describeSubActions(stream, node, subNum, active);
		
		node.appendChild(subNode);
	}
}