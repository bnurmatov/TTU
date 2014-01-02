////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.moduleUtility.vo
{

	/**
	 * Describes user answer. 
	 */
	public class UserAnswerVO
	{
		/**
		 * Constructor
		 */
		public function UserAnswerVO(correctAnswers:Array = null, userAnswers:Array = null,
								 isCorrect:Boolean = false)
		{
			this.correctAnswers = correctAnswers;
			this.userAnswers = userAnswers;
			this.isCorrect = isCorrect;
		}
		
		/**
		 * Side one text.
		 */
		public var correctAnswers:Array;

		/**
		 * Side two text.
		 */
		public var userAnswers:Array;
		
		/**
		 * The language of the user answer.
		 */
		public var userTextSide:String;
		
		/**
		 * User answer text.
		 */		
		public var userText:String;
		
		/**
		 * Indicates that user answer is correct. 
		 */		
		public var isCorrect:Boolean;
	}
}