package org.osflash.actions
{
	import flash.utils.getQualifiedClassName;
	import org.osflash.actions.stream.IActionInputStream;
	import org.osflash.actions.stream.IActionOutputStream;
	import org.osflash.actions.uid.UID;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class Action implements IAction
	{
		
		/**
		 * @private
		 */
		private var _id : String;
		
		/**
		 * @private
		 */
		private var _qname : String;
		
		/**
		 * @private
		 */
		private var _numStreamProperties : uint;
		
		public function Action(numStreamProperties : uint = 0)
		{
			_numStreamProperties = numStreamProperties;
			
			_id = UID.create();
			_qname = getQualifiedClassName(this);
		}

		/**
		 * @inheritDoc
		 */
		public function commit() : void
		{
			throw new Error('Override Action commit method.');
		}

		/**
		 * @inheritDoc
		 */
		public function revert() : void
		{
			throw new Error('Override Action revert method.');
		}
		
		/**
		 * @inheritDoc
		 */
		public function read(stream : IActionInputStream) : void
		{
			const qname : String = stream.readUTF();
			const id : String = stream.readUTF();
			const numChildren : uint = stream.readUnsignedInt();
			const numProperties : uint = stream.readUnsignedInt();
			
			if(numChildren != 0 || qname != _qname || numProperties != _numStreamProperties)
				ActionError.throwError(ActionError.INVALID_INPUT_STREAM);
			
			_id = id;
		}
		
		/**
		 * @inheritDoc
		 */
		public function write(stream : IActionOutputStream) : void
		{
			stream.writeUTF(_qname);
			stream.writeUTF(id);
			stream.writeUnsignedInt(0);
			stream.writeUnsignedInt(_numStreamProperties);
		}
		
		/**
		 * @inheritDoc
		 */
		public function describe(stream : IActionOutputStream) : void
		{
			stream.writeUTF(_qname);
			stream.writeUTF(id);
			stream.writeUnsignedInt(0);
			stream.writeUnsignedInt(_numStreamProperties);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id() : String { return _id; }
		public function set id(value : String) : void { _id = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get qname() : String { return _qname; }
	}
}
