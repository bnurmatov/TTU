////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * AnswerVo class 
	 */
	public class AnswerVo extends EventDispatcher
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
		 * The id of question.
		 */
		public var guid:String;
		
		/**
		 * 
		 */		
		public var position:uint = 1;
		
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
		 * AnswerVo 
		 */
		public function AnswerVo()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  isCorrect
		//----------------------------------
		private var _isCorrect:Boolean;

		[Bindable(event="isCorrectChange")]
		/**
		 * A flag that indicates if concrete answer is correct.
		 * 
		 */
		public function get isCorrect():Boolean
		{
			return _isCorrect;
		}

		/**
		 * @private
		 */
		public function set isCorrect(value:Boolean):void
		{
			if( _isCorrect !== value)
			{
				_isCorrect = value;
				dispatchEvent(new Event("isCorrectChange"));
			}
		}

		//----------------------------------
		//  text
		//----------------------------------
		
		private var _text:String;

		[Bindable(event="answerTextChange")]
		/**
		 * The text of answer.
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
				dispatchEvent(new Event("answerTextChange"));
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