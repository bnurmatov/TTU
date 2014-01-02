////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package com.transparent.slowSoundFFT
{
	/**
	 * Fourier pseudo-polar class
	 */
	public class MathImaginary
	{
		
		/**
		 * Multiplication function
		 */
		public static function multiplication(multiplicand:Vector.<Number>, multiplicandIndex:uint, factor:Vector.<Number>, factorIndex:uint, product:Vector.<Number>, productIndex:uint, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				product[productIndex+i] = multiplicand[multiplicandIndex+i] * factor[factorIndex+i];
		}
		
		/**
		 * Multiplication imaginary function
		 */
		public static function multiplicationImaginary(imaginary:Vector.<Number>, product:Vector.<Number>, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				product[i] = product[i] * imaginary[i];
		}
		
		/**
		 * Addition imaginary function
		 */
		public static function additionImaginary(imaginary:Vector.<Number>, imaginaryIndex:uint, sum:Vector.<Number>, sumIndex:uint, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				sum[sumIndex+i] = sum[sumIndex+i] + imaginary[imaginaryIndex+i];
		}
		
		/**
		 * Phase function
		 */
		public static function phaseComplex(real:Vector.<Number>, imaginary:Vector.<Number>, phase:Vector.<Number>, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				phase[i] = Math.atan2(imaginary[i], real[i]);
		}
		
		/**
		 * Magnitude function
		 */
		public static function magnitudeComplex(real:Vector.<Number>, imaginary:Vector.<Number>, magnitude:Vector.<Number>, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				magnitude[i] = Math.sqrt(imaginary[i] * imaginary[i] + real[i] * real[i]);
		}
		
		/**
		 * Clear function
		 */
		public static function clearVector(vector:Vector.<Number>, index:uint, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				vector[index+i] = 0;
		}
		
		/**
		 * Move function
		 */
		public static function moveVector(vector:Vector.<Number>, indexOne:uint, indexTwo:uint, numTransform:uint) : void
		{
			var i:uint;
			if (indexTwo < indexOne)
			{
				for (i = 0; i < numTransform; i++)
					vector[indexTwo+i] = vector[indexOne+i];
			}
			else if (indexTwo > indexOne)
			{
				indexOne = indexOne + (numTransform - 1);
				indexTwo = indexTwo + (numTransform - 1);
				for (i = 0; i < numTransform; i++)
					vector[indexTwo-i] = vector[indexOne-i];
			}
		}
		
		/**
		 * Copy function
		 */
		public static function copyVector(source:Vector.<Number>, sourceIndex:uint, destination:Vector.<Number>, destinationIndex:uint, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
				destination[destinationIndex+i] = source[sourceIndex+i];
		}

		/**
		 * Revert to complex
		 */
		public static function polarToComplex(magnitude:Vector.<Number>, phase:Vector.<Number>, real:Vector.<Number>, imaginary:Vector.<Number>, numTransform:uint) : void
		{
			for (var i:uint = 0; i < numTransform; i++)
			{
				
				real[i] = magnitude[i] * Math.cos(phase[i]);
				imaginary[i] = magnitude[i] * Math.sin(phase[i]);
			}
		}
		
	}
}
