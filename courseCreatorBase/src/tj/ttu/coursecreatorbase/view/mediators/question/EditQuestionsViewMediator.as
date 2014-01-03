////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.question
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.components.events.QuestionEvent;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.question.EditQuestionsView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * AssesmentViewMediator class 
	 */
	public class EditQuestionsViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'AssesmentViewMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var isDoneView:Boolean;
		private var nextNote:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AssesmentViewMediator 
		 */
		public function EditQuestionsViewMediator(viewComponent:EditQuestionsView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():EditQuestionsView
		{
			return viewComponent as EditQuestionsView;
		}
		
		public function get resourceManager():IResourceManager
		{
			return ResourceManager.getInstance();
		}
		
		private var _courseProxy:CourseProxy;
		
		private function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy;
			return _courseProxy;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			if(component)
			{
				component.addEventListener(QuestionEvent.GET_QUESTIONS, onGetQuestions);
				component.addEventListener(QuestionEvent.SAVE_QUESTIONS, onSaveQuestions);
				component.addEventListener(QuestionEvent.DONE_QUESTIONS_VIEW, onDoneView);
				component.addEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				component.addEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, onCancelPreviouseAction);
				component.addEventListener(CourseEvent.HAS_CHANGE, onHasChange);
				if(courseProxy)
				{
					courseProxy.shouldCheckOnValid = true;
					component.chapter = courseProxy.currentChapter;
				}
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(QuestionEvent.GET_QUESTIONS, onGetQuestions);
				component.removeEventListener(QuestionEvent.SAVE_QUESTIONS, onSaveQuestions);
				component.removeEventListener(QuestionEvent.DONE_QUESTIONS_VIEW, onDoneView);
				component.removeEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				component.removeEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, onCancelPreviouseAction);
				component.removeEventListener(CourseEvent.HAS_CHANGE, onHasChange);
				component.resetComponent();
			}
			isDoneView = false;
			nextNote = null;
			if(courseProxy)
			{
				courseProxy.hasQuestionsChange = false;
				courseProxy.shouldCheckOnValid = false;
			}
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			var questions:IList = note.getBody() as IList;
			switch(note.getName())
			{
				case CourseServiceNotification.QUESTIONS_UPDATED:
					hideBusyProgressBar(note.getName());
					setData(questions);
					if(courseProxy && courseProxy.unsavedPopupShown)
					{
						if(nextNote == CourseCreatorNotifications.SHOW_MY_LESSONS)
						{
							sendNotification(CourseCreatorNotifications.DONE_QUESTION_VIEW);
							courseProxy.unsavedPopupShown = false;
							sendNotification(nextNote);
						}
						else 
							startPreviousAction();
					}
					break;
				case CourseServiceNotification.QUESTIONS_BY_CHAPTER_UUID_RETRIVED:
					hideBusyProgressBar(note.getName());
					setData(questions);
					break;
				case TTUConstants.LANGUAGE_CHANGE:
				case CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE:
					if(courseProxy && courseProxy.hasQuestionsChange)
					{
						nextNote = note.getName() == TTUConstants.LANGUAGE_CHANGE ? CourseCreatorNotifications.SHOW_MY_LESSONS : CourseCreatorNotifications.START_PREVIOUSE_ACTION;
						courseProxy.unsavedPopupShown = true;
						sendNotification(CourseCreatorNotifications.SHOW_UNSAVED_POPUP);
					}
					break;
				case CourseCreatorNotifications.SAVE_CHANGES:
					if(courseProxy && courseProxy.hasQuestionsChange && component)
						component.saveChanges();
					break;
				case CourseCreatorNotifications.DISCARD_CHANGES:
					if(courseProxy && component)
					{
						component.restoreFromOriginalQuestions();
						component.hasChange = courseProxy.hasQuestionsChange = false;
						
						if(nextNote == CourseCreatorNotifications.SHOW_MY_LESSONS)
						{
							sendNotification(CourseCreatorNotifications.DONE_QUESTION_VIEW);
							courseProxy.unsavedPopupShown = false;
							sendNotification(nextNote);
						}
						else if(component.isQuestionsComplete())
							startPreviousAction();
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CourseServiceNotification.QUESTIONS_UPDATED,
					CourseServiceNotification.QUESTIONS_BY_CHAPTER_UUID_RETRIVED,
					CourseCreatorNotifications.SAVE_CHANGES,
					CourseCreatorNotifications.DISCARD_CHANGES,
					TTUConstants.LANGUAGE_CHANGE,
					CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function showBusyProgressBar(message:String, noteName:String):void
		{
			var vo:BusyProgressbarVO = new BusyProgressbarVO(message, noteName);
			sendNotification( TTUConstants.SHOW_BUSY_PROGRESS_BAR, vo);
		}
		
		public function hideBusyProgressBar(noteName:String):void
		{
			var vo:BusyProgressbarVO = new BusyProgressbarVO(null, noteName);
			sendNotification( TTUConstants.SPIN_END, vo);
		}
		/**
		 *  @private
		 */
		private function setData(questions:IList, shouldCloneQuestions:Boolean = true):void
		{
			if(courseProxy && courseProxy.currentChapter)
			{
				courseProxy.hasQuestionsChange = false;
				courseProxy.currentChapter.questions = questions;
			}
			if(component)
			{
				component.hasChange = false;
				component.changedQuestions = null;
				component.questions = questions;
				if(shouldCloneQuestions)
					component.setOriginalQuestions(questions);
			}
		}
		
		/**
		 *  @private
		 */
		private function startPreviousAction():void
		{
			if(courseProxy && courseProxy.unsavedPopupShown)
			{
				if(isDoneView)
					sendNotification(CourseCreatorNotifications.DONE_QUESTION_VIEW);
				isDoneView = false;
				courseProxy.unsavedPopupShown = false;
				sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onGetQuestions(event:QuestionEvent):void
		{
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveQuestionsProgressMessage') || 'Retrieving questions';
			showBusyProgressBar(message, CourseServiceNotification.QUESTIONS_BY_CHAPTER_UUID_RETRIVED);
			sendNotification(CourseServiceNotification.RETRIVE_QUESTIONS_BY_CHAPTER_UUID, event.data);
		}
		
		protected function onSaveQuestions(event:QuestionEvent):void
		{
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'saveQuestionsProgressMessage') || 'Saving questions';
			showBusyProgressBar(message, CourseServiceNotification.QUESTIONS_UPDATED);
			sendNotification(CourseServiceNotification.UPDATE_QUESTIONS, event.data );
		}
		
		
		protected function onDoneView(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.DONE_QUESTION_VIEW);
		}
		
		protected function onShowUnsavedPopup(event:Event):void
		{
			if(courseProxy)
				courseProxy.unsavedPopupShown = true;
			isDoneView = true;
			sendNotification(CourseCreatorNotifications.SHOW_UNSAVED_POPUP);
		}
		
		protected function onCancelPreviouseAction(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
		}
		
		protected function onHasChange(event:CourseEvent):void
		{
			if(courseProxy)
				courseProxy.hasQuestionsChange = event.data as Boolean;
		}
		
	}
}