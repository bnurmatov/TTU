////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.remove
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * PrepareRemoveLessonCommand class 
	 */
	public class PrepareRemoveLessonCommand extends BaseAirCommand
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
		 * PrepareRemoveLessonCommand 
		 */
		public function PrepareRemoveLessonCommand()
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
			var lesson:LessonVO = notification.getBody() as LessonVO;
			if(lesson && lessonAdapterProxy)
			{
				lessonAdapterProxy.currentLesson = lesson;
				if(!lesson.chapters || lesson.chapters.length == 0)
				{
					var serviceVO:ChapterServiceVO = new ChapterServiceVO(lesson.guid, lesson.version, null);
					if(chapterAdapterProxy && serviceVO)
					{
						chapterAdapterProxy.currentChapterServiceVO = serviceVO;
						chapterAdapterProxy.getChaptersByLessonUuid( serviceVO.lessonUuid, CourseAirConstants.RETRIEVE_LESSON_CHAPTERS_COMPLETE, CourseAirConstants.PARSE_LOCAL_CHAPTERS_FOR_DELETE_LESSON);
					}
				}
				else
					sendNotification(CourseAirConstants.REMOVE_LOCAL_LESSON);
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