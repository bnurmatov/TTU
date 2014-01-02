////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.update
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * UpdateChapterCompleteCommand class 
	 */
	public class UpdateChapterCompleteCommand extends BaseAirCommand
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
		 * UpdateChapterCompleteCommand 
		 */
		public function UpdateChapterCompleteCommand()
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
			if(chapterAdapterProxy && chapterAdapterProxy.currentChapter && imageAdapterProxy)
			{
				imageAdapterProxy.getImagesByTargetUuid(chapterAdapterProxy.currentChapter.chapterUuid, CourseAirConstants.GET_IMAGES_BY_TARGET_UUID_COMPLETE);
				chapterAdapterProxy.currentChapter.images = AssetsUtil.prependRootPathForImages(chapterAdapterProxy.currentChapter.lessonUuid, chapterAdapterProxy.currentChapter.version, imageAdapterProxy.currentImages);
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