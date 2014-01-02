////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.remove
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * DeleteChapterAssetsFromDiskCommand class 
	 */
	public class DeleteChapterAssetsFromDiskCommand extends BaseAirCommand
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
		 * DeleteChapterAssetsFromDiskCommand 
		 */
		public function DeleteChapterAssetsFromDiskCommand()
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
			if(chapterAdapterProxy && chapterAdapterProxy.currentChapterServiceVO)
			{
				var serviceVo:ChapterServiceVO = chapterAdapterProxy.currentChapterServiceVO;
				var chapter:ChapterVO = serviceVo.chapter;
				var fileName:String;
				// delete chapter's images
				for each(var image:ImageVO in chapter.images)
				{
					if(image)
					{
						fileName = FileNameUtil.getFileName(image.imageUrl);
						AssetsUtil.deleteImageFromLocalStorage(serviceVo.lessonUuid, serviceVo.lessonVersion, fileName);
					}
				}
				
				// delete chapter's sounds
				for each(var sound:SoundVO in chapter.sounds)
				{
					if(sound)
					{
						fileName = FileNameUtil.getFileName(sound.soundUrl);
						AssetsUtil.deleteSoundFromLocalStorage(serviceVo.lessonUuid, serviceVo.lessonVersion, fileName);
					}
				}
				
				// delete chapter's video
				for each(var video:VideoVO in chapter.videoList)
				{
					if(video)
					{
						fileName = FileNameUtil.getFileName(video.videoUrl);
						AssetsUtil.deleteVideoFromLocalStorage(serviceVo.lessonUuid, serviceVo.lessonVersion, fileName);
					}
				}
				chapterAdapterProxy.cleanUp();
				sendNotification(CourseServiceNotification.CHAPTER_REMOVED);
			}
			else
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, "Error delete chapter. Current chapter service vo is not set.");
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