////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.upload
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * UploadLocalResourceContentCompleteCommand class 
	 */
	public class UploadLocalResourceContentCompleteCommand extends BaseAirCommand
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
		 * UploadLocalResourceContentCompleteCommand 
		 */
		public function UploadLocalResourceContentCompleteCommand()
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
			if(resourceAdapterProxy && resourceAssetProxy)
			{
				var mediaVo:MediaVO = resourceAssetProxy.mediaVo;
				var resource:ResourceVO = resourceAdapterProxy.currentResource;
				resource = AssetsUtil.prependRootPathForSingleResource(mediaVo.lessonUuid, mediaVo.lessonVersion, resource);
				sendNotification(CourseServiceNotification.RESOURCE_CONTENT_UPLOADED, resource);
				resourceAdapterProxy.cleanUp();
				resourceAssetProxy.cleanUp();
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