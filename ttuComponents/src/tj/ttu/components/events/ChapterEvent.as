////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	/**
	 * ChapterEvent class 
	 */
	public class ChapterEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const CHAPTER_TITLE_TEXT_BINDING:String 	= 'chapterTitleTextBinding';
		public static const ADD_NEW_CHAPTER:String				= 'addNewChapter';
		public static const DELETE_CHAPTER:String				= 'deleteChapter';
		public static const SAVE_CHAPTERS:String 				= 'saveChapters';
		public static const RECORD_CHAPTER_AUDIO:String 		= 'recordChapterAudio';
		public static const UPLOAD_CHAPTER_AUDIO:String 		= 'uploadChapterAudio';
		public static const UPLOAD_CHAPTER_VIDEO:String 		= 'uploadChapterVideo';
		public static const INSERT_CHAPTER_IMAGE:String 		= 'insertChapterImage';
		public static const CHANGE_CHAPTER_COMMENT:String 		= 'changeChapterComment';
		public static const CHANGE_CHAPTER_ASSESMENTS:String 	= 'changeChapterAssesments';
		public static const EDIT_CHAPTER_QUESTIONS:String 		= 'editChapterQuestions';
		public static const QUESTION_VIEW_HIDE:String 			= 'questionViewHide';
		public static const TEXT_FLOW_CHANGE:String 			= 'textFlowChange';
		public static const CURRENT_CHAPTER_CHANGE:String 		= 'currentChapterChange';
		public static const SHOW_IMAGE_FULL_SCREEN:String 		= 'showImageFullScreen';
		public static const SHOW_VIDEO_PLAYER:String 			= 'showVideoPlayer';
		public static const EDIT_IMAGE:String 					= 'editImage';
		public static const ORIGINAL_TEXT_FLOW:String			= 'originalTextFlow';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var data:Object;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterEvent 
		 */
		public function ChapterEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
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
			return new ChapterEvent(type, data, bubbles);
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