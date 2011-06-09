package org.osflash.actions.debug
{
	import org.osflash.actions.IActionManager;
	import org.osflash.stream.IStreamOutput;
	import org.osflash.stream.types.bytearray.StreamByteArrayOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeActions(manager : IActionManager) : String
	{
		const stream : IStreamOutput = new StreamByteArrayOutput();
		manager.describe(stream);
		
		const actions : XML = describeWriteActions(stream);
		return describeSubActions(actions.children().(name() == "action"), actions.@current, -1);
	}
}

function describeSubActions(	children : XMLList, 
								id : String, 
								indent : int, 
								active : Boolean = false
								) : String
{
	indent++;
	
	var result : String = "";
	
	for each(var action : XML in children)
	{
		const qname : String = action.@qname;
		const qnameParts : Array = qname.split('::');
		const name : String = qnameParts[qnameParts.length - 1];
		
		const status : Boolean = indent <= 0 ? (action.@id == id) : active;
		
		result += padIndent(indent);
		result += '[' + (status ? '>' : ' ') + ']';
		result += ' ' + name + ' (id="' + action.@id + '")\n';
			
		const subChildren : XMLList = action.children().(name() == "action");
		if(subChildren.length() > 0)
		{
			result += describeSubActions(subChildren, id, indent, status);
		}
	}
	
	return result;
}

function padIndent(level : int) : String
{
	var result : String = "";
	while(--level > -1)
	{
		result += '\t';
	}
	return result;
}