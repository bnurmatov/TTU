////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 30, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.update
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.coretypes.LessonVO;
	
	/**
	 * UpdateLessonCommand class 
	 */
	public class UpdateLocalLessonChaptersCommand extends BaseAirCommand
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
		 * UpdateLessonCommand 
		 */
		public function UpdateLocalLessonChaptersCommand()
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
			var lesson:LessonVO = notification.getBody() as LessonVO;
			if(chapterAdapterProxy && lesson)
			{
				chapterAdapterProxy.updateChapters(lesson.chapters, CourseAirConstants.UPDATE_LOCAL_LESSON_CHAPTERS_COMPLETE);
			}
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