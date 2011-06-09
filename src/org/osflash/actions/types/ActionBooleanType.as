package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionBooleanType extends Action
	{
		
		private var _value : Boolean;

		public function ActionBooleanType()
		{
			super(1);
			
			_value = false;
		}
		
		/**
		 * Initialiser for the ActionBooleanType
		 * 
		 * @param value Boolean
		 */
		public function init(value : Boolean) : void
		{
			_value = value ? true : false;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function commit() : void
		{
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function revert() : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function read(stream : IStreamInput) : void
		{
			super.read(stream);
			
			_value = stream.readBoolean();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function write(stream : IStreamOutput) : void
		{
			super.write(stream);
			
			stream.writeBoolean(_value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IStreamOutput) : void
		{
			super.describe(stream);
			
			stream.writeBoolean(_value);
		}
	}
}
