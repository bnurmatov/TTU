////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.sound
{
	
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.scanHardware;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.resources.ResourceManager;
	
	import tj.ttu.components.events.SoundRecorderEvent;
	
	/**
	 * FlashSoundRecorder class 
	 */
	public class FlashSoundRecorder extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var silenceTimer:Timer;
		
		public var microphone:Microphone;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * FlashSoundRecorder 
		 */
		public function FlashSoundRecorder()
		{
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  gain
		//
		//--------------------------------------------------------------------------
		private var _gain:Number = 70;
		/**
		 * @inherited 
		 */
		public function get gain():Number
		{
			return _gain;
		}
		
		/**
		 * @inherited 
		 */
		public function set gain(value:Number):void
		{
			if (value > 100 || value < 0)
				throw new ArgumentError(ResourceManager.getInstance().getString("tlcomponents", "gainArgumentError"));
			_gain = value;
		}
		//--------------------------------------------------------------------------
		//
		//  rate
		//
		//--------------------------------------------------------------------------
		
		private var _rate:int = 44;
		/**
		 * The rate at which the microphone is capturing sound, in kHz.
		 */ 
		public function get rate():int
		{
			return _rate;
		}
		
		/**
		 * The rate at which the microphone is capturing sound, in kHz. Acceptable values are 5, 8, 11, 22, and 44.
		 */ 
		public function set rate(value:int):void
		{
			switch (value)
			{
				case 5:
				case 8:
				case 11:
				case 22:
				case 44:
					_rate = value;
					break;
				default:
					throw new ArgumentError(ResourceManager.getInstance().getString("tlcomponents", "rateArgumentError"));
			}
		}
		//--------------------------------------------------------------------------
		//
		//  encodeQuality
		//
		//--------------------------------------------------------------------------
		private var _encodeQuality:int = 16;
		/**
		 * @inherited 
		 */
		public function get encodeQuality():int
		{
			return _encodeQuality;
		}
		
		/**
		 * @inherited 
		 */
		public function set encodeQuality(value:int):void
		{
			if (value < 0 || value > 10)
				throw new ArgumentError(ResourceManager.getInstance().getString("tlcomponents", "encodeQualityArgumentError"));
			_encodeQuality = value;
		}
		//--------------------------------------------------------------------------
		//
		//  soundData
		//
		//--------------------------------------------------------------------------
		/**
		 * @inherited 
		 */
		protected var _soundData:ByteArray;
		public function get soundData():ByteArray
		{
			if(_soundData)
				return makeStereo(_soundData);
			return _soundData;
		}
		//--------------------------------------------------------------------------
		//
		//  volumeLevel
		//
		//--------------------------------------------------------------------------
		/**
		 * @inherited 
		 */
		public function get volumeLevel():int
		{
			if (microphone)
				return microphone.activityLevel ?microphone.activityLevel / 10 : 0;
			return 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  isRecording
		//
		//--------------------------------------------------------------------------
		private var _isRecording:Boolean = false;
		/**
		 * @inherited 
		 */
		public function get isRecording():Boolean
		{
			return _isRecording;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods : Public
		//
		//--------------------------------------------------------------------------
		/**
		 * If it is recording bails out.
		 * <p/>
		 * Starts Recording if there is a microphone, otherwise dispatches error. 
		 * 
		 */		
		public function startRecord():void
		{
			if(isRecording)
				return;
			scanHardware();
			microphone = Microphone.getMicrophone();
			
			if (microphone) 
			{
				microphone.setSilenceLevel(0, 5000); // 20, 5000 IXT-8902
				microphone.rate = rate;
				microphone.gain = gain;
				microphone.setUseEchoSuppression(true);
				microphone.addEventListener(StatusEvent.STATUS, onMicrophoneStatusChange);
				microphone.addEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
				
				if(!microphone.muted)
					startSilenceTimer();
				
				_isRecording = true;
				_soundData = new ByteArray();
				microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicrophoneSampleData);
				dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.RECORD_START));
			}
			else
			{
				dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.MICROPHONE_ERROR, false, false, ResourceManager.getInstance().getString("tlcomponents", "microphoneNotConnected")));
			}
		}
		
		/**
		 * Stops the recoring and removes event listener from microphone object
		 * 		 
		 * */		
		public function stopRecord(shouldDispatchEvent:Boolean = true):void
		{
			stopSilenceTimer();
			
			if (!_isRecording)
				return;
			
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicrophoneSampleData);
			microphone.removeEventListener(StatusEvent.STATUS, onMicrophoneStatusChange);
			microphone.removeEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
