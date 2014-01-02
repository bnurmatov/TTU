////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 22, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.retrieve
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * RetriveLessonChaptersCommand class 
	 */
	public class RetrieveLessonChaptersCommand extends BaseAirCommand
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
		 * RetriveLessonChaptersCommand 
		 */
		public function RetrieveLessonChaptersCommand()
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
			var serviceVO:ChapterServiceVO = notification.getBody() as ChapterServiceVO;
			if(chapterAdapterProxy && serviceVO)
			{
				chapterAdapterProxy.currentChapterServiceVO = serviceVO;
				chapterAdapterProxy.getChaptersByLessonUuid( serviceVO.lessonUuid, CourseAirConstants.RETRIEVE_LESSON_CHAPTERS_COMPLETE, CourseAirConstants.PARSE_LOCAL_LESSON_CHAPTERS);
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