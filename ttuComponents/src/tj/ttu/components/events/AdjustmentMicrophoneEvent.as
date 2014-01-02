////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	
	/**
	 *  This class descride a names for all events 
	 *  wich using in adjustment procedure.
	 */
	public class AdjustmentMicrophoneEvent extends Event
	{
		//----------------------------------------------------------------------
		//
		//	Static constants
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Public static constants
		//
		//--------------------------------------------------
		
		//----------------------------------
		// constant PROCEED
		//----------------------------------
		
		/**
		 * This constant define a name for a proceed adjustment microphone event.
		 */
		public static const PROCEED:String = "proceed";
		
		//----------------------------------
		// constant DETECT
		//----------------------------------
		
		/**
		 * This constant define a name for a detection microphone event.
		 */
		public static const DETECT:String = "detect";
		
		//----------------------------------
		// constant ADJUSTMENT
		//----------------------------------
		
		/**
		 * This constant define a name for a adjustment microphone event.
		 */
		public static const ADJUSTMENT:String = "adjustment";
		
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */ 
		public function AdjustmentMicrophoneEvent(type:String)
		{
			super(type, true, false);
		}
	}
}