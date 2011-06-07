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
	public function describeActions(manager : IActionManager) : String
	{
		const output : IActionOutputStream = new ActionByteArrayOutputStream();
		manager.describe(output);
		
		const input : IActionInputStream = new ActionByteArrayInputStream(output);
		
		var current : String = "";
		var result : String = "";
		
		if(input.readBoolean() == true)
			current = input.readUTF();
		
		const total : int = input.readUnsignedInt();
		for(var i : int = 0; i < total; i++)
		{
			const num : int = input.readUnsignedInt();
			const item : String = input.readUTF();
			
			result += '[' + ((item == current) ? '>' : ' ') + '] Action (id="' + item + '")';
			result += '\n';  
						
			for(var j : int = 0; j < num; j++)
			{
				// TODO : more recursion.
				const subnum : int = input.readUnsignedInt();
				if(subnum > 0)
					throw new Error('Missing implementation');
				
				const subItem : String = input.readUTF();
				
				result += '\t[' + ((item == current) ? '>' : ' '); 
				result += '] Action (id="' + subItem + '")';
				result += '\n';
			}
		}
		
		return result;
	}
}