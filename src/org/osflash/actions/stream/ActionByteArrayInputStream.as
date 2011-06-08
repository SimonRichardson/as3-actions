package org.osflash.actions.stream
{
	import flash.errors.IllegalOperationError;
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
			if(_buffer.readByte() != ActionStreamTypes.INT)
				ActionStreamError.throwError(ActionStreamError.INVALID_INT);
				
			return _buffer.readInt();
		}

		/**
		 * @inheritDoc
		 */
		public function readUnsignedInt() : uint
		{
			if(_buffer.readByte() != ActionStreamTypes.UINT)
				ActionStreamError.throwError(ActionStreamError.INVALID_UINT);
				
			return _buffer.readUnsignedInt();
		}

		/**
		 * @inheritDoc
		 */
		public function readFloat() : Number
		{
			if(_buffer.readByte() != ActionStreamTypes.FLOAT)
				ActionStreamError.throwError(ActionStreamError.INVALID_FLOAT);
				
			return _buffer.readFloat();
		}

		/**
		 * @inheritDoc
		 */
		public function readUTF() : String
		{
			if(_buffer.readByte() != ActionStreamTypes.UTF)
				ActionStreamError.throwError(ActionStreamError.INVALID_UTF);
				
			return _buffer.readUTF();
		}

		/**
		 * @inheritDoc
		 */
		public function readBoolean() : Boolean
		{
			if(_buffer.readByte() != ActionStreamTypes.BOOLEAN)
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
		public function get nextType() : int
		{
			const pos : uint = _buffer.position;
			if(pos >= _buffer.length)
				return ActionStreamTypes.EOF;
			
			const type : int = _buffer.readByte();
			_buffer.position = pos;
			
			return type;
		}

		/**
		 * @inheritDoc
		 */
		public function get position() : uint { return _buffer.position; }
		public function set position(value : uint) : void { _buffer.position = value; }

		public function toString() : String
		{
			const stream : IActionOutputStream = new ActionStringOutputStream();
			
			while(_buffer.position < _buffer.length)
			{
				switch(_buffer.readByte())
				{
					case ActionStreamTypes.UTF: 
						stream.writeUTF(_buffer.readUTF()); 
						break;
					case ActionStreamTypes.INT: 
						stream.writeInt(_buffer.readInt()); 
						break;
					case ActionStreamTypes.UINT: 
						stream.writeUnsignedInt(_buffer.readUnsignedInt()); 
						break;
					case ActionStreamTypes.FLOAT: 
						stream.writeFloat(_buffer.readFloat()); 
						break;
					case ActionStreamTypes.BOOLEAN: 
						stream.writeBoolean(_buffer.readBoolean()); 
						break;
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
