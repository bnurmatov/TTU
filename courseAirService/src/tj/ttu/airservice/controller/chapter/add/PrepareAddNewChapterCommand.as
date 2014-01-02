////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 26, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.add
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * PrepareAddNewCardCommand class 
	 */
	public class PrepareAddNewChapterCommand extends BaseAirCommand
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
		 * PrepareAddNewCardCommand 
		 */
		public function PrepareAddNewChapterCommand()
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
			var chapterServiceVo:ChapterServiceVO = note.getBody() as ChapterServiceVO;
			if(chapterServiceVo && chapterAdapterProxy)
			{
				chapterAdapterProxy.currentChapterServiceVO = chapterServiceVo;
				chapterAdapterProxy.getMaxChapterPosition( chapterServiceVo.lessonUuid, chapterServiceVo.lessonVersion, CourseAirConstants.ADD_NEW_LOCAL_CAHPTER ); 
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