package org.osflash.actions.stream
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class ActionStringInputStream implements IActionInputStream
	{

		/**
		 * @private
		 */
		private var _buffer : String;
		
		/**
		 * @private
		 */
		private var _position : uint;
		
		public function ActionStringInputStream(stream : IActionOutputStream)
		{
			if (!(stream is ActionStringOutputStream))
				throw new Error('Missing Implementation');

			const output : ActionStringOutputStream = ActionStringOutputStream(stream);
			output.position = 0;
			
			_buffer = output.buffer;
			_position = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function readInt() : int
		{
			if(readByte() != ActionStreamTypes.INT)
				ActionStreamError.throwError(ActionStreamError.INVALID_INT);
			
			const length : int = readPacketLength();
			return parseInt(_buffer.substr(_position, length));
		}

		/**
		 * @inheritDoc
		 */
		public function readUnsignedInt() : uint
		{
			if(readByte() != ActionStreamTypes.UINT)
				ActionStreamError.throwError(ActionStreamError.INVALID_UINT);
				
			const length : int = readPacketLength();
			return parseInt(_buffer.substr(_position, length));
		}

		/**
		 * @inheritDoc
		 */
		public function readFloat() : Number
		{
			if(readByte() != ActionStreamTypes.FLOAT)
				ActionStreamError.throwError(ActionStreamError.INVALID_FLOAT);
				
			const length : int = readPacketLength();
			return parseFloat(_buffer.substr(_position, length));
		}

		/**
		 * @inheritDoc
		 */
		public function readUTF() : String
		{
			if(readByte() != ActionStreamTypes.UTF)
				ActionStreamError.throwError(ActionStreamError.INVALID_UTF);
				
			const length : int = readPacketLength();
			return _buffer.substr(_position, length);
		}

		/**
		 * @inheritDoc
		 */
		public function readBoolean() : Boolean
		{
			if(readByte() != ActionStreamTypes.BOOLEAN)
				ActionStreamError.throwError(ActionStreamError.INVALID_BOOLEAN);
				
			const length : int = readPacketLength();
			return _buffer.substr(_position, length) == "true";
		}

		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			_buffer = "";
		}
		
		/**
		 * @private
		 */
		private function readByte() : int
		{
			const byte : int = parseInt(_buffer.substr(_position, 1));
			_position++;
			
			return byte;
		}
		
		/**
		 * @private
		 */
		private function readPacketLength() : int
		{
			var packet : String = "";
			
			const total : int = _buffer.length;
			for(var i : int = _position; i < total; i++)
			{
				if(_buffer.charCodeAt(_position) == 58)
					break;
				
				packet += _buffer.charAt(_position);
				
				_position++;
			}
			
			return parseInt(packet);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextType() : int
		{
			if(_position >= _buffer.length)
				return ActionStreamTypes.EOF;
			
			return parseInt(_buffer.substr(_position, 1));
		}

		/**
		 * @inheritDoc
		 */
		public function get position() : uint { return _position; }
		public function set position(value : uint) : void { _position = value; }

		public function toString() : String
		{
			return _buffer;
		}
	}
}
