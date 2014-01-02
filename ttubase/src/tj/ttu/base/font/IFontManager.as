
////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 13, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.font
{
	import flash.events.IEventDispatcher;

	public interface IFontManager extends IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function load(fontURL:String):void;
		/**
		 * Stops the loading of the font 
		 */		
		function close():void;
		
	}
	
	
}
