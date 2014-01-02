////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 19, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.controller.popups.ShowChapterCommentPopup;
	import tj.ttu.coursecreatorbase.controller.popups.ShowCourseManagePopup;
	import tj.ttu.coursecreatorbase.controller.popups.ShowEditImagePopupCommand;
	import tj.ttu.coursecreatorbase.controller.popups.ShowInsertImagePopup;
	import tj.ttu.coursecreatorbase.controller.popups.ShowSoundRecorderPopup;
	import tj.ttu.coursecreatorbase.controller.popups.ShowUnsavedPopup;
	import tj.ttu.coursecreatorbase.controller.state.CreateLessonStateChangeCommand;
	import tj.ttu.coursecreatorbase.controller.state.MainViewStateChangeCommand;
	
	/**
	 * RegisterCommands class 
	 */
	public class RegisterCommands extends SimpleCommand
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
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * RegisterCommands 
		 */
		public function RegisterCommands()
		{
			super();
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
		override public function execute(notification:INotification):void
		{
			facade.registerCommand( CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP, ShowCourseManagePopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_SOUND_RECORDER_WINDOW, ShowSoundRecorderPopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_CLONE_LESSON_POPUP, ShowCourseManagePopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_INSERT_IMAGE_WINDOW, ShowInsertImagePopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_EDIT_IMAGE_POPUP, ShowEditImagePopupCommand );
			facade.registerCommand( CourseCreatorNotifications.SHOW_EDIT_LESSON_DETAILS_POPUP, ShowCourseManagePopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_CHAPTER_COMMENT_POPUP, ShowChapterCommentPopup );
			facade.registerCommand( CourseCreatorNotifications.SHOW_UNSAVED_POPUP, ShowUnsavedPopup);
			facade.registerCommand( CourseCreatorNotifications.MAIN_VIEW_STATE_CHANGE, MainViewStateChangeCommand);
			facade.registerCommand( CourseCreatorNotifications.CREATE_LESSON_STATE_CHANGE, CreateLessonStateChangeCommand);
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