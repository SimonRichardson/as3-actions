package org.osflash.actions
{
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
		
		public function Action()
		{
			_id = UID.create();
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
		public function get id() : String { return _id; }
		public function set id(value : String) : void { _id = value; }
	}
}
