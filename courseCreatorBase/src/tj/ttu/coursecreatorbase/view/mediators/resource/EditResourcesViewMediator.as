////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.resource
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.components.events.ResourceEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.view.components.resource.EditResourcesView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.create.BaseCreateCourseViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * EditSubjectsViewMediator class 
	 */
	public class EditResourcesViewMediator extends BaseCreateCourseViewMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'EditSubjectsViewMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var isDiscardChanges:Boolean = false;
		private var removingResource:ResourceVO;
		private var addNewResourceInProsses:Boolean;
		private var operationInProcess:Boolean;
		private var spinMessage:String;
		private var spinEndNote:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * EditSubjectsViewMediator 
		 */
		public function EditResourcesViewMediator(viewComponent:EditResourcesView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():EditResourcesView
		{
			return viewComponent as EditResourcesView;
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
				component.addEventListener(ResourceEvent.ADD_NEW_RESOURCE, 			onAddNewResource);
				component.addEventListener(ResourceEvent.DELETE_RESOURCE, 			onDeleteResource);
				component.addEventListener(ResourceEvent.SAVE_RESOURCES, 			onUpdateResources);
				component.addEventListener(ResourceEvent.UPLOAD_BOOK, 				onUploadBook);
				component.addEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				if(courseProxy)
				{
					if(courseProxy.currentLesson)
					{
						if(!courseProxy.currentLesson.resources || courseProxy.currentLesson.resources.length == 0)
							retriveResources();
						else
							setData();
					}
					courseProxy.shouldCheckOnValid = true;
					component.lesson = courseProxy.currentLesson;
				}
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ResourceEvent.ADD_NEW_RESOURCE, 			onAddNewResource);
				component.removeEventListener(ResourceEvent.DELETE_RESOURCE, 			onDeleteResource);
				component.removeEventListener(ResourceEvent.SAVE_RESOURCES, 			onUpdateResources);
				component.removeEventListener(ResourceEvent.UPLOAD_BOOK, 				onUploadBook);
				component.removeEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				component.resetComponent();
			}
			if(courseProxy)
				courseProxy.shouldCheckOnValid = false;
			spinMessage = null;
			spinEndNote = null;
			hideBusyProgressBar(CourseServiceNotification.RESOURCES_RETRIEVED);
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			var resources:Array;
			var resource:ResourceVO;
			switch(note.getName())
			{
				case CourseServiceNotification.RESOURCES_RETRIEVED:
				{
					hideBusyProgressBar(note.getName());
					resources = note.getBody() as Array;
					if(courseProxy && courseProxy.currentLesson)
					{
						courseProxy.currentLesson.resources = resources;
						setData();
					}
					if(isDiscardChanges)
					{
						isDiscardChanges = false;
						if(component)
						{
							component.hasChange = courseProxy.hasChange = false;
							if(courseProxy.unsavedPopupShown)
							{
								courseProxy.unsavedPopupShown = false;
								if(component.checkOnValid())
									sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
							}
						}
					}
					break;
				}
				case CourseServiceNotification.RESOURCE_ADDED:
				{
					hideBusyProgressBar(note.getName());
					resource = note.getBody() as ResourceVO;
					component.resources = component.resources|| new ArrayList();
					component.resources.addItemAt(resource, component.selecetdItemIndex + 1);
					courseProxy.currentLesson.resources = component.resources.toArray();
					component.selecetdItemIndex = component.selectedIndex = component.selecetdItemIndex + 1;
					addNewResourceInProsses = false;
					break;
				}
				case CourseServiceNotification.RESOURCE_REMOVED:
				{
					hideBusyProgressBar(note.getName());
					if(component)
					{
						if(component.resources)
						{
							var index:int = component.resources.getItemIndex(removingResource);
							if(index != -1)
								component.resources.removeItemAt(index);
						}
						var tmp:int = Math.min(component.selectedIndex, component.resources.length -1) ;
						component.selectedIndex = -1;
						component.selectedIndex = component.selectedIndex = tmp;
					}
					break;
				}
				case CourseServiceNotification.RESOURCES_UPDATED:
				{
					hideBusyProgressBar(note.getName());
					resources = note.getBody() as Array;
					if(component)
					{
						component.resources = new ArrayList(resources);
						component.selectedIndex = component.selecetdItemIndex;
						component.hasChange = false;
					}
					if(courseProxy && courseProxy.currentLesson)
						courseProxy.currentLesson.resources = resources;
					operationInProcess = false;
					if(component.nextClicked)
					{
						courseProxy.shouldCheckOnValid = false;
						component.nextClicked = false;
						nextScreen();
					}
					
					if(courseProxy.unsavedPopupShown)
					{
						courseProxy.shouldCheckOnValid = false;
						courseProxy.unsavedPopupShown = false;
						sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
					}
					break;
				}
				case CourseServiceNotification.RESOURCE_CONTENT_UPLOADED:
				{
					hideBusyProgressBar(note.getName());
					resource = note.getBody() as ResourceVO;
					if(resource && component && component.currentResource)
						component.currentResource.resourcePath = resource.resourcePath;
					break;
				}
				case CourseCreatorNotifications.HAS_CHANGE:
				{
					if(component)
						component.hasChange = note.getBody() as Boolean;
					break;
				}
				case CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE:
				{
					if(courseProxy && !courseProxy.hasQuestionsChange)
					{
						if(courseProxy.hasChange)
						{
							courseProxy.unsavedPopupShown = true;
							sendNotification(CourseCreatorNotifications.SHOW_UNSAVED_POPUP);
						}
						else
						{
							if(component && component.checkOnValid())
								sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
						}
					}
					break;
				}	
				case CourseCreatorNotifications.SAVE_CHANGES:
					if(component && courseProxy && !courseProxy.hasQuestionsChange)
						component.saveChanges();
					break;
				case CourseCreatorNotifications.DISCARD_CHANGES:
					if(courseProxy && !courseProxy.hasQuestionsChange)
					{
						isDiscardChanges = true;
						retriveResources();
					}
					break;
				case CourseServiceNotification.SAVE_RESOURCE_CONTENT_CANCELED:
					
					break;
				case TTUConstants.SPIN_START:
					showBusyProgressBar(spinMessage, spinEndNote);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push( CourseServiceNotification.RESOURCE_ADDED);
			arr.push( CourseServiceNotification.RESOURCE_REMOVED);
			arr.push( CourseServiceNotification.RESOURCES_UPDATED);
			arr.push( CourseServiceNotification.RESOURCES_RETRIEVED);
			arr.push( CourseServiceNotification.RESOURCE_CONTENT_UPLOADED);
			arr.push(CourseCreatorNotifications.HAS_CHANGE);
			arr.push(CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE);
			arr.push(CourseCreatorNotifications.SAVE_CHANGES);
			arr.push(CourseCreatorNotifications.DISCARD_CHANGES);
			arr.push(CourseServiceNotification.SAVE_RESOURCE_CONTENT_CANCELED);
			arr.push(TTUConstants.SPIN_START);
			return arr;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 */
		private function setData():void
		{
			if(component && courseProxy && courseProxy.currentLesson)
			{
				component.isSaveInProcess = false;
				component.hasChange = false;
				component.resources = courseProxy.currentLesson.resourceList;
			}
		}
		
		private function retriveResources():void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveResourcesProgressMessage') || 'Retrieving resources';
				showBusyProgressBar(message, CourseServiceNotification.RESOURCES_RETRIEVED);
				var serviceVO:ResourceServiceVO = new ResourceServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, null);
				sendNotification(CourseServiceNotification.RETRIEVE_RESOURCES, serviceVO);
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
		protected function onUploadBook(event:ResourceEvent):void
		{
			if(!event.data || !courseProxy || !courseProxy.currentLesson)
				return;
			spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'uploadResourceProgressMessage') || 'Uploading resource';
			spinEndNote = CourseServiceNotification.RESOURCE_CONTENT_UPLOADED;
			var mediaVO:MediaVO = new MediaVO();
			mediaVO.lessonUuid =  courseProxy.currentLesson.guid;
			mediaVO.lessonVersion =  courseProxy.currentLesson.version;
			mediaVO.resource =  event.data as ResourceVO;
			sendNotification(CourseServiceNotification.UPLOAD_RESOURCE_CONTENT, mediaVO);
		}
		
		protected function onUpdateResources(event:ResourceEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'updateResourcesProgressMessage') || 'Updating resources';
				showBusyProgressBar(message, CourseServiceNotification.RESOURCES_UPDATED);
				sendNotification(CourseServiceNotification.UPDATE_RESOURCES, courseProxy.currentLesson);
			}
		}
		
		protected function onDeleteResource(event:ResourceEvent):void
		{
			if(!event.data || !courseProxy || !courseProxy.currentLesson)
				return;
			
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'removeResourceProgressMessage') || 'Removing resource';
			showBusyProgressBar(message, CourseServiceNotification.RESOURCE_REMOVED);
			removingResource = event.data as ResourceVO;
			var serviceVO:ResourceServiceVO = new ResourceServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, removingResource);
			sendNotification(CourseServiceNotification.REMOVE_RESOURCE, serviceVO);
		}
		
		protected function onAddNewResource(event:ResourceEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'newResourceProgressMessage') || 'Adding resource';
				showBusyProgressBar(message, CourseServiceNotification.RESOURCE_ADDED);
				var vo:ResourceServiceVO = new ResourceServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, new ResourceVO());
				sendNotification( CourseServiceNotification.ADD_NEW_RESOURCE, vo );
			}
		}
		
		protected function onCancelPreviouseAction(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
		}
	}
}