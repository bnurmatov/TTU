////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.sound
{
	
	/**
	 *  This class is a enumeration of 
	 * <code>AdjustmentMicrophoneWindow</code> states.
	 * 
	 * @see AdjustmentMicrophoneWindow
	 */
	public class AdjustmentMicrophoneWindowState
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
		// constant NORMAL_STATE
		//----------------------------------
		
		/**
		 * Constant define the default normal state.
		 */
		public static const NORMAL_STATE:String = "normalState";
		
		//----------------------------------
		// constant TEST_MIC_STATE
		//----------------------------------
		
		/**
		 * Constant define the state, that provide microphone adjustment 
		 * using AutomationGainControl.
		 */
		public static const TEST_MIC_STATE:String = "testMicState";
		
		//----------------------------------
		// constant CORRECT_FEEDBACK_MIC_STATE
		//----------------------------------
		
		/**
		 * Constant define the state, who reports about successfuly
		 * microphone adjustment .
		 */
		public static const CORRECT_FEEDBACK_MIC_STATE:String = "correctFeedbackMicState";
		
		//----------------------------------
		// constant INCORRECT_FEEDBACK_MIC_STATE
		//----------------------------------
		
		/**
		 * Constant define the state, who reports, 
		 * that microphone sensitivity level is not set.
		 */
		public static const INCORRECT_FEEDBACK_MIC_STATE:String = "incorrectFeedbackMicState";
		
		//----------------------------------
		// constant NO_DETECTED_MIC_STATE
		//----------------------------------
		
		/**
		 * Constant define the state, who reports, 
		 * that no detected microphone in system.
		 */
		public static const NO_DETECTED_MIC_STATE:String = "noDetectedMicState";
		
		//----------------------------------
		// constant DETECTED_MIC_STATE
		//----------------------------------
		
		/**
		 * Constant define the state, who reports, 
		 * that microphone detected in system.
		 */
		public static const DETECTED_MIC_STATE:String = "detectedMicState";
	}
}