////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.retrieve
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * RetrieveLessonResourceCommand class 
	 */
	public class RetrieveLessonResourceCommand extends BaseAirCommand
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
		 * RetrieveLessonResourceCommand 
		 */
		public function RetrieveLessonResourceCommand()
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
			var serviceVO:ResourceServiceVO = notification.getBody() as ResourceServiceVO;
			if(resourceAdapterProxy && serviceVO)
			{
				resourceAdapterProxy.serviceVO = serviceVO;
				resourceAdapterProxy.retrieveResourcesByLessonUuid( serviceVO.lessonUuid, CourseAirConstants.RETRIEVE_LESSON_RESOURCES_COMPLETE);
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