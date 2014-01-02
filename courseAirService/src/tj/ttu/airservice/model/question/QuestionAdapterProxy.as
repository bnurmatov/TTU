////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 9, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.question
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.courseservice.model.vo.QuestionServiceVO;
	
	/**
	 * QuestionAdapterProxy class 
	 */
	public class QuestionAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'QuestionAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 * The current question that is being worked with
		 */
		public var currentQuestion:QuestionVo;
		
		
		/**
		 * The index of our current working question
		 */
		private var currentQuestionIndex:int;
		
		/**
		 * The index of our current working question
		 */
		public var questionServiceVO:QuestionServiceVO;
		
		public var questionsBuildingCompleteNotification:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * QuestionAdapterProxy 
		 */
		public function QuestionAdapterProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  currentQuestions
		//----------------------------------
		private var _currentQuestions:Array;
		
		public function get currentQuestions():Array
		{
			return _currentQuestions;
		}
		
		public function set currentQuestions(value:Array):void
		{
			if( _currentQuestions !== value)
			{
				_currentQuestions = value;
				currentQuestionIndex = _currentQuestions ? _currentQuestions.length : -1;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			currentQuestion = null;
			currentQuestions = null;
			super.onRemove();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function cleanUp():void
		{
			currentQuestion = null;
			currentQuestions = null;
			questionServiceVO = null;
			questionsBuildingCompleteNotification = null;
		}
		/**
		 * Shift to the next <code>QuestionVO</code> in array of current questions.
		 */
		public function shiftCurrentQuestion():void
		{
			currentQuestion = currentQuestions ? currentQuestions[--currentQuestionIndex] : null;
		}
		
		/**
		 * Retrieves any answers that belong to the 'current' question.
		 * 
		 */
		public function getCurrentQuestionAnswers():void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.GET_ANSWERS_BY_QUESTION_UUID_SQL;
			statement.parameters[":question_uuid"] = currentQuestion.guid;
			statement.itemClass = AnswerVo;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = CourseAirConstants.RETRIEVE_QUESTION_ANSWERS_COMPLETE;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Retrieves any questions that belong to the 'current' chapter.
		 * 
		 */
		public function retrieveQuestionsByChapterUuid(chapterUuid:String, completionNotification:String, questionsBuildingCompleteNotification:String):void
		{
			this.questionsBuildingCompleteNotification = questionsBuildingCompleteNotification;
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.GET_QUESTION_BY_CHAPTER_UUID_SQL;
			statement.parameters[":chapter_uuid"] = chapterUuid;
			statement.itemClass = QuestionVo;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 *  @public
		 */
		public function addNewQuestion(question:QuestionVo, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			createQuestion( question, completionNotification, isTransaction );
			for each (var answer:AnswerVo in question.answers)
			{
				if(answer)
					createAnswer(answer, question.guid);
			}
		}
		
		/**
		 *  @public
		 */
		public function removeExistingQuestion(question:QuestionVo, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			deleteQuestion( question);
		}
		
		/**
		 *  @public
		 */
		public function createQuestion(question:QuestionVo, completionNotification:String, isTransaction:Boolean = true, isEdit:Boolean = false):void
		{
			// create new UUID and reset version, unless editing
			if(!isEdit|| StringUtil.isNullOrEmpty(question.guid))
			{
				question.guid = UIDUtil.createUID();
			}
			
			currentQuestion 		= question;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			insertQuestion(question, isEdit);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Insert a new question into the database.
		 * 
		 * @param question 	The <code>QuestionVo</code> object representing the list to insert
		 * @param isEdit	Flag determining whether or not we are editing
		 */
		private function insertQuestion(question:QuestionVo, isEdit:Boolean = false):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_QUESTION_SQL_KEY);
			
			statement.parameters[':chapter_uuid']				= question.chapterUuid;
			statement.parameters[':uuid']						= question.guid;
			statement.parameters[':text']						= question.text;
			statement.parameters[':incorrect_answer_hint']		= question.incorrectAnswerHint;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 * Updates an existing question to the new state.
		 * 
		 * @param questions The array of <code>QuestionVo</code> object
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateQuestions(questions:IList, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			if(!databaseMangerProxy) return;
			
			databaseMangerProxy.beginTransaction();
			var deleteQuestions:IList = getDeleteQuestions( currentQuestions, questions );
			
			if(deleteQuestions)
			{
				for each(var questionVO:QuestionVo in deleteQuestions)
				{
					if(questionVO)
						removeExistingQuestion( questionVO );
				}
			}
			
			var updateQuestions:IList = getUpdateQuestions(currentQuestions, questions );
			if(updateQuestions)
			{
				for each(var item:QuestionVo in updateQuestions)
				{
					updateQuestion(item, null, false);
				}
			}
			
			var insertQuestions:IList = getInsertQuestions( currentQuestions, questions);
			if(insertQuestions)
			{
				for each(var question:QuestionVo in insertQuestions)
				{
					addNewQuestion(question);
				}
			}
			databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Updates an existing chapter to the new state.
		 * 
		 * @param question The <code>QuestionVO</code> object representing the question to update
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateQuestion(question:QuestionVo, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// save chapter to proxy
			currentQuestion = question;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			
			updateQuestionRecord(question);
			updateAnswers(question.answers, question.guid);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update question to match the <code>QuestionVo</code> object which represents
		 * the question's new state.
		 * 
		 * @param question The <code>QuestionVo</code> object representing the question to update
		 */
		private function updateQuestionRecord(question:QuestionVo):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_QUESTION_SQL_KEY);
			
			statement.parameters[':chapter_uuid']				= question.chapterUuid;
			statement.parameters[':uuid']						= question.guid;
			statement.parameters[':text']						= question.text;
			statement.parameters[':incorrect_answer_hint']		= question.incorrectAnswerHint;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		private function deleteQuestion(question:QuestionVo):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.DELETE_QUESTION_SQL_KEY );
			
			statement.parameters[':uuid'] 			= question.guid;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		//----------------------------------
		//  answer
		//----------------------------------
		/**
		 *  @public
		 */
		public function createAnswer(answer:AnswerVo, questionUuid:String, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// create new UUID and reset version, unless editing
			if(StringUtil.isNullOrEmpty(answer.guid))
			{
				answer.guid = UIDUtil.createUID();
			}
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			insertAnswer(answer, questionUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Insert a new answer into the database.
		 * 
		 * @param answer 	The <code>AnswerVo</code> object representing the list to insert
		 * @param questionUuid	Flag determining whether or not we are editing
		 */
		private function insertAnswer(answer:AnswerVo, questionUuid:String):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_ANSWER_SQL_KEY);
			
			statement.parameters[':question_uuid']	= questionUuid;
			statement.parameters[':uuid']			= answer.guid;
			statement.parameters[':text']			= answer.text;
			statement.parameters[':position']		= answer.position;
			statement.parameters[':is_correct']		= answer.isCorrect;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Updates an existing answers to the new state.
		 * 
		 * @param question The <code>QuestionVO</code> object representing the question to update
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateAnswers(answers:IList, questionUuid:String, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			var existingAnswers:IList = getAnswersByQuestionUuid(questionUuid);
			
			var deleteAnswers:IList = getDeleteAnswers(existingAnswers, answers );
			if(deleteAnswers)
			{
				for each(var item:AnswerVo in deleteAnswers)
				{
					if(item)
						deleteAnswer( item );
				}
			}
			
			var insertAnswers:IList = getInsertAnswers(existingAnswers, answers);
			if(insertAnswers)
			{
				for each(var answer:AnswerVo in insertAnswers)
				{
					if(answer)
						createAnswer( answer, questionUuid );
				}
			}
			
			var updateAnswers:IList = getUpdateAnswers(existingAnswers, answers);
			if(updateAnswers)
			{
				for each(var answerVO:AnswerVo in updateAnswers)
				{
					if(answerVO)
						updateAnswerRecord(answerVO, questionUuid);
				}
			}
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update answer to match the <code>AnswerVo</code> object which represents
		 * the answer's new state.
		 * 
		 * @param answer The <code>AnswerVo</code> object representing the answer to update
		 */
		private function updateAnswerRecord(answer:AnswerVo, questionUuid:String):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_ANSWER_SQL_KEY);
			
			statement.parameters[':question_uuid']		= questionUuid;
			statement.parameters[':uuid']				= answer.guid;
			statement.parameters[':text']				= answer.text;
			statement.parameters[':position']			= answer.position;
			statement.parameters[':is_correct']			= answer.isCorrect;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		private function deleteAnswer(answer:AnswerVo):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.DELETE_ANSWER_SQL_KEY);
			
			statement.parameters[':uuid'] 			= answer.guid;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		
		private function hasAnswersChange(existAnswers:IList, updateAnswers:IList):Boolean
		{
			if(!existAnswers && updateAnswers) return true;
			if(existAnswers && !updateAnswers) return true;
			if(existAnswers.length != updateAnswers.length) return true;
			
			for each(var item:AnswerVo in updateAnswers)
			{
				if(item)
				{
					for each(var answer:AnswerVo in existAnswers)
					{
						if(answer && (answer.text != item.text || answer.isCorrect != item.isCorrect))
							return true;
					}
				}
			}
			return false;
		}
		/**
		 *  @private
		 */
		private function getUpdateQuestions(existQuestions:Array, updateQuestions:IList):IList
		{
			if(!existQuestions) return null;
			var result:IList = new ArrayCollection();
			for each(var item:QuestionVo in updateQuestions)
			{
				if(item)
				{
					for each(var question:QuestionVo in existQuestions)
					{
						if(question && question.guid == item.guid && (question.text != item.text || hasAnswersChange(question.answers, item.answers)))
						{
							result.addItem( item );
							break;
						}
					}
				}
			}
			
			return result.length > 0 ? result : null;
		}
		/**
		 *  @private
		 */
		private function getInsertQuestions(existQuestions:Array, updateQuestions:IList):IList
		{
			if(!existQuestions) return updateQuestions;
			var newQuestions:IList = new ArrayCollection();
			for each(var item:QuestionVo in updateQuestions)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var question:QuestionVo in existQuestions)
					{
						if(question && question.guid != item.guid)
							existFlag = false;
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						newQuestions.addItem( item );
				}
			}
			
			return newQuestions.length > 0 ? newQuestions : null;
		}
		
		/**
		 *  @private
		 */
		private function getDeleteQuestions(existQuestions:Array, updateQuestions:IList):IList
		{
			if(!existQuestions) return null;
			var deleteQuestions:IList = new ArrayCollection();
			for each(var item:QuestionVo in existQuestions)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var question:QuestionVo in updateQuestions)
					{
						if(question && question.guid != item.guid)
						{
							existFlag = false;
						}
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						deleteQuestions.addItem( item );
				}
			}
			
			return deleteQuestions.length > 0 ? deleteQuestions : null;
		}
		
		//----------------------------------
		//  answer
		//----------------------------------
		/**
		 *  @private
		 */
		/**
		 *  @private
		 */
		private function getUpdateAnswers(existAnswers:IList, updateAnswers:IList):IList
		{
			if(!existAnswers) return null;
			var answers:IList = new ArrayCollection();
			for each(var item:AnswerVo in updateAnswers)
			{
				if(item)
				{
					for each(var answer:AnswerVo in existAnswers)
					{
						if(answer && answer.guid == item.guid && (answer.text != item.text || answer.isCorrect != item.isCorrect))
						{
							answers.addItem( item );
							break;
						}
					}
				}
			}
			
			return answers.length > 0 ? answers : null;
		}
		/**
		 *  @private
		 */
		private function getInsertAnswers(existAnswers:IList, updateAnswers:IList):IList
		{
			if(!existAnswers) return updateAnswers;
			var newAnswers:IList = new ArrayCollection();
			for each(var item:AnswerVo in updateAnswers)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var answer:AnswerVo in existAnswers)
					{
						if(answer && answer.guid != item.guid)
							existFlag = false;
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						newAnswers.addItem( item );
				}
			}
			
			return newAnswers.length > 0 ? newAnswers : null;
		}
		
		/**
		 *  @private
		 */
		private function getDeleteAnswers(existAnswers:IList, updateAnswers:IList):IList
		{
			if(!existAnswers) return null;
			var deleteAnswers:IList = new ArrayCollection();
			for each(var item:AnswerVo in existAnswers)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var answer:AnswerVo in updateAnswers)
					{
						if(answer && answer.guid != item.guid)
						{
							existFlag = false;
						}
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						deleteAnswers.addItem( item );
				}
			}
			
			return deleteAnswers.length > 0 ? deleteAnswers : null;
		}
		
		private function getAnswersByQuestionUuid(questionUuid:String):IList
		{
			if(!currentQuestions || StringUtil.isNullOrEmpty(questionUuid))
				return null;
			for each(var item:QuestionVo in currentQuestions)
			{
				if(item && item.guid == questionUuid)
					return item.answers;
			}
			return null;
		}
	}
}