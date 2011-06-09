package org.osflash.actions
{
	import org.osflash.signals.ISignal;
	import org.osflash.stream.IStreamIO;
	import org.osflash.stream.IStreamOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionManager extends IStreamIO
	{
		
		function register(actionClass : Class) : void;
		
		function unregister(actionClass : Class) : void;
		
		function commit(action : IAction) : void;
		
		function revert(action : IAction) : void;
		
		function dispatch(action : IAction) : void;
		
		function undo() : Boolean;
		
		function redo() : Boolean;
		
		function clear() : void;
				
		function describe(stream : IStreamOutput) : void;
		
		function get invalidated() : Boolean;
		
		function get length() : int;
		
		function get current() : IAction;
		
		function get commitSignal() : ISignal;
		
		function get changeSignal() : ISignal;
		
		function get revertSignal() : ISignal;
		
		function get orphanedSignal() : ISignal;
		
		function toString() : String;
	}
}
