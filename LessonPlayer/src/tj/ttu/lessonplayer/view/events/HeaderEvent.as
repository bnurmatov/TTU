////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.events
{
	import flash.events.Event;
	
	/**
	 * HeaderEvent class 
	 */
	public class HeaderEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const GET_HELP:String = 'getHelp';
		public static const RELOAD_MODULE:String = 'reloadModule';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var data:Object;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * HeaderEvent 
		 */
		public function HeaderEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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