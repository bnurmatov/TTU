////////////////////////////////////////////////////////////////////////////////
// Copyright 2009, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.sound
{
	import flash.display.GraphicsPathCommand;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import spark.components.Group;
	
	import tj.ttu.components.skins.sound.ErrorSoundLoadingSkin;
	
	/**
	 * Canvas for displaying Wave form 
	 */ 
	public class WaveForm extends Group
	{
		private var errorGroup:ErrorSoundLoadingSkin = new ErrorSoundLoadingSkin();
		
		//-------------------------------------------------------------------------
		// Variables
		//-------------------------------------------------------------------------
	
		/** Sound player Object */
		public var numChannels:uint =2;
		
		/** isDrawing */
		private var isDrawing:Boolean = false;
		
		/** oldWidth */
		private var oldWidth:Number = 0;
		
		/** oldHeight */
		private var oldHeight:Number = 0;

		/** scale value */
		private var _scaleView:Number = 1;
		
		public function get scaleView():Number
		{
			return _scaleView;
		}

		public function set scaleView(value:Number):void
		{
			_scaleView = value;
		}
		
		private var _sampleRate:int = 44100;
		
		public function get sampleRate():int
		{
			return _sampleRate;
		}
		
		public function set sampleRate(value:int):void
		{
			if (value <=0)
				throw new ArgumentError(resourceManager.getString("tlcomponents","waveFormSampleRateError"));
			_sampleRate = value;
		}
		
		//-------------------------------------------------------------------------
		// Constructor
		//-------------------------------------------------------------------------
		/**
		 * Constructor.
		 */
		public function WaveForm()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.errorGroup.verticalCenter = 0;
			this.errorGroup.horizontalCenter = 0;
		}
		//-------------------------------------------------------------------------
		// Properties
		//-------------------------------------------------------------------------
		
		//-------------------------------------------------------------------------
		// duration
		//-------------------------------------------------------------------------
		/**
		 * @private
		 */
		public function get duration():Number 
		{
			if(_sndBytes)
			{
				var frames:int  = _sndBytes.length /(8/numChannels);
				return (frames / sampleRate);
			}
			return 0;
		}
		
		//-------------------------------------------------------------------------
		// sndBytes
		//-------------------------------------------------------------------------
		/** 
		 * Hold raw bytes of sound 
		 */
		private var _sndBytes:ByteArray = new ByteArray();
		/**
		 *  @private
		 */ 
		public function set sndBytes(value:ByteArray):void
		{
			 
			if(!value || value.length == 0)
			{
				_sndBytes = null;
				graphics.clear();
				return;
			}
			var oldPos:uint = value.position;
			value.position = 0;
			_sndBytes = new ByteArray();
			_sndBytes.writeBytes(value, 0, value.length);
			_sndBytes.position = 0;
			value.position = oldPos; 
			//drawWave();
			drawError = false;
			needRedraw = true;
			invalidateProperties();
		}
		private var needRedraw:Boolean = false;
		
		private var _drawError:Boolean = false
		public function get drawError():Boolean
		{
			return _drawError;
		}
		
		public function set drawError(value:Boolean):void
		{
			_drawError = value;
			needRedraw = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (needRedraw)
			{
				needRedraw = false;
				drawWave();
			}
		}
		
		//-------------------------------------------------------------------------
		// waveColor
		//-------------------------------------------------------------------------
		
		/**
		 * @private
		 * waveColor
		 */
		private var _waveColor:uint;
		
		/**
		 *  @private
		 */ 
		public function set waveColor(value:uint):void
		{
			_waveColor = value;
		}
		/**
		 *  @private
		 */ 
		public function get waveColor():uint
		{
			return _waveColor;
		}
		//-------------------------------------------------------------------------
		// width
		//-------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		
		//-------------------------------------------------------------------------
		// height
		//-------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		//-------------------------------------------------------------------------
		// Method :  public 
		//-------------------------------------------------------------------------
		
		
		//-------------------------------------------------------------------------
		// Overriden methods : protected
		//-------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(uw:Number, uh:Number) : void
		{
			super.updateDisplayList(uw, uh);
			if((oldWidth != uw ||oldHeight !=uh) && (_sndBytes || drawError) )
			{
				oldWidth = uw;
				oldHeight = uh;
				drawWave();
			}
		}
		
		//-------------------------------------------------------------------------
		// Private methods
		//-------------------------------------------------------------------------
		/**
		 * Draws wave form of the sound. 
		 * Used new drawPath method of Flash player 10. 
		 */  
		private function drawWave():void
		{
			if (drawError && !errorGroup.parent)
			{
				this.addElement(errorGroup);
				return;
			}
			if (!drawError && errorGroup.parent)
			{
				this.removeElement(errorGroup);
			}
			
			if(isDrawing || !_sndBytes || drawError )
				return;
			
			
			
			if (_sndBytes && _sndBytes.length == 0)
				return;
			
			isDrawing = true;
			
			var commandVector:Vector.<int> = new Vector.<int>();
			
			var dataVector:Vector.<Number> = new Vector.<Number>();
			
			var mid:uint 	= height/2;
			
			/** 
			 * 4 is size of step  since readFloat() reads 4 bytes
			 * 44100 sample rate of sound. It is always 44100 for row sound data
			 */ 
			var divisor:Number =(numChannels ==2)?16:4
			
			var stepInTime:Number = (divisor/8)/sampleRate;
			
			var pixelsPerStep:Number  = width/duration;
			
			pixelsPerStep = (pixelsPerStep * stepInTime);
			
			_sndBytes.position = 0;
			
			graphics.clear();
			
			graphics.lineStyle(1,waveColor,1);
			
			var step:Number = 0;
			var oldStep:int = -1;
			commandVector.push(GraphicsPathCommand.MOVE_TO);
			
			dataVector.push(0, mid);
			
			var len:int = _sndBytes.length;
			//necessarily a multiple of 4. At one point on the screen, two reading
			var stepForByteArray:int = int((_sndBytes.length / width) / 4 /2); 
			// at least 2 values at the point screen
			var stepPixel:Number = 1/2;
			
			for(var i:int =0; i < width; i++)
			{
				var max:Number = -1;
				var min:Number = 1;
				for (var j:int = 0; j< stepForByteArray; j++)
				{
					if(_sndBytes.bytesAvailable < 8)
						break;
					var val:Number = _sndBytes.readFloat() * scaleView;
					// Check correct value, should be inside -1..1
					if(val > 1) val = 1;
					else if(val < -1) val = -1;
					if (val < min)
					{
						min =val;
					}
					if (val > max)
					{
						max = val;
					}
					_sndBytes.readFloat(); //skip stereo
				}
				
				var waveHeight:Number = mid +(max*mid);
				
				commandVector.push(GraphicsPathCommand.LINE_TO);
				
				dataVector.push(Number(i), waveHeight);
				waveHeight = mid +(min*mid);
				
				commandVector.push(GraphicsPathCommand.LINE_TO);
				
				dataVector.push(Number(i)+stepPixel, waveHeight);
				
			}
			
			commandVector.push(GraphicsPathCommand.LINE_TO);
			dataVector.push(i, mid);

			commandVector.push(GraphicsPathCommand.LINE_TO);
			dataVector.push(width, mid);
			
			graphics.drawPath(commandVector, dataVector);
			
			graphics.moveTo(0, mid);
			
			cacheAsBitmap = true;
			
			commandVector = null;
			
			dataVector = null;
			
			_sndBytes.position = 0;
			
			isDrawing = false;
		}
		
		/**
		 * @private
		 */
		private function onAddedToStage(event:Event):void
		{
			drawWave();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		/**
		 * @private
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.ctrlKey)
			{
				switch(event.keyCode)
				{
					case Keyboard.RIGHT:
						width += 100;
						break;
					case Keyboard.LEFT:
						width -= 100;
						break;
					case Keyboard.UP:
						height += 100;
						break;
					
					case Keyboard.DOWN:
						height -= 100;
						break;
				}
				width 	= width  < 0 ? 0 : width;
				height 	= height < 0 ? 0 : height;
				drawWave();
			}
		}
		
		/**
		 * @private
		 */
		private function onRemovedFromStage(event:Event):void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
	}
}