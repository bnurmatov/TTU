////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 2, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.clone
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * CloneLessonCompleteCommand class 
	 */
	public class CloneLessonCompleteCommand extends BaseAirCommand
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
		 * CloneLessonCompleteCommand 
		 */
		public function CloneLessonCompleteCommand()
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
			if(lessonAdapterProxy && lessonAdapterProxy.currentLesson)
			{
				AssetsUtil.copyLocalLessonAssets(lessonAdapterProxy.sourceLessonUuid, lessonAdapterProxy.sourceLessonVersion, lessonAdapterProxy.currentLesson.guid, lessonAdapterProxy.currentLesson.version);
				sendNotification(CourseServiceNotification.LESSON_CLONED, lessonAdapterProxy.currentLesson);
				lessonAdapterProxy.cleanUp();
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