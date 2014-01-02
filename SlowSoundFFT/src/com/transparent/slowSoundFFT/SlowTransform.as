﻿////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
﻿package com.transparent.slowSoundFFT
{
	import com.transparent.slowSoundFFT.FFT.FFT2;
	
	
	public class SlowTransform extends Object
	{
		private var fft:FFT2;
		private var numSamples:uint = 0;
		private var magnitude:Vector.<Vector.<Number>>;
		private var mulFactor:Vector.<Number>;
		private var tempRe:Vector.<Number>;
		private var tempIm:Vector.<Number>;
		private var specReLeft:Vector.<Number>;
		private var specReRight:Vector.<Number>;
		private var tempBuffer:Vector.<Vector.<Number>>;
		private var phaseLeft:Vector.<Number>;
		private var phaseRight:Vector.<Number>;
		private var resultPhase:Vector.<Vector.<Number>>;
		private const NUM_CHANNELS:uint = 2;
		private var LENGHT:uint = 0;
		private var specImLeft:Vector.<Number>;
		private var specImRight:Vector.<Number>;
		
		
		/**
		 * Constructor
		 */		
		public function SlowTransform()
		{
		}
		
		/**
		 * Process vocoder function
		 */	
		public function transform(tempSource:Vector.<Vector.<Number>>, pitch:uint, tempDestination:Vector.<Vector.<Number>>, stepPosition:uint, phaseShift:Boolean = false) : void
		{
			var temp:Vector.<Number> = null;
			for (var i:int = 0; i < NUM_CHANNELS; i++)
			{
				MathImaginary.moveVector(tempBuffer[i], numSamples, 0, LENGHT - numSamples);
				MathImaginary.clearVector(tempBuffer[i], LENGHT - numSamples, numSamples);
				MathImaginary.multiplication(tempSource[i], 0, mulFactor, 0, tempRe, 0, LENGHT);
				MathImaginary.multiplication(tempSource[i], 1, mulFactor, 0, tempIm, 0, (LENGHT - 1));
				tempIm[(LENGHT - 1)] = 0;
				twoInOneForward(tempRe, tempIm, specReLeft, specImLeft, specReRight, specImRight);
				MathImaginary.magnitudeComplex(specReLeft, specImLeft, magnitude[i], LENGHT / 2);
				if (phaseShift == false)
				{
					MathImaginary.phaseComplex(specReLeft, specImLeft, phaseLeft, LENGHT / 2);
					MathImaginary.phaseComplex(specReRight, specImRight, phaseRight, LENGHT / 2);
					temp = resultPhase[i];
					for (var j:int = 0; j < LENGHT / 2; j++)
						temp[j] = temp[j] + numSamples * (phaseRight[j] - phaseLeft[j]);
				}
				else
					MathImaginary.phaseComplex(specReLeft, specImLeft, resultPhase[i], LENGHT / 2);
			}
			MathImaginary.polarToComplex(magnitude[0], resultPhase[0], specReLeft, specImLeft, LENGHT / 2);
			MathImaginary.polarToComplex(magnitude[1], resultPhase[1], specReRight, specImRight, LENGHT / 2);
			twoInOneInverse(specReLeft, specImLeft, specReRight, specImRight, tempRe, tempIm);
			MathImaginary.multiplicationImaginary(mulFactor, tempRe, LENGHT);
			MathImaginary.additionImaginary(tempRe, 0, tempBuffer[0], 0, LENGHT);
			MathImaginary.multiplicationImaginary(mulFactor, tempIm, LENGHT);
			MathImaginary.additionImaginary(tempIm, 0, tempBuffer[1], 0, LENGHT);
			MathImaginary.copyVector(tempBuffer[0], 0, tempDestination[0], stepPosition, numSamples);
			MathImaginary.copyVector(tempBuffer[1], 0, tempDestination[1], stepPosition, numSamples);
		}
		
		/**
		 * Initial vocoder function
		 */		
		public function init(log2Len:uint) : void
		{
			LENGHT = 1 << log2Len;
			numSamples = LENGHT / 4;
			fft = new FFT2();
			fft.init(log2Len);
			mulFactor = new Vector.<Number>(LENGHT);
			var i:uint;
			for (i = 0; i < LENGHT; i++)
			{
				mulFactor[i] = 0.5 * (1 - Math.cos(2 * Math.PI * i / LENGHT));
			}
			tempBuffer = new Vector.<Vector.<Number>>(NUM_CHANNELS);
			for (i = 0; i < NUM_CHANNELS; i++)
			{
				
				tempBuffer[i] = new Vector.<Number>(LENGHT);
				MathImaginary.clearVector(tempBuffer[i], 0, LENGHT);
			}
			phaseLeft = new Vector.<Number>(LENGHT, true);
			phaseRight = new Vector.<Number>(LENGHT, true);
			tempRe = new Vector.<Number>(LENGHT, true);
			tempIm = new Vector.<Number>(LENGHT, true);
			specReLeft = new Vector.<Number>(LENGHT, true);
			specReRight = new Vector.<Number>(LENGHT, true);
			specImLeft = new Vector.<Number>(LENGHT, true);
			specImRight = new Vector.<Number>(LENGHT, true);
			magnitude = new Vector.<Vector.<Number>>(2);
			resultPhase = new Vector.<Vector.<Number>>(2);

			for (i = 0; i < NUM_CHANNELS; i++)
			{
				resultPhase[i] = new Vector.<Number>(LENGHT);
				magnitude[i] = new Vector.<Number>(LENGHT);
				MathImaginary.clearVector(resultPhase[i], 0, LENGHT);
				MathImaginary.clearVector(magnitude[i], 0, LENGHT);
			}
		}
		/**
		 * Direct conversion FFT.
		 *    		 
		 */
		final public function twoInOneForward(tempRe:Vector.<Number>, tempIm:Vector.<Number>, specRe0:Vector.<Number>, specIm0:Vector.<Number>, specRe1:Vector.<Number>, specIm1:Vector.<Number>) : void
		{
			fft.run(tempRe, tempIm);
			var k:uint = LENGHT - 1;
			for (var i:uint = 1; i < LENGHT / 2; i++)
			{
				
				specRe0[i] = (tempRe[i] + tempRe[k]) / 2;
				specIm0[i] = (tempIm[i] - tempIm[k]) / 2;
				specRe1[i] = (tempIm[i] + tempIm[k]) / 2;
				specIm1[i] = -(tempRe[i] - tempRe[k]) / 2;
				k--;
			}
			specRe0[0] = tempRe[0] / 2;
			specIm0[0] = 0;
			specRe1[0] = tempIm[0] / 2;
			specIm1[0] = 0;
			return;
		}
		
		/**
		 * Reverse conversion FFT.
		 */
		final public function twoInOneInverse(specRe0:Vector.<Number>, specIm0:Vector.<Number>, specRe1:Vector.<Number>, specIm1:Vector.<Number>, tempRe:Vector.<Number>, tempIm:Vector.<Number>) : void
		{
			var j:uint = LENGHT - 1;
			for (var i:uint = 1; i < LENGHT / 2 ; i++)
			{
				
				tempRe[i] = specRe0[i] - specIm1[i]; 
				tempIm[i] = specIm0[i] + specRe1[i];
				
				tempRe[j] = specRe0[i] + specIm1[i];
				tempIm[j] = specRe1[i] - specIm0[i];
				j--;
			}
			tempIm[0] = 0;
			tempRe[0] = 0;
			tempIm[LENGHT / 2] = 0;
			tempRe[LENGHT / 2] = 0;
			fft.run(tempRe, tempIm, true);
			return;
		}

		/**
		 * Destructor vocoder function
		 */		
		public function close() : void
		{
			if (fft)
				fft.close();
			fft = null;
			mulFactor = null;
			tempBuffer = null;
			phaseLeft = null;
			phaseRight = null;
			tempRe = null;
			tempIm = null;
			specReLeft = null;
			specImLeft = null;
			specReRight = null;
			specImRight = null;
			resultPhase = null;
			magnitude = null;
		}
		
	}
}
