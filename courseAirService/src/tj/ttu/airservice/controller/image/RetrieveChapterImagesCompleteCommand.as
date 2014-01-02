////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 29, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.image
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * RetrieveChapterImagesCompleteCommand class 
	 */
	public class RetrieveChapterImagesCompleteCommand extends BaseAirCommand
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
		 * RetrieveChapterImagesCompleteCommand 
		 */
		public function RetrieveChapterImagesCompleteCommand()
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
			if(chapterAdapterProxy && chapterAdapterProxy.currentChapter && chapterAdapterProxy.currentChapterServiceVO)
			{
				var images:IList = new ArrayCollection(notification.getBody() as Array);
				chapterAdapterProxy.currentChapter.images = AssetsUtil.prependRootPathForImages(chapterAdapterProxy.currentChapterServiceVO.lessonUuid, chapterAdapterProxy.currentChapterServiceVO.lessonVersion, images);
				chapterAdapterProxy.getCurrentChapterSounds();
			}
			//	sendNotification(CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE);
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