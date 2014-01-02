////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 7, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.utils.messages
{
	/**
	 * ModuleMessage class 
	 */
	public class ModuleMessage extends ModulePipeMessage
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ModuleMessage 
		 */
		public function ModuleMessage(action:String, contentType:String, content:Object = null)
		{
			super(action, contentType, content);
			this.content = content;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _content:Object;

		public function get content():Object
		{
			return _content;
		}

		public function set content(value:Object):void
		{
			_content = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		
	}
}