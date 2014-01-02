////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 18, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.audio
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.ToggleButton;
	import spark.components.mediaClasses.VolumeBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TrackBaseEvent;
	
	import tj.ttu.base.view.components.videoplayer.LimitedScrubBar;
	
	/**
	 * TTUAudioPlayer class 
	 */
	public class TTUAudioPlayer extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var playPauseButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var scrubBar:LimitedScrubBar;
		
		[SkinPart(required="true")]
		public var volumeBar:VolumeBar;
		
		[SkinPart(required="true")]
		public var audioPlayer:AudioPlayer;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  limit
		//----------------------------------
		public var isLimited:Boolean;
		
		/**
		 *  @private
		 *  When someone is holding the scrubBar, we don't want to update the 
		 *  range's value--for this time period, we'll let the user completely 
		 *  control the range.
		 */
		private var scrubBarMouseCaptured:Boolean;
		
		/**
		 *  @private
		 *  We pause the video when dragging the thumb for the scrub bar.  This 
		 *  stores whether we were paused or not.
		 */
		private var wasPlayingBeforeSeeking:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * TTUAudioPlayer 
		 */
		public function TTUAudioPlayer()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var soundUrlChanged:Boolean;
		private var _soundUrl:String;
		
		public function get soundUrl():String
		{
			return _soundUrl;
		}
		
		public function set soundUrl(value:String):void
		{
			if( _soundUrl !== value)
			{
				_soundUrl = value;
				soundUrlChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
		//  volume
		//----------------------------------
		
		private var _volume:Number = 1;;
		
		[Inspectable(category="General", defaultValue="1.0", minValue="0.0", maxValue="1.0")]
		[Bindable(event="volumeChanged")]
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			if( _volume !== value)
			{
				_volume = value;
				
				if(audioPlayer)
					audioPlayer.volume = _volume;
				
				if(volumeBar)
					volumeBar.value = _volume;
			}
		}
		
		//----------------------------------
		//  muted
		//----------------------------------
		
		private var _muted:Boolean;
		
		[Inspectable(category="General", defaultValue="false")]
		[Bindable(event="mutedChanged")]
		public function get muted():Boolean
		{
			return _muted;
		}
		
		public function set muted(value:Boolean):void
		{
			if( _muted !== value)
			{
				_muted = value;
				
				if(audioPlayer)
					audioPlayer.muted = _muted;
				
				if(volumeBar)
					volumeBar.muted = _muted;
			}
		}
		
		//----------------------------------
		//  playing
		//----------------------------------
		
		[Inspectable(category="General")]
		[Bindable("audioPlayerStateChange")]
		
		/**
		 *  @copy spark.components.VideoDisplay#playing
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get playing():Boolean
		{
			if (audioPlayer)
				return audioPlayer.playing;
			else
				return false;
		}
		
		//----------------------------------
		//  currentPosition
		//----------------------------------
		private var _currentPosition:Number;
		
		[Inspectable(category="General", defaultValue="0.00", minValue="0.00")]
		[Bindable(event="currentPositionChange")]
		public function get currentPosition():Number
		{
			return _currentPosition;
		}
		
		public function set currentPosition(value:Number):void
		{
			if( _currentPosition !== value)
			{
				_currentPosition = value;
				dispatchEvent(new Event("currentPositionChange"));
			}
		}
		
		//----------------------------------
		//  soundDuration
		//----------------------------------
		private var soundDurationChanged:Boolean = false;
		private var _soundDuration:Number;
		
		[Inspectable(category="General", defaultValue="0.00", minValue="0.00")]
		[Bindable(event="soundDurationChange")]
		public function get soundDuration():Number
		{
			return _soundDuration;
		}
		
		public function set soundDuration(value:Number):void
		{
			if( _soundDuration !== value)
			{
				_soundDuration = value;
				soundDurationChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("soundDurationChange"));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(soundUrlChanged && audioPlayer)
			{
				audioPlayer.changeUrl = _soundUrl;
				soundUrlChanged = false;
			}
			if(soundDurationChanged && scrubBar)
			{
				scrubBar.isLimited = isLimited;
				scrubBar.minimum = 0;
				scrubBar.maximum = _soundDuration;
				soundDurationChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == playPauseButton)
			{
				playPauseButton.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			}
			else if(instance == audioPlayer)
			{
				audioPlayer.addEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.addEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
				audioPlayer.addEventListener(AudioPlayer.RAW_LOADED, onGetSoundDuration);
				audioPlayer.addEventListener(AudioPlayer.POSITION_CHANGED, onSoundPositionChanged);
			}
			else if (instance == volumeBar)
			{
				volumeBar.minimum = 0;
				volumeBar.maximum = 1;
				volumeBar.value = volume;
				volumeBar.muted = muted;
				
				volumeBar.addEventListener(Event.CHANGE, volumeBar_changeHandler);
				volumeBar.addEventListener(FlexEvent.MUTED_CHANGE, volumeBar_mutedChangeHandler);
			}
			else if (instance == scrubBar)
			{
				scrubBar.limit = -1;
				
				// add thumbPress and thumbRelease so we pause the video while dragging
				scrubBar.addEventListener(TrackBaseEvent.THUMB_PRESS, scrubBar_thumbPressHandler);
				scrubBar.addEventListener(TrackBaseEvent.THUMB_RELEASE, scrubBar_thumbReleaseHandler);
				
				// add change to actually seek() when the change is complete
				scrubBar.addEventListener(Event.CHANGE, scrubBar_changeHandler);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == playPauseButton)
			{
				playPauseButton.removeEventListener(MouseEvent.CLICK, onPlayPauseClick);
			}
			else if (instance == volumeBar)
			{
				volumeBar.removeEventListener(Event.CHANGE, volumeBar_changeHandler);
				volumeBar.removeEventListener(FlexEvent.MUTED_CHANGE, volumeBar_mutedChangeHandler);
			}
			else if (instance == scrubBar)
			{
				// add thumbPress and thumbRelease so we pause the video while dragging
				scrubBar.removeEventListener(TrackBaseEvent.THUMB_PRESS, scrubBar_thumbPressHandler);
				scrubBar.removeEventListener(TrackBaseEvent.THUMB_RELEASE, scrubBar_thumbReleaseHandler);
				
				// add change to actually seek() when the change is complete
				scrubBar.removeEventListener(Event.CHANGE, scrubBar_changeHandler);
			}
			else if(instance == audioPlayer)
			{
				audioPlayer.removeEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.removeEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
				audioPlayer.removeEventListener(AudioPlayer.RAW_LOADED, onGetSoundDuration);
				audioPlayer.removeEventListener(AudioPlayer.POSITION_CHANGED, onSoundPositionChanged);
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function resetComponent():void
		{
			soundUrl = null;
			soundDuration = 0;
			currentPosition = 0;
			volume = 1;
			muted = false;
			stop();
		}
		/**
		 *  Formats a time value, specified in seconds, into a String that 
		 *  gets used for <code>currentTime</code> and the <code>duration</code>.
		 * 
		 *  @param value Value in seconds of the time to format.
		 * 
		 *  @return Formatted time value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function formatTimeValue(value:Number):String
		{
			// default format: hours:minutes:seconds
			value = Math.round(value);
			
			var hours:uint = Math.floor(value/3600) % 24;
			var minutes:uint = Math.floor(value/60) % 60;
			var seconds:uint = value % 60;
			
			var result:String = "";
			if (hours != 0)
				result = hours + ":";
			
			if (result && minutes < 10)
				result += "0" + minutes + ":";
			else
				result += minutes + ":";
			
			if (seconds < 10)
				result += "0" + seconds;
			else
				result += seconds;
			
			return result;
		}
		
		/**
		 *  @public
		 */
		
		public function pause():void
		{
			audioPlayer.pause();
		}
		
		/**
		 *  @copy spark.components.VideoDisplay#play()
		 * 
		 *  @throws TypeError if the skin hasn't been loaded up yet
		 *                    and there's no videoDisplay.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function play(resume:Boolean = false):void
		{
			audioPlayer.play(resume);
		}
		
		/**
		 *  @copy spark.components.VideoDisplay#seek()
		 * 
		 *  @throws TypeError if the skin hasn't been loaded up yet
		 *                    and there's no videoDisplay.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function seek(time:Number):void
		{
			currentPosition = time;
			audioPlayer.position = time;
			play(true);
		}
		
		/**
		 *  @copy spark.components.VideoDisplay#stop()
		 * 
		 *  @throws TypeError if the skin hasn't been loaded up yet
		 *                    and there's no videoDisplay.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function stop():void
		{
			audioPlayer.stop();
			playPauseButton.selected = false;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onSoundPositionChanged(event:Event):void
		{
			currentPosition = audioPlayer.position;
			if(scrubBar)
				scrubBar.value = _currentPosition;
		}
		
		protected function onGetSoundDuration(event:Event):void
		{
			soundDuration = audioPlayer.duration;
		}
		
		protected function onPlayPauseClick(event:MouseEvent):void
		{
			if(!playPauseButton.selected)
				pause();
			else
			{
				if( audioPlayer.position != 0)
					audioPlayer.play( true );
				else
					audioPlayer.play();
			}
		}
		
		/**
		 * @private
		 * Used for handling IOError events.
		 */
		protected function onPlaySoundError(event:IOErrorEvent):void
		{
			playPauseButton.selected = false;
			dispatchEvent(event);
		}
		
		/**
		 * 
		 * Handler for <code>Event.SOUND_COMPLETE</code> event dispatched by player.
		 * 
		 * @param event The <code>Event</code> event dispatched by player.
		 * 
		 */		
		protected function onPlaySoundComplete(event:Event):void
		{
			playPauseButton.selected = false;
		}
		
		/**
		 *  @private
		 */
		private function volumeBar_changeHandler(event:Event):void
		{
			if (volume != volumeBar.value)
				volume = volumeBar.value;
		}
		
		/**
		 *  @private
		 */
		private function volumeBar_mutedChangeHandler(event:FlexEvent):void
		{
			if (muted != volumeBar.muted)
				muted = volumeBar.muted;
		}
		
		/**
		 *  @private
		 */
		private function scrubBar_thumbPressHandler(event:TrackBaseEvent):void
		{
			scrubBarMouseCaptured = true;
			if (playing)
			{
				pause();
				wasPlayingBeforeSeeking = true;
			}
		}
		
		/**
		 *  @private
		 */
		private function scrubBar_thumbReleaseHandler(event:TrackBaseEvent):void
		{
			scrubBarMouseCaptured = false;
			if (wasPlayingBeforeSeeking)
			{
				play(true);
				wasPlayingBeforeSeeking = false;
			}
		}
		
		/**
		 *  @private
		 */
		private function scrubBar_changeHandler(event:Event):void
		{
			seek(scrubBar.value);
		}
		
	}
}