////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 12, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.events.font
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * FontEvent class 
	 */
	public class FontEvent extends ProgressEvent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const FONT_LOAD_PROGRESS	:String = "fontLoadProgress";
		
		public static const FONT_LOAD_ERROR		:String = "fontLoadError";
		
		public static const FONT_REGISTERED		:String = "fontRegistered";
		
		public static const COMPLETE			:String = "complete";
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public  var fontName:String;
		
		public var text:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * FontEvent 
		 */
		public function FontEvent(type:String, 
								  bubbles:Boolean=false, 
								  cancelable:Boolean=false,
								  fontName:String=null,
								  bytesLoaded:uint=0, 
								  bytesTotal:uint=0, 
								  text:String ="")
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
			
			this.fontName = fontName;
			this.text = text;
			
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
		override public function clone():Event
		{
			return new FontEvent(type, bubbles, cancelable, fontName, bytesLoaded, bytesTotal, text);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		
	}
}