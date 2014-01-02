////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 19, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.states.CourseBaseState;
	import tj.ttu.coursecreatorbase.view.components.popup.CourseManagePopup;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * CourseManagePopupMediator class 
	 */
	public class CourseManagePopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CourseManagePopupMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var lesson:LessonVO;
		private var nextNoteName:String;
		private var spinEndNote:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseManagePopupMediator 
		 */
		public function CourseManagePopupMediator(viewComponent:CourseManagePopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CourseManagePopup
		{
			return viewComponent as CourseManagePopup;
		}
		
		public function get resourceManager():IResourceManager
		{
			return ResourceManager.getInstance();
		}
		
		private var _courseProxy:CourseProxy;
		
		private function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			return _courseProxy;
		}
		
		/**
		 * we currently only have a single user system 
		 */
		private var _resourceProxy:ResourceProxy;
		
		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy = facade.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
			return _resourceProxy;
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
				component.addEventListener(CourseEvent.CREATE_LESSON, onCreateLesson);
				component.addEventListener(CourseEvent.SAVE_LESSON, onSaveLesson);
				component.addEventListener(CourseEvent.CLONE_LESSON, onCloneLesson);
				component.addEventListener(CourseEvent.RETURN_TO_MY_LESSONS, onReturnToCourseView);
				component.addEventListener(CloseEvent.CLOSE, onClose);
				
				sendNotification(CourseServiceNotification.RETRIEVE_ALL_DEPARTMENTS);
				retrieveSpecialities();
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(CourseEvent.CREATE_LESSON, onCreateLesson);
				component.removeEventListener(CourseEvent.SAVE_LESSON, onSaveLesson);
				component.removeEventListener(CourseEvent.CLONE_LESSON, onCloneLesson);
				component.removeEventListener(CourseEvent.RETURN_TO_MY_LESSONS, onReturnToCourseView);
				component.removeEventListener(CloseEvent.CLOSE, onClose);
				component.resetComponent();
				PopUpManager.removePopUp( component );
			}
			nextNoteName = null;
			lesson = null;
			viewComponent = null;
			hideBusyProgressBar( CourseServiceNotification.SPECIALITIES_RETRIEVED );
			super.onRemove();
		}
		
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case CourseServiceNotification.ALL_DEPARTMENTS_RETRIEVED:
				{
					if(component)
						component.departments = note.getBody() as IList;
					break;
				}
				case CourseServiceNotification.SPECIALITIES_RETRIEVED:
				{
					hideBusyProgressBar(note.getName());
					if(component)
						component.specialities = note.getBody() as IList;
					break;
				}
				case CourseServiceNotification.LESSON_NAME_VALIDATION_RESULT:
				{
					hideBusyProgressBar(note.getName());
					var lessonNameIsValid:Boolean = note.getBody() as Boolean;
					if(lessonNameIsValid)
						doLessonOperation();
					else
					{
						if(component)
						{
							nextNoteName = null;
							lesson = null;
							component.duplicateName();
						}
					}
					break;
				}
				case CourseServiceNotification.LESSON_CREATED:
				{
					hideBusyProgressBar(note.getName());
					if(courseProxy)
					{
						courseProxy.shouldCheckOnValid = false;
						courseProxy.resetCreateMaxActiveViewIndex();
						sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED, courseProxy.createMaxActiveViewIndex);
					if(courseProxy.userPrefs)
						courseProxy.userPrefs.hasLesson = true;
					}
					removeMediator();
					break;
				}
				case CourseServiceNotification.LESSON_UPDATED:
				{
					hideBusyProgressBar(note.getName());
					removeMediator();
					break;
				}
				case CourseServiceNotification.LESSON_CLONED:
				{
					hideBusyProgressBar(note.getName());
					var cloningLesson:LessonVO = note.getBody() as LessonVO;
					if(courseProxy && cloningLesson)
					{
						courseProxy.cleanUp();
						courseProxy.currentLesson = cloningLesson;
						courseProxy.createMaxActiveViewIndex = cloningLesson.createMaxActiveViewIndex;
						courseProxy.currentStateIndex = cloningLesson.viewIndex;
						courseProxy.addQueueNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, cloningLesson.viewIndex);
						sendNotification(CourseCreatorNotifications.CHANGE_MAIN_VIEW, CourseBaseState.CREATE_COURSE);
					}
					removeMediator();
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push(CourseServiceNotification.ALL_DEPARTMENTS_RETRIEVED);
			arr.push(CourseServiceNotification.SPECIALITIES_RETRIEVED);
			arr.push(CourseServiceNotification.LESSON_CREATED);
			arr.push(CourseServiceNotification.LESSON_UPDATED);
			arr.push(CourseServiceNotification.LESSON_CLONED);
			arr.push(CourseServiceNotification.LESSON_NAME_VALIDATION_RESULT);
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
		private function removeMediator():void
		{
			facade.removeMediator( NAME );
		}
		
		private function doLessonOperation():void
		{
			if(lesson && nextNoteName)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'lessonOperationProgressMessage') || 'Lesson operation process';
				showBusyProgressBar( message, spinEndNote );
				sendNotification(nextNoteName, lesson);
			}
		}
		
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
		
		private function retrieveSpecialities():void
		{
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'specialitiesRetrivingProgressMessage') || 'Retriving Specialities';
			showBusyProgressBar(message, CourseServiceNotification.SPECIALITIES_RETRIEVED);
			sendNotification(CourseServiceNotification.RETRIEVE_SPECIALITIES);
		}
		
		private function showValidationProgress():void
		{
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'validationLessonNameProgressMessage') || 'Validation Lesson name';
			showBusyProgressBar( message,  CourseServiceNotification.LESSON_NAME_VALIDATION_RESULT);
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onClose(event:Event):void
		{
			removeMediator();
		}
		
		protected function onCloneLesson(event:CourseEvent):void
		{
			showValidationProgress();
			lesson = event.data as LessonVO;
			nextNoteName = CourseServiceNotification.CLONE_LESSON;
			spinEndNote = CourseServiceNotification.LESSON_CLONED;
			sendNotification(CourseServiceNotification.VALIDATE_LESSON_NAME, lesson);
		}
		
		
		protected function onReturnToCourseView(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.CHANGE_MAIN_VIEW, CourseBaseState.COURSE_LIST);
			removeMediator();
		}
		
		protected function onCreateLesson(event:CourseEvent):void
		{
			showValidationProgress();
			lesson = event.data as LessonVO;
			lesson.locale = resourceProxy.locale;
			nextNoteName = CourseServiceNotification.CREATE_LESSON;
			spinEndNote = CourseServiceNotification.LESSON_CREATED;
			sendNotification(CourseServiceNotification.VALIDATE_LESSON_NAME, lesson);
		}
		
		protected function onSaveLesson(event:CourseEvent):void
		{
			showValidationProgress();
			lesson = event.data as LessonVO;
			nextNoteName = CourseServiceNotification.UPDATE_LESSON;
			spinEndNote = CourseServiceNotification.LESSON_UPDATED;
			sendNotification(CourseServiceNotification.VALIDATE_LESSON_NAME, lesson);
		}
	}
}