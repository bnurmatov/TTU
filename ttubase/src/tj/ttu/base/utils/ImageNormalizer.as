////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	
	
	/**
	 * ImageEncoder class 
	 */
	public class ImageNormalizer
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
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @private 
		 */
		static public function normalizeAndEncode(bitmapData:BitmapData, encoder:IImageEncoder=null):ByteArray
		{
			if(!bitmapData)
				return null;
			
			encoder = encoder || new PNGEncoder();
			bitmapData = normalize(bitmapData);
			
			return encoder.encode(bitmapData);
		}
		
		/**
		 * @private 
		 */		
		static public function normalize(bitmapData:BitmapData, maxWidth:Number = NaN, maxHeight:Number = NaN):BitmapData 
		{
			if(!bitmapData)
				return null;
			
			const _maxWidth:Number 	= maxWidth 	? Math.min(maxWidth	, SupportedMediaFormat.IMAGE_MAX_WIDTH) 	: SupportedMediaFormat.IMAGE_MAX_WIDTH;
			const _maxHeight:Number = maxHeight ? Math.min(maxHeight, SupportedMediaFormat.IMAGE_MAX_HEIGHT) 	: SupportedMediaFormat.IMAGE_MAX_HEIGHT;
			
			if(bitmapData.width > _maxWidth || bitmapData.height > _maxHeight)
			{
				var factor:Number = Math.min(_maxWidth / bitmapData.width, _maxHeight / bitmapData.height);
				var tmpBitmapData:BitmapData = new BitmapData(bitmapData.width * factor, bitmapData.height * factor);
				var m:Matrix = new Matrix();   
				m.scale(factor, factor);
				tmpBitmapData.draw(bitmapData, m);
				return tmpBitmapData;
			}
			
			return bitmapData;
		}
		
		static public function normalizeForText(bitmapData:BitmapData):BitmapData 
		{
			const _maxWidth:Number 	= 320;
			const _maxHeight:Number = 240;
			
			if(bitmapData.width > _maxWidth || bitmapData.height > _maxHeight)
			{
				var factor:Number = Math.min(_maxWidth / bitmapData.width, _maxHeight / bitmapData.height);
				var tmpBitmapData:BitmapData = new BitmapData(bitmapData.width * factor, bitmapData.height * factor);
				var m:Matrix = new Matrix();   
				m.scale(factor, factor);
				tmpBitmapData.draw(bitmapData, m);
				return tmpBitmapData;
			}
			
			return bitmapData;
		}		
		static public function normalizeForSize(bitmapData:BitmapData, width:Number, height:Number):BitmapData 
		{
			const _maxWidth:Number 	= width;
			const _maxHeight:Number = height;
			var factor:Number = Math.min(_maxWidth / bitmapData.width, _maxHeight / bitmapData.height);
			var tmpBitmapData:BitmapData = new BitmapData(bitmapData.width * factor, bitmapData.height * factor);
			var m:Matrix = new Matrix();   
			m.scale(factor, factor);
			tmpBitmapData.draw(bitmapData, m);
			return tmpBitmapData;
			
		}		
	}
}