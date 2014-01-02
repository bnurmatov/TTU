////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 29, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.retrieve
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.coretypes.LessonVO;
	
	/**
	 * RetrieveLessonChaptersComplete class 
	 */
	public class RetrieveLessonChaptersComplete extends BaseAirCommand
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
		 * RetrieveLessonChaptersComplete 
		 */
		public function RetrieveLessonChaptersComplete()
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
			if(chapterAdapterProxy)
			{
				var chapters:Array = notification.getBody() as Array; 
				//TO DO
				if(!chapterAdapterProxy.currentChapters)
				{
					chapterAdapterProxy.currentChapters = chapters || [];
				}
				
				if(chapterAdapterProxy.currentChapters)
				{
					chapterAdapterProxy.shiftCurrentChapter();
					if(chapterAdapterProxy.currentChapter)
						chapterAdapterProxy.getCurrentChapterImages();
					else
					{
						sendNotification(chapterAdapterProxy.chaptersBuildingCompleteNotification, chapterAdapterProxy.currentChapters);
						chapterAdapterProxy.cleanUp();
					}
					
				}
				else	// no chapters returned. Start the next lesson.
				{
					sendNotification(chapterAdapterProxy.chaptersBuildingCompleteNotification, chapterAdapterProxy.currentChapters);
					chapterAdapterProxy.cleanUp();
				}
			}
		}
		
/*		override public function execute( notification:INotification ) : void
		{
			
			if(lessonAdapterProxy && chapterAdapterProxy)
			{
				// save chapters to the current lesson or set empty array
				var currentLesson:LessonVO = lessonAdapterProxy.currentLesson;
				var chapters:Array = notification.getBody() as Array; 
				//TO DO
				if(!currentLesson.chapters)
				{
					currentLesson.chapters = chapters || [];
					chapterAdapterProxy.currentChapters = currentLesson.chapters;
				}
				
				if(chapterAdapterProxy.currentChapters)
				{
					chapterAdapterProxy.shiftCurrentChapter();
					if(chapterAdapterProxy.currentChapter)
						chapterAdapterProxy.getCurrentChapterImages();
					else
						sendNotification(CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE);
					
				}
				else	// no chapters returned. Start the next lesson.
					sendNotification(CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE);
			}
		}*/
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