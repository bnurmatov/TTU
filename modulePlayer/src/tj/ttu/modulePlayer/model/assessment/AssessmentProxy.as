////////////////////////////////////////////////////////////////////////////////
// Copyright 2010, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.model.assessment
{
	import flash.events.Event;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	
	/**
	 * AssessmentProxy class 
	 */
	public class AssessmentProxy extends Proxy
	{
		//------------------------------------------------------
		// Constants
		//------------------------------------------------------
		
		
		
		/**
		 *  Constant for name of class
		 */ 
		public static const NAME	:String = "AssessmentProxy";
		
		/**
		 * Default assessment Data error message.
		 */
		protected static const ASSESSMENT_ERROR:String = "You do not have data for assessment. Please include correct Byki Lists.";
		//------------------------------------------------------
		// Variables
		//------------------------------------------------------
		public var percentAchived:Number = 0;
		
		public var isAssessmentComplete:Boolean = false;
		
		
		private var currentIndex:int = 0;
		
		
		
		//------------------------------------------------------
		// Constructor
		//------------------------------------------------------
		/**
		 * 
		 *Constructor 
		 */
		public function AssessmentProxy() 
		{
			super( NAME );
		}
		
		
		//------------------------------------------------------
		// 
		// overrriden methods
		// 
		//------------------------------------------------------
		
		
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister() : void
		{
			super.onRegister();
		}
		/**
		 * @inheritDoc
		 */
		override public function onRemove() : void
		{
			reset();
			super.onRemove();
		}
		//------------------------------------------------------
		// Properties
		//------------------------------------------------------
		//----------------------------------
		//  assessmentEnabled
		//----------------------------------
		/**
		 *  @private
		 *  Internal storage for assessmentEnabled property
		 *  @default false 
		 */
		private var _assessmentEnabled:Boolean = false;
		/** 
		 *  A boolean value holding enabled status of the assessment 
		 * 	<code>false</code> indicates assessment is not enabled because required activities are not completed
		 *  and <code>true</code> indicates assessment is enabled because required activities are completed 
		 */   
		public function get assessmentEnabled():Boolean
		{
			return _assessmentEnabled;
		}
		/**
		 * @private 
		 */
		public function set assessmentEnabled(value:Boolean):void
		{
			if (value === this._assessmentEnabled)
				return;
			this._assessmentEnabled = value;
		}
		
		
		//----------------------------------
		//  progressBefore
		//----------------------------------
		/**
		 *  An int value holding index of next activity
		 */ 
		public function get progressBefore ():int
		{
			var numItems:int =0;
			return numItems;
		}
		
		//----------------------------------
		//  score
		//----------------------------------
		private var _score:ScoreVO;
		/**
		 *  An int value holding index of next activity
		 */ 
		public function get score():ScoreVO
		{
			return _score;
		}
		
		/**
		 * @private
		 */		
		public function set score(value:ScoreVO):void
		{
			_score = value;
		}
		
		//----------------------------------
		//  isPassed
		//----------------------------------
		/**
		 *  An int value holding index of next activity
		 */ 
		public function get isPassed():Boolean
		{
			if(!score)
				return false;
			
			return hasPassed();
		}
		
		/***
		 *  An int value holding index of next activity
		 */ 
		public function get isLastAttemptPassed():Boolean
		{
			return hasPassed(true);
		}		
		
		//----------------------------------
		//  isAssessment
		//----------------------------------
		/**
		 *  @private
		 *  Internal storage for isAssessment property
		 *  @default false 
		 */
		private var _isAssessment:Boolean = false;
		/** 
		 *  A boolean value indicating type of activity.
		 * 	<code>false</code> indicates that current activity is not Assessmnet
		 *  and <code>true</code> means that current activity is an Assessment 
		 */   
		public function get isAssessment():Boolean
		{
			return _isAssessment;
		}
		/**
		 *  @private
		 */ 	
		public function set isAssessment(value:Boolean):void
		{
			_isAssessment = value;
		}
		
		
		//----------------------------------
		//  initScore
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _initScore:int = 0;
		
		/**
		 * Initial score (received from LMS at the session start)
		 */
		public function get initScore():int
		{
			return _initScore;
		}
		/**
		 * @private
		 */		
		public function set initScore(value:int):void
		{
			_initScore = value;
		}
		//----------------------------------
		//  total
		//----------------------------------
		private var _total:int = 0;
		
		public function get total():int
		{
			return _total;
		}
		
		public function set total(value:int):void
		{
			if( _total !== value)
			{
				_total = value;
			}
		}
		
		//-----------------------
		// minScore
		//-----------------------
		
		/**
		 * @private 
		 * Deafult minimum score for assessment
		 */
		private var _minScore:Number = 69;
		
		/** 
		 * Returns true if show hints is inidcated as true in xml 
		 */
		public function get minScore():Number
		{
			return _minScore;
		}
		/**
		 * @private
		 */  
		public function set minScore(value:Number):void
		{
			_minScore = value;
		}
		//-----------------------
		// minItems
		//-----------------------
		/** 
		 * @private
		 * Deafult minimum number of items for assessment
		 */
		private var _minItems:Number = 16;
		
		/** 
		 * Deafult minimum number of items for assessment
		 */
		public function get minItems():Number
		{
			return _minItems;
		}
		/** 
		 * Deafult minimum number of items for assessment
		 */
		public function set minItems(value:Number):void
		{
			_minItems = value;
		}
		//-----------------------
		// maxItems
		//-----------------------
		
		/** 
		 * @private
		 * Deafult maximum number of items for assessment
		 */
		
		private var _maxItems:Number = 24;
		
		/** 
		 * Returns maximum number of items 
		 */
		public function get maxItems():Number
		{
			return _maxItems;
		}
		/** 
		 * @private
		 */
		public function set maxItems(value:Number):void
		{
			_maxItems = value;
		}
		//----------------------------------
		//  status
		//----------------------------------
		private var _status:String = ModuleStatus.NOT_ATTEMPTED;

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}
		//----------------------------------
		//  name
		//----------------------------------
		private var _name:String = "Assessment";

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		//----------------------------------
		//  questions
		//----------------------------------
		private var _questions:Array = [];

		[ArrayElementType("tj.ttu.base.vo.QuestionVo")]
		public function get questions():Array
		{
			return _questions;
		}

		public function set questions(value:Array):void
		{
			_questions = value;
			total = _questions ? _questions.length : 0;
		}

		//-------------------------------------------------------------------------------
		//
		// Public Methods
		//
		//-------------------------------------------------------------------------------
		
		/**
		 * Resets all values 
		 */		
		
		public function reset():void
		{
			initScore = 0;
			isAssessment = false;
			percentAchived = 0;
			isAssessmentComplete = false;
			assessmentEnabled = false;
			currentIndex = 0;
			total = 0;
			name = "Assessment";
			status = ModuleStatus.NOT_ATTEMPTED;
			minScore = 69;
			maxItems = 24;
			minItems = 16;
			questions = [];
			score = null;
		}
		/**
		 * @private
		 */	
		private function  hasPassed(lastAttempt:Boolean=false):Boolean
		{
			if (!_score)
				return true;
			
			if(_score) 
			{
				if(_total < _score.total)
				{
					_score.total = _total;
					_score.incorrect = _score.incorrect > 0 ? Math.min(_total,  _score.incorrect):0;
					_score.correct = _score.total - _score.incorrect;
				}
			}
			
			percentAchived = Math.round(((_score.correct/_score.total) * 100));
			initScore = Math.max(percentAchived, initScore);
			return Math.max(percentAchived, lastAttempt? 0 : initScore) >= minScore;
		}
		
		/**
		 * Setup byki List data for assessment modules.
		 * @param bLists A array of the bykiLists.
		 */ 
		public function setAssessmentData(lesson:LessonVO):void
		{
			if(!lesson)
				return;
			questions = [];
			for each( var item:ChapterVO in lesson.chapters)
			{
				if(item.questions)
				{
					questions = questions.concat(item.questions.toArray());
				}
			}
			
			if(questions.length >0)
			{
				questions = randomize(questions);
				total = questions.length;
			}
		}
		
		/**
		 * Setup byki List data for assessment modules.
		 * @param bLists A array of the bykiLists.
		 */ 
		public function resetAnswerSelected():void
		{
			for each(var question:QuestionVo in _questions)
			{
				for each(var answer:AnswerVo in question.answers)
				{
					answer.selected = false;
				}
			}
		}
		
		/**
		 * Utility fucntion which randomizes given array
		 */ 
		private function randomize(value:Array):Array
		{
			var arr:Array = value.concat();
			var randomizedArray:Array = [];
			while(arr.length > 0)
			{
				var rnd:int = Math.random()*arr.length;
				randomizedArray.push(arr[rnd]);
				arr.splice(rnd, 1);
			}
			return randomizedArray;	
		}
		
	}
}