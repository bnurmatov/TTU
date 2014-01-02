////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.remove
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * RemoveResourceAssetsFromDiskCommand class 
	 */
	public class RemoveResourceAssetsFromDiskCommand extends BaseAirCommand
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
		 * RemoveResourceAssetsFromDiskCommand 
		 */
		public function RemoveResourceAssetsFromDiskCommand()
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
			if(resourceAdapterProxy && resourceAdapterProxy.serviceVO)
			{
				var serviceVo:ResourceServiceVO = resourceAdapterProxy.serviceVO;
				var resource:ResourceVO = serviceVo.resource;
				var fileName:String;
				
				if(resource && !StringUtil.isNullOrEmpty(resource.resourcePath))
				{
					fileName = FileNameUtil.getFileName(resource.resourcePath);
					AssetsUtil.deleteResourceFromLocalStorage(serviceVo.lessonUuid, serviceVo.lessonVersion, fileName);
				}
				
				resourceAdapterProxy.cleanUp();
				sendNotification(CourseServiceNotification.RESOURCE_REMOVED);
			}
			else
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, "Error delete resource. Current resource service vo is not set.");
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