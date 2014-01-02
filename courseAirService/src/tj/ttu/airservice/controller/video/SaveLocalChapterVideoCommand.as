////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.video
{
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SaveLocalChapterVideoCommand class 
	 */
	public class SaveLocalChapterVideoCommand extends BaseAirCommand
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
		 * SaveLocalChapterVideoCommand 
		 */
		public function SaveLocalChapterVideoCommand()
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
			if(mediaVO && videoAdapterProxy && videoAssetProxy)
			{
				videoAssetProxy.mediaVo = mediaVO;
				if(mediaVO.videoVO && mediaVO.binaryContent)
				{
					var videoVO:VideoVO = mediaVO.videoVO;
					mediaVO.fileName = UIDUtil.createUID() + videoAssetProxy.mediaType;
					videoVO.videoUrl = AssetsUtil.VIDEO_PATH + mediaVO.fileName;
					mediaVO.videoVO = videoVO;
					
					if(videoAdapterProxy)
					{
						videoAdapterProxy.currentVideo = videoVO;
						videoAdapterProxy.addNewVideo(mediaVO, null , true);
					}
				}
				else
				{
					fileRefferenceProxy.browseForVideo(CourseAirConstants.CHAPTER_VIDEO_DATA_LOADED,
						CourseServiceNotification.SAVE_VIDEO_CANCELED, null, null, TTUConstants.SPIN_START);
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