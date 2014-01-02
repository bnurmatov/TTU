////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.create
{
	import flash.events.Event;
	
	import mx.events.StateChangeEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.states.CourseBaseState;
	import tj.ttu.coursecreatorbase.states.CreateCourseStates;
	import tj.ttu.coursecreatorbase.view.components.create.CreateCourse;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.chapter.EditChaptersViewMediator;
	import tj.ttu.coursecreatorbase.view.mediators.details.CourseDetailsViewMediator;
	import tj.ttu.coursecreatorbase.view.mediators.publish.PublishLessonViewMediator;
	import tj.ttu.coursecreatorbase.view.mediators.resource.EditResourcesViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * CreateCourseMediator class 
	 */
	public class CreateCourseMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CreateCourseMediator';
		
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
		 * CreateCourseMediator 
		 */
		public function CreateCourseMediator(viewComponent:CreateCourse)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CreateCourse
		{
			return viewComponent as CreateCourse;
		}
		
		private var _courseProxy:CourseProxy;
		
		private function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
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
				component.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
				component.addEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				if(courseProxy)
				{
					if(!courseProxy.currentCreateLessonState)
					{
						courseProxy.currentCreateLessonState = CreateCourseStates.getViewName(courseProxy.currentStateIndex);
						component.currentViewIndex = courseProxy.currentStateIndex;
						component.validateNow();
						sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED);
					}
					else
						component.enableTabbarItem(courseProxy.createMaxActiveViewIndex);
					addMediator( courseProxy.currentCreateLessonState );
				}
				
				sendNotification(CourseCreatorNotifications.ENABLE_MAIN_TAB_BY_INDEX, CourseBaseState.getViewIndex(CourseBaseState.CREATE_COURSE));
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
				component.removeEventListener(CourseEvent.SHOW_UNSAVED_POPUP, onShowUnsavedPopup);
				component.resetComponent();
			}
			if(courseProxy)
			{
				courseProxy.shouldCheckOnValid = false;
				removeMediator( courseProxy.currentCreateLessonState );
			}
			viewComponent = null;
			super.onRemove();
		}
		
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
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
				case CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX:
				{
					if(component)
					{
						var index:int = int(note.getBody());
						component.currentViewIndex = index;
						courseProxy.currentCreateLessonState = CreateCourseStates.getViewName(index);
					}
					break;
				}
				case CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW:
				{
					component.currentViewIndex = CreateCourseStates.getViewIndex(note.getBody() as String);
					break;
				}
				case CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED:
				{
					component.enableTabbarItem( courseProxy.createMaxActiveViewIndex );
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
				case CourseCreatorNotifications.MAIN_TAB_STOPED_ACTION:
				{
					if(component)
						component.resetIndexes();
					break;
				}
				case CourseServiceNotification.LESSON_CREATED:
					component.enableTabbarItem(0);
					component.currentViewIndex = 0;
					break;
				case CourseServiceNotification.VIEW_INDEX_UPDATED:
				{
					if(courseProxy && component)
					{
						var viewIndex:int = int(note.getBody());
						courseProxy.setCurrentStateIndex(viewIndex);
						courseProxy.currentCreateLessonState = CreateCourseStates.getViewName(viewIndex);
					}
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push(CourseCreatorNotifications.HAS_CHANGE);
			arr.push(CourseCreatorNotifications.HAS_QUESTIONS_CHANGE);
			arr.push(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX);
			arr.push(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED);
			arr.push(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
			arr.push(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
			arr.push(CourseCreatorNotifications.MAIN_TAB_STOPED_ACTION);
			arr.push(CourseServiceNotification.VIEW_INDEX_UPDATED);
			arr.push(CourseCreatorNotifications.SHOULD_CHECK_ON_VALID);
			arr.push(CourseServiceNotification.LESSON_CREATED);
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
		private function addMediator(viewState:String):void
		{
			switch(viewState)
			{
				case CreateCourseStates.COURSE_DETAILS:
				{
					if(component.courseDetailsView)
						facade.registerMediator( new CourseDetailsViewMediator(component.courseDetailsView));
					break;
				}
				case CreateCourseStates.EDIT_CHAPTERS:
				{
					if(component.editChaptersView)
						facade.registerMediator( new EditChaptersViewMediator(component.editChaptersView));
					break;
				}
				case CreateCourseStates.EDIT_RESOURCES:
				{
					if(component.editResourcesView)
						facade.registerMediator( new EditResourcesViewMediator(component.editResourcesView));
					break;
				}
				case CreateCourseStates.PUBLISH_LESSON:
				{
					if(component.publishLessonView)
						facade.registerMediator( new PublishLessonViewMediator(component.publishLessonView));
					break;
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function removeMediator(viewState:String):void
		{
			switch(viewState)
			{
				case CreateCourseStates.COURSE_DETAILS:
				{
					facade.removeMediator( CourseDetailsViewMediator.NAME);
					break;
				}
				case CreateCourseStates.EDIT_CHAPTERS:
				{
					facade.removeMediator( EditChaptersViewMediator.NAME);
					break;
				}
				case CreateCourseStates.EDIT_RESOURCES:
				{
					facade.removeMediator( CourseDetailsViewMediator.NAME);
					break;
				}
				case CreateCourseStates.PUBLISH_LESSON:
				{
					facade.removeMediator( PublishLessonViewMediator.NAME);
					break;
				}
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
		protected function onStateChange(event:StateChangeEvent):void
		{
			removeMediator( event.oldState );
			addMediator( event.newState );
			var index:int = CreateCourseStates.getViewIndex(event.newState);
			if(courseProxy)
			{
				courseProxy.currentCreateLessonState = event.newState; 
				sendNotification(CourseServiceNotification.UPDATE_VIEW_INDEX, index);
				courseProxy.currentStateIndex =  index;
				courseProxy.createMaxActiveViewIndex = index;
			}
			sendNotification(CourseCreatorNotifications.CREATE_LESSON_STATE_CHANGE, event);
		}
		
		protected function onShowUnsavedPopup(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE);
			sendNotification(CourseCreatorNotifications.SUB_TAB_STOPED_ACTION);
		}
		
		/**
		 *  @private
		 */
		
		
	}
}