package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.stream.IStreamInput;
	import org.osflash.stream.IStreamOutput;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionIntType extends Action
	{
		
		private var _value : int;

		public function ActionIntType()
		{
			super(1);
			
			_value = 0;
		}
		
		/**
		 * Initialiser for the ActionIntType
		 * 
		 * @param value int
		 */
		public function init(value : int) : void
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
			
			_value = stream.readInt();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function write(stream : IStreamOutput) : void
		{
			super.write(stream);
			
			stream.writeInt(_value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IStreamOutput) : void
		{
			super.describe(stream);
			
			stream.writeInt(_value);
		}

	}
}
