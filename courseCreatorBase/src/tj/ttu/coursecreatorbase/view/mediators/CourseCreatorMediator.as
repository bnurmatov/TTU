////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators
{
	import flash.events.Event;
	
	import mx.events.StateChangeEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.LocaleVO;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.states.CourseBaseState;
	import tj.ttu.coursecreatorbase.states.CreateCourseStates;
	import tj.ttu.coursecreatorbase.view.components.CourseBase;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.create.CreateCourseMediator;
	import tj.ttu.coursecreatorbase.view.mediators.view.CourseViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.UserSettingsVO;
	import tj.ttu.modulePlayer.view.mediators.LessonHolderMediator;
	
	/**
	 * CourseBaseMediator class 
	 */
	public class CourseCreatorMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CourseBaseMediator';
		
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
		 * CourseBaseMediator 
		 */
		public function CourseCreatorMediator(viewComponent:CourseBase)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CourseBase
		{
			return viewComponent as CourseBase;
		}
		
		private var _courseProxy:CourseProxy;
		public function get courseProxy():CourseProxy
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
				facade.registerProxy( new CourseProxy());
				sendNotification(CourseServiceNotification.RETRIEVE_USER_SETTINGS);
				component.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
				component.addEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				component.addEventListener(CourseEvent.SHOW_CREATE_LESSON_WINDOW, onShowCreateLessonPopup);
				
				facade.registerMediator( new CreateCourseMediator(component.createCourseView));	
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
				component.removeEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				component.removeEventListener(CourseEvent.SHOW_CREATE_LESSON_WINDOW, onShowCreateLessonPopup);
				
				facade.removeMediator( CreateCourseMediator.NAME);	
				facade.removeMediator( CourseViewMediator.NAME);
				facade.removeProxy( CourseProxy.NAME );
			}
			viewComponent = null
			super.onRemove();
		}
		
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case TTUConstants.LANGUAGE_CHANGE:
				{
					var vo:LocaleVO = note.getBody() as LocaleVO;
					if(vo && courseProxy)
					{
						courseProxy.currentLocale = vo.locale;
					}
					break;
				}
				case CourseServiceNotification.USER_SETTINGS_RETRIEVED:
				{
					var userPrefs:UserSettingsVO = note.getBody() as UserSettingsVO;
					if(userPrefs)
					{
						courseProxy.userPrefs = userPrefs;
						courseProxy.currentLocale = userPrefs.locale;
						courseProxy.currentStateIndex 	= userPrefs.createViewIndex;
						
						if(userPrefs.currentLessonUUID)
							sendNotification(CourseServiceNotification.RETRIEVE_LESSON_BY_UUID, userPrefs.currentLessonUUID);
						else if(userPrefs.hasLesson)
						{
							if(component)
								component.currentViewIndex = CourseBaseState.getViewIndex( CourseBaseState.COURSE_LIST);
						}
						else
							sendNotification(CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP);
					}
					else
					{
						sendNotification(CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP);
					}
					break;
				}
				case CourseServiceNotification.LESSON_BY_UUID_RETRIEVED:
				{
					if(courseProxy && note.getBody())
					{
						if(note.getBody() is Array)
							courseProxy.currentLesson = (note.getBody() as Array)[0];
						else
							courseProxy.currentLesson = note.getBody() as LessonVO;
						courseProxy.currentStateIndex = courseProxy.currentLesson.viewIndex;
						courseProxy.createMaxActiveViewIndex = courseProxy.currentLesson.createMaxActiveViewIndex;
						sendNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, courseProxy.currentLesson.viewIndex);
					}
					break;
				}
				case CourseCreatorNotifications.CHANGE_MAIN_VIEW:
				{
					if(component)
						component.currentViewIndex = CourseBaseState.getViewIndex( note.getBody() as String);
					break;
				}
				case CourseCreatorNotifications.SHOW_MY_LESSONS:
				{
					if(component)
						component.currentViewIndex = CourseBaseState.getViewIndex( CourseBaseState.COURSE_LIST);
					break;
				}
				case CourseCreatorNotifications.HAS_CHANGE:
				{
					if(component)
						component.hasChange =  note.getBody() as Boolean;
					break;
				}
				case CourseCreatorNotifications.HAS_QUESTIONS_CHANGE:
				{
					if(component)
						component.hasQuestionsChange = note.getBody() as Boolean;
					break;
				}
				case CourseCreatorNotifications.SHOULD_CHECK_ON_VALID:
				{
					if(component)
						component.shouldCheckOnValid = note.getBody() as Boolean;
					break;
				}
				case CourseCreatorNotifications.START_PREVIOUSE_ACTION:
				{
					if(component)
						component.continueAction();
					break;
				}
				case CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION:
				case CourseCreatorNotifications.SUB_TAB_STOPED_ACTION:
				{
					if(component)
						component.resetIndexes();
					break;
				}
				case CourseCreatorNotifications.SHOW_PREVIEW :
				{
					component.isLessonPlayer = true;
					break;
				}
				case CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP :
				{
					component.currentViewIndex = 0;
					courseProxy.shouldCheckOnValid = false;
					break;
				}
				case TTUConstants.BACK_TO_VIEW :
				{
					if(component.isLessonPlayer)
					{
						component.isCreateCourse = true;
					}
					break;
				}
				case TTUConstants.SHOW_ERROR_WINDOW:
				case TTUConstants.FONT_LOADED:
				{
					sendNotification(TTUConstants.SPIN_END, new BusyProgressbarVO(null, note.getName()));
					break;
				}
				case CourseCreatorNotifications.ENABLE_MAIN_TAB_BY_INDEX:
				{
					if(component)
						component.enableTabbarItem(int(note.getBody()));
					break;
				}
				case CourseCreatorNotifications.DISABLE_MAIN_TAB_BY_INDEX:
				{
					if(component)
						component.enableTabbarItem(int(note.getBody()), false);
					break;
				}
				case CourseServiceNotification.USER_SETTINGS_UPDATED:
				{
					if(courseProxy)
						courseProxy.userPrefs = note.getBody() as UserSettingsVO;
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push(CourseServiceNotification.USER_SETTINGS_RETRIEVED);
			arr.push(CourseServiceNotification.LESSON_BY_UUID_RETRIEVED);
			arr.push(CourseCreatorNotifications.CHANGE_MAIN_VIEW);
			arr.push(CourseCreatorNotifications.SHOW_MY_LESSONS);
			arr.push(CourseCreatorNotifications.HAS_CHANGE);
			arr.push(CourseCreatorNotifications.HAS_QUESTIONS_CHANGE);
			arr.push(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
			arr.push(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
			arr.push(CourseCreatorNotifications.SUB_TAB_STOPED_ACTION);
			arr.push(CourseCreatorNotifications.SHOULD_CHECK_ON_VALID);
			arr.push(CourseCreatorNotifications.SHOW_PREVIEW);
			arr.push(TTUConstants.BACK_TO_VIEW);
			arr.push(TTUConstants.SHOW_ERROR_WINDOW);
			arr.push(TTUConstants.FONT_LOADED);
			arr.push(TTUConstants.LANGUAGE_CHANGE);
			arr.push(CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP);
			arr.push(CourseCreatorNotifications.ENABLE_MAIN_TAB_BY_INDEX);
			arr.push(CourseCreatorNotifications.DISABLE_MAIN_TAB_BY_INDEX);
			arr.push(CourseServiceNotification.USER_SETTINGS_UPDATED);
			return arr;
			
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
		protected function onStateChange(event:StateChangeEvent):void
		{
			if(event.newState == CourseBaseState.CREATE_COURSE)
			{
				if(facade.hasMediator(CourseViewMediator.NAME))
					facade.removeMediator(CourseViewMediator.NAME);
				if(facade.hasMediator(LessonHolderMediator.NAME))
					facade.removeMediator(LessonHolderMediator.NAME);
				facade.registerMediator( new CreateCourseMediator(component.createCourseView));
			}
			else if(event.newState == CourseBaseState.COURSE_LIST)
			{
				if(facade.hasMediator(CreateCourseMediator.NAME))
					facade.removeMediator(CreateCourseMediator.NAME);
				if(facade.hasMediator(LessonHolderMediator.NAME))
					facade.removeMediator(LessonHolderMediator.NAME);
				facade.registerMediator( new CourseViewMediator(component.courseView));
			}
			else if(event.newState == CourseBaseState.LESSON_PLAYER)
			{
				if(facade.hasMediator(CreateCourseMediator.NAME))
					facade.removeMediator(CreateCourseMediator.NAME);
				if(facade.hasMediator(CourseViewMediator.NAME))
					facade.removeMediator(CourseViewMediator.NAME);
				facade.registerMediator( new LessonHolderMediator(component.lessonHolder));
			}
			sendNotification(CourseCreatorNotifications.MAIN_VIEW_STATE_CHANGE, event);
		}
		
		protected function onShowUnsavedPopup(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE);
			sendNotification(CourseCreatorNotifications.MAIN_TAB_STOPED_ACTION);
		}
		
		protected function onShowCreateLessonPopup(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP );
		}
		/**
		 *  @private
		 */
		
		
	}
}