//			microphone = null;
			
			_isRecording = false;
			
			if(shouldDispatchEvent)
				if (_soundData && _soundData.length > 0)
					dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.RECORD_FINISHED));
				else
					dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.RECORD_STOP));
		}

		/**
		 * Stops the recoring and removes event listener from microphone object
		 * 		 
		 * */		
		public function abortRecord():void
		{
			stopSilenceTimer();
			
			if (!_isRecording)
				return;
			
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicrophoneSampleData);
			microphone.removeEventListener(StatusEvent.STATUS, onMicrophoneStatusChange);
			microphone.removeEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
			microphone = null;
			
			_isRecording = false;
			dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.RECORD_STOP));
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			// TODO: implement
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods : Private
		//
		//--------------------------------------------------------------------------
		/**
		 *Handler for <code> SampleDataEvent.SAMPLE_DATA</code> of Microphone obejct
		 * Writes event bytes to <code>sampleData</code> ByteArray
		 * @param event SampleDataEvent deispatched by microphone
		 * 
		 */		
		private function onMicrophoneSampleData( event :SampleDataEvent ) :void 
		{
			_soundData.writeBytes(event.data, 0, event.data.bytesAvailable);
		}
		
		/**
		 * Handler for  <code>StatusEvent </code> dispatched by Microphone
		 * @param event
		 * Recording should start or stop based on this event. If user recjects access to Microphone 
		 * than code of the event is <code>Muted</code>.
		 * 
		 */		
		private function onMicrophoneStatusChange(event:StatusEvent):void 
		{
			if(event.code == "Microphone.Muted")
			{
					stopRecord(false);
					dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.MICROPHONE_ERROR, false, false, ResourceManager.getInstance().getString("tlcomponents", "userRejectedAccess")));
			}
			if(event.code == "Microphone.Unmuted")
			{
				startSilenceTimer();
			}
		}
 		/** 
		 * Handler for  <code>onMicrophoneActivity </code> dispatched by Microphone
		 */ 
		private function onMicrophoneActivity(event:ActivityEvent):void 
		{
			if(event.activating == false)
			{
				stopRecord(false);
				
				dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.TIMEOUT, false, false, ResourceManager.getInstance().getString("tlcomponents", "recordingTimeOut")));
			}
			else if(event.activating)
			{
				stopSilenceTimer();
			}
		}

		/**
		 *  Flash Records as mono, but our RawAudioController works only with stereo // someone rmoved code for handling mono
		 * Therefore we need to convert sound to stereo and send it to RawAudioController 
		 * @param bytes Recorded sound in mono format
		 * @return Recorded sound converted to stereo
		 * 
		 */		
		private function makeStereo(bytes:ByteArray):ByteArray
		{
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
		
		/**
		 * @private
		 * Starts timer
		 */		
		private function startSilenceTimer():void
		{
			if(silenceTimer)
			{
				stopSilenceTimer();
			}
			silenceTimer = new Timer(5000, 1); 
			silenceTimer.addEventListener(TimerEvent.TIMER, onSilenceTimer);
			silenceTimer.start();
		}
		/**
		 * @private
		 * Stops timer
		 * 
		 */		
		private function stopSilenceTimer():void
		{
			if(silenceTimer)
			{
				silenceTimer.removeEventListener(TimerEvent.TIMER, onSilenceTimer);
				silenceTimer = null;
			}
		}
		
		
		/**
		 * Handler for <code>TimerEvent.TIMER</code> of silenceTimer
		 * it stops the timer and recording, and dispatches timeout event 
		 */	
		
		
		private function onSilenceTimer(event:TimerEvent):void
		{
			stopSilenceTimer();
			stopRecord(false);
			dispatchEvent(new SoundRecorderEvent(SoundRecorderEvent.TIMEOUT, false, false, ResourceManager.getInstance().getString("tlcomponents", "recordingTimeOut")));
		}
	}
}
