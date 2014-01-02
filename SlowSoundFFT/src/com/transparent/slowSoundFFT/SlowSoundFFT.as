////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package com.transparent.slowSoundFFT
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.controls.Alert;

	/**
	 * Slow Sound class on Fast Fourier transform
	 */
	public class SlowSoundFFT
	{
		private var timePosition:Number= 0;

		private const  LOG2LEN:uint = 10;
		private const  SAMPLE_RATE:uint = 44100;
		private const  BUFFER_SIZE:uint = 2048;
		private const  STEP:uint = (1 << LOG2LEN) / 4;
		private const  LENGHT:uint= 1 << LOG2LEN;
		private const  STEP_PER_BUFFER:uint = BUFFER_SIZE / STEP;
		
		private var sourceTempVector:Vector.<Vector.<Number>>;
		
		private var lastOutLeftChannal:Number = 0;
		private var lastOutRightChannal:Number = 0;
		private var destinationSampleData:Vector.<Vector.<Number>>;
		private var slowTransform:SlowTransform;
		private var samplesAvailable:uint;
		private var sourseData:ByteArray = new ByteArray()
		
		/**
		 * Constructor
		 */		
		public function SlowSoundFFT(data:ByteArray)
		{
			if (!data || data.length == 0)
				return;
			sourceTempVector = new Vector.<Vector.<Number>>(2);
			sourceTempVector[0] = new Vector.<Number>(LENGHT);
			sourceTempVector[1] = new Vector.<Number>(LENGHT);
			destinationSampleData = new Vector.<Vector.<Number>>(2);
			destinationSampleData[0] = new Vector.<Number>(BUFFER_SIZE);
			destinationSampleData[1] = new Vector.<Number>(BUFFER_SIZE);
			slowTransform = new SlowTransform();
			slowTransform.init(LOG2LEN);
			sourseData = data;
		}
		
		/**
		 * Slow Sound process
		 */		
		public function sampleData(speed:Number, positionValue:Number):ByteArray
		{
			if (!sourseData || sourseData.length == 0)
				return null;
			samplesAvailable = sourseData.length / 4;
			timePosition = positionValue;
			var i:uint;
			var position:uint = timePosition * SAMPLE_RATE / 2;
			var currentPosition:Number;
			var j:uint;
			var currentIndex:uint;
			var nextIndex:uint;
			var shiftOfCurrentIndex:Number;
			var shiftOfNextIndex:Number;
			var currentHighBytes:Number;
			var currentLowBytes:Number;
			var nextHighBytes:Number;
			var nextLowBytes:Number;
			var tempRe:Number;
			var tempIm:Number;
			var leftSample:Number;
			var rightSample:Number;
			
			if (speed != 100)
			{
				for (i = 0; i < STEP_PER_BUFFER; i++)
				{
					if (timePosition * SAMPLE_RATE < (samplesAvailable - 1))
					{
						position = timePosition * SAMPLE_RATE;
						currentPosition = timePosition * SAMPLE_RATE;
						sourseData.position = position * 8;
					}
					else
					{
						position = samplesAvailable - 1;
						currentPosition = samplesAvailable - 1;
						timePosition = samplesAvailable / SAMPLE_RATE;
						sourseData.position = position * 8;
					}
					j = 0;
					if (timePosition > 0)
					{
						while (j < LENGHT)
						{
							currentIndex = Math.floor(currentPosition);
							nextIndex = currentIndex + 1;
							shiftOfCurrentIndex = currentPosition - currentIndex;
							shiftOfNextIndex = nextIndex - currentPosition;
							if (sourseData.bytesAvailable >= 16)
							{
								currentHighBytes = sourseData.readFloat();
								currentLowBytes = sourseData.readFloat();
								nextHighBytes = sourseData.readFloat();
								nextLowBytes = sourseData.readFloat();
							}
							else
								break;
							tempRe = shiftOfNextIndex * currentHighBytes + shiftOfCurrentIndex * nextHighBytes;
							tempIm = shiftOfNextIndex * currentLowBytes + shiftOfCurrentIndex * nextLowBytes;
							sourceTempVector[0][j] = tempRe;
							sourceTempVector[1][j] = tempIm;
							currentPosition = currentPosition + 1;
							j = j + 1;
						}
					}
					while (j < LENGHT)
					{
						//fill the rest buffer with zeroes	
						sourceTempVector[0][j] = 0;
						sourceTempVector[1][j] = 0;
						j++;
					}
					slowTransform.transform(sourceTempVector, 0, destinationSampleData, i * STEP, false);
					timePosition = timePosition + 0.01 * speed * STEP / SAMPLE_RATE;
					sourseData.position = timePosition * SAMPLE_RATE * 8;
					if (timePosition * SAMPLE_RATE > (samplesAvailable - 1))
					{
						timePosition = samplesAvailable/SAMPLE_RATE;
						sourseData.position = sourseData.length;
					}
					
				} //end of < steps per chunk
			}
			var resultSampleData:ByteArray = new ByteArray();
			if (speed == 100)
			{
				if (sourseData.length > position * 16 - 1)
					sourseData.position = position * 16;
				else
					return null;
				var len:int = BUFFER_SIZE;
				if (sourseData.bytesAvailable / 16 < BUFFER_SIZE)
					len = sourseData.bytesAvailable / 16 - 1;
				for (i = 0; i < len; i++) 
				{
					resultSampleData.writeFloat(sourseData.readFloat());
					resultSampleData.writeFloat(sourseData.readFloat());
					resultSampleData.writeFloat(sourseData.readFloat());
					resultSampleData.writeFloat(sourseData.readFloat());
				}
			}
			else
			{
				var lastOutChannal:Number = 0;
				for (i = 0; i < BUFFER_SIZE; i++) 
				{
					leftSample = destinationSampleData[0][i];
					rightSample = destinationSampleData[1][i];
					resultSampleData.writeFloat(0.5 * (leftSample + lastOutLeftChannal)); //smooth
					resultSampleData.writeFloat(0.5 * (rightSample + lastOutRightChannal));//smooth
					resultSampleData.writeFloat(leftSample);
					resultSampleData.writeFloat(rightSample);
					lastOutLeftChannal = leftSample;
					lastOutRightChannal = rightSample;
				}
			}
			resultSampleData.position = 0;
			return resultSampleData;
		}

		/**
		 * Destructor
		 */		
		public function close():void
		{
			if (slowTransform)
			{
				slowTransform.close();
				slowTransform = null;
			}
			sourceTempVector = null;
			destinationSampleData = null;
			sourseData = null;
		}
	}
}