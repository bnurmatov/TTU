////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Bindable]
	/**
	 * ResourceVO class 
	 */
	public class ResourceVO extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const BOOK					:String = 'BOOK';
		public static const INTERNET_RESOURCE		:String = 'INTERNET_RESOURCE';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 *  Resouce id.
		 */
		public var id:String;
		/**
		 *  Lesson UUID.
		 */
		public var lessonUuid:String;
		/**
		 *  Resouce UUID
		 */
		public var resourceUuid:String;
		
		/**
		 *  Position of Resouce.
		 */
		public var position:int;
		
		/**
		 *   Version of the Resouce
		 */
		public var version:int;
		
		/**
		 *  Published flag of the Chapter
		 */
		public var isPublished:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ResourceVO 
		 */
		public function ResourceVO()
		{
			super(null);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------
		// title
		//------------------------------------------
		private var _title:String;
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		//------------------------------------------
		// url
		//------------------------------------------
		private var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		//------------------------------------------
		// resourceNativePath
		//------------------------------------------
		private var _resourceNativePath:String;

		public function get resourceNativePath():String
		{
			return _resourceNativePath;
		}

		public function set resourceNativePath(value:String):void
		{
			if( _resourceNativePath !== value)
			{
				_resourceNativePath = value;
			}
		}

		//------------------------------------------
		// resourcePath
		//------------------------------------------
		private var _resourcePath:String;

		public function get resourcePath():String
		{
			return _resourcePath;
		}

		public function set resourcePath(value:String):void
		{
			_resourcePath = value;
		}
		
		
		//------------------------------------------
		// comment
		//------------------------------------------
		private var _comment:String;
		
		public function get comment():String
		{
			return _comment;
		}
		
		public function set comment(value:String):void
		{
			_comment = value;
		}
		
		//------------------------------------------
		// resouceType
		//------------------------------------------
		private var _resouceType:String = BOOK;

		[Bindable(event="resouceTypeChange")]
		public function get resouceType():String
		{
			return _resouceType;
		}

		public function set resouceType(value:String):void
		{
			if( _resouceType !== value)
			{
				_resouceType = value;
				dispatchEvent(new Event("resouceTypeChange"));
			}
		}
	
	}
}