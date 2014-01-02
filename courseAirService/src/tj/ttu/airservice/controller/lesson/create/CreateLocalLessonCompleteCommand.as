////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 27, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.create
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * CreateLocalLessonCompleteCommand class 
	 */
	public class CreateLocalLessonCompleteCommand extends BaseAirCommand
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
		 * CreateLocalLessonCompleteCommand 
		 */
		public function CreateLocalLessonCompleteCommand()
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
		override public function execute(note:INotification):void
		{
			if(lessonAdapterProxy.currentLesson )
			{
				if(!lessonAdapterProxy.currentLesson.chapters)
					lessonAdapterProxy.currentLesson.chapters = [];
				if(!lessonAdapterProxy.currentLesson.resources)
					lessonAdapterProxy.currentLesson.resources = [];
			}
			sendNotification(CourseServiceNotification.LESSON_CREATED, lessonAdapterProxy.currentLesson);
			lessonAdapterProxy.cleanUp();
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