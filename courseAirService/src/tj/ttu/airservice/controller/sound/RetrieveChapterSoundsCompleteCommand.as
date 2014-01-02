////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 29, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * RetrieveChapterSoundsCompleteCommand class 
	 */
	public class RetrieveChapterSoundsCompleteCommand extends BaseAirCommand
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
		 * RetrieveChapterSoundsCompleteCommand 
		 */
		public function RetrieveChapterSoundsCompleteCommand()
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
				var sounds:IList = new ArrayCollection(notification.getBody() as Array);
				chapterAdapterProxy.currentChapter.sounds = AssetsUtil.prependRootPathForSounds(chapterAdapterProxy.currentChapterServiceVO.lessonUuid, chapterAdapterProxy.currentChapterServiceVO.lessonVersion, sounds );
				chapterAdapterProxy.getCurrentChapterVideoList();
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