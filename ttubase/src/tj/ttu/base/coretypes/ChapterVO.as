////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.coretypes
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.collections.IList;
	import flash.events.Event;
	
	/**
	 * ChapterVO class 
	 */
	public class ChapterVO extends EventDispatcher
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
		/**
		 *  chapter id.
		 */
		public var id:String;
		/**
		 *  Lesson UUID.
		 */
		public var lessonUuid:String;
		/**
		 *  CHapter UUID
		 */
		public var chapterUuid:String;
		/**
		 *  Lesson creation date.
		 */
		public var creationDate:Date;
		
		/**
		 *  Lesson Last Modified  date.
		 */
		public var lastModifiedDate:Date;
		
		/**
		 *  Position of Chapter.
		 */
		public var position:int;
		
		/**
		 *   Version of the Chapter
		 */
		public var version:int;
		
		/**
		 *  Published flag of the Chapter
		 */
		[Bindable]
		public var isPublished:Boolean;
		
		/**
		 *  Published flag of the Chapter
		 */
		public var textFlow:TextFlow;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterVO 
		 */
		public function ChapterVO(target:IEventDispatcher=null)
		{
			super(target);
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
		// text
		//------------------------------------------
		private var _text:String;

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
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
		// images
		//------------------------------------------
		private var _images:IList;

		[ArrayElementType("tj.ttu.base.vo.ImageVO")]
		public function get images():IList
		{
			return _images;
		}

		public function set images(value:IList):void
		{
			_images = value;
		}

		//------------------------------------------
		// sounds
		//------------------------------------------
		private var _sounds:IList;

		[ArrayElementType("tj.ttu.base.vo.SoundVO")]
		public function get sounds():IList
		{
			return _sounds;
		}

		public function set sounds(value:IList):void
		{
			_sounds = value;
		}

		//------------------------------------------
		// videoList
		//------------------------------------------
		private var _videoList:IList;

		[ArrayElementType("tj.ttu.base.vo.VideoVO")]
		public function get videoList():IList
		{
			return _videoList;
		}

		public function set videoList(value:IList):void
		{
			if( _videoList !== value)
			{
				_videoList = value;
			}
		}

		//------------------------------------------
		// questions
		//------------------------------------------
		private var _questions:IList;

		public function get questions():IList
		{
			return _questions;
		}

		public function set questions(value:IList):void
		{
			_questions = value;
		}

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