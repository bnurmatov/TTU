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
	 *  wich using in sound recording process.
	 */
	public class NewSoundRecorderEvent extends Event
	{
		//----------------------------------------------------------------------
		//
		//	Static constants
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Public constants
		//
		//--------------------------------------------------
		
		//----------------------------------
		// constant START_BUFFER_FULL
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after start background buffer is full.
		 */
		public static const START_BUFFER_FULL:String = "startBufferFull";
		
		//----------------------------------
		// constant END_BUFFER_FULL
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after end background buffer is full.
		 */
		public static const END_BUFFER_FULL:String = "endBufferFull";
		
		//----------------------------------
		// constant START_RECORD
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after start recording.
		 */
		public static const START_RECORD:String = "startRecord";
		
		//----------------------------------
		// constant PAUSE_RECORD
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after pause recording.
		 */
		public static const PAUSE_RECORD:String = "pauseRecord";
		
		//----------------------------------
		// constant STOP_RECORD
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after stop recording.
		 */
		public static const STOP_RECORD:String = "stopRecord";
		
		//----------------------------------
		// constant FINISH_RECORD
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after finish recording.
		 */
		public static const FINISH_RECORD:String = "finishRecord";
		
		//----------------------------------
		// constant ABORT_RECORD
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after abort recording.
		 */
		public static const ABORT_RECORD:String = "abortRecord";
		
		//----------------------------------
		// constant ACTIVITY_LEVEL_CHANGE
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after change
		 * <code>activityLevel</code> of <code>microphone</code>.
		 */
		public static const ACTIVITY_LEVEL_CHANGE:String = "activityLevelChange";
		
		//----------------------------------
		// constant SILENCE_DETECTION
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after
		 * <code>microphone</code> detected the silence.
		 */
		public static const SILENCE_DETECTION:String = "silenceDetection";
		
		//----------------------------------
		// constant VOICE_DETECTION
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after
		 * <code>microphone</code> detected the voice.
		 */
		public static const VOICE_DETECTION:String = "voiceDetection";
		
		//----------------------------------
		// constant MICROPHONE_UNMUTED
		//----------------------------------
		
		/**
		 * Constant define name for event, wich dispatched after
		 * <code>microphone</code> is unmuted.
		 */
		public static const MICROPHONE_UNMUTED:String = "microphoneUnmuted";
		
		/**
		 * Error occured.
		 */ 
		public static const MICROPHONE_ERROR:String = "microphoneNotConnection";
		
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */ 
		public function NewSoundRecorderEvent(type:String)
		{
			super(type, true, false);
		}
	}
}