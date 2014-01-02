////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.popup.sound
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.TextArea;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.components.components.audio.AudioPlayer;
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.components.sound.AdjustmentMicrophoneWindow;
	import tj.ttu.components.components.sound.FlashSoundRecorder;
	import tj.ttu.components.components.sound.SoundPanel;
	import tj.ttu.components.events.SoundRecorderEvent;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.components.skins.sound.RecordingIndicatorSkin;
	import tj.ttu.components.skins.sound.VolumeLevelSkin;
	import tj.ttu.components.skins.sound.adjustmentMicrophoneWindow.AdjustmentMicrophoneWindowSkin;
	import tj.ttu.components.utils.WAVConverter;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.skins.popup.sound.SoundLoaderWindowSkin;
	import tj.ttu.coursecreatorbase.view.skins.popup.sound.SoundLoaderWindowWithTranscriptSkin;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	[SkinState("normal")]
	
	[SkinState("noSound")]
	/**
	 * SoundLoaderWindow class 
	 */
	public class SoundRecorderWindow extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * A skin part that defines the micConfigButton of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var micConfigButton:Button;
		
		/**
		 * 
		 * A skin part that defines the buttonSave of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var buttonSave:Button;
		
		/**
		 * 
		 * A skin part that defines the buttonCancel of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var buttonCancel:Button;
		
		
		/**
		 * 
		 * A skin part that defines the buttonPlayPause of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var existingSoundPanel:SoundPanel;
		
		/**
		 * 
		 * A skin part that defines the recordSoundPanel of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var recordSoundPanel:SoundPanel;
		
		/**
		 *  A skin part that defines the label. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var soundTextControl:RichEditableText;
		
		/**
		 *  A skin part that defines the record label indicator. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var textRecording:RecordingIndicatorSkin;
		
		/**
		 *  A skin part that defines the record actIndicator. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var actIndicator:VolumeLevelSkin;
		
		/**
		 *  A skin part that defines the record button. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="true")]
		public var recordButton:ToggleButton;
		
		/**
		 *  A skin part that defines the languageLabel. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var languageLabel:Label;
		
		/**
		 *  A skin part that defines the playPauseButton. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var playPauseButton:ToggleButton;
		
		/**
		 *  A skin part that defines the recordedPlayPauseButton. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var recordedPlayPauseButton:ToggleButton;
		
		/**
		 *  A skin part that defines the transcriptTextArea. 
		 *  
		 *  @productversion Flex 4
		 */
		[SkinPart(required="false")]
		public var transcriptTextArea:TextArea;
		
		/**
		 * Storage for <code>buttonClose</code> property
		 */		
		[SkinPart(required="false")]
		public var buttonClose:Button;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * 	The sampling rate, in Hz, for the data in the WAV file.
		 * 
		 * 	@default 44100
		 */
		public static const SAMPLING_RATE:int = 44100;
		
		/**
		 * 	The audio sample bit rate.  Has to be set to 8, 16, 24, or 32.
		 * 
		 * 	@default 16
		 */		
		public static const BIT_RATE:int = 16;
		
		/**
		 * 	The number of audio channels in the WAV file.
		 * 
		 * 	@default 2
		 */	
		public static const CHANNELS:int = 2;
		
		/**
		 * 	The  WAV file during.
		 * 
		 * 	@default 60
		 */
		public static const ONE_MINUTE:int = 60;
		
		
		/**
		 * 	The  WAV file header size.
		 * 
		 * 	@default 40
		 */
		public static const WAV_HEADER_SIZE:int = 40;
		
		/**
		 * 	two MB
		 */
		public static const TWO_MB:int = 2000000;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var audioPlayer:AudioPlayer;
		private var target:IVisualElement;
		
		/**
		 * sound recorder component
		 */ 
		private var soundRecord:FlashSoundRecorder;
		
		/**
		 * timer for indicate record level
		 */ 
		private var indicatorTimer:Timer;
		
		private var timerMaxRecordLength:Timer;
		
		private var permited:Boolean = false;
		
		/**
		 * @private
		 */
		
		private var confirmationPopup:ConfirmationPopup;
		
		private var popup:PopupWindow;
		
		private var microphoneSetingsView:AdjustmentMicrophoneWindow;
		
		
		/**
		 * flag error sound recorder
		 */ 
		private var flagError:Boolean = false;
		
		private var gain:uint = 70;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SoundLoaderWindow 
		 */
		public function SoundRecorderWindow()
		{
			super();
			audioPlayer = new AudioPlayer();
			audioPlayer.addEventListener( Event.SOUND_COMPLETE, soundPlayCompleteHandler );
			audioPlayer.addEventListener( AudioPlayer.RAW_LOADED, onRawLoadedHandler );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//-----------------------------------------
		// currentSound
		//-----------------------------------------		
		
		public function get fileSize():int
		{
			return (( SAMPLING_RATE * BIT_RATE * CHANNELS * ONE_MINUTE ) / 8) + WAV_HEADER_SIZE ;// File Size (Bytes) = (sampling rate) × (bit depth) × (number of channels) × (seconds) / 8
		}
		//-----------------------------------------
		// currentSound
		//-----------------------------------------		
		private var _isMicrophoneConfigured:Boolean = false;
		
		public function get isMicrophoneConfigured():Boolean
		{
			return _isMicrophoneConfigured;
		}
		
		public function set isMicrophoneConfigured(value:Boolean):void
		{
			if(_isMicrophoneConfigured != value)
			{
				_isMicrophoneConfigured = value;
				dispatchEvent( new CourseEvent(CourseEvent.MICROPHONE_CONFIGURED, _isMicrophoneConfigured));
			}
		}
		
		
		//-----------------------------------------
		// currentSound
		//-----------------------------------------		
		private var soundSourceChanged:Boolean = false;
		
		private var _currentSound:String = 'no sound';
		
		/**
		 * 
		 * Internal storage for imageSource.
		 * 
		 */
		public function get currentSound():String
		{
			return _currentSound;
		}
		
		
		/**
		 * 
		 * @private
		 * 
		 */		
		public function set currentSound(value:String):void
		{
			if(_currentSound != value)
			{
				_currentSound = value;
				soundSourceChanged 	= true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// sound Text
		//-----------------------------------------		
		private var soundTextChanged:Boolean = false;
		
		private var _soundText:String;
		
		/**
		 * 
		 * Internal storage for imageSource.
		 * 
		 */
		public function get soundText():String
		{
			return _soundText;
		}
		
		
		/**
		 * 
		 * @private
		 * 
		 */		
		public function set soundText(value:String):void
		{
			if(_soundText != value)
			{
				_soundText = value;
				soundTextChanged 	= true;
				invalidateProperties();
			}
		}
		
		
		//-----------------------------------------
		// mediaVO
		//-----------------------------------------
		private var mediaVOChanged:Boolean = false;
		private var _mediaVO:MediaVO;
		
		[Bindable(event="mediaVOChanged")]
		public function get mediaVO():MediaVO
		{
			return _mediaVO;
		}
		
		public function set mediaVO(value:MediaVO):void
		{
			if( _mediaVO !== value)
			{
				_mediaVO = value;
				dispatchEvent(new Event("mediaVOChanged"));
			}
		}
		
		//-----------------------------------------
		// sndData
		//-----------------------------------------
		private var sndDataChanged:Boolean = false;
		protected var _sndData:ByteArray;
		
		/**
		 *  @private
		 */ 
		public function set sndData(value:ByteArray):void
		{
			if(_sndData != value)
			{
				_sndData = value;
				sndDataChanged = true;
				invalidateProperties();
			}
		}
		public function get sndData():ByteArray
		{
			return _sndData;
		}
		
		//-----------------------------------------
		// userSndData
		//-----------------------------------------
		private var userSndDataChanged:Boolean = false;
		private var userSndDataEnabledChanged:Boolean = false;
		protected var _userSndData:ByteArray;
		
		/**
		 *  @private
		 */ 
		public function set userSndData(value:ByteArray):void
		{
			if(_userSndData != value)
			{
				_userSndData = value;
				userSndDataChanged = true;
				userSndDataEnabledChanged = true;
				invalidateProperties();
			}
		}
		public function get userSndData():ByteArray
		{
			return _userSndData;
		}
		
		//-----------------------------------------
		// userRecordedSound
		//-----------------------------------------
		private var _userRecordedSound:ByteArray;
		
		public function get userRecordedSound():ByteArray
		{
			return _userRecordedSound;
		}
		
		public function set userRecordedSound(value:ByteArray):void
		{
			_userRecordedSound = value;
		}
		
		//-----------------------------------------
		// isNoSound
		//-----------------------------------------
		private var _isNoSound:Boolean = false;
		
		public function get isNoSound():Boolean
		{
			return _isNoSound;
		}
		
		public function set isNoSound(value:Boolean):void
		{
			if(_isNoSound != value)
			{
				_isNoSound = value;
				invalidateSkinState();
			}
		}
		
		
		//-----------------------------------------
		// transcript
		//-----------------------------------------
		public var transcriptChanged:Boolean = false;
		private var _transcript:String;
		
		public function get transcript():String
		{
			return _transcript;
		}
		
		public function set transcript(value:String):void
		{
			if(_transcript != value)
			{
				_transcript = value;
				transcriptChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// isNoSoundLimit
		//-----------------------------------------
		private var _isSoundLimit:Boolean;
		
		public function get isSoundLimit():Boolean
		{
			return _isSoundLimit;
		}
		
		public function set isSoundLimit(value:Boolean):void
		{
			if( _isSoundLimit !== value)
			{
				_isSoundLimit = value;
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
			
			if( audioPlayer  && soundSourceChanged )
			{
				audioPlayer.sndURL = currentSound;
				soundSourceChanged = false;
			}
			
			if( soundTextControl  && soundTextChanged )
			{
				soundTextControl.text = soundText;
				soundTextChanged = false;
			}
			
			if(existingSoundPanel && sndDataChanged)
			{
				existingSoundPanel.sndData = sndData;
				playPauseButton.enabled = (sndData != null);
				sndDataChanged = false;
			}
			
			if(recordSoundPanel && userSndDataChanged)
			{
				recordSoundPanel.sndData = userSndData;
				recordedPlayPauseButton.enabled = (userSndData != null);
				buttonSave.enabled = true;
				userSndDataChanged = false;
			}
			
			if(buttonSave && userSndDataEnabledChanged)
			{
				buttonSave.enabled = (userSndData != null);
				userSndDataEnabledChanged = false;
			}
			if(transcriptTextArea && transcriptChanged)
			{
				transcriptTextArea.editable = true;
				transcriptTextArea.textFlow = _transcript ?  TextConverter.importToFlow(_transcript, TextConverter.PLAIN_TEXT_FORMAT):null;
				transcriptTextArea.editable = false;
				transcriptChanged = false;
			}
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == micConfigButton )
			{
				micConfigButton.addEventListener( MouseEvent.CLICK, microphoneConfiguration );
			}
			
			if( instance == buttonCancel )
			{
				buttonCancel.addEventListener( MouseEvent.CLICK, closeWindowHandler );
			}
			
			
			if( instance == buttonClose )
			{
				buttonClose.addEventListener( MouseEvent.CLICK, closeWindowHandler );
			}
			
			
			if( instance == buttonSave )
			{
				buttonSave.addEventListener(MouseEvent.CLICK , saveSoundHandler);
				buttonSave.enabled = false;
			}
			
			
			if(instance == recordButton)
			{
				recordButton.addEventListener(MouseEvent.CLICK, onMouseClick);
				initializeSoundRecorder();
			}
			
			if(instance == playPauseButton )
			{
				playPauseButton.enabled = _sndData != null;
				playPauseButton.addEventListener(MouseEvent.CLICK, onSoundNormalPlay);
			}
			
			if(instance == recordedPlayPauseButton )
			{
				recordedPlayPauseButton.enabled = _sndData != null;
				recordedPlayPauseButton.addEventListener(MouseEvent.CLICK, onUserSoundRecordedPlay);
			}
		}
		
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			
			if( instance == micConfigButton )
			{
				micConfigButton.removeEventListener( MouseEvent.CLICK, microphoneConfiguration );
			}
			
			if( instance == buttonCancel )
			{
				buttonCancel.removeEventListener( MouseEvent.CLICK, closeWindowHandler );
			}
			
			
			if( instance == buttonClose )
			{
				buttonClose.removeEventListener( MouseEvent.CLICK, closeWindowHandler );
			}
			
			if( instance == buttonSave )
			{
				buttonSave.removeEventListener(MouseEvent.CLICK , saveSoundHandler);
			}
			
			
			if(instance == recordButton)
			{
				recordButton.removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
			
			if(instance == playPauseButton )
			{
				playPauseButton.removeEventListener(MouseEvent.CLICK, onSoundNormalPlay);
			}
			
			if(instance == recordedPlayPauseButton )
			{
				recordedPlayPauseButton.removeEventListener(MouseEvent.CLICK, onUserSoundRecordedPlay);
			}
			
			super.partRemoved(partName, instance);
		}
		
		
		
		/**
		 *
		 * @inheritDoc 
		 * 
		 */		
		override protected function attachSkin() : void
		{
			setStyle("skinClass", SoundLoaderWindowSkin);
			super.attachSkin();
		}
		
		override protected function getCurrentSkinState():String
		{
			if(isNoSound)
				return 'noSound';
			return 'normal';
		}
		
		override public function setFocus():void
		{
			if(buttonSave && buttonSave.enabled)
				buttonSave.setFocus();
			else if(buttonCancel)
				buttonCancel.setFocus();
			else
				super.setFocus();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		protected function closeWindowHandler(event:MouseEvent=null):void
		{
			audioPlayer.stop();
			stopRecord();
			removeListeners();
			soundRecord = null;
			if(existingSoundPanel)
				existingSoundPanel.sndData = null;
			currentSound = null;
			target		= null;
			indicatorTimer = null;
			timerMaxRecordLength = null;
			confirmationPopup	= null;
			mediaVO		= null;
			sndData		= null;
			userRecordedSound = null;
			buttonSave.enabled = false;
			recordButton.selected = false;
			isNoSound = false;
			if(playPauseButton)
			{
				playPauseButton.selected = false;
				playPauseButton.enabled = false;
			}
			if(recordedPlayPauseButton)
			{
				recordedPlayPauseButton.selected = false;
				recordedPlayPauseButton.enabled = false;
			}
			
			dispatchEvent( new Event( Event.CLOSE ) );
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		private function saveSoundHandler(event:MouseEvent):void
		{
			var saveSoundWarn:String 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, "saveSoundWarn" ) || "Are you sure to save this sound?";
			var saveTitle:String 		= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, "saveSoundWarnTitle" ) || "Save sound";
			confirmationPopup = ConfirmationPopup.show( saveTitle, saveSoundWarn );
			
			confirmationPopup.addEventListener( ConfirmationPopup.OK, onSavingWarningPromptHandler );
			confirmationPopup.addEventListener( ConfirmationPopup.CANCEL, onSavingWarningPromptHandler );
			confirmationPopup.addEventListener( Event.CLOSE,  onSavingWarningPromptHandler);
		}
		
		private function onSavingWarningPromptHandler(event:Event):void
		{
			if( event.type == ConfirmationPopup.OK )
			{
				dispatchEvent( new CourseEvent( CourseEvent.SAVE_SOUND,  mediaVO) );
				closeWindowHandler();
			}
		}
		
		
		/**
		 * 
		 * Handler for <code>Event.SOUND_COMPLETE</code> event dispatched by player.
		 * 
		 * @param event The <code>Event</code> event dispatched by player.
		 * 
		 */		
		private function soundPlayCompleteHandler( event:Event ) : void
		{
			selected = false;
			audioPlayer.sndURL = null;
		}
		/**
		 * 
		 * Handler for <code>RawAudioControllerTwo.RAW_LOADED</code> event dispatched by player.
		 * 
		 * @param event The <code>Event</code> event dispatched by player.
		 * 
		 */		
		private function onRawLoadedHandler( event:Event ) : void
		{
			if(currentSound && currentSound == audioPlayer.sndURL)
				sndData = audioPlayer.normalSoundData;
			else
			{
				userSndData = audioPlayer.normalSoundData;
				mediaVO.binaryContent = audioPlayer.normalSoundData;
			}
			
			if( !target || !ToggleButton(target).selected)
				audioPlayer.stop();
		}
		
		protected function onSoundNormalPlay(event:Event):void
		{
			if(recordedPlayPauseButton && recordedPlayPauseButton.selected)
			{
				audioPlayer.stop();
				recordedPlayPauseButton.selected = false;
			}
			
			if(!playPauseButton.selected &&  audioPlayer.playing)
			{
				audioPlayer.pause();
			}
			else 
			{
				if(target == playPauseButton && audioPlayer.position != 0)
					audioPlayer.play( true );
				else
				{
					target = playPauseButton as IVisualElement;
					audioPlayer.normalSoundData = existingSoundPanel.sndData;
					audioPlayer.position = 0;
					audioPlayer.play();
				}
			}
		}
		
		
		protected function onUserSoundRecordedPlay(event:Event):void
		{
			if(playPauseButton && playPauseButton.selected)
			{
				audioPlayer.stop();
				playPauseButton.selected = false;
			}
			
			if(!recordedPlayPauseButton.selected &&  audioPlayer.playing)
			{
				audioPlayer.pause();
			}
			else 
			{
				if(target == recordedPlayPauseButton && audioPlayer.position != 0)
					audioPlayer.play( true );
				else
				{
					target = recordedPlayPauseButton as IVisualElement;
					audioPlayer.normalSoundData = recordSoundPanel.sndData;
					audioPlayer.position = 0;
					audioPlayer.play();
				}
			}
		}
		
		/**
		 * Handling event sound record new connected
		 */ 
		private function onSoundRecordConnection(event:SoundRecorderEvent):void
		{
			if(soundRecord)
			{
				soundRecord.addEventListener(SoundRecorderEvent.RECORD_START, onSoundRecordStart);
				soundRecord.addEventListener(SoundRecorderEvent.RECORD_STOP, onSoundRecordStop);
				soundRecord.addEventListener(SoundRecorderEvent.RECORD_FINISHED, onSoundRecordFinished);
				soundRecord.addEventListener(SoundRecorderEvent.RECORD_ERROR, onSoundRecordError);
				soundRecord.addEventListener(SoundRecorderEvent.MICROPHONE_ERROR, onSoundRecordError);
				soundRecord.addEventListener(SoundRecorderEvent.TIMEOUT, onSoundRecordError);
			}
		} 
		
		private function removeListeners():void
		{
			if(soundRecord)
			{
				soundRecord.removeEventListener(SoundRecorderEvent.RECORD_START, onSoundRecordStart);
				soundRecord.removeEventListener(SoundRecorderEvent.RECORD_STOP, onSoundRecordStop);
				soundRecord.removeEventListener(SoundRecorderEvent.RECORD_FINISHED, onSoundRecordFinished);
				soundRecord.removeEventListener(SoundRecorderEvent.RECORD_ERROR, onSoundRecordError);
				soundRecord.removeEventListener(SoundRecorderEvent.MICROPHONE_ERROR, onSoundRecordError);
				soundRecord.removeEventListener(SoundRecorderEvent.TIMEOUT, onSoundRecordError);
			}
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if(!permited)
			{
				if (!recordButton.selected)
				{
					stopRecord();
				}
				else
				{	
					if(audioPlayer && audioPlayer.playing)
						audioPlayer.stop();
					if(playPauseButton)
						playPauseButton.selected = false;
					
					if(recordedPlayPauseButton)
						recordedPlayPauseButton.selected = false;
					
					if(isMicrophoneConfigured)
						startRecord();
					else
						microphoneConfiguration( null );
					
				}
			} 
			else 
			{
				indicatorTimer.stop();
				if(timerMaxRecordLength)
					timerMaxRecordLength.stop();
				recordButton.selected = false;
				Alert.show("Please, reload your browser!");
			}
		}
		/**
		 * microphone settings handler
		 */
		
		private function microphoneConfiguration(event:MouseEvent):void
		{
			if(microphoneSetingsView == null)
			{
				if(event && recordButton.selected)
				{
					stopRecord();
					recordButton.selected = false;
				}
				removeListeners();
				soundRecord = null;
				microphoneSetingsView = new AdjustmentMicrophoneWindow();
				microphoneSetingsView.setStyle("skinClass", AdjustmentMicrophoneWindowSkin );
				microphoneSetingsView.gain = gain;
				
				microphoneSetingsView.addEventListener( Event.CLOSE, onMicrophoneSetingsHandler );
				microphoneSetingsView.addEventListener(AdjustmentMicrophoneWindow.FINISH_SETTINGS, onMicrophoneSetingsHandler );
				PopUpManager.addPopUp( microphoneSetingsView, this, true );
				PopUpManager.centerPopUp( microphoneSetingsView );
			}
		}
		
		/**
		 * microphone settings handler
		 */
		
		private function onMicrophoneSetingsHandler(event:Event):void
		{
			if(event.type == AdjustmentMicrophoneWindow.FINISH_SETTINGS )
			{
				gain = microphoneSetingsView.gain;
				if(recordButton.selected)
					startRecord();
				isMicrophoneConfigured = true;
			}
			else
				recordButton.selected = false;
			PopUpManager.removePopUp( microphoneSetingsView );
			microphoneSetingsView = null;
		}
		
		
		/**
		 * visualization record level
		 */
		private function onIndicatorTimer(event:TimerEvent):void
		{
			/*if(System.freeMemory < TWO_MB)
			{
				recordButton.selected = false;
				recordedPlayPauseButton.enabled = true;			
				stopRecord();
				showRecordTimeoutPopup();
			}*/
			actIndicator.setCurrentState("s"+soundRecord.volumeLevel.toString());
		}
		
		protected function onTimerMaxRecordLengthCompleteHandler(event:TimerEvent):void
		{
			recordButton.selected = false;
			recordedPlayPauseButton.enabled = true;			
			stopRecord();
			timerMaxRecordLength.removeEventListener(TimerEvent.TIMER, onTimerMaxRecordLengthCompleteHandler);
		}
		
		/**
		 * Handling event sound record error (+ message)
		 */ 
		private function onSoundRecordError(event:SoundRecorderEvent):void
		{
			recordButton.selected = false;			
			if (indicatorTimer)
			{
				indicatorTimer.removeEventListener(TimerEvent.TIMER, onIndicatorTimer);
				indicatorTimer.stop();
			}
			actIndicator.setCurrentState("s0");
			textRecording.setCurrentState("disabled");
			textRecording.blinkLabel.stop();
			
			if (soundRecord)
			{
				stopRecord();
				soundRecord = null;
			}
			initializeSoundRecorder();
			Alert.show("Please record sound again.","Sound Recorder Error");
		} 
		
		/**
		 * Handling event sound record start
		 */ 
		private function onSoundRecordStart(event:SoundRecorderEvent):void
		{
			recordButton.enabled = true;
			textRecording.setCurrentState("show");
			textRecording.blinkLabel.play();
		} 
		/**
		 * Handling event sound record stop (not data)
		 */ 
		private function onSoundRecordStop(event:SoundRecorderEvent):void
		{
			recordButton.enabled = true;			
			recordedPlayPauseButton.enabled = true;			
		} 
		/**
		 * Handling event sound record finished (+ data)
		 */ 
		private function onSoundRecordFinished(event:SoundRecorderEvent):void
		{
			if (soundRecord.soundData.length > 0)
				addRecordUserSound(soundRecord.soundData, false);
			recordButton.enabled = true;			
			recordedPlayPauseButton.enabled = true;
			removeListeners();
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
		
		
		/**
		 * 
		 * Storage for selected.
		 * 
		 */		
		private function set selected( value:Boolean ) : void
		{
			if( target is ToggleButton )
			{
				var button:ToggleButton = target as ToggleButton;
				
				button.selected = value;
				
				if( button.selected )
				{
					button.toolTip 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'pauseSoundToolTip' ) || 'Pause Sound';
					button.label 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'pauseSound' ) || 'Pause';
				}
				else
				{
					button.toolTip 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'playSoundToolTip' ) || 'Play Sound';
					button.label 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'playSound' ) || 'Play';
				}
			}
			
			if(playPauseButton)
			{
				playPauseButton.selected = value; 
			}
			if(recordedPlayPauseButton)
			{
				recordedPlayPauseButton.selected = value; 
			}
		}
		
		
		/**
		 * sound record section
		 */
		
		private function initializeSoundRecorder() :void
		{
			if(soundRecord)
				return;
			soundRecord = new FlashSoundRecorder();
			
			if(soundRecord is FlashSoundRecorder)
			{
				onSoundRecordConnection(null);
			}
		}
		
		private function startRecord():void
		{
			if(!soundRecord)
				initializeSoundRecorder();
			onSoundRecordConnection( null );
			soundRecord.gain = gain;
			soundRecord.startRecord();
			indicatorTimer = new Timer(20);
			indicatorTimer.addEventListener(TimerEvent.TIMER, onIndicatorTimer);
			indicatorTimer.start();
			if(isSoundLimit)
			{
				timerMaxRecordLength = new Timer(ONE_MINUTE);
				timerMaxRecordLength.addEventListener(TimerEvent.TIMER, onTimerMaxRecordLengthCompleteHandler);
				timerMaxRecordLength.start();
			}
			recordedPlayPauseButton.enabled = false;
		}
		
		private function stopRecord():void
		{
			if(soundRecord)
				soundRecord.stopRecord();
			if(indicatorTimer)
			{
				indicatorTimer.removeEventListener(TimerEvent.TIMER, onIndicatorTimer);
				indicatorTimer.stop();
			}
			
			if(timerMaxRecordLength)
			{
				timerMaxRecordLength.stop();
				timerMaxRecordLength.removeEventListener(TimerEvent.TIMER, onTimerMaxRecordLengthCompleteHandler);
			}
			if(actIndicator)
				actIndicator.setCurrentState("s0");
			if(textRecording)
			{
				textRecording.setCurrentState("disabled");
				textRecording.blinkLabel.stop();
			}
			//recordedPlayPauseButton.enabled = true;	
		}
		
		/**
		 * add new user sound in user sound holder
		 */
		private function addRecordUserSound(data:ByteArray, selected:Boolean):void
		{
			var wavWriter:WAVConverter = new WAVConverter();
			userSndData = data;
			// Set settings
			data.position = 0;
			
			// convert ByteArray to WAV
			userRecordedSound = wavWriter.processSamples( data, SAMPLING_RATE, CHANNELS );
			mediaVO.binaryContent	= userRecordedSound;	
		}
		
		private function calculateFileDuration(memory:int):int
		{
			if(!memory)
				return 0;
			var oneSecSize:int = (( SAMPLING_RATE * BIT_RATE * CHANNELS ) / 8) ;//+ WAV_HEADER_SIZE;
			return (memory - WAV_HEADER_SIZE) / oneSecSize;
		}
		
		
		//-----------------------------------------
		// timeout popup
		//----------------------------------------
		private function showRecordTimeoutPopup():void
		{
			var message:String = resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'timeoutMessage' ) || 'This recording has exceeded the maximum length allowed by your system. Your current recording will be saved, and a new recording can be made if necessary.'
			var title:String =  resourceManager.getString( ResourceConstants.TTU_COMPONENTS, 'timeoutPopupTitle' ) || 'Timeout' 
			
			popup = new PopupWindow();
			popup.message 		= message;
			popup.setStyle( "skinClass", InfoWindowSkin );
			
			popup.addEventListener( PopupWindow.OK, onShowRecordTimeoutPopupHandler );
			popup.addEventListener( Event.CLOSE,  onShowRecordTimeoutPopupHandler);
			
			var parent:Sprite;
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			// no types so no dependencies
			var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			PopUpManager.addPopUp( popup, parent, true );
			PopUpManager.centerPopUp( popup );
			popup.setFocus();
		}
		
		private function onShowRecordTimeoutPopupHandler(event:Event):void
		{
			PopUpManager.removePopUp( popup );
			popup = null;
		}
		
	}
}