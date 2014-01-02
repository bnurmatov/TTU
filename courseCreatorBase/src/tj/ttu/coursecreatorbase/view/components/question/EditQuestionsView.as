////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.question
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.managers.PopUpManager;
	import mx.utils.UIDUtil;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridSelectionEvent;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.components.components.datagrid.CustomDataGrid;
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.events.DataGridEvent;
	import tj.ttu.components.events.QuestionEvent;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.coursecreatorbase.utils.QuestionUtil;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.model.vo.QuestionServiceVO;
	
	/**
	 * AssesmentView class 
	 */
	public class EditQuestionsView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		[SkinPart(required="true")]
		public var buttonClose:Button;
		
		[SkinPart(required="true")]
		public var addNewQuestionButton:Button;
		
		[SkinPart(required="true")]
		public var addNewAnswerButton:Button;
		
		[SkinPart(required="true")]
		public var saveButton:Button;
		
		[SkinPart(required="true")]
		public var doneButton:Button;
		
		[SkinPart(required="true")]
		public var questionList:CustomDataGrid;
		
		[SkinPart(required="true")]
		public var answerList:List;
		
		[SkinPart(required="true")]
		public var questionTextArea:TextArea;
		
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
		private var latinDirection:String; 
		private var cyrillicDirection:String;
		private var popup:PopupWindow;
		private var confirmationPopup:ConfirmationPopup;
		private var isAnswerDeleteConfirm:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AssesmentView 
		 */
		public function EditQuestionsView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// hasChange
		//-----------------------------------------
		private var _hasChange:Boolean;
		
		[Bindable(event="hasChange")]
		public function get hasChange():Boolean
		{
			return _hasChange;
		}
		
		public function set hasChange(value:Boolean):void
		{
			if( _hasChange !== value)
			{
				_hasChange = value;
				dispatchEvent(new CourseEvent(CourseEvent.HAS_CHANGE, _hasChange));
			}
		}
		
		//-----------------------------------------
		// chapter
		//-----------------------------------------
		private var _chapter:ChapterVO;
		
		public function get chapter():ChapterVO
		{
			return _chapter;
		}
		
		public function set chapter(value:ChapterVO):void
		{
			if( _chapter !== value)
			{
				_chapter = value;
				if(_chapter)
				{
					if(_chapter.questions)
						questions = _chapter.questions;
					else
						dispatchEvent(new QuestionEvent(QuestionEvent.GET_QUESTIONS, chapter.chapterUuid));
				}
				
			}
		}
		
		//-----------------------------------------
		// questions
		//-----------------------------------------
		private var questionsChanged:Boolean = false;
		private var _questions:IList;
		
		[ArrayElementType("tj.ttu.courseservice.model.vo.QuestionVo")]
		public function get questions():IList
		{
			return _questions;
		}
		
		public function set questions(value:IList):void
		{
			_questions = value;
			questionsChanged = true;
			invalidateProperties();
		}
		
		//-----------------------------------------
		// currentQuestion
		//-----------------------------------------
		private var questionTextChanged:Boolean = false;
		private var answersChanged:Boolean = false;
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
				enableElements( _currentQuestion != null );
				questionTextChanged = true;
				answersChanged = true;
				invalidateProperties();
				commitProperties();
			}
		}
		
		//-----------------------------------------
		// originalQuestions
		//-----------------------------------------
		private var _originalQuestions:IList;
		
		public function get originalQuestions():IList
		{
			return _originalQuestions;
		}
		
		public function set originalQuestions(value:IList):void
		{
			_originalQuestions = value;
		}
		
		//-----------------------------------------
		// changedQuestions
		//-----------------------------------------
		private var _changedQuestions:IList;
		
		public function get changedQuestions():IList
		{
			return _changedQuestions;
		}
		
		public function set changedQuestions(value:IList):void
		{
			_changedQuestions = value;
		}
		
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
				invalidateProperties();
			}
		}
		//-----------------------------------------
		// selectedIndex
		//-----------------------------------------
		private var selectedIndexChange:Boolean = false;
		private var _selectedIndex:int = 0;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if( _selectedIndex !== value)
			{
				_selectedIndex = value;
				selectedIndexChange = true;
				invalidateProperties();
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
				questionTextArea.textFlow = currentQuestion ? TLFUtil.createFlow( currentQuestion.text, latinFont, cyrillicFont) : null;
				currentQuestion ? checkOnEmptyText() : questionTextArea.errorString = "";
				questionTextChanged = false;
			}
			if(answersChanged && answerList)
			{
				answerList.dataProvider = currentQuestion ? currentQuestion.answers : null;
				answersChanged = false;
			}
			if(questionsChanged && questionList)
			{
				questionList.dataProvider = _questions;
				questionsChanged = false;
				if( _questions && _questions.length > 0 && _questions.length > _selectedIndex && _selectedIndex != -1 )
				{
					currentQuestion = _questions.getItemAt( _selectedIndex ) as QuestionVo;
					questionList.selectedIndex = _selectedIndex;
					scrollGrid( _selectedIndex );
				}
				else
					changedQuestions = null;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == buttonClose)
				buttonClose.addEventListener(MouseEvent.CLICK, onDoneView);
			else if(instance == addNewQuestionButton)
				addNewQuestionButton.addEventListener(MouseEvent.CLICK, onAddNewQuestion);
			else if(instance == addNewAnswerButton)
			{
				addNewAnswerButton.addEventListener(MouseEvent.CLICK, onAddNewAnswer);
				addNewAnswerButton.enabled = false;
			}
			else if(instance == saveButton)
				saveButton.addEventListener(MouseEvent.CLICK, onSaveButtonClick);
			else if(instance == doneButton)
				doneButton.addEventListener(MouseEvent.CLICK, onDoneView);
			else if(instance == questionList)
			{
				questionList.addEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				questionList.addEventListener(DataGridEvent.ITEM_DELETE, onQuestionDelete );
			}
			else if(instance == answerList)
			{
				answerList.addEventListener(QuestionEvent.DELETE_ANSWER, onDeleteAnswer);
				answerList.addEventListener(QuestionEvent.ANSWER_SELECTION_CHANGE, onAnswerSelectionChange);
				answerList.addEventListener(QuestionEvent.ANSWER_TEXT_CHANGE, onAnswerTextChange);
				answerList.enabled = false;
			}
			else if(instance == questionTextArea)
			{
				questionTextArea.addEventListener(TextOperationEvent.CHANGE, onQuestionTextChange);
				questionTextArea.enabled = false;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == buttonClose)
				buttonClose.removeEventListener(MouseEvent.CLICK, onDoneView);
			else if(instance == addNewQuestionButton)
				addNewQuestionButton.removeEventListener(MouseEvent.CLICK, onAddNewQuestion);
			else if(instance == addNewAnswerButton)
				addNewAnswerButton.removeEventListener(MouseEvent.CLICK, onAddNewAnswer);
			else if(instance == saveButton)
				saveButton.removeEventListener(MouseEvent.CLICK, onSaveButtonClick);
			else if(instance == doneButton)
				doneButton.removeEventListener(MouseEvent.CLICK, onDoneView);
			else if(instance == questionList)
			{
				questionList.removeEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				questionList.removeEventListener(DataGridEvent.ITEM_DELETE, onQuestionDelete );
			}
			else if(instance == answerList)
			{
				answerList.removeEventListener(QuestionEvent.DELETE_ANSWER, onDeleteAnswer);
				answerList.removeEventListener(QuestionEvent.ANSWER_SELECTION_CHANGE, onAnswerSelectionChange);
				answerList.removeEventListener(QuestionEvent.ANSWER_TEXT_CHANGE, onAnswerTextChange);
			}
			else if(instance == questionTextArea)
			{
				questionTextArea.removeEventListener(TextOperationEvent.CHANGE, onQuestionTextChange);
			}
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
			cyrillicDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_DIRECTION)||"ltr";
			latinDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_DIRECTION)||"ltr";
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function resetComponent():void
		{
			hasChange = false;
			_chapter = null;
			questions = null;
			currentQuestion = null;
			originalQuestions = null;
			changedQuestions = null;
			_selectedIndex = 0;
			popup = null;
			if(questionTextArea)
			{
				questionTextArea.text = "";
				questionTextArea.errorString = "";
			}
		}
		
		public function saveChanges():void
		{
			onSaveButtonClick(null);
		}
		/**
		 *  @public
		 */
		public function setOriginalQuestions(questionList:IList):void
		{
			originalQuestions = null;
			if(!questionList)
				return;
			
			if(!originalQuestions) originalQuestions = new ArrayCollection();
			
			for each(var item:QuestionVo in questionList)
			{
				if(item)
					originalQuestions.addItem(QuestionUtil.cloneQuestion( item ));
			}
		}
		
		public function restoreFromOriginalQuestions():void
		{
			var questionsBeforeChange:IList = new ArrayCollection();
			for each(var question:QuestionVo in originalQuestions)
			{
				if(question)
					questionsBeforeChange.addItem( QuestionUtil.cloneQuestion(question));
			}
			questions = questionsBeforeChange;
			if(chapter)
				chapter.questions = questionsBeforeChange;
			changedQuestions = null;
			hasChange = false;
		}
		
		/**
		 *  @private
		 */
		private function scrollGrid(itemIndex:int):void
		{
			questionList.ensureCellIsVisible(itemIndex, 1);
		}
		
		private function enableElements(enable:Boolean):void
		{
			questionTextArea.enabled 		= enable;
			addNewAnswerButton.enabled 		= enable;
			answerList.enabled 				= enable;
		}
		
		
		private function getOriginalQuestion(changedQuestion:QuestionVo):QuestionVo
		{
			if(!originalQuestions || !changedQuestion) return null;
			for each(var item:QuestionVo in changedQuestion)
			{
				if(item && item.guid == changedQuestion.guid)
					return item;
			}
			return null;
		}
		
		public function addToChangedQuestions(question:QuestionVo):void
		{
			if(!changedQuestions)
				changedQuestions = new ArrayCollection();
			
			if(changedQuestions.getItemIndex(question.guid ) == -1)
				changedQuestions.addItem( question.guid );
			
			hasChange = changedQuestions.length > 0;
		}
		
		public function removeFromChangedQuestions(question:QuestionVo):void
		{
			if(!changedQuestions)
				return;
			var index:int = changedQuestions.getItemIndex( question.guid );
			if(index != -1) changedQuestions.removeItemAt( index );
			
			hasChange = changedQuestions.length > 0;
		}
		
		private function compareChanges():void
		{
			if(currentQuestion)
			{
				var origQuestion:QuestionVo = getOriginalQuestion(currentQuestion);
				
				if(!origQuestion)
					addToChangedQuestions(currentQuestion);
				else if(QuestionUtil.compareQuestion(origQuestion, currentQuestion))
					addToChangedQuestions(currentQuestion);
				else
					removeFromChangedQuestions(currentQuestion);
			}
		}
		
		private function checkOnEmptyText():void
		{
			if(questionTextArea)
				questionTextArea.errorString = StringUtil.isNullOrEmpty(questionTextArea.text) ? resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyQuestionTextError') || 'Question text is missing.' : '';
		}
		
		public function isQuestionsComplete():Boolean
		{
			for each(var question:QuestionVo in questions)
			{
				if(question && (StringUtil.isNullOrEmpty(question.text) || !isAnswersComplete(question.answers)))
					return false;
			}
			return true;
		}
		
		private function isAnswersComplete(answerList:IList):Boolean
		{
			if(!answerList || answerList.length == 0) return false;
			var completeFlag:Boolean = true;
			var selectedCorrectAnswer:int = 0;
			for each(var answer:AnswerVo in answerList)
			{
				if(answer)
				{
					if(StringUtil.isNullOrEmpty(answer.text))
					{
						completeFlag = false;
						break;
					}
					
					if(answer.isCorrect) selectedCorrectAnswer++;
				}
			}
			return (!completeFlag || selectedCorrectAnswer == 0 ) ? false : true;
		}
		
		public function showIncompleteItemsPopup():void
		{
			var titleText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "warningPopupTitleText") || "WARNING";
			var messageText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "incompleteQuestionsWarningMessage") || "Some of the questions in this list are missing text or correct answer doesn't selected.  Complete or remove these items before proceeding.";
			popup = new PopupWindow();
			popup.setStyle("skinClass", InfoWindowSkin);
			popup.title = titleText;
			popup.message = messageText;
			popup.addEventListener(Event.CLOSE, onPopupHandler);
			popup.addEventListener(PopupWindow.OK, onPopupHandler);
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			PopUpManager.addPopUp(popup, rootApp, true);
			PopUpManager.centerPopUp(popup);
			popup.setFocus();
		}
		
		private function showDeleteConfirmPopup():void
		{
			var deleteChapterWarn:String 	= resourceManager.getString( ResourceConstants.COURSE_CREATOR, "deleteItemWarnMessage" ) || "Are you sure to delete this item?";
			var deleteTitle:String 		= resourceManager.getString( ResourceConstants.COURSE_CREATOR, "deleteItemWarnTitle" ) || "DELETE ITEM";
			confirmationPopup = ConfirmationPopup.show( deleteTitle, deleteChapterWarn, true );
			
			confirmationPopup.addEventListener( ConfirmationPopup.YES, onDeleteWarningPromptHandler );
			confirmationPopup.addEventListener( ConfirmationPopup.NO, onDeleteWarningPromptHandler );
			confirmationPopup.addEventListener( Event.CLOSE,  onDeleteWarningPromptHandler);
		}
		
		private function deleteAnswer():void
		{
			if(answerList.selectedItem)
			{
				var answer:AnswerVo = answerList.selectedItem as AnswerVo;
				if(currentQuestion && answer)
				{
					var index:int = currentQuestion.answers.getItemIndex(answer);
					if(index != -1)
					{
						currentQuestion.answers.removeItemAt(index);
						answersChanged = true;
						invalidateProperties();
						addToChangedQuestions(currentQuestion);
					}
				}
			}
		}
		
		private function deleteQuestion():void
		{
			var deletingQuestion:QuestionVo = questionList.selectedItem as QuestionVo;
			if(deletingQuestion && _questions)
			{
				var index:int = _questions.getItemIndex( deletingQuestion );
				if(index != -1)
				{
					_questions.removeItemAt( index );
					questions = _questions;
					if(deletingQuestion.isNotSaveToServer)
						removeFromChangedQuestions(deletingQuestion);
					else
						addToChangedQuestions( deletingQuestion );
					if(index == selectedIndex)
					{
						if(questions.length == 0)
							currentQuestion = null;
						else
						{
							_selectedIndex = (questions.length -1) < _selectedIndex ? _selectedIndex - 1 : _selectedIndex;
							currentQuestion = questions.getItemAt( _selectedIndex ) as QuestionVo;
						}
					}
				}
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		protected function onPopupHandler(event:Event):void
		{
			popup.removeEventListener(Event.CLOSE, onPopupHandler);
			popup.removeEventListener(PopupWindow.OK, onPopupHandler);
			PopUpManager.removePopUp( popup );
			popup = null;
			dispatchEvent(new CourseEvent(CourseEvent.CANCEL_PREVIOUSE_ACTION))
		}
		/**
		 *  @protected
		 */
		private function onDeleteWarningPromptHandler(event:Event):void
		{
			if( event.type == ConfirmationPopup.YES )
			{
				if(isAnswerDeleteConfirm)
					deleteAnswer();
				else
					deleteQuestion();
				
			}
			confirmationPopup = null;
			isAnswerDeleteConfirm = false;
		}
		
		protected function onQuestionTextChange(event:TextOperationEvent):void
		{
			if(currentQuestion)
				currentQuestion.text = TrimUtil.trim(questionTextArea.text);
			formatInputText(questionTextArea, event );
			if(questionList)
				questionList.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
			checkOnEmptyText();
			compareChanges();
		}
		
		protected function onQuestionDelete(event:DataGridEvent):void
		{
			showDeleteConfirmPopup();
		}
		
		protected function indexChangedHandler(event:GridSelectionEvent):void
		{
			if(questionList.selectedItem is QuestionVo)
			{
				currentQuestion = questionList.selectedItem as QuestionVo;
				selectedIndex = questionList.selectedIndex;
			}
		}
		
		protected function onDoneView(event:MouseEvent):void
		{
			if(hasChange)
			{
				if(isQuestionsComplete())
					dispatchEvent(new CourseEvent(CourseEvent.SHOW_UNSAVED_POPUP));
				else
					showIncompleteItemsPopup();
			}
			else
			{
				dispatchEvent(new QuestionEvent(QuestionEvent.DONE_QUESTIONS_VIEW));
			}
		}
		
		protected function onSaveButtonClick(event:MouseEvent):void
		{
			if(chapter)
			{
				if(isQuestionsComplete())
				{
					var serviceVO:QuestionServiceVO = new QuestionServiceVO(questions, chapter.chapterUuid);
					dispatchEvent(new QuestionEvent(QuestionEvent.SAVE_QUESTIONS, serviceVO));
				}
				else
					showIncompleteItemsPopup();
			}
		}
		
		protected function onAddNewAnswer(event:MouseEvent):void
		{
			if(currentQuestion)
			{
				currentQuestion.answers.addItem(new AnswerVo());
				answersChanged = true;
				invalidateProperties();
				compareChanges();
			}
		}
		
		protected function onAddNewQuestion(event:MouseEvent):void
		{
			var question:QuestionVo = new QuestionVo();
			question.guid = UIDUtil.createUID();
			if(chapter)
				question.chapterUuid = chapter.chapterUuid;
			question.answers = new ArrayCollection();
			question.answers.addItem(new AnswerVo());
			question.answers.addItem(new AnswerVo());
			question.answers.addItem(new AnswerVo());
			question.answers.addItem(new AnswerVo());
			question.isNotSaveToServer = true;
			if(!_questions)
				_questions = new ArrayCollection();
			_questions.addItem(question);
			questions = _questions;
			addToChangedQuestions(question);
			_selectedIndex = questions.length - 1;
			currentQuestion = question;
		}
		
		
		protected function onAnswerTextChange(event:QuestionEvent):void
		{
			compareChanges();
		}
		
		protected function onAnswerSelectionChange(event:QuestionEvent):void
		{
			compareChanges();
		}
		
		protected function onDeleteAnswer(event:QuestionEvent):void
		{
			isAnswerDeleteConfirm = true;
			showDeleteConfirmPopup();
		}		
		
		/** 
		 * @private
		 * Sets Direction and font of text control based on user's input
		 */
		private function formatInputText(control:TextArea, event:TextOperationEvent):void
		{
			if(event.operation is InsertInlineGraphicOperation )
			{
				event.preventDefault();
			}
			else if(event.operation is InsertTextOperation)
			{
				var operation:InsertTextOperation = event.operation as InsertTextOperation;
				var currentPosition:int = Math.max( control.selectionAnchorPosition, control.selectionActivePosition);
				var srt:String = control.text;
				if(currentPosition > srt.length)
					currentPosition = srt.length;
				
				if(operation.text == " ")
					return;
				
				var regExp:RegExp = /\S/ig;
				var format:TextLayoutFormat =  new TextLayoutFormat();
				if(regExp.test(operation.text))
					format.fontFamily =  TLFUtil.getFont(operation.text, latinFont, cyrillicFont);
				if(format.fontFamily == cyrillicFont && latinDirection == Direction.RTL && control.getStyle("direction") == Direction.LTR)
				{
					control.setStyle("direction",  Direction.RTL);
					control.setStyle("textAlign",  TextAlign.RIGHT);
				}
				else if (format.fontFamily == latinFont && cyrillicDirection == Direction.LTR && control.getStyle("direction") == Direction.RTL)
				{
					control.setStyle("direction",  Direction.LTR);
					control.setStyle("textAlign",  TextAlign.LEFT);
				}
				control.setFormatOfRange(format, currentPosition - operation.text.length, currentPosition);
			}
		}
	}
}