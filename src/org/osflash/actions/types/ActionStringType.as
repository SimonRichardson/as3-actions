package org.osflash.actions.types
{
	import org.osflash.actions.Action;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionStringType extends Action
	{

		private var _string : String;

		public function ActionStringType()
		{
			super(1);
			
			_string = "";
		}

		/**
		 * Initialiser for the ActionStringType
		 * 
		 * @param value String
		 */
		public function init(value : String) : void
		{
			if(null == value) throw new ArgumentError('Given value can not be null');
			
			_string = value;
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
			
			_string = stream.readUTF();
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function write(stream : IActionOutputStream) : void
		{
			super.write(stream);
			
			stream.writeUTF(_string);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function describe(stream : IActionOutputStream) : void
		{
			super.describe(stream);
			
			stream.writeUTF(_string);
		}
	}
}
