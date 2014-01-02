////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.chapter
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.components.events.ChapterEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.view.components.chapter.EditChaptersView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.mediators.create.BaseCreateCourseViewMediator;
	import tj.ttu.coursecreatorbase.view.mediators.question.EditQuestionsViewMediator;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * EditChaptersViewMediator class 
	 */
	public class EditChaptersViewMediator extends BaseCreateCourseViewMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'EditChaptersViewMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var isDiscardChanges:Boolean = false;
		private var removingChapter:ChapterVO;
		private var spinMessage:String;
		private var spinEndNote:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * EditChaptersViewMediator 
		 */
		public function EditChaptersViewMediator(viewComponent:EditChaptersView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():EditChaptersView
		{
			return viewComponent as EditChaptersView;
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
				component.addEventListener(ChapterEvent.CURRENT_CHAPTER_CHANGE, 	onCurrentChapterChange);
				component.addEventListener(ChapterEvent.ADD_NEW_CHAPTER, 			onAddNewChapter);
				component.addEventListener(ChapterEvent.DELETE_CHAPTER, 			onDeleteChapter);
				component.addEventListener(ChapterEvent.SAVE_CHAPTERS, 				onUpdateChapters);
				component.addEventListener(ChapterEvent.CHANGE_CHAPTER_COMMENT, 	onChangeChapterComment);
				component.addEventListener(ChapterEvent.INSERT_CHAPTER_IMAGE, 		onInsertChapterImage);
				component.addEventListener(ChapterEvent.EDIT_IMAGE,	 				onEditImage);
				component.addEventListener(ChapterEvent.RECORD_CHAPTER_AUDIO, 		onRecordChapterAudio);
				component.addEventListener(ChapterEvent.UPLOAD_CHAPTER_AUDIO, 		onUploadChapterAudio);
				component.addEventListener(ChapterEvent.UPLOAD_CHAPTER_VIDEO, 		onUploadChapterVideo);
				component.addEventListener(ChapterEvent.SHOW_IMAGE_FULL_SCREEN, 	onShowImageFullScreen);
				component.addEventListener(ChapterEvent.SHOW_VIDEO_PLAYER, 			onShowVideoPlayer);
				component.addEventListener(IOErrorEvent.IO_ERROR, 					onIOError);
				component.addEventListener(ChapterEvent.EDIT_CHAPTER_QUESTIONS, 	onEditChapterQuestions);
				component.addEventListener(ChapterEvent.QUESTION_VIEW_HIDE, 		onHideQuestionView);
				component.addEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				//setData();
				if(courseProxy)
				{
					if(courseProxy.currentLesson)
					{
						if(!courseProxy.currentLesson.chapters || courseProxy.currentLesson.chapters.length == 0)
							retriveChapters();
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
				component.removeEventListener(ChapterEvent.CURRENT_CHAPTER_CHANGE, 	onCurrentChapterChange);
				component.removeEventListener(ChapterEvent.ADD_NEW_CHAPTER, 		onAddNewChapter);
				component.removeEventListener(ChapterEvent.DELETE_CHAPTER, 			onDeleteChapter);
				component.removeEventListener(ChapterEvent.SAVE_CHAPTERS, 			onUpdateChapters);
				component.removeEventListener(ChapterEvent.CHANGE_CHAPTER_COMMENT, 	onChangeChapterComment);
				component.removeEventListener(ChapterEvent.INSERT_CHAPTER_IMAGE, 	onInsertChapterImage);
				component.removeEventListener(ChapterEvent.EDIT_IMAGE,	 			onEditImage);
				component.removeEventListener(ChapterEvent.RECORD_CHAPTER_AUDIO, 	onRecordChapterAudio);
				component.removeEventListener(ChapterEvent.UPLOAD_CHAPTER_AUDIO, 	onUploadChapterAudio);
				component.removeEventListener(ChapterEvent.UPLOAD_CHAPTER_VIDEO, 	onUploadChapterVideo);
				component.removeEventListener(ChapterEvent.SHOW_IMAGE_FULL_SCREEN, 	onShowImageFullScreen);
				component.removeEventListener(ChapterEvent.SHOW_VIDEO_PLAYER, 			onShowVideoPlayer);
				component.removeEventListener(IOErrorEvent.IO_ERROR, 					onIOError);
				component.removeEventListener(ChapterEvent.EDIT_CHAPTER_QUESTIONS, 	onEditChapterQuestions);
				component.removeEventListener(ChapterEvent.QUESTION_VIEW_HIDE, 		onHideQuestionView);
				component.removeEventListener(CourseEvent.CANCEL_PREVIOUSE_ACTION, 	onCancelPreviouseAction);
				component.resetComponent();
			}
			if(courseProxy)
				courseProxy.shouldCheckOnValid = false;
			isDiscardChanges = false;
			removingChapter = null;
			spinMessage = null;
			spinEndNote = null;
			hideBusyProgressBar(CourseServiceNotification.CHAPTERS_RETRIEVED);
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			var chapter:ChapterVO = note.getBody() as ChapterVO;
			switch(note.getName())
			{
				case CourseServiceNotification.CHAPTERS_RETRIEVED:
				{
					var chapters:Array = note.getBody() as Array;
					hideBusyProgressBar(note.getName());
					if(courseProxy && courseProxy.currentLesson)
					{
						courseProxy.updateChapters(chapters);
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
				case CourseServiceNotification.CHAPTER_ADDED:
				{
					hideBusyProgressBar(note.getName());
					if(courseProxy && component)
					{
						courseProxy.addChapter(chapter);
						setData();
						component.selectedIndex = courseProxy.currentLesson && courseProxy.currentLesson.chapters ?  courseProxy.currentLesson.chapters.length -1 : 0;
						courseProxy.currentChapterIndex = courseProxy.getCurrentChapterIndexByChapter(chapter);	
						component.startEditor();
					}
					break;
				}
				case CourseServiceNotification.AUDIO_ASSOCIATED:
				{
					hideBusyProgressBar(note.getName());
					if(component && courseProxy)
					{
						var sound:SoundVO = note.getBody() as SoundVO;
						component.insertSelectedaSound( sound );
						courseProxy.addChapterSound( sound );
					}
					break;
				}
				case CourseServiceNotification.VIDEO_ASSOCIATED:
				{
					hideBusyProgressBar(note.getName());
					if(component && courseProxy)
					{
						var video:VideoVO = note.getBody() as VideoVO;
						component.insertSelectedVideo( video );
						courseProxy.addChapterVideo( video );
					}
					break;
				}
				case CourseServiceNotification.CHAPTER_REMOVED:
				{
					hideBusyProgressBar(note.getName());
					if(component && courseProxy)
					{
						courseProxy.removeChapter( removingChapter );
						
						if(courseProxy.currentChapterIndex == courseProxy.chapters.length)
							courseProxy.currentChapterIndex --;
						
						component.chapters = null;
						component.currentChapter = null;
						
						setData();
						component.selectedIndex = courseProxy.currentChapterIndex;
						removingChapter = null;
					}
					break;
				}
				case CourseServiceNotification.CHAPTERS_UPDATED:
				{
					hideBusyProgressBar(note.getName());
					if(courseProxy)
						courseProxy.updateChapters( note.getBody() as Array);
					setData();
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
				case CourseServiceNotification.IMAGE_ASSOCIATED:
					hideBusyProgressBar(note.getName());
					if(component && courseProxy)
					{
						var image:ImageVO = note.getBody() as ImageVO;
						component.insertSelectedaImage( image );
						courseProxy.addChapterImage( image );
					}
					break;
				case CourseCreatorNotifications.HAS_CHANGE:
				{
					if(component)
						component.hasChange = note.getBody() as Boolean;
					break;
				}
				case CourseCreatorNotifications.DONE_QUESTION_VIEW:
				{
					if(component)
						component.moveDownHolder();
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
							if(courseProxy.shouldCheckOnValid && component && component.checkOnValid())
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
						retriveChapters();
					}
					break;
				case TTUConstants.SPIN_START:
					showBusyProgressBar( spinMessage, spinEndNote );
					break;
				case CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO:
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
			arr.push(CourseServiceNotification.IMAGE_ASSOCIATED);
			arr.push(CourseServiceNotification.AUDIO_ASSOCIATED);
			arr.push(CourseServiceNotification.VIDEO_ASSOCIATED);
			arr.push(CourseServiceNotification.CHAPTERS_RETRIEVED);
			arr.push(CourseServiceNotification.CHAPTER_ADDED);
			arr.push(CourseServiceNotification.CHAPTER_UPDATED);
			arr.push(CourseServiceNotification.CHAPTERS_UPDATED);
			arr.push(CourseServiceNotification.CHAPTER_REMOVED);
			arr.push(CourseCreatorNotifications.HAS_CHANGE);
			arr.push(CourseCreatorNotifications.DONE_QUESTION_VIEW);
			arr.push(CourseCreatorNotifications.USER_IS_GOING_TO_LEAVE_THIS_PAGE);
			arr.push(CourseCreatorNotifications.SAVE_CHANGES);
			arr.push(CourseCreatorNotifications.DISCARD_CHANGES);
			arr.push(CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO);
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
		private function setData():void
		{
			if(component && courseProxy && courseProxy.currentLesson)
			{
				component.isSaveInProcess = false;
				component.hasChange = false;
				component.chapters = courseProxy.chapters;
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
		
		protected function onDeleteChapter(event:ChapterEvent):void
		{
			if(!event.data || !courseProxy || !courseProxy.currentLesson)
				return;
			
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'removeChapterProgressMessage') || 'Chapter removing';
			showBusyProgressBar(message, CourseServiceNotification.CHAPTER_REMOVED);
			removingChapter = event.data as ChapterVO;
			var serviceVO:ChapterServiceVO = new ChapterServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, removingChapter);
			sendNotification(CourseServiceNotification.REMOVE_CHAPTER, serviceVO);
		}
		
		
		protected function onCurrentChapterChange(event:ChapterEvent):void
		{
			if(courseProxy)
				courseProxy.currentChapter = event.data as ChapterVO;
		}		
		
		protected function onIOError(event:IOErrorEvent):void
		{
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, event.text);
		}
		/**
		 *  @protected
		 */
		
		protected function onUploadChapterAudio(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson && courseProxy.currentChapter)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingCahpterAudioProgressMessage') || 'Adding chapter\'s audio';
				spinEndNote = CourseServiceNotification.AUDIO_ASSOCIATED;
				var mediaVO:MediaVO = new MediaVO(courseProxy.currentChapter.chapterUuid);
				mediaVO.lessonUuid = courseProxy.currentLesson.guid;
				mediaVO.lessonVersion = courseProxy.currentLesson.version;
				mediaVO.soundVO = event.data as SoundVO;
				sendNotification( CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO, mediaVO );
			}
		}
		
		protected function onRecordChapterAudio(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson && courseProxy.currentChapter)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingCahpterAudioProgressMessage') || 'Adding chapter\'s audio';
				spinEndNote = CourseServiceNotification.AUDIO_ASSOCIATED;
				var mediaVO:MediaVO = new MediaVO(courseProxy.currentChapter.chapterUuid);
				mediaVO.lessonUuid = courseProxy.currentLesson.guid;
				mediaVO.lessonVersion = courseProxy.currentLesson.version;
				mediaVO.soundVO = event.data as SoundVO;
				sendNotification( CourseCreatorNotifications.SHOW_SOUND_RECORDER_WINDOW, mediaVO );
			}
		}
		
		protected function onUploadChapterVideo(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson && courseProxy.currentChapter)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingCahpterVideoProgressMessage') || 'Adding chapter\'s video';
				spinEndNote = CourseServiceNotification.VIDEO_ASSOCIATED;
				var mediaVO:MediaVO = new MediaVO(courseProxy.currentChapter.chapterUuid);
				mediaVO.lessonUuid = courseProxy.currentLesson.guid;
				mediaVO.lessonVersion = courseProxy.currentLesson.version;
				mediaVO.videoVO = event.data as VideoVO;
				sendNotification( CourseServiceNotification.ASSOCIATE_CHAPTER_VIDEO, mediaVO );
			}
		}
		
		protected function onInsertChapterImage(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson && courseProxy.currentChapter)
			{
				spinMessage = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'addingCahpterImageProgressMessage') || 'Adding chapter\'s image';
				spinEndNote = CourseServiceNotification.IMAGE_ASSOCIATED;
				var mediaVO:MediaVO = new MediaVO(courseProxy.currentChapter.chapterUuid);
				mediaVO.lessonUuid = courseProxy.currentLesson.guid;
				mediaVO.lessonVersion = courseProxy.currentLesson.version;
				mediaVO.imageVO = event.data as ImageVO;
				sendNotification( CourseCreatorNotifications.SHOW_INSERT_IMAGE_WINDOW, mediaVO );
			}
		}
		
		protected function onEditImage(event:ChapterEvent):void
		{
			sendNotification(CourseCreatorNotifications.SHOW_EDIT_IMAGE_POPUP, event.data);
		}
		
		protected function onShowImageFullScreen(event:ChapterEvent):void
		{
			sendNotification(TTUConstants.SHOW_IMAGE_FULL_SCREEN_WINDOW, event.data);
		}
		
		protected function onShowVideoPlayer(event:ChapterEvent):void
		{
			sendNotification(TTUConstants.SHOW_VIDEO_PLAYER, event.data);			
		}		
		
		protected function onChangeChapterComment(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentChapter)
			{
				sendNotification( CourseCreatorNotifications.SHOW_CHAPTER_COMMENT_POPUP, courseProxy.currentChapter );
			}
		}
		
		protected function onAddNewChapter(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'newChaptersProgressMessage') || 'New Chapter adding';
				showBusyProgressBar(message, CourseServiceNotification.CHAPTER_ADDED);
				var vo:ChapterServiceVO = new ChapterServiceVO(courseProxy.currentLesson.guid, courseProxy.currentLesson.version, new ChapterVO());
				sendNotification( CourseServiceNotification.ADD_NEW_CHAPTER, vo );
			}
		}
		
		protected function onUpdateChapters(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentLesson)
			{
				var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'updateChaptersProgressMessage') || 'Chapters updating';
				showBusyProgressBar(message, CourseServiceNotification.CHAPTERS_UPDATED);
				sendNotification(CourseServiceNotification.UPDATE_CHAPTERS, courseProxy.currentLesson);
			}
		}
		
		protected function onEditChapterQuestions(event:ChapterEvent):void
		{
			if(facade.hasMediator(EditQuestionsViewMediator.NAME))
				facade.removeMediator(EditQuestionsViewMediator.NAME);
			if(component)
				facade.registerMediator( new EditQuestionsViewMediator(component.questionsView));
		}		
		
		protected function onHideQuestionView(event:ChapterEvent):void
		{
			if(facade.hasMediator(EditQuestionsViewMediator.NAME))
				facade.removeMediator(EditQuestionsViewMediator.NAME);
		}		
		
		protected function onCancelPreviouseAction(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.CANCEL_PREVIOUSE_ACTION);
		}
		
	}
}