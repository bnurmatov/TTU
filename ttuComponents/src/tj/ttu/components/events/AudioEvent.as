////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 6, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	/**
	 * AudioEvent class 
	 */
	public class AudioEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const STOP_AUDIO:String 		= "stopAudio";
		public static const PAUSE_AUDIO:String 		= "pauseAudio";
		public static const PLAY_AUDIO:String 		= "playAudio";
		public static const RECORD_AUDIO:String 	= "recordAudio";
		public static const UPLOAD_AUDIO:String 	= "uploadAudio";
		public static const REMOVE_AUDIO:String 	= "removeAudio";
		
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
		 * AudioEvent 
		 */
		public function AudioEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
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
		override public function clone():Event
		{
			return new AudioEvent(type, data);
		}
		
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