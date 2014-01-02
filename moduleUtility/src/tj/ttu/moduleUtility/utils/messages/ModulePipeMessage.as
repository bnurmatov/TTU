////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.utils.messages
{
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	
	import tj.ttu.moduleUtility.view.interfaces.IModulePipeMessage;
	
	/**
	 * ModulePipeMessage class 
	 */
	public class ModulePipeMessage extends Message implements IModulePipeMessage
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
		 * ModulePipeMessage 
		 */
		public function ModulePipeMessage(action:String, contentType:String, body:Object=null, priority:int=5)
		{
			var header:Object = 
				{
					"action": action, 
					"contentType" : contentType
				};
			
			super(action, header, body, priority);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get action():String
		{
			return header.action;
		}
		
		public function get contentType():String
		{
			return header.contentType;
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