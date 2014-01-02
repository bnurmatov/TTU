////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * InsertImageVO class 
	 */
	public class ImageVO extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
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
		 *
		 */
		/**
		 * Image url
		 */
		public var imageUrl:String;
		
		/**
		 * Image url
		 */
		public var image:Object;
		
		/**
		 * Image url
		 */
		public var originalImageUrl:Object;
		/**
		 * Image url
		 */
		public var binarySource:ByteArray;
		/**
		 * Image width
		 */
		public var width:String;
		
		/**
		 * Image height
		 */
		public var height:String;
		
		/**
		 * Image location enum : The float to assign (String value, none for inline with text, left/right/start/end for float)
		 */
		public var location:String = NONE;
		
		/**
		 * Image location into text
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
		 * InsertImageVO 
		 */
		public function ImageVO(target:IEventDispatcher=null)
		{
			super(target);
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