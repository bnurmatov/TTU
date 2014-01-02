////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.video
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * RetrieveChapterVideoListCompleteCommand class 
	 */
	public class RetrieveChapterVideoListCompleteCommand extends BaseAirCommand
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
		 * RetrieveChapterVideoListCompleteCommand 
		 */
		public function RetrieveChapterVideoListCompleteCommand()
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
				var videoList:IList = new ArrayCollection(notification.getBody() as Array);
				chapterAdapterProxy.currentChapter.videoList = AssetsUtil.prependRootPathForVideoList(chapterAdapterProxy.currentChapterServiceVO.lessonUuid, chapterAdapterProxy.currentChapterServiceVO.lessonVersion, videoList );
				chapterAdapterProxy.getCurrentChapterQuestions();
				//sendNotification(CourseAirConstants.RETRIEVE_LESSON_CHAPTERS_COMPLETE);
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