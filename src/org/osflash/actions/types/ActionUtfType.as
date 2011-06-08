package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionUtfType extends Action
	{

		private var _value : String;

		public function ActionUtfType()
		{
			super(1);
			
			_value = "";
		}

		/**
		 * Initialiser for the ActionUtfType
		 * 
		 * @param value String
		 */
		public function init(value : String) : void
		{
			if(null == value) throw new ArgumentError('Given value can not be null');
			
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
		final override public function read(stream : IActionInputStream) : void
		{
			super.read(stream);
			
			_value = stream.readUTF();
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function write(stream : IActionOutputStream) : void
		{
			super.write(stream);
			
			stream.writeUTF(_value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IActionOutputStream) : void
		{
			super.describe(stream);
			
			stream.writeUTF(_value);
		}
	}
}
