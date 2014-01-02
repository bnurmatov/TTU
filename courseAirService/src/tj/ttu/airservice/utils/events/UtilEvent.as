////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 18, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils.events
{
	import flash.events.Event;
	
	/**
	 * UtilEvent class 
	 */
	public class UtilEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *  Triggered when .b4x creation completes
		 */
		public static const B4X_CREATION_COMPLETE:String = "b4xCreationComplete";
		
		/**
		 *  Triggered when installer creation completes
		 */
		public static const INSTALLER_CREATION_COMPLETE:String = "installerCreationComplete";
		
		/**
		 *  Triggered when dvd content creation completes
		 */
		public static const DVD_CONTENT_CREATION_COMPLETE:String = "dvdContentCreationComplete";
		
		/**
		 *  Triggered when .b4x creation completes
		 */
		public static const IMAGES_LOADED_COMPLETE:String = "imagesLoadedComplete";
		
		/**
		 *  Triggered when .b4x creation completes
		 */
		public static const UTIL_ERROR:String = "utilError";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Data sent in the event
		 */
		public var data:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * UtilEvent 
		 */
		public function UtilEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
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