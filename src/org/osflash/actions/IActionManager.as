package org.osflash.actions
{
	import org.osflash.actions.stream.IActionIOStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import org.osflash.signals.ISignal;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface IActionManager extends IActionIOStream
	{
		
		function register(actionClass : Class) : void;
		
		function unregister(actionClass : Class) : void;
		
		function commit(action : IAction) : void;
		
		function revert(action : IAction) : void;
		
		function dispatch(action : IAction) : void;
		
		function undo() : Boolean;
		
		function redo() : Boolean;
		
		function clear() : void;
				
		function describe(stream : IActionOutputStream) : void;
		
		function get invalidated() : Boolean;
		
		function get length() : int;
		
		function get current() : IAction;
		
		function get commitSignal() : ISignal;
		
		function get changeSignal() : ISignal;
		
		function get revertSignal() : ISignal;
		
		function toString() : String;
	}
}
