////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.question.update
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.model.vo.QuestionServiceVO;
	
	/**
	 * PrepareUpdateQuestionsCommand class 
	 */
	public class PrepareUpdateQuestionsCommand extends BaseAirCommand
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
		 * PrepareUpdateQuestionsCommand 
		 */
		public function PrepareUpdateQuestionsCommand()
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
			var vo:QuestionServiceVO = notification.getBody() as QuestionServiceVO;
			if(questionAdapterProxy && vo)
			{
				questionAdapterProxy.questionServiceVO = vo;
				questionAdapterProxy.retrieveQuestionsByChapterUuid(vo.chapterUuid, CourseAirConstants.RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE, CourseAirConstants.UPDATE_LOCAL_QUESTIONS);
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