////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 13, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.image
{
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.model.image.ImageAssetProxy;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * PrepareSaveLocalLessonImageCommand class 
	 */
	public class SaveLocalImageCommand extends BaseAirCommand
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
		 * PrepareSaveLocalLessonImageCommand 
		 */
		public function SaveLocalImageCommand()
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
			var mediaVO:MediaVO = note.getBody() as MediaVO;
			if(mediaVO)
			{
				imageAssetsProxy.mediaVo = mediaVO;
				if(mediaVO.imageVO && mediaVO.imageVO.image)
				{
					var imageVo:ImageVO = mediaVO.imageVO;
					mediaVO.fileName = UIDUtil.createUID() + ImageAssetProxy.DEFAULT_IMAGE_TYPE;
					imageVo.imageUrl = AssetsUtil.IMAGE_PATH + mediaVO.fileName;
					mediaVO.binaryContent = imageVo.binarySource;
					mediaVO.imageVO = imageVo;
					
					if(imageAdapterProxy)
					{
						imageAdapterProxy.currentImage = imageVo;
						imageAdapterProxy.addNewImage(mediaVO, CourseAirConstants.SAVE_LOCAL_IMAGE_COMPLETE, true);
					}
				}
				else
				{
					fileRefferenceProxy.browseForImage(CourseAirConstants.IMAGE_DATA_LOADED,
						CourseServiceNotification.SAVE_IMAGE_CANCELED, null, null, TTUConstants.SPIN_START );
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