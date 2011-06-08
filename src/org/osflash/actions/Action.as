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
		
		private var _qname : String;
		
		public function Action()
		{
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
			const numChildren : uint = stream.readUnsignedInt();
			const qname : String = stream.readUTF();
			const id : String = stream.readUTF();
			
			if(numChildren != 0 || qname != _qname)
				ActionError.throwError(ActionError.INVALID_INPUT_STREAM);
			
			_id = id;
		}
		
		/**
		 * @inheritDoc
		 */
		public function write(stream : IActionOutputStream) : void
		{
			stream.writeUnsignedInt(0);
			stream.writeUTF(_qname);
			stream.writeUTF(id);
		}
		
		/**
		 * @inheritDoc
		 */
		public function describe(stream : IActionOutputStream) : void
		{
			stream.writeUnsignedInt(0);
			stream.writeUTF(id);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id() : String { return _id; }
		public function set id(value : String) : void { _id = value; }
	}
}
