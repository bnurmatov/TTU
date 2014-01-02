////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.TextEvent;
	
	/**
	 * Common event used to dispatch <code>ISoundRecorder</code> status changes.
	 */
	public class SoundRecorderEvent extends TextEvent
	{
		/**
		 * Record process started.
		 */ 
		public static const RECORD_START:String = "recordStart";
		
		/**
		 * Record was stopped, but there is no data in response.
		 */
		public static const RECORD_STOP:String = "recordStop";
		
		/**
		 * Record successfully completed. Sound data is available in <code>soundData</code> property.
		 */
		public static const RECORD_FINISHED:String = "recordFinished";
		
		/**
		 * Error occured.
		 */ 
		public static const RECORD_ERROR:String = "error";

		/**
		 * Timeout.
		 */ 
		public static const TIMEOUT:String = "timeout";

		/**
		 * Error occured.
		 */ 
		public static const MICROPHONE_ERROR:String = "microphoneNotConnection";
		
		/**
		 * Error occured during connection to server.
		 */
		public static const CONNECTION_ERROR:String = "connectionError";

		/**
		 * Successfully connection to server.
		 */
		public static const CONNECTION_SUCCESS:String = "connectionSuccess";
		
		/**
		 * Constructs a SoundRecorderEvent object.
		 */ 
		public function SoundRecorderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, text:String="")
		{
			super(type, bubbles, cancelable, text);
		}
	
	}
}