////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.components.components.sound
{
	
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.scanHardware;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.resources.ResourceManager;
	
	import tj.ttu.components.events.NewSoundRecorderEvent;
	
	//----------------------------------
	//  Events
	//----------------------------------
	
	/**
	 * Event, that dispatched after start recording.
	 */
	[Event(name="startRecord", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after pause recording.
	 */
	[Event(name="pauseRecord", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after stop recording.
	 */
	[Event(name="stopRecord", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after finish recording.
	 */
	[Event(name="finishRecord", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after abort recording.
	 */
	[Event(name="abortRecord", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after change <code>activityLevel</code> of
	 * <code>microphone</code>.
	 */
	[Event(name="activityLevelChange", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after <code>microphone</code> detected the silence.
	 */
	[Event(name="silenceDetection", type="ctj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after <code>microphone</code> detected the voice.
	 */
	[Event(name="voiceDetection", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched after <code>microphone</code> unmuted.
	 */
	[Event(name="microphoneUnmuted", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * Event, that dispatched if <code>microphone</code> is not connected.
	 */
	[Event(name="microphoneNotConnection", type="tj.ttu.components.events.NewSoundRecorderEvent")]
	
	/**
	 * NewFlashSoundRecorder class;
	 * This class use for voice recording by microphone;
	 * For advanced recordign use experimental functionality:
	 * AutomationGainControl, implemented in <code>automationGainControl</code> method;
	 * Also for experiment in this class implement posibility for :
	 * voiceAutoDetection and triming silence in <code>buffer</code>;
	 * VoiceAutoDetection implement in <code>Microphone</code> class, but in this
	 * class this functionality using by some different way;
	 * Silence triming implemented in <code>trimSilence</code> method;
	 * Class inherits from <code>EventDispatcher</code> and report about
	 * all significant processes and events occuring in the instance of this class
	 * through the broadcast of the event, for example:
	 * After starting recording - dispatched new instance of
	 * <code>flash.events.Event</code> with <code>START_RECORD</code> name,
	 * that predefined in same <code>const</code> in this class;
	 * The task of the class - to be instantiated once and set up,
	 * automatically determine the user's voice and silence, for correct realisation
	 * these goals - needing trim <code>buffer</code> by silence;
	 *
	 * Settings in OS for testing and correct work:
	 * microphone gain - 50%, boost - +10dB
	 *
	 * @see https://confluence.transparent.com/display/DEV/Sound+Recording
	 * @see flash.media.Microphone
	 * @see #automationGainControl()
	 */
	public class SoundRecorder extends EventDispatcher
	{
		
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function SoundRecorder(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//----------------------------------------------------------------------
		//
		//	Constants
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Private constants
		//
		//--------------------------------------------------
		
		//----------------------------------
		// BACKGROUND_BUFFER_SIZE
		//----------------------------------
		
		/**
		 * Constant, that define size for background buffer in ms(milliseconds).
		 */
		private const BACKGROUND_BUFFER_SIZE:uint = 100;
		
		//----------------------------------
		// SILENCE_TIMEOUT
		//----------------------------------
		
		/**
		 * Constant, that define time for silence timeout in ms(milliseconds).
		 */
		private const SILENCE_TIMEOUT:uint = 1000000000;
		
		//----------------------------------
		// SILENCE_LEVEL
		//----------------------------------
		
		/**
		 * Constant, that define silence level in 1 to 100.
		 * 0 - work permamently;
		 * 1 - work permamently;
		 * 2 - reacts to the slightest whiff of a microphone in the direction of;
		 * 3 - responds to the loud noises but not reacts to quiet voice;
		 * 4 - responds to the loud noises but not reacts to quiet voice;
		 */
		//		private const SILENCE_LEVEL:uint = 4;
		private const SILENCE_LEVEL:uint = 0;
		
		//----------------------------------
		// TIMER_DELAY
		//----------------------------------
		
		/**
		 * Constant, that define for timer that use for AGC.
		 */
		private const TIMER_DELAY:uint = 1;
		
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Private Variables
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// _microphone
		//----------------------------------
		
		/**
		 * @private
		 * Storage of current used microphone.
		 */
		private var _microphone:Microphone;
		
		//----------------------------------
		// _isDisabled
		//----------------------------------
		
		/**
		 * @private
		 * Storage for isDisabled property.
		 */
		private var _isDisabled:Boolean;
		
		//----------------------------------
		// _useAutomationGainControl
		//----------------------------------
		
		/**
		 * @private
		 * Storage for useAutomationGainControl property.
		 */
		private var _useAutomationGainControl:Boolean;
		
		//----------------------------------
		// _useVoiceDetection
		//----------------------------------
		
		/**
		 * @private
		 * Storage for useVoiceDetection property.
		 */
		private var _useVoiceDetection:Boolean;
		
		//----------------------------------
		// _startBackgroundBuffer
		//----------------------------------
		
		/**
		 * @private
		 * Storage for startBackgroundBuffer property.
		 */
		private var _startBackgroundBuffer:ByteArray;
		
		//----------------------------------
		// _endBackgroundBuffer
		//----------------------------------
		
		/**
		 * @private
		 * Storage for endBackgroundBuffer property.
		 */
		private var _endBackgroundBuffer:ByteArray;
		
		//----------------------------------
		// _buffer
		//----------------------------------
		
		/**
		 * @private
		 * Storage for buffer property.
		 */
		private var _buffer:ByteArray;
		
		//----------------------------------
		// _soundData
		//----------------------------------
		
		/**
		 * @private
		 * Storage for soundData property.
		 */
		private var _soundData:ByteArray;
		
		//----------------------------------
		// isInitialised
		//----------------------------------
		
		/**
		 * @private
		 * Remember that component is initialised.
		 */
		private var isInitialised:Boolean;
		
		//----------------------------------
		// isRecording
		//----------------------------------
		
		/**
		 * @private
		 * Indicate that record is work.
		 */
		private var _isRecording:Boolean;
		
		//----------------------------------
		// isPauseRecording
		//----------------------------------
		
		/**
		 * @private
		 * Indicate that record is paused.
		 */
		private var isPauseRecording:Boolean;
		
		//----------------------------------
		// isSilenceDetected
		//----------------------------------
		
		/**
		 * @private
		 * Indicate that the silence detected.
		 */
		private var isSilenceDetected:Boolean;
		
		//----------------------------------
		// isVoiceDetected
		//----------------------------------
		
		/**
		 * @private
		 * Indicate that the voice detected.
		 */
		private var isVoiceDetected:Boolean;
		
		//----------------------------------
		// timer
		//----------------------------------
		
		/**
		 * @private
		 * Use for automation gain control.
		 */
		private var timer:Timer;
		
		private var _isAdjustment:Boolean;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// microphone
		//----------------------------------
		
		/**
		 * Return reference to Microphone object for audio recording.
		 * After initialisation return reference to default system microphone.
		 *
		 * @default null
		 * @return flash.media.Microphone Reference to Microphone object for audio recording.
		 */
		public function get microphone():Microphone
		{
			return _microphone;
		}
		
		//----------------------------------
		// volumeLevel
		//----------------------------------
		
		/**
		 * Return current volume level of microphone
		 * Volume level represented by <code>activityLevel</code> property.
		 *
		 * @default null
		 * @return int Volume level on microphone input.
		 */
		public function get volumeLevel():int
		{
			return _microphone ? int(microphone.activityLevel/10) : -1;
		}
		
		//----------------------------------
		// isDisabled
		//----------------------------------
		
		/**
		 * Indicate disable or enable sound recorder.
		 *
		 * @default false
		 * @return Boolean
		 */
		public function get isDisabled():Boolean
		{
			return _isDisabled;
		}
		
		//----------------------------------
		// isRecording
		//----------------------------------
		
		/**
		 * Indicate recording.
		 *
		 * @default false
		 * @return Boolean
		 */
		public function get isRecording():Boolean
		{
			return _isRecording;
		}
		
		//----------------------------------
		// useAutomationGainControl
		//----------------------------------
		
		/**
		 * Use for indicate usage of AutomationGainControl.
		 *
		 * @default false
		 * @return Boolean
		 */
		public function get useAutomationGainControl():Boolean
		{
			return _useAutomationGainControl;
		}
		
		/**
		 * @private
		 */
		public function set useAutomationGainControl(value:Boolean):void
		{
			_useAutomationGainControl = value;
		}
		
		//----------------------------------
		// useVoiceDetection
		//----------------------------------
		
		/**
		 * Use for indicate usage of automation voice detection.
		 *
		 * @default false
		 * @return Boolean
		 */
		public function get useVoiceDetection():Boolean
		{
			return _useVoiceDetection;
		}
		
		/**
		 * @private
		 */
		public function set useVoiceDetection(value:Boolean):void
		{
			_useVoiceDetection = value;
		}
		
		//----------------------------------
		// startBackgroundBuffer
		//----------------------------------
		
		/**
		 * Return instance of ByteArray that contains recorded background.
		 *
		 * @default null
		 * @return ByteArray ByteArray that contains recorded audio.
		 */
		public function get startBackgroundBuffer():ByteArray
		{
			return _startBackgroundBuffer;
		}
		
		//----------------------------------
		// endBackgroundBuffer
		//----------------------------------
		
		/**
		 * Return instance of ByteArray that contains recorded background.
		 *
		 * @default null
		 * @return ByteArray ByteArray that contains recorded audio.
		 */
		public function get endBackgroundBuffer():ByteArray
		{
			return _endBackgroundBuffer;
		}
		
		//----------------------------------
		// buffer
		//----------------------------------
		
		/**
		 * Return instance of ByteArray that contains recorded audio
		 * without any modifications.
		 *
		 * @default null
		 * @return ByteArray ByteArray that contains recorded audio.
		 */
		public function get buffer():ByteArray
		{
			return _buffer;
		}
		
		//----------------------------------
		// soundData
		//----------------------------------
		
		/**
		 * Return instance of ByteArray that contains recorded audio
		 * in stereo format.
		 *
		 * @default null
		 * @return ByteArray ByteArray that contains recorded audio.
		 */
		public function get soundData():ByteArray
		{
			return makeStereo(_soundData);
		}
		
		public function get rawSoundData():ByteArray
		{
			return _soundData;
		}
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Public Methods
		//
		//--------------------------------------------------
		
		//----------------------------------
		// init
		//----------------------------------
		
		/**
		 * Initialise microphone;
		 * Executed only once, before microphone used;
		 * Check flag <code>isInitialised</code>
		 * and if <code>NewFlashSoundRecorder</code> is initialised return from method.
		 * After executing, flag <code>isInitialised</code> sets to <code>true</code>;
		 * In this method calls FlashPlayer security window for allowing access to hardware;
		 * Initialising the <code>microphone</code> property;
		 * Configuring listeners for current Microphone object;
		 *
		 * @see flash.media.Microphone
		 * @see microphone
		 * @see isInitialised
		 */
		public function init(level:int = -1, timeout:int = -1, isAdjustment:Boolean = false):void
		{
			trace("init");
			//			if (isInitialised) return;
			
			//			isInitialised = true;
			
			this._isAdjustment = isAdjustment;
			
			if (_microphone)
			{
				_microphone.removeEventListener(StatusEvent.STATUS, microphone_statusHandler);
				_microphone.removeEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphone_sampleDataHandler);
				_microphone = null;
				timer = null;
				
			}
			
			scanHardware();
			
			if (!_microphone)
				_microphone = Microphone.getMicrophone();
			
			if (!_microphone)
			{
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.MICROPHONE_ERROR));
				return;
			}
			
			_microphone.rate = 44;
			
			if (level == -1 && timeout == -1)
			{
				_microphone.setSilenceLevel(SILENCE_LEVEL, SILENCE_TIMEOUT);
			}
			else
			{
				_microphone.setSilenceLevel(level, timeout);
			}
			
			
			_microphone.addEventListener(StatusEvent.STATUS, microphone_statusHandler);
			
			timer = new Timer(TIMER_DELAY, 0);
			
			if (_microphone.muted)
			{
				Security.showSettings(SecurityPanel.PRIVACY);
			}
			else
			{
				if (useVoiceDetection)
				{
					_microphone.setLoopBack(true);
					
					_microphone.addEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
				}
			}
		}
		
		public function configuringMicrophone(update:Boolean = false):void
		{
			//			if (update)
			//			{
			//				_microphone.removeEventListener(StatusEvent.STATUS, microphone_statusHandler);
			//				_microphone.removeEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
			//				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphone_sampleDataHandler);
			//				configuringMicrophone();
			//			}
			//			else
			//			{
			//				trace("add activity listener");
			//				_microphone.addEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
			//			}
		}
		
		public function disable():void
		{
			trace("disable");
//			_isDisabled = true;
//			_microphone.setLoopBack(false);
//			_microphone.removeEventListener(StatusEvent.STATUS, microphone_statusHandler);
//			_microphone.removeEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
			abortRecord();
		}
		
		public function enable():void
		{
			trace("enable");
			_isDisabled = false;
//			_microphone.addEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
		}
		
		//----------------------------------
		// recordBackground
		//----------------------------------
		
		public function recordBackground(isStart:Boolean = true):void
		{
			trace("record background " + isStart);
			
			scanHardware();
			_microphone = Microphone.getMicrophone();
			
			if (_microphone)
			{
				if (isStart)
				{
					_startBackgroundBuffer = new ByteArray();
					_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, mic_startBackgroundSampleDataHandler);
				}
				else
				{
					_endBackgroundBuffer = new ByteArray();
					_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, mic_endBackgroundSampleDataHandler);
				}
			}
			else
			{
				_startBackgroundBuffer = null;
				_endBackgroundBuffer = null;
				_soundData = null;
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.MICROPHONE_ERROR));
			}
			
			
			
			//setTimeout(stopRecordingBackground, BACKGROUND_BUFFER_SIZE, isStart);
		}
		
		//----------------------------------
		// stopRecordingBackground
		//----------------------------------
		
		public function stopRecordingBackground(isStart:Boolean = true):void
		{
			trace("stopRecordingBackground " + isStart);
			if (isStart)
			{
				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, mic_startBackgroundSampleDataHandler);
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.START_BUFFER_FULL));
			}
			else
			{
				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, mic_endBackgroundSampleDataHandler);
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.END_BUFFER_FULL));
			}
		}
		
		//----------------------------------
		// startRecord
		//----------------------------------
		
		/**
		 * Init start recording;
		 * Init <code>buffer</code> for record sound data;
		 * Set flag <code>isRecording</code> to <code>true</code>;
		 * Configure listener for current Microphone object for listen
		 * <code>SampleDataEvent.SAMPLE_DATA</code>;
		 * Dispatch new instance of <code>flash.events.Event</code>
		 * with <code>START_RECORD</code> name,
		 * that predefined in same <code>const</code> in this class;
		 */
		public function startRecord():void
		{
			if (isRecording) return;
			
			trace("NewFlashSoundRecorder::startRecord");
			scanHardware();
			_microphone = Microphone.getMicrophone();
			
			if (_microphone)
			{
				_isRecording = true;
				
				if (!_buffer || _buffer.length != 0) _buffer = new ByteArray();
				if (!_soundData || _soundData.length != 0) _soundData = new ByteArray();
				
				_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphone_sampleDataHandler);
				
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.START_RECORD));
			}
			else
			{
				_soundData = null;
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.MICROPHONE_ERROR));
			}
			
		}
		
		//----------------------------------
		// pauseRecord
		//----------------------------------
		
		/**
		 * Pause recording audio.
		 * Check flag <code>isRecording</code>, if <code>false</code> return from method;
		 * Set flag <code>isRecording</code> to <code>false</code>;
		 * Check flag <code>isPauseRecording</code>, if <code>false</code>
		 * set flag <code>isPauseRecording</code> to <code>true</code>,
		 * else call <code>resumeRecord()</code>;
		 * Remove listener for current Microphone object for listen
		 * <code>SampleDataEvent.SAMPLE_DATA</code>;
		 * Dispatch new instance of <code>flash.events.Event</code>
		 * with <code>PAUSE_RECORD</code> name,
		 * that predefined in same <code>const</code> in this class;
		 */
		public function pauseRecord():void
		{
			
		}
		
		//----------------------------------
		// stopRecord
		//----------------------------------
		
		/**
		 * Stop recording;
		 * Set flag <code>isRecording</code> to <code>false</code>;
		 * Remove listener for current Microphone object for listen
		 * <code>SampleDataEvent.SAMPLE_DATA</code>;
		 * Dispatch new instance of <code>flash.events.Event</code>
		 * with <code>STOP_RECORD</code> name,
		 * that predefined in same <code>const</code> in this class;
		 */
		public function stopRecord():void
		{
			trace("NewFlashSoundRecorder::stopRecord");
			if (_isRecording == false)
				return;
			_isRecording = false;
			
			if (_microphone)
			{
				_microphone.setLoopBack(false);
				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphone_sampleDataHandler);
				_microphone.removeEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
			}
			else
			{
				_soundData = null;
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.MICROPHONE_ERROR));
			}
			
			dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.STOP_RECORD));
		}
		
		//----------------------------------
		// abortRecord
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */
		public function abortRecord():void
		{
			trace("abortRecord");
			_isRecording = false;
			
			if (_microphone)
			{
				_microphone.setLoopBack(false);
				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphone_sampleDataHandler);
			}
			
			dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.ABORT_RECORD));
		}
		
		//--------------------------------------------------
		//
		//	Private Methods
		//
		//--------------------------------------------------
		
		//----------------------------------
		// finishRecord
		//----------------------------------
		
		/**
		 * @private
		 * TODO: asdoc
		 */
		private function finishRecord():void
		{
			dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.FINISH_RECORD));
		}
		
		//----------------------------------
		// automationGainControl
		//----------------------------------
		
		/**
		 * @orivate
		 * Used for control <code>microphone.gain</code>;
		 * Can not very loud or very quiet sound recording;
		 * Monitors changes in the <code>microphone.activityLevel</code>,
		 * and based on current data change <code>microphone.gane</code>.
		 * Steps for work:
		 * 1. Define minimum level, that should be differencing voice and noise;
		 * This is very abstract step and this level certainly must be the same
		 * like <code>SILENCE_LEVEL</code> value, witch describe the value to
		 * determine the silence;
		 * define the limits of the input level and gain, these parameters should
		 * be use for correction microphone <code>gain</code>;
		 * 2. Check current <code>activityLevel</code> for equality with minimum level,
		 * if current <code>activityLevel</code> less than minimum level - do nothing,
		 * because it is not a voice;
		 * otherwise analyze <code>activityLevel</code> further;
		 * 3. Check current <code>activityLevel</code> for equality with
		 * minActivityLevel and maxActivityLevel,
		 * if current <code>activityLevel</code> less than minActivityLevel :
		 * check gain for equality with minGainLevel and maxGainLevel;
		 * otherwise if current <code>activityLevel</code> more than maxActivityLevel
		 * also check gain for equality with minGainLevel and maxGainLevel;
		 * 4. Define the gain coefficient according previous analizes.
		 */
		private function automationGainControl():void
		{
			//			trace("microphone.muted = " + microphone.muted);
//			if (microphone.activityLevel == -1)
//			{
//				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
//				timer.stop();
//			}
			
			//			trace("NewFlashSoundRecorder::automationGainControl");
			//			trace("microphone.activityLevel = " + microphone.activityLevel);
			//			trace("volumeLevel = " + volumeLevel);
			//			trace("microphone.gain = " + microphone.gain);
			//			trace("microphone.silenceLevel = " + microphone.silenceLevel);
//			var voiceDetectionActivityLevel:uint = 5;
//			var minActivityLevel:uint = 30;
//			var maxActivityLevel:uint = 70;
//			var minGainLevel:uint = 10;
//			var maxGainLevel:uint = 70;
//			var defaultGainLevel:uint = 43;
//			var gainDelta:Number = 1;
			
//			microphone.setSilenceLevel(10, SILENCE_TIMEOUT);
			
//			if (microphone.activityLevel < minActivityLevel)
//			{
//				if (microphone.gain < minGainLevel)
//				{
//					microphone.gain = defaultGainLevel;
//				}
//				if (microphone.gain > minGainLevel && microphone.gain < maxGainLevel)
//				{
//					microphone.gain += 10;
//				}
//				if (microphone.gain > maxGainLevel)
//				{
//					microphone.gain -= 10;
//				}
//			}
//			if (microphone.activityLevel > maxActivityLevel)
//			{
//				microphone.gain -= 10;
//			}
			
			//			if (microphone.activityLevel > voiceDetectionActivityLevel)
			//			{
			//				trace("VOICE DETECTED");
			//				if (microphone.activityLevel < minActivityLevel)
			//				{
			//					trace("VERY QUIET");
			//					if (microphone.gain < 50)
			//					{
			//						trace("INCREASE GAIN");
			//						microphone.gain += 10;
			//					}
			//				}
			//				if (microphone.activityLevel > maxActivityLevel)
			//				{
			//					trace("VERY LOUD");
			//					if (microphone.gain > 50)
			//					{
			//						trace("REDUCE GAIN 15");
			//						microphone.gain -= 15;
			//					}
			//					else if (microphone.gain > 40)
			//					{
			//						trace("REDUCE GAIN 10");
			//						microphone.gain -= 10;
			//					}
			//					else if (microphone.gain > 30)
			//					{
			//						trace("REDUCE GAIN 5");
			//						microphone.gain -= 5;
			//					}
			//				}
			//			}
			//			else
			//			{
			//				trace("RESTORE DEFAULT MICROPHONE GAIN");
			//				microphone.gain = defaultGainLevel;
			//			}
		}
		
		//----------------------------------
		// trimSilence
		//----------------------------------
		
		/**
		 * @orivate
		 * This method will trim <code>_buffer</code> by silence;
		 * For this need analise <code>_buffer</code> and clear what is silence;
		 * For start analise first and last bytes;
		 * For example posible comparison these bytes with predefined "silence bytes";
		 * Another way is use wav drawing for analising amplitude gharacteristics;
		 */
		private function trimSilence():void
		{
			
		}
		
		//----------------------------------
		// makeStereo
		//----------------------------------
		
		/**
		 * This method convert mono audio to stereo.
		 * Flash Player record audio in mono, but for some purposes,
		 * it is necessary to stereo.
		 *
		 * @param bytes Recorded audio in mono format
		 * @return Recorded audio, converted to stereo
		 */
		public function makeStereo(bytes:ByteArray):ByteArray
		{
			if (!bytes) return null;
			
			bytes.position = 0;
			var outBytes:ByteArray = new ByteArray();
			while(bytes.bytesAvailable >=4)
			{
				var sample:Number = bytes.readFloat();
				outBytes.writeFloat(sample);
				outBytes.writeFloat(sample);
			}
			outBytes.position = 0;
			return outBytes;
		}
		
		//----------------------------------------------------------------------
		//
		//	EventHandler's
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// microphone_statusHandler
		//----------------------------------
		
		/**
		 * @private
		 * TODO: asdoc
		 */
		private function microphone_statusHandler(e:StatusEvent):void
		{
			trace("NewFlashSoundRecorder::microphone_statusHandler");
			trace("e.code = " + e.code);
			trace("e.level = " + e.level);
			if (e.code == "Microphone.Unmuted")
			{
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.MICROPHONE_UNMUTED));
				
				if (useVoiceDetection)
				{
					_microphone.setLoopBack(true);
					
					_microphone.addEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
				}
			}
			else
			{
				_microphone.removeEventListener(ActivityEvent.ACTIVITY, microphone_activityHandler);
			}
		}
		
		//----------------------------------
		// microphone_activityHandler
		//----------------------------------
		
		/**
		 * @private
		 * TODO: asdoc
		 */
		private function microphone_activityHandler(e:ActivityEvent):void
		{
			trace("NewFlashSoundRecorder::microphone_activityHandler");
			trace("e.activating = " + e.activating);
			
			if (e.activating)
			{
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.VOICE_DETECTION));
				
				if (!isRecording)
					startRecord();
				
				if (useVoiceDetection)
					_microphone.setLoopBack(false);
				
				if (useAutomationGainControl)
				{
					timer.addEventListener(TimerEvent.TIMER, timerHandler);
					timer.start();
				}
			}
			else
			{
				dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.SILENCE_DETECTION));
				
				stopRecord();
				
				if (useVoiceDetection)
					_microphone.setLoopBack(true);
				
				if (!_isAdjustment)
					_microphone.setLoopBack(false);
				
				if (useAutomationGainControl)
				{
					timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					timer.stop();
				}
			}
		}
		
		//----------------------------------
		// microphone_sampleDataHandler
		//----------------------------------
		
		/**
		 * @private
		 * TODO: asdoc
		 */
		private function microphone_sampleDataHandler(e:SampleDataEvent):void
		{
			//			trace("NewFlashSoundRecorder::microphone_sampleDataHandler");
			//			trace("e.position = " + e.position);
			//			trace("e.data.bytesAvailable = " + e.data.bytesAvailable);
			//			trace("_microphone.activityLevel = " + _microphone.activityLevel);
			//			trace("_microphone.gain = " + _microphone.gain);
			if (!_isAdjustment)
			{
				_buffer.writeBytes(e.data, 0, e.data.bytesAvailable);
				_soundData.writeBytes(e.data, 0, e.data.bytesAvailable);
			}
			dispatchEvent(new NewSoundRecorderEvent(NewSoundRecorderEvent.ACTIVITY_LEVEL_CHANGE));
		}
		
		/**
		 * @private
		 * @param e TimerEvent
		 */
		private function timerHandler(e:TimerEvent):void
		{
			automationGainControl();
		}
		
		private function mic_startBackgroundSampleDataHandler(e:SampleDataEvent):void
		{
			//			trace("mic_startBackgroundSampleDataHandler");
			_startBackgroundBuffer.writeBytes(e.data, 0, e.data.bytesAvailable);
			if (_startBackgroundBuffer.length  > 4410 * 4 )
			{
				stopRecordingBackground()
			}
		}
		
		private function mic_endBackgroundSampleDataHandler(e:SampleDataEvent):void
		{
			//			trace("mic_endBackgroundSampleDataHandler");
			_endBackgroundBuffer.writeBytes(e.data, 0, e.data.bytesAvailable);
			if (_endBackgroundBuffer.length  > 4410 * 4  )
			{
				stopRecordingBackground(false)
			}
		}
	}
}