////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.audio
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.components.events.AudioEvent;
	
	[Event(name="stopAudio", type="tj.ttu.components.events.AudioEvent")]
	[Event(name="pauseAudio", type="tj.ttu.components.events.AudioEvent")]
	[Event(name="playAudio", type="tj.ttu.components.events.AudioEvent")]
	[Event(name="recordAudio", type="tj.ttu.components.events.AudioEvent")]
	[Event(name="uploadAudio", type="tj.ttu.components.events.AudioEvent")]
	[Event(name="removeAudio", type="tj.ttu.components.events.AudioEvent")]
	
	/**
	 * AudioBar class 
	 */
	public class ManageAudioBar extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * uploadButton
		 */
		[SkinPart(required="true")]
		public var uploadAudioButton:Button;
		/**
		 * playButton
		 */
		[SkinPart(required="false")]
		public var recordAudioButton:Button;
		
		
		/**
		 * playPauseButton
		 */
		[SkinPart(required="false")]
		public var playPauseAudioButton:ToggleButton;
		
		/**
		 * stopButton
		 */
		[SkinPart(required="false")]
		public var stopAudioButton:Button;
		
		/**
		 * deleteButton
		 */
		[SkinPart(required="true")]
		public var deleteAudioButton:Button;
		
		
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
		/**
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AudioBar 
		 */
		public function ManageAudioBar()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _hasAudioUrl:Boolean;

		[Bindable(event="hasAudioUrlChange")]
		public function get hasAudioUrl():Boolean
		{
			return _hasAudioUrl;
		}

		public function set hasAudioUrl(value:Boolean):void
		{
			if( _hasAudioUrl !== value)
			{
				_hasAudioUrl = value;
				dispatchEvent(new Event("hasAudioUrlChange"));
			}
		}

		private var _playPauseSelected:Boolean;
		
		[Bindable(event="playPauseSelectedChange")]
		public function get playPauseSelected():Boolean
		{
			return _playPauseSelected;
		}
		
		public function set playPauseSelected(value:Boolean):void
		{
			if( _playPauseSelected !== value)
			{
				_playPauseSelected = value;
				dispatchEvent(new Event("playPauseSelectedChange"));
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == deleteAudioButton)
				deleteAudioButton.addEventListener(MouseEvent.CLICK, onDeleteAudioButtonClick);
			if(instance == uploadAudioButton)
				uploadAudioButton.addEventListener(MouseEvent.CLICK, onUploadAudioButtonClick);
			if(instance == recordAudioButton)
				recordAudioButton.addEventListener(MouseEvent.CLICK, onRecordAudioButtonClick);
			if(instance == playPauseAudioButton)
				playPauseAudioButton.addEventListener(MouseEvent.CLICK, onPlayPauseAudioButtonClick);
			if(instance == stopAudioButton)
				stopAudioButton.addEventListener(MouseEvent.CLICK, onStopAudioButtonClick);
		}
		
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == deleteAudioButton)
				deleteAudioButton.removeEventListener(MouseEvent.CLICK, onDeleteAudioButtonClick);
			if(instance == uploadAudioButton)
				uploadAudioButton.removeEventListener(MouseEvent.CLICK, onUploadAudioButtonClick);
			if(instance == recordAudioButton)
				recordAudioButton.removeEventListener(MouseEvent.CLICK, onRecordAudioButtonClick);
			if(instance == playPauseAudioButton)
				playPauseAudioButton.removeEventListener(MouseEvent.CLICK, onPlayPauseAudioButtonClick);
			if(instance == stopAudioButton)
				stopAudioButton.removeEventListener(MouseEvent.CLICK, onStopAudioButtonClick);
			
			super.partRemoved(partName, instance);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		private function onStopAudioButtonClick(event:MouseEvent):void
		{
			playPauseSelected = false;
			dispatchEvent(new AudioEvent(AudioEvent.STOP_AUDIO));		
		}
		
		private function onPlayPauseAudioButtonClick(event:MouseEvent):void
		{
			_playPauseSelected = playPauseAudioButton.selected;
			var eventType:String = _playPauseSelected ? AudioEvent.PLAY_AUDIO : AudioEvent.PAUSE_AUDIO;
			dispatchEvent(new AudioEvent(eventType));		
		}
		
		private function onRecordAudioButtonClick(event:MouseEvent):void
		{
			playPauseSelected = false;
			dispatchEvent(new AudioEvent(AudioEvent.RECORD_AUDIO));		
		}
		
		private function onUploadAudioButtonClick(event:MouseEvent):void
		{
			playPauseSelected = false;
			dispatchEvent(new AudioEvent(AudioEvent.UPLOAD_AUDIO));			
		}
		
		private function onDeleteAudioButtonClick(event:MouseEvent):void
		{
			playPauseSelected = false;
			dispatchEvent(new AudioEvent(AudioEvent.REMOVE_AUDIO));			
		}
		
	}
}