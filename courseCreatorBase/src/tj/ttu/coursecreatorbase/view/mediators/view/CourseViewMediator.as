////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.view
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.base.vo.DepartmentVO;
	import tj.ttu.components.events.DataGridEvent;
	import tj.ttu.components.events.LessonEvent;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.states.CourseBaseState;
	import tj.ttu.coursecreatorbase.view.components.view.CourseView;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * CourseViewMediator class 
	 */
	public class CourseViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "CourseViewMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var isDeleteLessonProcess:Boolean;
		private var clonningLesson:LessonVO;
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
		 * CourseViewMediator 
		 */
		public function CourseViewMediator( viewComponent:CourseView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CourseView
		{
			return viewComponent as CourseView;
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
				component.addEventListener(LessonEvent.GET_LESSONS, onGetLessons);
				component.addEventListener( DataGridEvent.ITEM_EDIT, onLessonEdit );
				component.addEventListener( DataGridEvent.ITEM_CLONE, onLessonClone );
				component.addEventListener( DataGridEvent.ITEM_DELETE, onLessonDelete );
				retrieveDepartments();
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(LessonEvent.GET_LESSONS, onGetLessons);
				component.removeEventListener( DataGridEvent.ITEM_EDIT, onLessonEdit );
				component.removeEventListener( DataGridEvent.ITEM_CLONE, onLessonClone );
				component.removeEventListener( DataGridEvent.ITEM_DELETE, onLessonDelete );
				hideBusyProgressBar( CourseServiceNotification.DEPARTMENTS_RETRIEVED );
			}
			isDeleteLessonProcess = false;
			super.onRemove();
		}
		
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case CourseServiceNotification.DEPARTMENTS_RETRIEVED:
				{
					hideBusyProgressBar(note.getName());
					if(courseProxy && component)
					{
						var departments:IList = note.getBody() as IList;
						if(departments.length > 0)
							component.departments = courseProxy.departments = departments;
						else
						{
							component.departments = null;
							courseProxy.cleanUp();
							courseProxy.resetUserPrefs();
							sendNotification(CourseCreatorNotifications.CHANGE_MAIN_VIEW, CourseBaseState.CREATE_COURSE);
							sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED, 0);
							sendNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, 0);
						}
					}
					break;
				}
				case CourseServiceNotification.LESSONS_BY_DEPARTMENT_RETRIEVED:
				{
					hideBusyProgressBar(note.getName());
					var lessons:IList = note.getBody() as IList;
					if(!lessons || lessons.length == 0)
						retrieveDepartments();
					else
					{
						if(component)
							component.lessons = note.getBody() as IList;
					}
					break;
				}
				case CourseServiceNotification.LESSON_CLONED:
				{
					var lesson:LessonVO = note.getBody() as LessonVO;
					if(lesson && lesson.departmentId == clonningLesson.departmentId)
					{
						if(component)
							component.applyCloneLesson(lesson);
					}
					else
						retrieveDepartments();
					break;
				}
				case CourseServiceNotification.LESSON_DELETED:
				{
					hideBusyProgressBar(note.getName());
					
					if(courseProxy)
					{
						if(courseProxy.currentLesson)
						{
							if(courseProxy.deletingLesson.guid == courseProxy.currentLesson.guid)
							{
								courseProxy.cleanUp();
								courseProxy.resetUserPrefs();
							}
						}
						if(component.lessons.length == 1)
						{
							component.lessons  = null;
							component.isLesson = false;
							retrieveDepartments();
						}
						else if(component && component.currentDepartment)
						{
							component.lessons = null;
							retrieveLessonsByDepartment(component.currentDepartment);
						}
						courseProxy.deletingLesson = null;
						isDeleteLessonProcess = false;
					}	
					break;
				}
				case TTUConstants.SHOW_ERROR_WINDOW:
					hideBusyProgressBar(note.getName());
					if(courseProxy)
						courseProxy.deletingLesson = null;
					isDeleteLessonProcess = false;
					break;
				case TTUConstants.LANGUAGE_CHANGE:
					retrieveDepartments();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push(CourseServiceNotification.DEPARTMENTS_RETRIEVED);
			arr.push(CourseServiceNotification.LESSONS_BY_DEPARTMENT_RETRIEVED);
			arr.push(CourseServiceNotification.LESSON_CLONED);
			arr.push(CourseServiceNotification.LESSON_DELETED);
			arr.push(TTUConstants.SHOW_ERROR_WINDOW);
			arr.push(TTUConstants.LANGUAGE_CHANGE);
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
		private function retrieveDepartments():void
		{
			if(component && resourceProxy)
			{
				component.isDepartment = true;
				component.locale = resourceProxy.locale;
			}
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveDepartmentsProgressMessage') || 'Retrieving departments';
			showBusyProgressBar(message, CourseServiceNotification.DEPARTMENTS_RETRIEVED);
			sendNotification(CourseServiceNotification.RETRIEVE_DEPARTMENTS);
		}
		
		private function retrieveLessonsByDepartment(departmentVO:DepartmentVO):void
		{
			if(!departmentVO) return;
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveLessonsProgressMessage') || 'Retrieving lessons';
			showBusyProgressBar(message, CourseServiceNotification.LESSONS_BY_DEPARTMENT_RETRIEVED);
			sendNotification(CourseServiceNotification.RETRIEVE_LESSONS_BY_DEPARTMENT, departmentVO.departmentCode);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onGetLessons(event:LessonEvent):void
		{
			var departmentVO:DepartmentVO = event.data as DepartmentVO;
			retrieveLessonsByDepartment(departmentVO);
		}
		
		
		/**
		 *  @private
		 */
		protected function onLessonEdit(event:DataGridEvent):void
		{
			var lessonVO:LessonVO = event.item as LessonVO;
			if(!lessonVO)
				return;
			
			if(courseProxy)
			{
				courseProxy.cleanUp();
				courseProxy.currentLesson = lessonVO;
				courseProxy.wasLessonRetrieved = true;
				courseProxy.addQueueNotification(CourseCreatorNotifications.CHANGE_CREATE_COURSE_VIEW_INDEX, lessonVO.viewIndex);
				sendNotification(CourseCreatorNotifications.CHANGE_MAIN_VIEW, CourseBaseState.CREATE_COURSE);
				if(lessonVO.createMaxActiveViewIndex == 0)
					sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED, 0);
				else
					courseProxy.createMaxActiveViewIndex = lessonVO.createMaxActiveViewIndex;
			}
			
		}
		
		
		protected function onLessonDelete(event:DataGridEvent):void
		{
			if(isDeleteLessonProcess)
				return;
			var data:LessonVO = event.item as LessonVO;
			if(!data)
				return;
			isDeleteLessonProcess = true;
			if(courseProxy)
			{
				courseProxy.deletingLesson = data;
				if(courseProxy.currentLesson && courseProxy.currentLesson.guid == courseProxy.deletingLesson.guid)
					sendNotification(CourseCreatorNotifications.DISABLE_MAIN_TAB_BY_INDEX, CourseBaseState.getViewIndex(CourseBaseState.CREATE_COURSE));
			}
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'deleteLessonProgressMessage') || 'Removing lesson';
			showBusyProgressBar(message, CourseServiceNotification.LESSON_DELETED);
			sendNotification(CourseServiceNotification.DELETE_LESSON, data);
			
		}
		
		protected function onLessonClone(event:DataGridEvent):void
		{
			clonningLesson = event.item as LessonVO;
			if(clonningLesson )
				sendNotification(CourseCreatorNotifications.SHOW_CLONE_LESSON_POPUP, clonningLesson);
		}
	}
}