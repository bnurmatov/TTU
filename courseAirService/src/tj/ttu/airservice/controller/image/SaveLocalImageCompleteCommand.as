////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 17, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.image
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SaveLessonImageCompleteCommand class 
	 */
	public class SaveLocalImageCompleteCommand extends BaseAirCommand
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
		 * SaveLessonImageCompleteCommand 
		 */
		public function SaveLocalImageCompleteCommand()
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
		override public function execute( notification:INotification ) : void
		{
			if(imageAdapterProxy && imageAssetsProxy)
			{
				var image:ImageVO = imageAdapterProxy.currentImage;
				var mediaVo:MediaVO = imageAssetsProxy.mediaVo;
				image = AssetsUtil.prependRootPathForSingleImage(mediaVo.lessonUuid, mediaVo.lessonVersion, image);
				image.binarySource = null;
				image.image = null;
				sendNotification(CourseServiceNotification.IMAGE_ASSOCIATED, image);
				imageAdapterProxy.cleanUp();
				imageAssetsProxy.cleanUp();
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