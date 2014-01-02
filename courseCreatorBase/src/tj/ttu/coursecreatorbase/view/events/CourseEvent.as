////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 20, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.events
{
	import flash.events.Event;
	
	/**
	 * CourseEvent class 
	 */
	public class CourseEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const CREATE_LESSON					:String = 'createLesson';
		public static const SAVE_LESSON						:String = 'saveLesson';
		public static const CLONE_LESSON					:String = 'cloneLesson';
		public static const PREVIEW_LESSON					:String = 'previewLesson';
		public static const SAVE_SOUND						:String = 'saveSound';
		public static const SHOW_CREATE_LESSON_WINDOW		:String = 'showCreateLessonWindow';
		public static const SHOW_EDIT_LESSON_DETAILS_WINDOW	:String = 'showEditLessonDetailsWindow';
		public static const SHOW_UNSAVED_POPUP				:String = 'showUnsavedPopup';
		public static const RETURN_TO_MY_LESSONS			:String = 'returnToMyLessons';
		public static const INSERT_IMAGE					:String = 'insertImage';
		public static const EDIT_IMAGE						:String = 'editImage';
		public static const UPDATE_IMAGE					:String = 'updateImage';
		public static const REMOVE_IMAGE					:String = 'removeImage';
		public static const MICROPHONE_CONFIGURED			:String = "microphoneConfigured";
		public static const HAS_CHANGE						:String = "hasChange";
		public static const CANCEL_PREVIOUSE_ACTION			:String = "cancelPreviouseCction";
		public static const BACK_TO_PREVIOUS_SCREEN			:String = "backToPreviousScreen";
		public static const NEXT							:String = "next";
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
		 * CourseEvent 
		 */
		public function CourseEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new CourseEvent(type, data);
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