////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 9, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.create
{
	import flash.events.Event;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.states.CreateCourseStates;
	import tj.ttu.coursecreatorbase.view.components.create.BaseCreateCourseView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * BaseCreateCourseViewMediator class 
	 */
	public class BaseCreateCourseViewMediator extends Mediator
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
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * BaseCreateCourseViewMediator 
		 */
		public function BaseCreateCourseViewMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get comp():BaseCreateCourseView
		{
			return viewComponent as BaseCreateCourseView;
		}
		
		private var _courseProxy:CourseProxy;
		public function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy;
			return _courseProxy;
		}
		
		public function get resourceManager():IResourceManager
		{
			return ResourceManager.getInstance();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			if(comp)
			{
				comp.addEventListener(CourseEvent.SHOW_EDIT_LESSON_DETAILS_WINDOW, onEditLessonDetails);
				comp.addEventListener(CourseEvent.HAS_CHANGE, onHasChange);
				comp.addEventListener(CourseEvent.NEXT, onNextScreen);
				comp.addEventListener(CourseEvent.BACK_TO_PREVIOUS_SCREEN, onBackToPreviouseScreen);
			}
		}
		
		override public function onRemove():void
		{
			if(comp)
			{
				comp.removeEventListener(CourseEvent.SHOW_EDIT_LESSON_DETAILS_WINDOW, onEditLessonDetails);
				comp.removeEventListener(CourseEvent.HAS_CHANGE, onHasChange);
				comp.removeEventListener(CourseEvent.NEXT, onNextScreen);
				comp.removeEventListener(CourseEvent.BACK_TO_PREVIOUS_SCREEN, onBackToPreviouseScreen);
			}
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case CourseServiceNotification.LESSON_CREATED:
				{
					if(courseProxy && comp)
					{
						comp.lesson = courseProxy.currentLesson = note.getBody() as LessonVO;
						courseProxy.shouldCheckOnValid = true;
					}
					break;
				}
				case CourseCreatorNotifications.HAS_CHANGE:
				{
					if(comp)
						comp.hasChange =  note.getBody() as Boolean;
					break;
				}
				case TTUConstants.SHOW_ERROR_WINDOW:
				{
					hideBusyProgressBar(note.getName());
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CourseServiceNotification.LESSON_CREATED,
			CourseCreatorNotifications.HAS_CHANGE,
			TTUConstants.SHOW_ERROR_WINDOW];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function nextScreen():void
		{
			var newIndex:int = CreateCourseStates.getViewIndex(courseProxy.currentCreateLessonState) + 1;
			if(newIndex < 4 )
			{
				sendNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, newIndex);
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
	
		/**
		 *  @private
		 */
		
		public function disableRightTabs(viewName:String):void
		{
			if(courseProxy)
			{
				var viewIndex:int = CreateCourseStates.getViewIndex(viewName);
				courseProxy.resetStateIndex();
				courseProxy.resetCreateMaxActiveViewIndex();
				courseProxy.currentStateIndex = viewIndex;
				courseProxy.createMaxActiveViewIndex = viewIndex;
				if(viewIndex == 0)
					sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED, viewIndex);
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
		
		
		protected function onEditLessonDetails(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.SHOW_EDIT_LESSON_DETAILS_POPUP );
		}
		
		protected function onHasChange(event:CourseEvent):void
		{
			if(courseProxy)
				courseProxy.hasChange = event.data as Boolean;
		}
		
		
		protected function onBackToPreviouseScreen(event:Event):void
		{
			var newIndex:int = CreateCourseStates.getViewIndex(courseProxy.currentCreateLessonState) - 1;
			if(newIndex >= 0 )
			{
				sendNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, newIndex);
			}
		}
		
		protected function onNextScreen(event:Event):void
		{
			nextScreen();
		}
		
	}
}