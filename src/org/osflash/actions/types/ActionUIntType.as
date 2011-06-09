package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionUIntType extends Action
	{
		
		private var _value : int;

		public function ActionUIntType()
		{
			super(1);
			
			_value = 0;
		}
		
		/**
		 * Initialiser for the ActionUIntType
		 * 
		 * @param value uint
		 */
		public function init(value : uint) : void
		{
			if(isNaN(value)) throw new ArgumentError('Given value can not be NaN');
			if(value < 0) throw new ArgumentError('Given value can not be less then 0');
			
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
			
			_value = stream.readUnsignedInt();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function write(stream : IStreamOutput) : void
		{
			super.write(stream);
			
			stream.writeUnsignedInt(_value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IStreamOutput) : void
		{
			super.describe(stream);
			
			stream.writeUnsignedInt(_value);
		}
	}
}
