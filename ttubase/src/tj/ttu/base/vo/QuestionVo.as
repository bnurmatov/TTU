////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	[Bindable]
	/**
	 * QuestionVo class 
	 */
	public class QuestionVo extends EventDispatcher
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
		 * The UUID of target.
		 */
		public var chapterUuid:String;
		
		/**
		 * The id of question.
		 */
		public var guid:String;
		
		/**
		 * The list of proposed answers for this question.
		 */
		[ArrayElementType("tj.ttu.base.vo.AnswerVo")]
		public var answers:IList = new ArrayCollection();
		
		/**
		 * Text to display when incorrect answer is given
		 *  
		 */
		public var incorrectAnswerHint:String;
		/**
		 * It's flag for check hasChange
		 */	
		public var isNotSaveToServer:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * QuestionVo 
		 */
		public function QuestionVo()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  isMultiChoice
		//----------------------------------
		/**
		 * It's flag for check choice answers
		 */	
		public function get isMultiChoice():Boolean
		{
			var correctAnswers:int = 0;
			for each(var item:AnswerVo in answers)
			{
				if(item.isCorrect)
					correctAnswers++;
			}
			return correctAnswers > 1;
		}
		//----------------------------------
		//  correctAnswers
		//----------------------------------
		public function get correctAnswers():Array
		{
			var correctAnswers:Array = [];
			for each(var item:AnswerVo in answers)
			{
				if(item.isCorrect)
					correctAnswers.push(item);
			}
			return correctAnswers ;
		}
		//----------------------------------
		//  userAnswers
		//----------------------------------
		public function get userAnswers():Array
		{
			var userAnswers:Array = [];
			for each(var item:AnswerVo in answers)
			{
				if(item.selected)
					userAnswers.push(item);
			}
			return userAnswers ;
		}
		//----------------------------------
		//  text
		//----------------------------------
		private var _text:String;
		
		[Bindable(event="questionTextChange")]
		/**
		 * The text of question.
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if( _text !== value)
			{
				_text = value;
				dispatchEvent(new Event("questionTextChange"));
			}
		}
		
		//----------------------------------
		//  selected
		//----------------------------------
		private var _selected:Boolean;
		
		[Bindable(event="selectedChange")]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if( _selected !== value)
			{
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
		
	}
}