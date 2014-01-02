////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 13, 2013, Tajik Technical University
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
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RetriveQuestionsByChapterUuidCompleteCommand class 
	 */
	public class RetrieveQuestionsByChapterUuidCompleteCommand extends BaseAirCommand
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
		 * RetriveQuestionsByChapterUuidCompleteCommand 
		 */
		public function RetrieveQuestionsByChapterUuidCompleteCommand()
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
			if(questionAdapterProxy )
			{
				var questions:Array = notification.getBody() as Array; 
				//TO DO
				if(!questionAdapterProxy.currentQuestions)
				{
					questionAdapterProxy.currentQuestions = questions;
				}
				
				if(questionAdapterProxy.currentQuestions)
				{
					questionAdapterProxy.shiftCurrentQuestion();
					if(questionAdapterProxy.currentQuestion)
						questionAdapterProxy.getCurrentQuestionAnswers();
					else
						sendResultNote();
					
				}
				else	// no questions returned.
					sendResultNote();
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
		private function sendResultNote():void
		{
			if(!questionAdapterProxy) return;
			
			sendNotification(questionAdapterProxy.questionsBuildingCompleteNotification, new ArrayCollection(questionAdapterProxy.currentQuestions));
			
			questionAdapterProxy.cleanUp();
		}
		
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