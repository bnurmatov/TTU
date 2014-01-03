////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.publish
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.base.utils.LanguageInfoUtil;
	import tj.ttu.components.events.PublishEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.view.components.publish.PublishLessonView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.create.BaseCreateCourseViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	import tj.ttu.courseservice.model.vo.PublishServiceVO;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	
	/**
	 * PublishLessonViewMediator class 
	 */
	public class PublishLessonViewMediator extends BaseCreateCourseViewMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'PublishLessonViewMediator';
		
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
		 * PublishLessonViewMediator 
		 */
		public function PublishLessonViewMediator(viewComponent:PublishLessonView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():PublishLessonView
		{
			return viewComponent as PublishLessonView;
		}
		
		private var _resourceProxy:ResourceProxy;
		
		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy = facade.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
			return _resourceProxy;
		}
		
		//-----------------------------------
		//	ModuleProxy
		//-----------------------------------
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
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
				component.addEventListener(CourseEvent.PREVIEW_LESSON, onPreviewLesson);
				component.addEventListener(PublishEvent.PUBLISH_LESSON, onPublishLesson);
				component.addEventListener(PublishEvent.DOWNLOAD_LESSON_ARTIFACT, onDownloadLessonArtifact);
				component.addEventListener(PublishEvent.SAVE_LESSON_ARTIFACT, onLessonLessonArtifact);
				if(courseProxy)
				{
					if(courseProxy.currentLesson)
					{
						if(!courseProxy.currentLesson.artifactList || courseProxy.currentLesson.artifactList.length == 0)
							retriveArtifacts();
						else
							setData();
						
						if(!courseProxy.currentLesson.chapters || courseProxy.currentLesson.chapters.length == 0)
							retriveChapters();
					}
					component.lesson = courseProxy.currentLesson;
				}
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(CourseEvent.PREVIEW_LESSON, onPreviewLesson);
				component.removeEventListener(PublishEvent.PUBLISH_LESSON, onPublishLesson);
				component.removeEventListener(PublishEvent.DOWNLOAD_LESSON_ARTIFACT, onDownloadLessonArtifact);
				component.removeEventListener(PublishEvent.SAVE_LESSON_ARTIFACT, onLessonLessonArtifact);
				component.resetComponent();
			}
			
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case CourseServiceNotification.LESSON_PUBLISHED:
				case CourseServiceNotification.ARTIFACTS_RETRIEVED:
				{
					hideBusyProgressBar(note.getName());
					if(courseProxy && courseProxy.currentLesson)
					{
						courseProxy.currentLesson.artifacts = note.getBody() as Array;
						if(component)
						{
							component.resetSelectedOptions();
							component.artifacts = courseProxy.currentLesson.artifactList;
						}
					}
					break;
				}
				case CourseServiceNotification.CHAPTERS_RETRIEVED:
				{
					var chapters:Array = note.getBody() as Array;
					hideBusyProgressBar(note.getName());
					if(courseProxy && courseProxy.currentLesson)
					{
						courseProxy.updateChapters(chapters);
					}
					break;
				}	
				case TTUConstants.LANGUAGE_CHANGE:
				{
					sendNotification(CourseCreatorNotifications.SHOW_MY_LESSONS);
					break;
				}	
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push( CourseServiceNotification.LESSON_PUBLISHED );
			arr.push( CourseServiceNotification.ARTIFACTS_RETRIEVED );
			arr.push(CourseServiceNotification.CHAPTERS_RETRIEVED);
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
		
		/**
		 *  @private
		 */
		private function setData():void
		{
			if(component && courseProxy && courseProxy.currentLesson)
			{
				component.artifacts = courseProxy.currentLesson.artifactList;
			}
		}
		
		private function retriveArtifacts():void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveLessonArtifactsMessage') || 'Retrieving Lesson artifacts';
				showBusyProgressBar(message, CourseServiceNotification.ARTIFACTS_RETRIEVED);
				var serviceVO:PublishServiceVO = new PublishServiceVO();
				serviceVO.lessonUuid = courseProxy.currentLesson.guid;
				serviceVO.lessonVersion = courseProxy.currentLesson.version;
				sendNotification(CourseServiceNotification.RETRIEVE_ARTIFACTS, serviceVO);
			}
		}
		
		private function retriveChapters():void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'retrieveChaptersProgressMessage') || 'Chapters retrieving';
				showBusyProgressBar(message, CourseServiceNotification.CHAPTERS_RETRIEVED);
				var serviceVO:ChapterServiceVO = new ChapterServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, null);
				sendNotification(CourseServiceNotification.RETRIEVE_CHAPTERS, serviceVO);
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
		
		protected function onPreviewLesson(event:Event):void
		{
			if(courseProxy && courseProxy.currentLesson && moduleProxy)
			{
				moduleProxy.isUnitHome = true;
				moduleProxy.isPaused = true;
				sendNotification(TTUConstants.SET_MODULE_DATA, courseProxy.currentLesson);
				sendNotification(CourseCreatorNotifications.SHOW_PREVIEW);
			}
			
		}
		
		protected function onDownloadLessonArtifact(event:PublishEvent):void
		{
			sendNotification( CourseServiceNotification.DOWNLOAD_ARTIFACT, event.data );
		}
		
		protected function onLessonLessonArtifact(event:PublishEvent):void
		{
			sendNotification( CourseServiceNotification.SAVE_ARTIFACT_TO_DISK, event.data );
		}	
		
		protected function onPublishLesson(event:PublishEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'publishLessonProgressMessage') || 'Lesson publishing';
				showBusyProgressBar(message, CourseServiceNotification.LESSON_PUBLISHED);
				var serviceVO:PublishServiceVO = new PublishServiceVO();
				serviceVO.lessonUuid = courseProxy.currentLesson.guid;
				serviceVO.lessonVersion = courseProxy.currentLesson.version;
				serviceVO.lesson = courseProxy.currentLesson;
				serviceVO.options = event.data as Array;
				serviceVO.languageCode = LanguageInfoUtil.getInstance().getLanguageCode(resourceProxy.locale);
				sendNotification(CourseServiceNotification.PUBLISH_LESSON, serviceVO);
			}	
		}		
		
	}
}