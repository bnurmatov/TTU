////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;
	
	/**
	 * WavConverter class 
	 */
	public class WAVConverter
	{
		
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
		
		
		/**
		 * 	@private
		 *  Used for resampling channels where input channels > output channels
		 */
		private var tempValueSum:Number = 0;
		/**
		 * 	@private
		 *  Used for resampling channels where input channels > output channels
		 */
		private var tempValueCount:int = 0;
		
		//-------------------------------------------------------------------
		// Properties
		//-------------------------------------------------------------------
		
		/**
		 * 	The sampling rate, in Hz, for the data in the WAV file.
		 * 
		 * 	@default 44100
		 */
		public var samplingRate:Number = 44100;
		
		/**
		 * 	The audio sample bit rate.  Has to be set to 8, 16, 24, or 32.
		 * 
		 * 	@default 16
		 */		
		public var sampleBitRate:int = 16; // ie: 16 bit wav file
		
		/**
		 * 	The number of audio channels in the WAV file.
		 * 
		 * 	@default 2
		 */	
		public var numOfChannels:int = 2;
		
		/**
		 * 	The WAV header compression code value.  The default is the PCM 
		 *  code.
		 * 
		 * 	@default 1 
		 */	
		public var compressionCode:int = 1;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * WavConverter 
		 */
		public function WAVConverter()
		{
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * 	@private
		 * 	Create WAV header bytes
		 */
		private function header(dataOutput:IDataOutput, fileSize:Number):void
		{
			dataOutput.writeUTFBytes("RIFF");
			dataOutput.writeUnsignedInt(fileSize); // Size of whole file
			dataOutput.writeUTFBytes("WAVE");
			// WAVE Chunk
			dataOutput.writeUTFBytes("fmt ");	// Chunk ID
			dataOutput.writeUnsignedInt(16);	// Header Chunk Data Size
			dataOutput.writeShort(compressionCode); // Compression code - 1 = PCM
			dataOutput.writeShort(numOfChannels); // Number of channels
			dataOutput.writeUnsignedInt(samplingRate); // Sample rate
			dataOutput.writeUnsignedInt(samplingRate * (numOfChannels * sampleBitRate / 8)); // Byte Rate == SampleRate * NumChannels * BitsPerSample/8
			dataOutput.writeShort(numOfChannels * sampleBitRate / 8); // Block align == NumChannels * BitsPerSample/8
			dataOutput.writeShort(sampleBitRate); // Bits Per Sample
		}
		
		/**
		 * 	Resample the <code>dataInput</code> audio data into the WAV format.
		 *  Writing the output to the <code>dataOutput</code> object.
		 * 
		 * 	<p>The <code>dataOutput.endian</code> will be set to <code>Endian.LITTLE_ENDIAN</code>
		 *  with the header and data written out on the data stream. The <code>dataInput</code>
		 *  will set the position = 0 and read all bytes in the <code>ByteArray</code> as samples.
		 * 
		 * 	
		 *  </p>
		 * 
		 * 	@param dataOutput The IDataOutput object that you want the WAV formated bytes to be written to.
		 *  @param dataInput 	The audio sample data in float format.
		 * 	@param inputSamplingRate The sampling rate of the <code>dataInput</code> data.
		 *  @param inputNumChannels	The number of audio changes in <code>dataInput</code> data.
		 *  	
		 */
		public function processSamples(dataInput:ByteArray, inputSamplingRate:int, inputNumChannels:int = 1):ByteArray
		{
			if (!dataInput || dataInput.bytesAvailable <= 0) // Return if null
				throw new Error("No audio data");
			
			var outputData:ByteArray = new ByteArray();
			
			// 16 bit values are between -32768 to 32767.
			var bitResolution:Number = (Math.pow(2, sampleBitRate)/2)-1;
			var soundRate:Number = samplingRate / inputSamplingRate;
			var dataByteLength:int = ((dataInput.length/4) * soundRate * sampleBitRate/8);
			// data.length is in 4 bytes per float, where we want samples * sampleBitRate/8 for bytes
			var fileSize:int = 32 + 8 + dataByteLength;
			// WAV format requires little-endian
			outputData.endian = Endian.LITTLE_ENDIAN;  
			// RIFF WAVE Header Information
			header(outputData, fileSize);
			// Data Chunk Header
			outputData.writeUTFBytes("data");
			outputData.writeUnsignedInt(dataByteLength); // Size of whole file
			
			// Write data to file
			dataInput.position = 0;
			var tempData:ByteArray = new ByteArray();
			tempData.endian = Endian.LITTLE_ENDIAN;
			
			
			
			// Write to file in chunks of converted data.
			while (dataInput.bytesAvailable > 0) 
			{
				tempData.clear();
				// Resampling logic variables
				var minSamples:int = Math.min(dataInput.bytesAvailable/4, 8192);
				var readSampleLength:int = minSamples;//Math.floor(minSamples/soundRate);
				var resampleFrequency:int = 100;  // Every X frames drop or add frames
				var resampleFrequencyCheck:int = (soundRate-Math.floor(soundRate))*resampleFrequency;
				var soundRateCeil:int = Math.ceil(soundRate);
				var soundRateFloor:int = Math.floor(soundRate);
				var jlen:int = 0;
				var channelCount:int = (numOfChannels-inputNumChannels);
				/*
				trace("resampleFrequency: " + resampleFrequency + " resampleFrequencyCheck: " + resampleFrequencyCheck
				+ " soundRateCeil: " + soundRateCeil + " soundRateFloor: " + soundRateFloor);
				*/
				var value:Number = 0;
				// Assumes data is in samples of float value
				for (var i:int = 0;i < readSampleLength;i+=4)
				{
					value = dataInput.readFloat();
					// Check for sanity of float value
					if (value > 1 || value < -1)
						throw new Error("Audio samples not in float format");
					
					// Special case with 8bit WAV files
					if (sampleBitRate == 8)
						value = (bitResolution * value) + bitResolution;
					else
						value = bitResolution * value;
					
					// Resampling Logic for non-integer sampling rate conversions
					jlen = (resampleFrequencyCheck > 0 && i % resampleFrequency < resampleFrequencyCheck) ? soundRateCeil : soundRateFloor; 
					for (var j:int = 0; j < jlen; j++)
					{
						writeCorrectBits(tempData, value, channelCount);
					}
				}
				outputData.writeBytes(tempData);
			}
			return outputData;
		}
		
		/**
		 * 	@private
		 * 	Change the audio sample to the write resolution
		 */
		private function writeCorrectBits(outputData:ByteArray, value:Number, channels:int):void
		{
			// Handle case where input channels > output channels.  Sum values and divide values
			if (channels < 0)
			{
				if (tempValueCount+channels == 1)
				{
					value = int(tempValueSum/tempValueCount);
					tempValueSum = 0;
					tempValueCount = 0;
					channels = 1;
				}
				else
				{
					tempValueSum += value;
					tempValueCount++;
					return;
				}
			}
			else
			{
				channels++;
			}
			// Now write data according to channels
			for (var i:int = 0;i < channels; i++) 
			{
				if (sampleBitRate == 8)
					outputData.writeByte(value);
				else if (sampleBitRate == 16)
					outputData.writeShort(value);
				else if (sampleBitRate == 24)
				{
					outputData.writeByte(value & 0xFF);
					outputData.writeByte(value >>> 8 & 0xFF); 
					outputData.writeByte(value >>> 16 & 0xFF);
				}
				else if (sampleBitRate == 32)
					outputData.writeInt(value);
				else
					throw new Error("Sample bit rate not supported");
			}
		}
	}
}