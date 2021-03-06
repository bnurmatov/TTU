////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.utils.ByteArray;

	/**
	 * VideoVO class 
	 */
	public class VideoVO
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		public static const LEFT	:String = "left";
		
		public static const RIGHT	:String = "right";
		
		public static const TOP		:String = "top";
		
		public static const BOTTOM	:String = "bottom";
		
		public static const START	:String = "start";
		
		public static const END		:String = "end";
		
		public static const CENTER	:String = "center";
		
		public static const NONE	:String = "none";
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Video url
		 */
		public var videoUrl:String;
		/**
		 * Sound content
		 */
		public var binarySource:ByteArray;
		
		/**
		 * Image location enum : The float to assign (String value, none for inline with text, left/right/start/end for float)
		 */
		public var location:String = NONE;
		
		
		/**
		 * Sound location into text
		 */
		public var textPosition:int;
		
		/**
		 * padding to left of media
		 */
		public var paddingLeft:Number = 0;
		
		/**
		 * padding to right of media 
		 */
		public var paddingRight:Number = 0;
		
		/**
		 * padding to top of media
		 */
		public var paddingTop:Number = 0;
		
		/**
		 * padding to botton of media 
		 */
		public var paddingBottom:Number = 0;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * VideoVO 
		 */
		public function VideoVO()
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