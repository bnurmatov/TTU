////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 12, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.upload
{
	import flash.net.FileReference;
	
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.utils.SupportedFileFormat;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * ResourceContentDataLoadedCommand class 
	 */
	public class ResourceContentDataLoadedCommand extends BaseAirCommand
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
		 * ResourceContentDataLoadedCommand 
		 */
		public function ResourceContentDataLoadedCommand()
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
			if(notification.getBody() && resourceAssetProxy && resourceAdapterProxy)
			{
				// get file ref, and save extension type for use later in import
				var fileReference:FileReference = notification.getBody() as FileReference;
				var mediaType:String = SupportedFileFormat.extractFileType(fileReference);
				
				// check supported sound
				if(SupportedMediaFormat.isPDF(mediaType))
				{
					var resource:ResourceVO						= resourceAssetProxy.mediaVo.resource;
					resourceAssetProxy.mediaType 				= mediaType;
					resourceAssetProxy.mediaVo.binaryContent 	= fileReference.data;
					resourceAssetProxy.mediaVo.fileName 		= UIDUtil.createUID() + resourceAssetProxy.mediaType;
					resource.resourcePath						= AssetsUtil.RESOURCE_PATH + resourceAssetProxy.mediaVo.fileName;
					if(resourceAssetProxy.mediaVo.binaryContent)
					{
						resourceAssetProxy.writeResourceToDisk();
						resourceAdapterProxy.updateResourcePath(resource, CourseAirConstants.UPLOAD_RESOURCE_CONTENT_COMPLETE, true)
					}
				}
				else
				{
					var errorMessage:String = 'Not Supported File Format Message : ' + mediaType;					
					sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, errorMessage);
				}
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