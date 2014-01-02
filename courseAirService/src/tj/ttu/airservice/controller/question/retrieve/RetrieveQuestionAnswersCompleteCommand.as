////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 12, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.question.retrieve
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	
	/**
	 * RetrieveQuestionAnswersComplete class 
	 */
	public class RetrieveQuestionAnswersCompleteCommand extends BaseAirCommand
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
		 * RetrieveQuestionAnswersComplete 
		 */
		public function RetrieveQuestionAnswersCompleteCommand()
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
			if(questionAdapterProxy && questionAdapterProxy.currentQuestion)
			{
				var answers:IList = new ArrayCollection(notification.getBody() as Array);
				questionAdapterProxy.currentQuestion.answers = answers;
				sendNotification(CourseAirConstants.RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE);
				questionAdapterProxy.cleanUp();
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