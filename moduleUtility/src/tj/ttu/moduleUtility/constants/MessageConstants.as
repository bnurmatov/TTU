////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.constants
{
	/**
	 * MessageConstants class 
	 */
	public final class MessageConstants
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const ALL:String = "all";
		
		//We do not need this audio player has volume and volume is handled by unit Player
		public static const SOUND_VOLUME:String = "soundVolume";
		
		//Why learning list ?
		public static const KEY_PRESSED:String = "keyPressed";
		
		public static const RESTART_MODULE:String = "restartModule";
		
		public static const PAUSE_MODULE:String = "pauseModule";
		
		/**
		 * Works as unpause after activity is suspended as a consequence of
		 * <code>ACTIVITY_SUSPEND</code> notification.
		 */
		public static const MODULE_DONE:String = "moduleDone";
		
		public static const MODULE_PROCEED:String = "moduleProceed";
		
		public static const PREVIEW_COMPLETED:String = "previewCompleted";
		
		public static const MODULE_STARTED:String = "moduleStarted";
		
		public static const MODULE_COMPLETED:String = "moduleCompleted";
		
		public static const MODULE_INCOMPLETE:String = "moduleIncomplete";
		
		public static const MODULE_SUSPEND:String = "moduleSuspend";
		
		public static const MODULE_ERROR:String = "moduleError";
		
		public static const SOUND_PLAY:String = "soundPlay";
		
		public static const CORRECT_SOUND:String = "correctSound";
		
		public static const INCORRECT_SOUND:String = "incorrectSound";
		
		//We do not these two. Again audio player will handle this 
		public static const SOUND_STOP:String = "soundStop";
		
		public static const SOUND_PAUSE:String = "soundPause";
		
		
		public static const DONE_MODULE:String = "doneModule";
		
		/**
		 * Dispatched when external link shall be opened in new window.
		 */
		public static const SHOW_BROWSER_POPUP:String = "showBrowserPopup";
		
		/**
		 *  The <code>ModuleConstants.DATA_ERROR</code> constant defines the value of the
		 *  <code>NAME</code> property for notification.
		 *  A module uses this notification to send data load error message.
		 */
		public static const FILE_LOAD_ERROR:String = "fileLoadError";
		
		/**
		 *  The <code>MessageConstants.MODULE_VERSION</code> constant defines the value of the
		 *  <code>contentType</code> property for activity message.
		 *  A module uses this message to send its version to the wrapper application.
		 */
		public static const MODULE_VERSION:String = "moduleVersion";
		
		/**
		 * The <code>MessageConstants.SHOW_ACTIVITY_HELP</code> constant 
		 * opens hlp file cor current activity via player 
		 * activity message.
		 */
		public static const SHOW_MODULE_HELP:String	= "showModuleHelp";
		
		/**
		 * The <code>MessageConstants.HIDE_MODULE</code> used 
		 * no notify that an activity should be hidden from lesson 
		 */
		public static const HIDE_MODULE		:String = "hideModule";
		/**
		 * The <code>MessageConstants.ASSESSMENT_QUESTIONS</code> used 
		 * no notify that an activity should be hidden from lesson 
		 */
		public static const ASSESSMENT_QUESTIONS		:String = "assessmentQuestions";
		
	}
}