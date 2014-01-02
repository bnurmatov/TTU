////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.audio
{
	import com.transparent.slowSoundFFT.SlowSoundFFT;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.AudioValues;
	import tj.ttu.base.constants.ResourceConstants;
	
	/**
	 * @copy flash.events.IOErrorEvent
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 *  Dispatched when the <code>volume</code> property 
	 *  changes for the RawAudioController. 
	 */
	[Event(name="volumeChanged", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the sound raw data loaded. 
	 */
	[Event(name="soundDataLoaded", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the <code>position</code> property 
	 *  changes for the RawAudioController. 
	 */
	[Event(name="positionChanged", type="flash.events.Event")]	
	
	/**
	 * @evenType flash.events.Event.SOUND_COMPLETE
	 */
	[Event(name="soundComplete", type="flash.events.Event")]
	
	/**
	 * Class responsible for playing raw data sound
	 */
	public class AudioPlayer extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//  Variables : public
		//--------------------------------------------------------------------------
		/**
		 *  Used to notify about availability of raw sound data.
		 *  When raw sound data is loaded and avilable an event type of <code>SOUND_DATA_LOADED</code>
		 *  is dipatched
		 */ 
		public static const RAW_LOADED:String = "soundDataLoaded";
		
		
		/**
		 *  The constant defines the value of the type property of the event object for an 
		 *  volume Changed event.
		 */		
		public static const VOLUME_CHANGED:String = "volumeChanged";
		
		
		/**
		 *  The constant defines the value of the type property of the event object for an 
		 *  position Changed event.
		 */		
		public static const POSITION_CHANGED:String = "positionChanged";
		
		
		/**
		 *  The constant defines the value of the type property of the event object for an 
		 *  url sound Changed event.
		 */			
		public static const SOUND_URL_CHANGED : String = "soundURLChanged";		
		
		/**
		 *  The constant defines the value of the type property of the event object for an 
		 *  url sound Changed event.
		 */			
		public static const PLAYING_CHANGED : String = "playingChange";		
		
		/** 
		 * Holds numChannels propety  
		 */	
		public var numChannels:uint = 2;

		//--------------------------------------------------------------------------
		//  Variables : private
		//--------------------------------------------------------------------------
		/** 
		 * Size of SampleDataBuffer
		 */
		private const BUFFER_SIZE:uint = 8192;
		
		/** 
		 * Size of SampleDataBuffer
		 */
		private const SAMPLE_RATE:uint = 44100;

		/** 
		 * Main sound object for playing sound 
		 */
		private var snd:Sound;
		
		/** 
		 * Holds reference for sound channel 
		 */
		private var channel:SoundChannel = new SoundChannel();
		
		/** 
		 *  Holds reference for sndTransform
		 */
		private var sndTransform:SoundTransform;
		
		/** 
		 * Holds reference of sndData
		 */
		private var sndData:ByteArray;
		
		/** 
		 *  Internal property for soundLoaded
		 */
		private var soundLoaded:Boolean = false;
		
		/**
		 * A flag that indicates if sound will be playing after loading.
		 */
		private var playAfterLoaded:Boolean = false;
		
		/** 
		 *  A flag that indicates if  sound is paused
		 */
		private var paused:Boolean = false;
		
		/** 
		 *  Slow sound eats or moves some sound data 
		 *  in the begiinig if window in last segment is too short. 
		 *  Therefore we add a 70 ms silent sound in the beginning of slow sound data.
		 */
		private var silanceData:ByteArray;
		
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 */		
		public function AudioPlayer()
		{
			sndTransform = new SoundTransform();
			enabled = false;
			silanceData = generateSilentAudio(0.1);
		}
		
		//--------------------------------------------------------------------------
		//  Variables: Skin Parts
		//--------------------------------------------------------------------------
		
		/** 
		 *  Internal property for soundLoaded
		 */
		private var slow:SlowSoundFFT;
		
		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  normalSoundData
		//--------------------------------------------------------------------------
		/**
		 * 
		 */
		private var _normalSoundData:ByteArray;
		
		public function get normalSoundData():ByteArray
		{
			return _normalSoundData;
		}
		
		/**
		 *  @private
		 */
		public function set normalSoundData(value:ByteArray):void
		{
			_normalSoundData = value;
			sndData = value;
			if (value && value.length > 0)
			{
				slow = new SlowSoundFFT(value);
			}
			else
			{
				silanceData = null;
				channel = null;
				if (slow)
				{
					slow.close();
					slow = null;
				}
			}
			position = 0;			
		}
		
		//--------------------------------------------------------------------------
		//  enabled
		//--------------------------------------------------------------------------
		
		/**
		 * Enables/disables controls.
		 */
		override public function set enabled(value:Boolean):void
		{
			if (value === super.enabled)
				return;
			
			super.enabled = value;
		}
		
		//----------------------------------------------------------------------
		//  muted
		//----------------------------------------------------------------------
		
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 * Storage for the <code>muted</code> property.
		 */
		private var _muted:Boolean = false;
		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		/**
		 *  @private
		 */
		public function set muted(value:Boolean):void
		{
			if (_muted == value)
				return;
			
			_muted = value;
			sndTransform.volume = value ? 0 : _volume;
			
			if(channel)
				channel.soundTransform = sndTransform;
		}
		
		/**
		 * Defines 
		 */		
		private var _useGlobalVolumeSettings:Boolean = false;
		
		/**
		 * Gets or sets if current instance of <code>RawAudioController</code> will auto sync it's volume settings with Unit player. 
		 * @return 
		 * 
		 */		
		public function get useGlobalVolumeSettings():Boolean
		{
			return _useGlobalVolumeSettings;
		}
		
		/**
		 * @private 
		 */		
		public function set useGlobalVolumeSettings(value:Boolean):void
		{
			if (value != _useGlobalVolumeSettings)
			{
				_useGlobalVolumeSettings = value;
				
				/*if (value)
				{
					AudioGlobalSettings.addEventListener(updateVolumeSettings, true);
					AudioGlobalSettings.updateListeners();
				}
				else
				{
					AudioGlobalSettings.removeEventListener(updateVolumeSettings);
				}*/
			}
		}
		
		//----------------------------------------------------------------------
		//  playing
		//----------------------------------------------------------------------
		
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 * Storage for the <code>playing</code> property.
		 */
		private var _playing:Boolean = false;
		
		/**
		 * TODO Nasrullo: Add comment please.
		 */
		[Bindable]
		public function set playing(value:Boolean):void
		{
			_playing = value;
			dispatchEvent(new Event(PLAYING_CHANGED));
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		//----------------------------------------------------------------------
		//  volume
		//----------------------------------------------------------------------
		
		[Inspectable(category="General", defaultValue="0.7")]
		
		/**
		 * Storage for the <code>volume</code> property.
		 */
		private var _volume:Number = 0.7;
		
		
		public function get volume():Number
		{
			return _volume;
		}
		
		/**
		 * @private
		 */
		public function set volume(value:Number):void
		{
			if (isNaN(value) || value == _volume)
				return;
			
			value = value < 0 ? 0 : value;
			
			if (value > 1)
			{
				value = value/100;
			}
			
			_volume = value;
			
			if (value > 0)
			{
				muted = false;
			}
			
			if (channel)
			{
				sndTransform.volume = muted ? 0 : _volume;
				channel.soundTransform = sndTransform;
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------
		//  slowSoundValue
		//--------------------------------------------------------------------------------------------------------------
		private var _slowSoundValue:Number = 1;
		
		/**
		 * Stores sound speed value for sound playback.
		 */
		public function get slowSoundValue():Number
		{
			return _slowSoundValue;
		}
		/**
		 * @private
		 */
		public function set slowSoundValue(value:Number):void
		{
			if(isNaN(value) || value == _slowSoundValue)
				return;
			
			_slowSoundValue = value;
		}
		
		
		//----------------------------------------------------------------------
		//  sndURL
		//----------------------------------------------------------------------
		
		[Inspectable(category="General")]
		
		/**
		 * @private
		 * Internal storage for the <code>sndURL</code> property.
		 */
		private var _sndUrl:String;
		
		/**
		 *  Holds value of current sound url.
		 * 
		 *  @return Url of current sound 
		 */
		public function get sndURL ():String
		{
			return _sndUrl;
		}
		/**
		 * @private 
		 */
		public function set sndURL (value:String):void
		{
			if (playing)
				stop();	

			cleanSrcSound();
			
			var prevUrl:String =  _sndUrl;
			
			_sndUrl = value;

			
			if(!value)
			{
				sndData = null;
				_normalSoundData = null;
				soundLoaded = false;
				return;
			}
			
			
			if (( value == prevUrl ) && soundLoaded )
			{
				play();
			}
			else
			{
				playAfterLoaded = true;
				preloadSound();
			}
			dispatchEvent(new Event(SOUND_URL_CHANGED));
		}
		
		
		//----------------------------------------------------------------------
		//  changeUrl
		//----------------------------------------------------------------------
		
		/**
		 * Set data url and not play sound
		 */
		public function set changeUrl(value:String):void
		{
			if (playing)
				stop();
			
			cleanSrcSound();
			
			if(!value)
			{
				sndData = null;
				_normalSoundData = null;
				soundLoaded = false;
				return;
			}

			playAfterLoaded = false;
			_sndUrl = value;
			preloadSound();
		}
		
		//----------------------------------------------------------------------
		//  play button tooltip
		//----------------------------------------------------------------------
		
		
		/**
		 * @private
		 */
		private var _playButtonTooltip:String;
		
		/**
		 * Tooltip for Play button in the default state.
		 */
		public function get playButtonTooltip():String
		{
			return _playButtonTooltip;
		}
		
		/**
		 * @private
		 */
		public function set playButtonTooltip(value:String):void
		{
			_playButtonTooltip = value;
		}
		
		
		//----------------------------------------------------------------------------------------------------------
		//  useTempo
		//----------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 * Internal storage for the <code>useTempo</code> property.
		 */
		private var _useTempo:Boolean = false;
		
		/**
		 * Storage for the <code>useTempo</code> property.
		 */
		public function get useTempo():Boolean
		{
			return _useTempo;
		}
		
		public function set useTempo(value:Boolean):void
		{
			_useTempo = value;
		}
		
		
		//----------------------------------------------------------------------------------------------------------
		//
		//	Overridden methods
		//
		//----------------------------------------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
		}
		
		//--------------------------------
		//	Overridden method: commitProperties
		//--------------------------------
		
		
		
		//----------------------------------------------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------------------------------------------
		
		//-----------------------------------------------------------------------
		//	Methods: Sound
		//-----------------------------------------------------------------------
		/**
		 * Stops snd  and rewinds it to the begining
		 */ 
		public function stop():void
		{
			position = 0;
			playing = false;
			paused = false;
			playAfterLoaded = false;
			if(snd)
			{
				snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			}
			if(channel)
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlayComplete);
				channel = null;
			}
		}
		
		/**
		 * 	Stops Sound
		 *  but does not rewind it to the begining
		 */
		public function pause():void
		{
			paused = true;
			
			if (!snd)
				return;
			
			snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			if(channel)
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlayComplete);
				channel = null;
			}
			
			playing = false;
			
			playAfterLoaded = false;
		}
		
		/**
		 * Play Sound
		 */
		public function play(resume:Boolean = false):void
		{
			/////////// it is necessary to fix the IXT-14509
			position = _position;
			////////////////////////
			
			if(!_normalSoundData)
				return;
			
			if( _playing )
				stop();
			
			if(!resume)
				position = 0; 
			
			startPlayBack(resume);	
		}
		
		private var srcSound:Sound;		
		
		/**
		 * @private
		 * Load mp3 file
		 */
		private function preloadSound():void
		{
			soundLoaded = false;
			
			sndData = null;
			_normalSoundData = null;
			
			if (sndURL == null)
				return;
			
			try
			{
				srcSound = new Sound();
				srcSound.addEventListener(Event.COMPLETE, sound_CompleteHandler, false, 0, true);
				srcSound.addEventListener(IOErrorEvent.IO_ERROR, sound_ErrorHandler, false, 0, true);
				
				srcSound.load(new URLRequest(sndURL));
			}
			catch(e: Event)
			{
				trace( e.toString() );
			}			
		}			
		
		/**
		 * @private
		 * Create, play or resume sound.
		 */
		protected function startPlayBack(resume:Boolean = false):void
		{
			
			if(snd)
			{
				snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				snd = null;
			}
			snd = new Sound();
			snd.addEventListener( SampleDataEvent.SAMPLE_DATA, onSampleData, false, 0, true );
			snd.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			
			if(sndData && sndData.position == sndData.length)
				sndData.position = 0;
			
			var curPos:Number = position < duration? position : 0;
			sndTransform.volume = muted ? 0 : volume;
			channel = snd.play(curPos);
			playing = true;
			if (!channel) //this happens when no Audio device is found in OS
			{
				stop();
				dispatchEvent(new Event(Event.SOUND_COMPLETE));
				return;
			}
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundPlayComplete, false, 0, true);
			channel.soundTransform = sndTransform;
		}
		
		/**
		 * @private
		 * Used for data cleaning and controller disabling.
		 */
		protected function clearDataDisableController():void
		{
			soundLoaded = false;
			normalSoundData = null;
			this.enabled = false;			
		}
		
		/**
		 * @private
		 * Used for handling sound loaded complete event.
		 */
		protected function sound_CompleteHandler(event:Event):void
		{
			srcSound.removeEventListener(Event.COMPLETE, sound_CompleteHandler);
			srcSound.removeEventListener(IOErrorEvent.IO_ERROR, sound_ErrorHandler);
			
//			if (!srcSound || (srcSound.bytesTotal > AudioValues.MAX_SOUND_LENGTH))
			if (!srcSound)
			{
				clearDataDisableController();
				srcSound = null;
				if (hasEventListener(IOErrorEvent.IO_ERROR))
					dispatchEvent(new IOErrorEvent( IOErrorEvent.IO_ERROR, 
						false, false, 
						resourceManager.getString(ResourceConstants.TTU_COMPONENTS, "maxSoundSizeExceeded",[AudioValues.MAX_SOUND_LENGTH]) ));
				
				return;
			}
			
			soundLoaded = true;
			normalSoundData = extractMp3Data(srcSound);
			srcSound = null;
			position = 0;
			
			dispatchEvent(new Event(RAW_LOADED));
			if (playAfterLoaded)
			{
				playAfterLoaded = false;
				play();
			}
		}
		
		/**
		 * @private
		 * Used for handling IOError events.
		 */
		protected function sound_ErrorHandler(event:IOErrorEvent):void
		{
			srcSound.removeEventListener(Event.COMPLETE, sound_CompleteHandler);
			srcSound.removeEventListener(IOErrorEvent.IO_ERROR, sound_ErrorHandler);
			srcSound = null;
			clearDataDisableController();
			// was crush 
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		
		
		/**
		 * Stop Sound play and close channel  
		 * and close sound.
		 */
		public function close():void
		{
			if(channel)
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlayComplete);
				channel = null;
			}
			if(snd && snd.isBuffering)
			{
				try
				{
					snd.close();
				}
				catch(e:Error){}
				
			}
			if(snd)
			{
				snd = null;
			}
		}
		
		
		/**
		 * Duration of the sound in millicesonds
		 * @return Returns duration of current sound as Number(float)
		 */ 
		public function get duration():Number 
		{
			if (!sndData)
				return 0;
			
			var frames:int  = sndData.length /(4 * numChannels);
			return (frames / SAMPLE_RATE);
		}
		/**
		 * @return Length of Bytes for given milleseconds
		 */ 
		public function getDataLengthByMilliseconds(dur:Number):Number
		{
			dur = dur * SAMPLE_RATE;
			return dur * (4 * numChannels);
		}
		/**
		 * Position of the sound in millicesonds
		 * Calculates current positions in milliseconds and returns it.
		 * @return Returns position of current sound in milliseconds as Number(float)
		 */
		[Inspectable(category="General")]
		private var _position:Number =0; 
		public function get position():Number 
		{
			if(!sndData)
				return 0;
			var pos:Number = sndData.position;
			_position = (pos /(4 * numChannels))/SAMPLE_RATE ;
			return _position 
		}
		/**
		 * Position of the sound in millicesonds
		 * @param Position in milliseconds
		 * Converts milliseconds to byte position and sets 
		 * the position of the raw sound ByteArray to it
		 */
		public function set position(value:Number):void 
		{
			if (isNaN( value ) || (value < 0.0001))
				value = 0;
			
			if(sndData)
			{
				if (value < duration)
				{
					_position = value;
					sndData.position = (_position * SAMPLE_RATE)*(4 * numChannels);
				}
				else
				{
					_position = duration;
					sndData.position = sndData.length;
				}
			}
			dispatchEvent(new Event ( POSITION_CHANGED ));
		}

		
		/**
		 * Handles SampleData Event  
		 * It has data property of type of ByteArray, length of which is 8192 bytes.
		 * As soon as this buffer is empty this ivent is fired and 
		 * we need to refill it starting from current position of raw sound data
		 *  
		 */ 
		private function onSampleData(event:SampleDataEvent):void 
		{
			if (!sndData && snd)
			{
				snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				trace("RawAudioController null sound reference");
				return;
			}
			if (!slow || sndData.bytesAvailable == 0)
				return;
			var slowValue:Number = useTempo? slowSoundValue : 1;
			var dataSlow:ByteArray = new ByteArray();
			dataSlow = slow.sampleData(slowValue*100, position);
			if (dataSlow && dataSlow.length > 0)
			{
				event.data.writeBytes(dataSlow, 0, dataSlow.length);
				_position = _position + dataSlow.length * slowValue/ SAMPLE_RATE / (4 * numChannels);
				position = _position;
			}
		}
		
		/**
		 * @private
		 */
		private function onIOErrorEvent(event:Event):void
		{
			
			var dispatcher:IEventDispatcher = event.target as IEventDispatcher;
			dispatcher.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
		}
		/**
		 * @private
		 * Extracts sound data form loaded mp3 file
		 */
		private function extractMp3Data(src:Sound):ByteArray 
		{
			var mp3Data:ByteArray = new ByteArray();
			var bytesExtracted:Number = Number.MAX_VALUE;

			if(!silanceData)
			{
				silanceData = generateSilentAudio(0.1);
			}
			mp3Data.writeBytes(silanceData, 0, silanceData.length);
			mp3Data.position = mp3Data.length;
			
			
			// extract method return number of extracted bytes. 
			//if tehre is no frames left it returns 0 
			
			while( bytesExtracted > 0)
			{
				bytesExtracted = src.extract(mp3Data, BUFFER_SIZE * 4 * numChannels);
			}
			mp3Data.position = mp3Data.length;
			mp3Data.writeBytes(silanceData, 0, silanceData.length);
			mp3Data.position = 0;
			return mp3Data;
		}
		
		
		/**
		 * @private
		 * Generates silent aduioData for givn legth in milliseconds
		 *  
		 */
		private function generateSilentAudio(dur:Number):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			var len:int = dur * SAMPLE_RATE;
			for(var i:int =0; i< len; i++)
			{
				ba.writeFloat(0);
				ba.writeFloat(0);
			}
			ba.position = 0;
			return ba;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		/*private function updateVolumeSettings(event:VolumeSettingsEvent):void
		{
			volume = event.volume;
			slowSoundValue = event.soundSpeed;
			muted = event.muted;
			useTempo = event.useTempo;
		}
		*/
		/**
		 * @private
		 */
		public function cleanSrcSound():void
		{
			if(srcSound)
			{
				try
				{
					srcSound.removeEventListener(Event.COMPLETE, sound_CompleteHandler);
					srcSound.removeEventListener(IOErrorEvent.IO_ERROR, sound_ErrorHandler);
					
					// don't check srcSound.isBuffering
					// sould be closed anyway 
					// Error #2044: Unhandled IOErrorEvent:. text=Error #2032: Stream Error.
					// if(srcSound.isBuffering && srcSound.bytesLoaded < srcSound.bytesTotal)
					
					srcSound.close();
				}
				catch(e: IOError)
				{
					trace( e.toString() );
				}
			}
			srcSound = null;
		}

		/**
		 * @private
		 */
		private function onSoundPlayComplete(event:Event = null):void 
		{
			if (snd)
				snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			if(channel)
				channel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlayComplete);
			position = 0; 
			playing = false;
			paused = false;
			playAfterLoaded = false;
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
}