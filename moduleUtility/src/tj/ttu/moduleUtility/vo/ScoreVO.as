////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.vo
{
	import tj.ttu.base.coretypes.ChapterVO;

	/**
	 * ScoreVO class 
	 */
	public class ScoreVO
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
		 * ScoreVO 
		 */
		public function ScoreVO()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */		
		private var _wasDoneButton:Boolean = false;
		
		/**
		 * Indicates that Done Button was selected. 
		 */
		public function get wasDoneButton():Boolean
		{
			return _wasDoneButton;
		}
		
		/**
		 * @private
		 */		
		public function set wasDoneButton(value:Boolean):void
		{
			_wasDoneButton = value;
		}
		
		private var _lastChapter:ChapterVO;

		public function get lastChapter():ChapterVO
		{
			return _lastChapter;
		}

		public function set lastChapter(value:ChapterVO):void
		{
			_lastChapter = value;
		}

		/**
		 * @private 
		 */		
		private var _lastAnswerPercentage:Number;

		/**
		 * Indicates how correct was the last answer. 
		 */		
		public function get lastAnswerPercentage():Number
		{
			return _lastAnswerPercentage;
		}
		
		/**
		 * @private 
		 */		
		public function set lastAnswerPercentage(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}else if(value > 100)
			{
				value = 100;
			}
			_lastAnswerPercentage = value;
		}
		public var data:Array;
		/**
		 * Total number of questions 
		 */		
		private var _total:Number;
		
		
		public function get total():Number
		{
			return _total;
		}
		public function set total(value:Number):void
		{
			_total = value;
		}
		/**
		 * Current position 
		 */
		private var _position:Number;
		public function get position():Number
		{
			return _position;
		}
		public function set position(value:Number):void
		{
			_position = value;
		}
		
		/**
		 * Correct answer count
		 */
		private var _correct:Number = 0;
		public function get correct():Number
		{
			return _correct;
		}
		public function set correct(value:Number):void
		{
			_correct = value;
		}
		/**
		 * Correct answer count
		 */
		private var _incorrect:Number = 0;
		public function get incorrect():Number
		{
			return _incorrect;
		}
		public function set incorrect(value:Number):void
		{
			_incorrect = value;
		}
		
		public var hasFeedback:Boolean = false;
		
		/**
		 * The list of the card scores that changed in last learning session.
		 */
		public var changedScores:Array;
		
		[ArrayElementType("tj.ttu.moduleUtility.vo.UserAnswerVO")]
		public var userAnswers:Array;
		
		public function toString():String
		{
			return "correct="+correct+",total="+total+",position="+position;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
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