package org.osflash.actions.debug
{
	import org.osflash.actions.IActionManager;
	import org.osflash.actions.stream.ActionByteArrayOutputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public function describeActions(manager : IActionManager) : String
	{
		const stream : IActionOutputStream = new ActionByteArrayOutputStream();
		manager.describe(stream);
		
		const actions : XML = describeWriteActions(stream);
		return describeSubActions(actions.children().(name() == "action"), actions.@current, -1);
	}
}

function describeSubActions(children : XMLList, id : String, indent : int) : String
{
	indent++;
	
	var result : String = "";
	
	for each(var action : XML in children)
	{
		const qname : String = action.@qname;
		const qnameParts : Array = qname.split('::');
		const name : String = qnameParts[qnameParts.length - 1];
			
		result += padIndent(indent);
		result += '[' + ((action.@id == id) ? '>' : ' ') + ']';
		result += ' ' + name + ' (id="' + action.@id + '")\n';
			
		const subChildren : XMLList = action.children().(name() == "action");
		if(subChildren.length() > 0)
		{
			result += describeSubActions(subChildren, id, indent);
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