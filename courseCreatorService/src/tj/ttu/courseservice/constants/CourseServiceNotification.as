////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.courseservice.constants
{
	/**
	 * CourseServiceNotification class 
	 */
	public class CourseServiceNotification
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const CREATE_LESSON:String = 'createLesson';
		public static const LESSON_CREATED:String = 'lessonCreated';
		
		public static const UPDATE_LESSON:String = 'updateLesson';
		public static const UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX:String = 'updateLessonMaxActiveViewIndex';
		public static const LESSON_UPDATED:String = 'lessonUpdated';
		
		public static const UPDATE_VIEW_INDEX:String = 'updateViewIndex';
		public static const VIEW_INDEX_UPDATED:String = 'viewIndexUpdated';
		
		public static const DELETE_LESSON:String = 'deleteLesson';
		public static const LESSON_DELETED:String = 'lessonDeleted';
		
		public static const CLONE_LESSON:String = 'cloneLesson';
		public static const LESSON_CLONED:String = 'lessonCloned';
		
		public static const RETRIEVE_LESSONS_BY_DEPARTMENT:String = 'retrieveLessonsByDepartment';
		public static const LESSONS_BY_DEPARTMENT_RETRIEVED:String = 'lessonsByDepartmentRetrieved';
		
		public static const RETRIEVE_LESSON_BY_UUID:String = 'retrieveLessonByUuid';
		public static const LESSON_BY_UUID_RETRIEVED:String = 'lessonsByUuidRetrieved';
		
		public static const VALIDATE_LESSON_NAME:String = 'validateLessonName';
		public static const LESSON_NAME_VALIDATION_RESULT:String = 'lessonNameValidationResult';
		
		public static const RETRIEVE_SPECIALITIES:String = 'retrieveSpecialities';
		public static const SPECIALITIES_RETRIEVED:String = 'specialitiesRetrieved';
		
		public static const RETRIEVE_ALL_DEPARTMENTS:String = 'retrieveAllDepartments';
		public static const ALL_DEPARTMENTS_RETRIEVED:String = 'allDepartmentsRetrieved';
		
		public static const RETRIEVE_DEPARTMENTS:String = 'retrieveDepartments';
		public static const DEPARTMENTS_RETRIEVED:String = 'departmentsRetrieved';
		
		public static const ASSOCIATE_LESSON_AUDIO:String = 'associateLessonAudio';
		public static const AUDIO_ASSOCIATED:String = 'audioAssociated';
		
		public static const ASSOCIATE_LESSON_VIDEO:String = 'associateLessonVideo';
		public static const ASSOCIATE_CHAPTER_VIDEO:String = 'associateChapterVideo';
		public static const VIDEO_ASSOCIATED:String = 'videoAssociated';
		
		public static const ASSOCIATE_CHAPTER_AUDIO:String = 'associateChapterAudio';
		public static const CHAPTER_AUDIO_ASSOCIATED:String = 'chapterAudioAssociated';
		
		public static const REMOVE_AUDIO:String = 'removeAudio';
		public static const AUDIO_REMOVED:String = 'audioRemoved';
		
		public static const ASSOCIATE_IMAGE:String = 'associateImage';
		public static const IMAGE_ASSOCIATED:String = 'imageAssociated';
		
		public static const UPDATE_IMAGE:String = 'updateImage';
		public static const IMAGE_UPDATED:String = 'imageUpdated';
		
		public static const REMOVE_IMAGE:String = 'removeImage';
		public static const IMAGE_REMOVED:String = 'imageRemoved';
		
		public static const SAVE_SOUND_CANCELED:String = 'saveSoundCanceled';
		public static const SAVE_VIDEO_CANCELED:String = 'saveVideoCanceled';
		public static const SAVE_IMAGE_CANCELED:String = 'saveImageCanceled';
		public static const SAVE_RESOURCE_CONTENT_CANCELED:String = 'saveResourceContentCanceled';
		
		//chapter
		public static const RETRIEVE_CHAPTERS:String = 'retrieveChapters';
		public static const CHAPTERS_RETRIEVED:String = 'chaptersRetrieved';
		public static const ADD_NEW_CHAPTER:String = 'addNewChapter';
		public static const CHAPTER_ADDED:String = 'chapterAdded';
		public static const UPDATE_CHAPTER:String = 'updateChapter';
		public static const CHAPTER_UPDATED:String = 'chapterUpdated';
		public static const UPDATE_CHAPTERS:String = 'updateChapters';
		public static const CHAPTERS_UPDATED:String = 'chaptersUpdated';
		public static const REMOVE_CHAPTER:String = 'removeChapter';
		public static const CHAPTER_REMOVED:String = 'chapterRemoved';
		
		//question
		public static const RETRIVE_QUESTIONS_BY_CHAPTER_UUID:String = 'retriveQuestionsByChapterUuid';
		public static const QUESTIONS_BY_CHAPTER_UUID_RETRIVED:String = 'questionsByChapterUuidRetrived';
		public static const UPDATE_QUESTIONS:String = 'updateQuestions';
		public static const QUESTIONS_UPDATED:String = 'questionsUpdated';
		
		//resource
		public static const RETRIEVE_RESOURCES:String = 'retrieveResources';
		public static const RESOURCES_RETRIEVED:String = 'resourcesRetrieved';
		public static const ADD_NEW_RESOURCE:String = 'addNewResource';
		public static const RESOURCE_ADDED:String = 'resourceAdded';
		public static const UPDATE_RESOURCE:String = 'updateResource';
		public static const RESOURCE_UPDATED:String = 'resourceUpdated';
		public static const UPDATE_RESOURCES:String = 'updateResources';
		public static const RESOURCES_UPDATED:String = 'resourcesUpdated';
		public static const REMOVE_RESOURCE:String = 'removeResource';
		public static const UPLOAD_RESOURCE_CONTENT:String = 'uploadResourceContent';
		public static const RESOURCE_CONTENT_UPLOADED:String = 'resourceContentUploaded';
		public static const RESOURCE_REMOVED:String = 'resourceRemoved';
		
		//resource
		public static const RETRIEVE_ARTIFACTS:String = 'retrieveArtifacts';
		public static const ARTIFACTS_RETRIEVED:String = 'artifactsRetrieved';
		public static const DOWNLOAD_ARTIFACT:String = 'downloadArtifact';
		public static const SAVE_ARTIFACT_TO_DISK:String = 'saveArtifactToDisk';
		public static const SAVE_ARTIFACT_TO_DISK_CANCELED:String = 'saveArtifactToDiskCanceled';
		public static const ARTIFACT_TO_DISK_SAVED:String = 'artifactToDiskSaved';
		public static const PUBLISH_LESSON:String = 'publishLesson';
		public static const LESSON_PUBLISHED:String = 'lessonPublished';
		
		public static const POPUP_WINDOW_CLOSE:String = 'popupWindowClose';
		public static const SHOW_ERROR_WINDOW:String = 'showErrorWindow';
		
		//resource
		public static const RETRIEVE_USER_SETTINGS:String = "retrieveUserSettings";
		public static const USER_SETTINGS_RETRIEVED:String = "userSettingsRetrieved";
		public static const UPDATE_USER_SETTINGS:String = "updateUserSettings";
		public static const USER_SETTINGS_UPDATED:String = "userSettingsUpdated";
	}
}