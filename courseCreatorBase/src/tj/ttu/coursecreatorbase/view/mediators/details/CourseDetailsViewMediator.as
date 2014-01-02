////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.details
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.components.events.AudioEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.view.components.details.CourseDetailsView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.create.BaseCreateCourseViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * CourseDetailsViewMediator class 
	 */
	public class CourseDetailsViewMediator extends BaseCreateCourseViewMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CourseDetailsViewMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var spinMessage:String;
		private var spinEndNote:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseDetailsViewMediator 
		 */
		public function CourseDetailsViewMediator(viewComponent:CourseDetailsView)
		{
			super(NAME, viewComponent);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CourseDetailsView
		{
			return viewComponent as CourseDetailsView;
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
				component.addEventListener(CourseEvent.SAVE_LESSON, onSaveLesson);
				component.addEventListener(CourseEvent.INSERT_IMAGE, onInsertLessonImage);
				component.addEventListener(CourseEvent.EDIT_IMAGE,	 onEditImage);
				component.addEventListener(AudioEvent.RECORD_AUDIO, onRecordAudio);
				component.addEventListener(AudioEvent.REMOVE_AUDIO, onRemoveAudio);
				component.addEventListener(AudioEvent.UPLOAD_AUDIO, onUploadAudio);
				component.addEventListener(IOErrorEvent.IO_ERROR, 	onIOError);
				component.addEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				if(courseProxy)
				{
					courseProxy.shouldCheckOnValid = true;
					if(courseProxy.currentLesson)
						component.lesson = courseProxy.currentLesson;
					else
						sendNotification( CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP );
				}
			}
			
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(CourseEvent.SAVE_LESSON, onSaveLesson);
				component.removeEventListener(CourseEvent.INSERT_IMAGE, onInsertLessonImage);
				component.removeEventListener(CourseEvent.EDIT_IMAGE,	 onEditImage);
				component.removeEventListener(AudioEvent.RECORD_AUDIO, onRecordAudio);
				component.removeEventListener(AudioEvent.REMOVE_AUDIO, onRemoveAudio);
				component.removeEventListener(AudioEvent.UPLOAD_AUDIO, onUploadAudio);
				component.removeEventListener(IOErrorEvent.IO_ERROR,   onIOError);
				component.removeEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				component.resetComponent();
			}
			
			if(courseProxy)
				courseProxy.shouldCheckOnValid = false;
			spinMessage = null;
			spinEndNote = null;
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case CourseServiceNotification.LESSON_UPDATED:
					hideBusyProgressBar(note.getName());
					if(courseProxy && component)
					{
						courseProxy.currentLesson = note.getBody() as LessonVO;
						component.lesson = null;
						component.lesson = courseProxy.currentLesson;
						component.hasChange = false;
						component.isSaveInProcess = false;
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
					}
					break;
				case CourseServiceNotification.AUDIO_ASSOCIATED:
					hideBusyProgressBar(note.getName());
					if(courseProxy && courseProxy.currentLesson && component)
					{
						var soundVO:SoundVO = note.getBody() as SoundVO;
						courseProxy.currentLesson.sound = soundVO;
						component.sound = soundVO;
					}
					break;
				case CourseServiceNotification.IMAGE_ASSOCIATED:
					hideBusyProgressBar(note.getName());
					if(component)
						component.insertSelectedaImage( note.getBody() as ImageVO );
					break;
				case CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE:
				{
					if(courseProxy)
					{
						if(courseProxy.hasChange)
						{
							courseProxy.unsavedPopupShown = true;
							sendNotification(CourseCreatorNotifications.SHOW_UNSAVED_POPUP);
						}
						else
						{
							if(component && component.checkRequiredFields())
								sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
						}
					}
					break;
				}	
				case CourseCreatorNotifications.SAVE_CHANGES:
					if(component)
						component.saveChanges();
					break;
				case CourseCreatorNotifications.DISCARD_CHANGES:
					if(courseProxy && component)
					{
						if(component)
						{
							component.hasChange = courseProxy.hasChange = false;
							if(courseProxy.unsavedPopupShown)
							{
								courseProxy.unsavedPopupShown = false;
								sendNotification(CourseCreatorNotifications.START_PREVIOUSE_ACTION);
							}
						}
					}
					break;
				case CourseServiceNotification.AUDIO_REMOVED:
					hideBusyProgressBar(note.getName());
					if(courseProxy.currentLesson)
						courseProxy.currentLesson.sound = null;
					if(component)
						component.sound = null;
					break;
				case TTUConstants.SPIN_START:
					showBusyProgressBar( spinMessage, spinEndNote );
					break;
				case CourseServiceNotification.ASSOCIATE_LESSON_AUDIO:
					var vo:MediaVO = note.getBody() as MediaVO;
					if(vo && vo.binaryContent)
						showBusyProgressBar( spinMessage, spinEndNote );
					break;
				case CourseServiceNotification.IMAGE_UPDATED:
					hideBusyProgressBar(note.getName());
					if(component)
						component.updateImage(note.getBody() as ImageVO);
					break;
				case CourseServiceNotification.IMAGE_REMOVED:
					hideBusyProgressBar(note.getName());
					break;
				case CourseCreatorNotifications.REMOVE_IMAGE_ELEMENT:
					if(component)
						component.removeSelectedImage(note.getBody() as InlineGraphicElement);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			arr.push(CourseServiceNotification.LESSON_UPDATED);
			arr.push(CourseServiceNotification.AUDIO_ASSOCIATED);
			arr.push(CourseServiceNotification.IMAGE_ASSOCIATED);
			arr.push(CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE);
			arr.push(CourseCreatorNotifications.SAVE_CHANGES);
			arr.push(CourseCreatorNotifications.DISCARD_CHANGES);
			arr.push(CourseServiceNotification.ASSOCIATE_LESSON_AUDIO);
			arr.push(CourseServiceNotification.AUDIO_REMOVED);
			arr.push(CourseServiceNotification.IMAGE_UPDATED);
			arr.push(CourseServiceNotification.IMAGE_REMOVED);
			arr.push(CourseCreatorNotifications.REMOVE_IMAGE_ELEMENT);
			arr.push(TTUConstants.SPIN_START);
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
		
		protected function onSaveLesson(event:CourseEvent):void
		{
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'saveLessonProgressMessage') || 'Lesson saving';
			showBusyProgressBar(message, CourseServiceNotification.LESSON_UPDATED);
			sendNotification(CourseServiceNotification.UPDATE_LESSON, event.data);
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, event.text);
		}
		/**
		 *  @private
		 */
		
		protected function onUploadAudio(event:AudioEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingLessonAudioProgressMessage') || 'Adding lesson\'s audio';
				spinEndNote = CourseServiceNotification.AUDIO_ASSOCIATED;
				var vo:MediaVO = new MediaVO(courseProxy.currentLesson.guid, MediaVO.LESSON);
				vo.lessonUuid = courseProxy.currentLesson.guid;
				vo.lessonVersion = courseProxy.currentLesson.version;
				vo.soundVO = new SoundVO();
				sendNotification(CourseServiceNotification.ASSOCIATE_LESSON_AUDIO, vo);
			}
		}
		
		protected function onRemoveAudio(event:AudioEvent):void
		{
			if(courseProxy && courseProxy.currentLesson && courseProxy.currentLesson.sound)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'removeLessonAudioProgressMessage') || 'Removing lesson\'s audio';
				spinEndNote = CourseServiceNotification.AUDIO_REMOVED;
				var vo:MediaVO = new MediaVO(courseProxy.currentLesson.guid, MediaVO.LESSON);
				vo.lessonUuid = courseProxy.currentLesson.guid;
				vo.lessonVersion = courseProxy.currentLesson.version;
				vo.soundVO = courseProxy.currentLesson.sound;
				sendNotification(CourseServiceNotification.REMOVE_AUDIO, vo);
			}
		}
		
		protected function onRecordAudio(event:AudioEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingLessonAudioProgressMessage') || 'Adding lesson\'s audio';
				spinEndNote = CourseServiceNotification.AUDIO_ASSOCIATED;
				var vo:MediaVO = new MediaVO(courseProxy.currentLesson.guid, MediaVO.LESSON);
				vo.lessonUuid = courseProxy.currentLesson.guid;
				vo.lessonVersion = courseProxy.currentLesson.version;
				vo.soundVO = new SoundVO();
				sendNotification(CourseCreatorNotifications.SHOW_SOUND_RECORDER_WINDOW, vo);
			}
		}
		
		protected function onInsertLessonImage(event:CourseEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingLessonImageProgressMessage') || 'Adding lesson\'s image';
				spinEndNote = CourseServiceNotification.IMAGE_ASSOCIATED;
				var mediaVO:MediaVO = new MediaVO(courseProxy.currentLesson.guid, MediaVO.AUTHOR);
				mediaVO.imageVO = event.data as ImageVO;
				mediaVO.lessonUuid = courseProxy.currentLesson.guid;
				mediaVO.lessonVersion = courseProxy.currentLesson.version;
				sendNotification(CourseCreatorNotifications.SHOW_INSERT_IMAGE_WINDOW, mediaVO);
			}
		}
		
		protected function onEditImage(event:CourseEvent):void
		{
			sendNotification(CourseCreatorNotifications.SHOW_EDIT_IMAGE_POPUP, event.data);
		}
		
		protected function onCancelPreviouseAction(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
		}
		
	}
}