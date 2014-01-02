////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	/**
	 * QuestionEvent class 
	 */
	public class QuestionEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const GET_QUESTIONS:String = 'getQuestions';
		public static const SAVE_QUESTIONS:String = 'saveQuestions';
		public static const DONE_QUESTIONS_VIEW:String = 'doneQuestionsView';
		public static const DELETE_QUESTION:String = 'deleteQuestion';
		public static const DELETE_ANSWER:String = 'deleteAnswer';
		public static const ANSWER_SELECTION_CHANGE:String = 'answerSelectionChange';
		public static const ANSWER_TEXT_CHANGE:String = 'answerTextChange';
		public static const CLOSE_QUESTIONS_VIEW:String = 'closeQuestionsView';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var data:Object;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * QuestionEvent 
		 */
		public function QuestionEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
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
		override public function clone():Event
		{
			return new QuestionEvent(type, data);
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