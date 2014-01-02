////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package com.transparent.slowSoundFFT.FFT
{
	/**
	 * Fast Fourier element class
	 */
	public class FFTElement
	{
		public var re:Number = 0.0;   // Real component
		public var im:Number = 0.0;   // Imaginary component
		public var next:FFTElement = null; // Next element in linked list
		public var revTgt:uint;    // Target position post bit-reversal
	}
}