package org.osflash.actions.stream
{
	import flash.utils.ByteArray;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionByteArrayInputStream implements IActionInputStream
	{

		/**
		 * @private
		 */
		private var _buffer : ByteArray;

		public function ActionByteArrayInputStream(stream : IActionOutputStream)
		{
			if (!(stream is ActionByteArrayOutputStream))
				throw new Error('Missing Implementation');

			const output : ActionByteArrayOutputStream = ActionByteArrayOutputStream(stream);
			output.position = 0;
			
			_buffer = output.buffer;
			_buffer.position = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function readInt() : int
		{
			if(_buffer.readByte() != ActionByteArrayOutputStream.INT)
				ActionStreamError.throwError(ActionStreamError.INVALID_INT);
				
			return _buffer.readInt();
		}

		/**
		 * @inheritDoc
		 */
		public function readUnsignedInt() : uint
		{
			if(_buffer.readByte() != ActionByteArrayOutputStream.UINT)
				ActionStreamError.throwError(ActionStreamError.INVALID_UINT);
				
			return _buffer.readUnsignedInt();
		}

		/**
		 * @inheritDoc
		 */
		public function readFloat() : Number
		{
			if(_buffer.readByte() != ActionByteArrayOutputStream.FLOAT)
				ActionStreamError.throwError(ActionStreamError.INVALID_FLOAT);
				
			return _buffer.readFloat();
		}

		/**
		 * @inheritDoc
		 */
		public function readUTF() : String
		{
			if(_buffer.readByte() != ActionByteArrayOutputStream.UTF)
				ActionStreamError.throwError(ActionStreamError.INVALID_UTF);
				
			return _buffer.readUTF();
		}

		/**
		 * @inheritDoc
		 */
		public function readBoolean() : Boolean
		{
			if(_buffer.readByte() != ActionByteArrayOutputStream.BOOLEAN)
				ActionStreamError.throwError(ActionStreamError.INVALID_BOOLEAN);
				
			return _buffer.readBoolean();
		}

		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			_buffer.clear();
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
			_buffer.position = value;
		}

		public function toString() : String
		{
			return "";
		}
	}
}
