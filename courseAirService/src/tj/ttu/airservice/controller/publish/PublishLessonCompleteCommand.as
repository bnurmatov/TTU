////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.publish
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * PublishLessonCompleteCommand class 
	 */
	public class PublishLessonCompleteCommand extends BaseAirCommand
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
		 * PublishLessonCompleteCommand 
		 */
		public function PublishLessonCompleteCommand()
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
			if(publishLessonProxy && publishLessonProxy.lesson && notification.getBody())
			{
				var artifacts:Array = notification.getBody() as Array;
				artifacts = AssetsUtil.prependRootPathForArtifacts(publishLessonProxy.serviceVO.lessonUuid, publishLessonProxy.serviceVO.lessonVersion, artifacts );
				publishLessonProxy.lesson.artifacts = artifacts;
				sendNotification(CourseServiceNotification.LESSON_PUBLISHED, publishLessonProxy.lesson.artifacts);
				publishLessonProxy.cleanUp();
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