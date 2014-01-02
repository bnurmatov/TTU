////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	/**
	 * AudioSettingEvent class 
	 */
	public class AudioSettingEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *  The <code>AudioSettingEvent.VOLUME_CHANGE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>VOLUME_CHANGE</code> event,
		 *  which indicates that volume of player has changed
		 */
		public static const VOLUME_CHANGE			:String = "volumeChange";
		
		/**
		 *  The <code>AudioSettingEvent.TEMPO_CHANGE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>TEMPO_CHANGE</code> event,
		 *  which indicates that tempo of player has changed.
		 */
		public static const TEMPO_CHANGE			:String = "tempoChange";
		/**
		 *  The <code>AudioSettingEvent.MUTED_CHANGE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>MUTED_CHANGE</code> event,
		 *  which indicates that muted property of player has changed.
		 */
		public static const MUTED_CHANGE			:String = "mutedChange";
		/**
		 *  The <code>AudioSettingEvent.TEMPO_ENABLED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>TEMPO_ENABLED</code> event,
		 *  which indicates that tempoEnabled property of player has changed.
		 */
		public static const TEMPO_ENABLED		:String = "tempoEnabled";
		
		/**
		 *  The <code>AudioSettingEvent.AUDIO_SETTING_CHANGE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>TEMPO_ENABLED</code> event,
		 *  which indicates thatone of 4 properties have changed.
		 */
		public static const AUDIO_SETTING_CHANGE		:String = "audioSettingChange";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Storage for volume property
		 */
		public var volume:Number;
		/**
		 * Storage for tempo property
		 */
		public var tempo:Number;
		/**
		 * Storage for muted property
		 */
		public var muted:Boolean;
		/**
		 * Storage for tempoEnabled property
		 */
		public var tempoEnabled:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AudioSettingEvent 
		 */
		public function AudioSettingEvent(type:String, 
										  volume:Number = 0, 
										  tempo:Number =1, 
										  muted:Boolean = false, 
										  tempoEnabled:Boolean = false, 
										  bubbles:Boolean=false, 
										  cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.volume 		= volume;
			this.tempo 			= tempo;
			this.muted 			= muted;
			this.tempoEnabled 	= tempoEnabled;
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
			return new AudioSettingEvent(type, volume, tempo, muted, tempoEnabled, bubbles);
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