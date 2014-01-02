////////////////////////////////////////////////////////////////////////////////
// Copyright Aug 28, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.components
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	
	import spark.components.Button;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.components.components.audio.AudioPlayer;
	import tj.ttu.components.components.progressbar.HalfCircleProgressBar;
	import tj.ttu.module.assesment.views.components.list.AnswerList;
	import tj.ttu.module.assesment.views.events.ActivityEvent;
	import tj.ttu.module.assesment.views.events.AssesmentEvent;
	import tj.ttu.module.assesment.views.renderers.SingleChoiseAnswerItemRenderer;
	import tj.ttu.moduleUtility.vo.UserAnswerVO;
	
	/**
	 * AssesmentPlayer class 
	 */
	public class AssesmentPlayer extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var nextButton:Button;
		
		[SkinPart(required="false")]
		public var skipButton:Button;
		
		[SkinPart(required="true")]
		public var progressBar:HalfCircleProgressBar;
		
		[SkinPart(required="true")]
		public var audioPlayer:AudioPlayer;
		
		[SkinPart(required="true")]
		public var questionTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var answerList:AnswerList;
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
		private var latinFont:String;
		private var wasLearned:Boolean;
		private var userAnswers:Array;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AssesmentPlayer 
		 */
		public function AssesmentPlayer()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// cyrillicFont
		//-----------------------------------------
		private var _cyrillicFont:String = "Cyrillic";
		
		public function get cyrillicFont():String
		{
			return _cyrillicFont;
		}
		
		public function set cyrillicFont(value:String):void
		{
			if(_cyrillicFont !== value)
			{
				_cyrillicFont = value;
				questionTextChanged = true;
				answersChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  currentQuestionIndex
		//--------------------------------------
		private var _currentQuestionIndex:int = 0;
		
		[Bindable(event="currentQuestionIndexChange")]
		public function get currentQuestionIndex():int
		{
			return _currentQuestionIndex;
		}
		
		public function set currentQuestionIndex(value:int):void
		{
			if( _currentQuestionIndex !== value)
			{
				_currentQuestionIndex = value;
				dispatchEvent(new Event("currentQuestionIndexChange"));
			}
		}
		
		//--------------------------------------
		//  questionCount
		//--------------------------------------
		private var _questionCount:int = 0;
		
		[Bindable(event="questionCountChange")]
		public function get questionCount():int
		{
			return _questionCount;
		}
		
		public function set questionCount(value:int):void
		{
			if( _questionCount !== value)
			{
				_questionCount = value;
				dispatchEvent(new Event("questionCountChange"));
			}
		}
		
		
		//--------------------------------------
		//  questionsProgress
		//--------------------------------------
		private var _questionsProgress:Number = 0;
		
		[Bindable(event="questionsProgressChange")]
		public function get questionsProgress():Number
		{
			return _questionsProgress;
		}
		
		public function set questionsProgress(value:Number):void
		{
			if( _questionsProgress !== value)
			{
				_questionsProgress = value;
				dispatchEvent(new Event("questionsProgressChange"));
			}
		}
		
		
		//--------------------------------------
		//  questions
		//--------------------------------------
		private var _questions:IList;
		
		public function get questions():IList
		{
			return _questions;
		}
		
		public function set questions(value:IList):void
		{
			if( _questions !== value)
			{
				_questions = value;
				questionCount = _questions ? _questions.length : 0;
				if(_questions)
					nextQuestion();
				else
					currentQuestion = null;
			}
		}
		
		//--------------------------------------
		//  currentQuestion
		//--------------------------------------
		private var _currentQuestion:QuestionVo;
		
		public function get currentQuestion():QuestionVo
		{
			return _currentQuestion;
		}
		
		public function set currentQuestion(value:QuestionVo):void
		{
			if( _currentQuestion !== value)
			{
				_currentQuestion = value;
				questionText = _currentQuestion ? _currentQuestion.text : null;
				isMultiChoice = _currentQuestion ? _currentQuestion.isMultiChoice : false;
				answers = _currentQuestion ? _currentQuestion.answers : null;
			}
		}
		
		//--------------------------------------
		//  questionText
		//--------------------------------------
		private var questionTextChanged:Boolean;
		private var _questionText:String;
		
		public function get questionText():String
		{
			return _questionText;
		}
		
		public function set questionText(value:String):void
		{
			if( _questionText !== value)
			{
				_questionText = value;
				questionTextChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  answers
		//--------------------------------------
		private var answersChanged:Boolean;
		private var _answers:IList;
		
		public function get answers():IList
		{
			return _answers;
		}
		
		public function set answers(value:IList):void
		{
			if( _answers !== value)
			{
				_answers = value;
				answersChanged = true;
				invalidateProperties();
			}
		}
		//--------------------------------------
		//  isMultiChoice
		//--------------------------------------
		private var isMultiChoiceChanged:Boolean;
		private var _isMultiChoice:Boolean;
		[Bindable(event="multiChoiceChanged")]
		public function get isMultiChoice():Boolean
		{
			return _isMultiChoice;
		}
		
		public function set isMultiChoice(value:Boolean):void
		{
			if( _isMultiChoice !== value)
			{
				_isMultiChoice = value;
				isMultiChoiceChanged = true;
				invalidateProperties();
				dispatchEvent(new Event('multiChoiceChanged'));
			}
		}
		
		//--------------------------------------
		//  muted
		//--------------------------------------
		private var mutedChange:Boolean = false;
		private var _muted:Boolean;
		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		public function set muted(value:Boolean):void
		{
			if( _muted !== value)
			{
				_muted = value;
				mutedChange = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  tempoEnabled
		//--------------------------------------
		private var tempoEnabledChange:Boolean = false;
		private var _tempoEnabled:Boolean;
		
		public function get tempoEnabled():Boolean
		{
			return _tempoEnabled;
		}
		
		public function set tempoEnabled(value:Boolean):void
		{
			if( _tempoEnabled !== value)
			{
				_tempoEnabled = value;
				tempoEnabledChange = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  volume
		//--------------------------------------
		private var volumeChange:Boolean = false;
		private var _volume:Number;
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			if( _volume !== value)
			{
				_volume = value;
				volumeChange = true;
				invalidateProperties();
			}
		}
		//--------------------------------------
		//  nextButtonEnable
		//--------------------------------------
		private var _nextButtonEnable:Boolean;
		
		[Bindable(event="nextButtonEnableChange")]
		public function get nextButtonEnable():Boolean
		{
			return _nextButtonEnable;
		}
		
		public function set nextButtonEnable(value:Boolean):void
		{
			if( _nextButtonEnable !== value)
			{
				_nextButtonEnable = value;
				dispatchEvent(new Event("nextButtonEnableChange"));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(questionTextChanged && questionTextArea)
			{
				questionTextArea.textFlow = _questionText ? TLFUtil.createFlow( _questionText, latinFont, cyrillicFont) : null;
				questionTextChanged = false;
			}
			if(answersChanged && answerList)
			{
				answerList.dataProvider = null;
				answerList.validateNow();
				answerList.dataProvider = _answers;
				answersChanged = false;
			}
			if(isMultiChoiceChanged && answerList)
			{
				answerList.isMultiChoice = _isMultiChoice;
				isMultiChoiceChanged = false;
			}
			if(mutedChange && audioPlayer)
			{
				audioPlayer.muted = _muted;
				mutedChange = false;
			}
			if(volumeChange && audioPlayer)
			{
				audioPlayer.volume = _volume;
				volumeChange = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == audioPlayer)
			{
				audioPlayer.addEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.addEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			else if(instance == nextButton)
				nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClick);
			else if(instance == skipButton)
				skipButton.addEventListener(MouseEvent.CLICK, onNextButtonClick);
			else if(instance == answerList)
				answerList.addEventListener(AssesmentEvent.SELECTION_CHANGE, onAnswerSelectionChange);
			
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == audioPlayer)
			{
				audioPlayer.removeEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.removeEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			else if(instance == nextButton)
				nextButton.removeEventListener(MouseEvent.CLICK, onNextButtonClick);
			else if(instance == skipButton)
				skipButton.removeEventListener(MouseEvent.CLICK, onNextButtonClick);
			else if(instance == answerList)
				answerList.removeEventListener(AssesmentEvent.SELECTION_CHANGE, onAnswerSelectionChange);
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function resetComponent():void
		{
			currentQuestionIndex = 0;
			questions = null;
			questionCount = 0;
			questionsProgress = 0;
			currentQuestion = null;
			questionText = null;
			answers = null;
			userAnswers = null;
			wasLearned = false;
			isMultiChoice = false;
			nextButtonEnable = false;
		}
		
		
		
		protected function playSound( soundUrl:String ) : void
		{
			if(audioPlayer.position != 0 && audioPlayer.sndURL == soundUrl)
			{
				audioPlayer.play( true );
				return;
			}
			
			audioPlayer.sndURL = null;
			audioPlayer.sndURL = soundUrl;
			audioPlayer.play();
		}
		
		protected function pauseSound( ) : void
		{
			if(audioPlayer && audioPlayer.playing)
				audioPlayer.pause();
		}
		
		private function nextQuestion():void
		{
			if(!wasLearned)
			{
				questionsProgress = ((currentQuestionIndex + 1 )* 100) / questionCount;
				wasLearned = currentQuestionIndex == (questionCount - 1);
			}
			if(_questions && _questions.length > currentQuestionIndex)
				currentQuestion = _questions.getItemAt(currentQuestionIndex) as QuestionVo;
		}
		
		
		private function getSelectedAnswersCount():int
		{
			var count:int = 0;
			for each(var item:AnswerVo in _answers)
			{
				if(item.selected)
					count++;
			}
			return count;
		}
		
		private function saveUserAnswerState():void
		{
			if(!userAnswers)
				userAnswers = [];
			var userAnswerVo:UserAnswerVO = new UserAnswerVO(currentQuestion.correctAnswers, currentQuestion.userAnswers);
			userAnswerVo.isCorrect = isUserAnswersCorrect( userAnswerVo.userAnswers );
			userAnswers.push( userAnswerVo );
			if(userAnswerVo.isCorrect)
				dispatchEvent(new AssesmentEvent(AssesmentEvent.SAVE_CORRECT_ANSWER_COUNT));
			if(currentQuestionIndex < questionCount)
				dispatchEvent(new AssesmentEvent(AssesmentEvent.SEND_USER_ANSWERS_STATUS, userAnswers));
		}
		
		private function isUserAnswersCorrect(userAnswers:Array):Boolean
		{
			if(!userAnswers || userAnswers.length == 0)
				return false;
			for each(var item:AnswerVo in userAnswers)
			{
				if(item.selected && !item.isCorrect)
					return false;
			}
			return true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onNextButtonClick(event:MouseEvent):void
		{
			nextButtonEnable = false;
			currentQuestionIndex += 1;
			saveUserAnswerState();
			if(currentQuestionIndex == questionCount)
				dispatchEvent(new ActivityEvent(ActivityEvent.SHOW_COMPLETE_POPUP, userAnswers));
			else
				nextQuestion();
		}
		
		protected function onAnswerSelectionChange(event:AssesmentEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			var selectedAnswers:int = getSelectedAnswersCount();
			if(_isMultiChoice)
				nextButtonEnable = selectedAnswers > 1;
			else
				nextButtonEnable = selectedAnswers > 0;
		}
		
		/**
		 *  @private
		 */
		
		/**
		 * @private
		 * Used for handling IOError events.
		 */
		protected function onPlaySoundError(event:IOErrorEvent):void
		{
			//resetSoundIcon();
			dispatchEvent(event);
		}
		
		/**
		 * 
		 * Handler for <code>Event.SOUND_COMPLETE</code> event dispatched by player.
		 * 
		 * @param event The <code>Event</code> event dispatched by player.
		 * 
		 */		
		protected function onPlaySoundComplete(event:Event):void
		{
			//resetSoundIcon();
		}
		
	}
}