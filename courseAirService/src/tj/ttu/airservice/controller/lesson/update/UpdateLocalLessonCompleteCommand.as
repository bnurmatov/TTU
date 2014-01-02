////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 30, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.update
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * UpdateListCompleteCommand class 
	 */
	public class UpdateLocalLessonCompleteCommand extends BaseAirCommand
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
		 * UpdateListCompleteCommand 
		 */
		public function UpdateLocalLessonCompleteCommand()
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
			if(lessonAdapterProxy && lessonAdapterProxy.currentLesson && imageAdapterProxy)
			{
				imageAdapterProxy.getImagesByTargetUuid(lessonAdapterProxy.currentLesson.guid, CourseAirConstants.GET_IMAGES_BY_TARGET_UUID_COMPLETE);
				lessonAdapterProxy.currentLesson.aboutCreatorImages = imageAdapterProxy.currentImages;
				lessonAdapterProxy.currentLesson = AssetsUtil.prependRootPathForLesson( lessonAdapterProxy.currentLesson );
				sendNotification(CourseServiceNotification.LESSON_UPDATED, lessonAdapterProxy.currentLesson);
				lessonAdapterProxy.cleanUp();
				imageAdapterProxy.cleanUp();
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