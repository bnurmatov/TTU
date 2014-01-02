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
	 * CloneLessonCommand class 
	 */
	public class CloneLessonCommand extends BaseAirCommand
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
		 * CloneLessonCommand 
		 */
		public function CloneLessonCommand()
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
			var lessons:Array = notification.getBody() as Array;
			var lesson:LessonVO = lessons ? lessons[0] as LessonVO : null;
			if(lesson && lessonAdapterProxy && lessonAdapterProxy.clonningLesson)
			{
				lesson.name 		= lessonAdapterProxy.clonningLesson.name;
				lesson.departmentId = lessonAdapterProxy.clonningLesson.departmentId;
				lesson.specialityId = lessonAdapterProxy.clonningLesson.specialityId;
				lesson.discipline 	= lessonAdapterProxy.clonningLesson.discipline;
				lessonAdapterProxy.currentLesson = lesson;
				lessonAdapterProxy.createLesson(lesson, true, CourseAirConstants.CLONE_LOCAL_LESSON_COMPLETE);
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