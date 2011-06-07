package org.osflash.actions.stream
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionByteArrayOutputStream implements IActionOutputStream
	{
		
		internal static const UTF : int = 0;
		
		internal static const INT : int = 1;
		
		internal static const UINT : int = 2;
		
		internal static const FLOAT : int = 3;
		
		internal static const BOOLEAN : int = 4;
		
		/**
		 * @private
		 */
		private var _buffer : ByteArray;

		public function ActionByteArrayOutputStream()
		{
			_buffer = new ByteArray();
		}

		/**
		 * @inheritDoc
		 */
		public function writeUTF(value : String) : void
		{
			_buffer.writeByte(UTF);
			_buffer.writeUTF(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeInt(value : int) : void
		{
			_buffer.writeByte(INT);
			_buffer.writeInt(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeUnsignedInt(value : uint) : void
		{
			_buffer.writeByte(UINT);
			_buffer.writeUnsignedInt(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeFloat(value : Number) : void
		{
			_buffer.writeByte(FLOAT);
			_buffer.writeFloat(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeBoolean(value : Boolean) : void
		{
			_buffer.writeByte(BOOLEAN);
			_buffer.writeBoolean(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			_buffer.clear();
			_buffer.position = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get position() : uint
		{
			return _buffer.position;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set position(value : uint) : void
		{
			if(value < 0) throw new ArgumentError('Value can not be less than zero');
			_buffer.position = value;
		}
		
		/**
		 * @private
		 */
		internal function get buffer() : ByteArray
		{
			return _buffer;
		}
		
		/**
		 * Return the stream as a string
		 */
		public function toString() : String
		{
			const stream : IActionOutputStream = new ActionStringOutputStream();
			
			while(_buffer.position < _buffer.length)
			{
				switch(_buffer.readByte())
				{
					case UTF: stream.writeUTF(_buffer.readUTF()); break;
					case INT: stream.writeInt(_buffer.readInt()); break;
					case UINT: stream.writeUnsignedInt(_buffer.readUnsignedInt()); break;
					case FLOAT: stream.writeFloat(_buffer.readFloat()); break;
					case BOOLEAN: stream.writeBoolean(_buffer.readBoolean()); break;
					default: 
						throw new IllegalOperationError();
						break;
				}
			}
			
			stream.position = 0;
			
			return stream.toString();
		}
	}
}
