////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 2, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.clone
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.coretypes.LessonVO;
	
	/**
	 * PrepareCloneLessonCommand class 
	 */
	public class PrepareCloneLessonCommand extends BaseAirCommand
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
		 * PrepareCloneLessonCommand 
		 */
		public function PrepareCloneLessonCommand()
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
			if(lessonAdapterProxy && lesson)
			{
				lessonAdapterProxy.clonningLesson = lesson;
				lessonAdapterProxy.sourceLessonUuid = lesson.guid;
				lessonAdapterProxy.sourceLessonVersion = lesson.version;
				lessonAdapterProxy.shouldGetChapters = true;
				lessonAdapterProxy.getLessonByUuid(lesson.guid, CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE, CourseAirConstants.CLONE_LOCAL_LESSON);
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