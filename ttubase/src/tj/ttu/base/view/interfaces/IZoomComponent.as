
////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 8, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.interfaces
{
	import flash.geom.Rectangle;

	public interface IZoomComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function get viewRect():Rectangle;
		function get bitmapScaleFactorMin():Number;
		function set bitmapScaleFactorMin(value:Number):void;
		function get bitmapScaleFactorMax():Number;
		function set bitmapScaleFactorMax(value:Number):void;
		function get bitmapScaleFactor():Number;
		function set bitmapScaleFactor(value:Number):void;
		function zoom(direction:String):void;
	}
	
	
}
