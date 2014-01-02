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
	
	/**
	 * RemoveCommand class 
	 */
	public class RemoveCommand extends SimpleCommand
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
		 * RemoveCommand 
		 */
		public function RemoveCommand()
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
			facade.removeCommand( CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP );
			facade.removeCommand( CourseCreatorNotifications.SHOW_SOUND_RECORDER_WINDOW);
			facade.removeCommand( CourseCreatorNotifications.SHOW_CLONE_LESSON_POPUP);
			facade.removeCommand( CourseCreatorNotifications.SHOW_INSERT_IMAGE_WINDOW);
			facade.removeCommand( CourseCreatorNotifications.SHOW_EDIT_IMAGE_POPUP);
			facade.removeCommand( CourseCreatorNotifications.SHOW_EDIT_LESSON_DETAILS_POPUP);
			facade.removeCommand( CourseCreatorNotifications.SHOW_CHAPTER_COMMENT_POPUP);
			facade.removeCommand( CourseCreatorNotifications.SHOW_UNSAVED_POPUP);
			facade.removeCommand( CourseCreatorNotifications.MAIN_VIEW_STATE_CHANGE);
			facade.removeCommand( CourseCreatorNotifications.CREATE_LESSON_STATE_CHANGE);
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