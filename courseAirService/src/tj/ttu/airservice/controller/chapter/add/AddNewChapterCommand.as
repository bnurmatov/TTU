////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 25, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.add
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * AddNewChapterCommand class 
	 */
	public class AddNewChapterCommand extends BaseAirCommand
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
		 * AddNewChapterCommand 
		 */
		public function AddNewChapterCommand()
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
			var result:Array = note.getBody() as Array;
			if(result && result.length > 0 && chapterAdapterProxy)
			{	
				var chapterServiceVO:ChapterServiceVO = chapterAdapterProxy.currentChapterServiceVO;
				var prevPos:int = uint(result[0].max_chapter_position);
				chapterServiceVO.chapter.position = prevPos + 1;
				chapterAdapterProxy.createChapter(chapterServiceVO.chapter, chapterServiceVO.lessonUuid, chapterServiceVO.lessonVersion, CourseAirConstants.ADD_NEW_LOCAL_CAHPTER_COMPLETE);
				
				// set lesson's changed property
				if(lessonAdapterProxy)
					lessonAdapterProxy.changedLesson(chapterServiceVO.lessonUuid);
			}
			else
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, "Add New Chapter - Chapters not found in local storage.");
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