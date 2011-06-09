package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionFloatType extends Action
	{
		
		private var _value : Number;

		public function ActionFloatType()
		{
			super(1);
			
			_value = 0;
		}
		
		/**
		 * Initialiser for the ActionFloatType
		 * 
		 * @param value Number
		 */
		public function init(value : Number) : void
		{
			if(isNaN(value)) throw new ArgumentError('Given value can not be NaN');
				
			_value = value;
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
			
			_value = stream.readFloat();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function write(stream : IStreamOutput) : void
		{
			super.write(stream);
			
			stream.writeFloat(_value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IStreamOutput) : void
		{
			super.describe(stream);
			
			stream.writeFloat(_value);
		}
	}
}
