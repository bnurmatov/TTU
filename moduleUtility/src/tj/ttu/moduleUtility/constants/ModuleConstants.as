////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.constants
{
	/**
	 * ModuleConstants class 
	 */
	public class ModuleConstants 
	{
		
		//----------------------------------------------------------------------
		//
		//  Class constants
		//
		//----------------------------------------------------------------------
		
		/**
		 *  The <code>ModuleConstants.STARTUP</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. Every module should 
		 *  create a StartupCommand which is registered used this constant.
		 */	
		public static const STARTUP						:String = "startup";
		
		/**
		 *  The <code>ModuleConstants.DISPOSE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. Every module should 
		 *  create a DisposeCommand which is registered used this constant.
		 */	
		public static const DISPOSE						:String = "dispose";
		
		/**
		 *  The <code>ModuleConstants.START_ACTIVITY</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module use this constants to start activity .
		 */		
		public static const START_ACTIVITY				:String	= "startActivity";
		
		/**
		 *  The <code>ModuleConstants.RESTART_ACTIVITY</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module use this constants to restart activity.
		 */			
		public static const RESTART_ACTIVITY			:String	= "restartActivity";
		
		/**
		 *  The <code>ModuleConstants.PAUSE_ACTIVITY</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module use this constants to pause activity. E.g. pause sounds, effects etc
		 */		
		public static const PAUSE_ACTIVITY				:String	= "pauseActivity";
		
		/**
		 *  The <code>ModuleConstants.ACTIVITY_SUSPEND</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module use this constants to suspend activity.
		 */		
		public static const ACTIVITY_SUSPEND			:String = "activitySuspend";
		
		/**
		 *  The <code>ModuleConstants.ACTIVITY_PROCEED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module use this constants to proceed activity after suspending.
		 */		
		public static const ACTIVITY_PROCEED			:String = "activityProceed";
		
		/**
		 *  The <code>ModuleConstants.READ_CONFIGURATION</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module should create a ReadConfigurationCommand 
		 *  which populates module proxy with the properties received from main application,
		 *  loads data, if needed.
		 */	
		public static const READ_CONFIGURATION			:String	= "readConfiguration";
		
		/**
		 *  The <code>ModuleConstants.TEST_CONFIGURATION</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module could create a TestConfiguratonCommand 
		 *  which populates module proxy with the default properties for testing without 
		 *  a wrapper, if needed.
		 */	
		public static const TEST_CONFIGURATION			:String	= "testConfiguration";
		
		/**
		 * The <code>ModuleConstants.UPDATE_PROGRESS</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification, which sends for update
		 * progress. 
		 */		
		public static const UPDATE_PROGRESS:String = "updateProgress";
		
		/**
		 *  The <code>ModuleConstants.SEND_MESSAGE_TO_SHELL</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification name send message to main application.
		 */	
		public static const SEND_MESSAGE_TO_SHELL		:String = "sendMessageToShell";
		
		/**
		 *  The <code>ModuleConstants.RESOURCE_CHANGE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about resource change.
		 */		
		public static const RESOURCE_CHANGE				:String	= "resourceChange";
		
		/**
		 *  The <code>ModuleConstants.LEARNING_PROGRESS</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about progress of learning.
		 */		
		public static const LEARNING_PROGRESS			:String	= "learningProgress";
		
		/**
		 *  The <code>ModuleConstants.ITEM_CHANGING</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about start changing current learning item.
		 */			
		public static const ITEM_CHANGING				:String	= "itemChanging";
		
		/**
		 *  The <code>ModuleConstants.ITEM_CHANGED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about changed current learning item.
		 */			
		public static const ITEM_CHANGED				:String	= "itemChanged";
		
		/**
		 *  The <code>ModuleConstants.KEY_PRESSED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about keyboard key pressed.
		 */
		public static const KEY_PRESSED					:String	= "keyPressed";

		/**
		 *  The <code>ModuleConstants.SOUND_PLAY</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about sound playback started.
		 */		
		public static const SOUND_PLAY					:String	= "soundPlay";
		
		/**
		 *  The <code>ModuleConstants.SOUND_EVENT</code> constant defines the value of the
		 *  <code>NAME</code> property for notification.
		 * expects SoundEvent in the message body
		 * @see com.transparent.events.SoundEvent
		 */
		public static const SOUND_EVENT					:String = "soundEvent";

		/**
		 *  The <code>ModuleConstants.PLAY_SOUND_EVENTS</code> constant defines the value of the
		 *  <code>NAME</code> property for notification.
		 * expects Array of the SoundEvent in the notification body
		 * @see com.transparent.events.SoundEvent
		 */
		
		public static const PLAY_SOUND_EVENTS			:String = "playSoundEvents";
		/**
		 *  The <code>ModuleConstants.SLOW_SOUND_PLAY</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every card module uses this notification to notify about slow sound playback started.
		 */		
		public static const SLOW_SOUND_PLAY					:String	= "slowSoundPlay";
		
		/**
		 *  The <code>ModuleConstants.SLOW_SOUND_COMPLETE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every card module uses this notification to notify about slow sound playing complete.
		 */		
		public static const SLOW_SOUND_COMPLETE					:String	= "slowSoundComplete";

		/**
		 *  The <code>ModuleConstants.SOUND_PAUSE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about sound paused.
		 */		
		public static const SOUND_PAUSE					:String	= "soundPause";

		/**
		 *  The <code>ModuleConstants.SOUND_VOLUME</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification for updating audio settings.
		 */	
		public static const SOUND_VOLUME				:String = "soundVolume";
		
		/**
		 *  The <code>ModuleConstants.SOUND_COMPLETE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about a sound has finished playing.
		 */		
		public static const SOUND_COMPLETE				:String	= "soundComplete";

		/**
		 *  The <code>ModuleConstants.SOUND_ERROR</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify about a sound error ocures.
		 */		
		public static const SOUND_ERROR					:String	= "soundError";
		
		/**
		 *  The <code>ModuleConstants.SOUND_MISSING</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  Every module uses this notification to notify that no sound found.
		 */		
		public static const SOUND_MISSING					:String	= "soundMissing";
		
		
		/**
		 *  The <code>ModuleConstants.LOAD_XML</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  A module uses this notification to load an xml file via LoadXMLCommand.
		 */		
		public static const LOAD_XML					:String	= "loadXml";
		
		/**
		 *  The <code>ModuleConstants.XML_LOADED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  A module uses this notification to parse into value object an xml sent by LoadXMLCommand.
		 * 
		 * TODO rename XML_LOADED -> PARSE_XML
		 */		
		public static const XML_LOADED					:String = "xmlLoaded";
		
		/**
		 *  The <code>ModuleConstants.START_GAME</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that file (usually XML) loading failed with an error 
		 *  (IO error, security error, etc).
		 */
		public static const FILE_LOAD_ERROR				:String = "fileLoadError";
		
				/**
		 *  The <code>ModuleConstants.PRELOAD_SOUND</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  A module uses this notification to load an sound file via PreLoadSoundCommand.
		 */		
		public static const PRELOAD_SOUND				:String = "preloadSound";
		
		/**
		 *  The <code>ModuleConstants.SOUND_PRELOAD_COMPLETE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  A module uses this notification to notifiy that the sound file has been loaded.
		 */		
		public static const SOUND_PRELOAD_COMPLETE 		:String	= "soundPreloadCompelte";
		
		/**
		 *  The <code>ModuleConstants.SOUND_THING_CHANGE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that the sound parameters were changed.
		 */		
		public static const SOUND_THING_CHANGE 			:String	= "soundThingChange";	
		
		/**
		 *  The <code>ModuleConstants.START_GAME</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notify that "Start Activity" Button on the start screen was pressed.
		 *  Dispatched, when user leaves start screen. (Hides StartScreen and shows MainView).
		 */
		public static const START_GAME					:String = "startGame";
		
		/**
		 *  The <code>ModuleConstants.PREVIOUS</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should return to previous step.
		 */
		public static const PREVIOUS					:String = "previous";
		
		/**
		 *  The <code>ModuleConstants.NEXT</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should go to next step.
		 */
		public static const NEXT						:String = "next";
		
		/**
		 *  The <code>ModuleConstants.SKIP</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should skip current step.
		 */
		public static const SKIP						:String = "skip";
		
		/**
		 *  The <code>ModuleConstants.FLIP</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should flip current card.
		 */
		public static const FLIP						:String = "flip";
		
		/**
		 *  The <code>ModuleConstants.AUTOFLIP</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should use 
		 *  autofliping in current learning process.
		 */
		public static const AUTOFLIP					:String = "autoflip";
		
		/**
		 *  The <code>ModuleConstants.CHECK</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that module should verifys 
		 *  an user answer.
		 */
		public static const CHECK						:String = "check";
		
		/**
		 *  The <code>ModuleConstants.ANSWER_INPUT</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that user input an answer.
		 */
		public static const ANSWER_INPUT				:String = "answerInput";
		
		/**
		 *  The <code>ModuleConstants.USER_ANSWER</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that user has answer to question.
		 */
		public static const USER_ANSWER					:String = "userAnswer";
		
		/**
		 *  The <code>ModuleConstants.DONE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that activity is done.
		 */
		public static const DONE						:String = "done";
		
		/**
		 *  The <code>ModuleConstants.SOUND_PLAY_CHANGED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that sound controller stops or begins play sound
		 */
		public static const SOUND_PLAY_CHANGED:String = "soundPlayChanged";
		
		/**
		 *  The <code>ModuleConstants.STORE_VOLUME_MESSAGE</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that sound message from unit player should be saved
		 */
		public static const STORE_VOLUME_MESSAGE:String = "storeVolumeMessage";
		
		
		/**
		 *  The <code>ModuleConstants.SHOW_ADJUSTMENT_WINDOW</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that microphone adjustment window
		 *  needs to show.
		 */
		public static const SHOW_ADJUSTMENT_WINDOW:String 	= "showAdjustmentWindow";
		
		/**
		 *  The <code>ModuleConstants.HIDE_ADJUSTMENT_WINDOW</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that microphone adjustment window
		 *  needs to hide.
		 */
		public static const HIDE_ADJUSTMENT_WINDOW:String 	= "hideAdjustmentWindow";
		
		/**
		 *  The <code>ModuleConstants.UPDATE_ADJUSTMENT_WINDOW</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy that microphone adjustment window
		 *  needs to update.
		 */
		public static const UPDATE_ADJUSTMENT_WINDOW:String = "updateAdjustmentWindow";
		
		/**
		 *  The <code>ModuleConstants.CONNECTION_RESTORED</code> constant defines the value of the 
		 *  <code>NAME</code> property for notification. 
		 *  This notification used to notifiy the activity that SCS is now available.
		 */
		public static const CONNECTION_RESTORED:String = "connectionRestored";
	}
}