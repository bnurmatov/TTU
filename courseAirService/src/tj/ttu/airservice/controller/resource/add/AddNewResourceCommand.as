////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.add
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * AddNewResourceCommand class 
	 */
	public class AddNewResourceCommand extends BaseAirCommand
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
		 * AddNewResourceCommand 
		 */
		public function AddNewResourceCommand()
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
			var result:Array = note.getBody() as Array;
			if(result && result.length > 0 && resourceAdapterProxy)
			{	
				var resourceServiceVO:ResourceServiceVO = resourceAdapterProxy.serviceVO;
				var prevPos:int = uint(result[0].max_resource_position);
				resourceServiceVO.resource.position = prevPos + 1;
				resourceServiceVO.resource.lessonUuid = resourceServiceVO.lessonUuid;
				resourceAdapterProxy.addNewResource(resourceServiceVO.resource, CourseAirConstants.ADD_NEW_LOCAL_RESOURCE_COMPLETE, true);
				
				// set lesson's changed property
				if(lessonAdapterProxy)
					lessonAdapterProxy.changedLesson(resourceServiceVO.lessonUuid);
			}
			else
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, "Add New Resource - Resources not found in local storage.");
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