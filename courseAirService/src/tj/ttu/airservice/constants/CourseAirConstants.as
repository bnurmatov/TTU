////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.constants
{
	/**
	 * CourseAirConstants class 
	 */
	public class CourseAirConstants
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//common
		public static const REGISTER_AIR_COMMAND:String = 'registerAirCommand';	
		public static const REMOVE_AIR_COMMAND:String = 'removeAirCommand';	
		
		
		public static const CREATE_DB_SCHEMA:String = 'createDbSchema';	
		public static const UPDATE_DB_SCHEMA:String = 'updateDbSchema';	
		public static const INSERT_DB_DATA:String = 'insertDbData';	
		public static const ADD_DEFAULT_USER:String = 'addDefaultUser';	
		public static const CREATE_LOCAL_LESSON_COMPLETE:String = 'createLocalLessonComplete';	
		public static const UPDATE_LOCAL_LESSON_COMPLETE:String = 'updateLocalLessonComplete';	
		public static const UPDATE_LOCAL_LESSON_CHAPTERS_COMPLETE:String = 'updateLocalLessonChaptersComplete';	
		public static const UPDATE_CHAPTER_COMPLETE:String = 'updateChapterComplete';	
		public static const PARSE_LOCAL_LESSONS:String = 'parseLocalLessons';	
		public static const RETRIEVE_LOCAL_LESSON_COMPLETE:String = 'retrieveLocalLessonComplete';	
		public static const RETRIEVE_LOCAL_LESSON_IMAGES_COMPLETE:String = 'retrieveLocalLessonImagesComplete';	
		public static const RETRIEVE_LOCAL_LESSON_SOUND_COMPLETE:String = 'retrieveLocalLessonSoundComplete';	
		public static const SHOW_ERROR_WINDOW:String = 'showErrorWindow';
		
		//lesson
		public static const LESSON_SOUND_DATA_LOADED:String = 'lessonSoundDataLoaded';	
		public static const CHAPTER_SOUND_DATA_LOADED:String = 'chapterSoundDataLoaded';	
		public static const SAVE_LOCAL_SOUND_COMPLETE:String = 'saveLocalSoundComplete';	
		public static const SAVE_LOCAL_VIDEO_COMPLETE:String = 'saveLocalVideoComplete';	
		public static const CHAPTER_VIDEO_DATA_LOADED:String = 'chapterVideoDataLoaded';	
		public static const REMOVE_PREVIOUS_LOCAL_LESSON_SOUND:String = 'removePreviousLocalLessonSound';	
		public static const REMOVE_LOCAL_LESSON:String = 'removeLocalLesson';	
		public static const REMOVE_LOCAL_LESSON_ASSETS_FROM_DISK:String = 'removeLocalLessonAssetsFromDisk';	
		public static const CLONE_LOCAL_LESSON:String = 'cloneLocalLesson';	
		public static const CLONE_LOCAL_LESSON_COMPLETE:String = 'cloneLocalLessonComplete';	
		public static const PUBLISH_LOCAL_LESSON_COMPLETE:String = 'publishLocalLessonComplete';	
		
		public static const IMAGE_DATA_LOADED:String = 'imageDataLoaded';	
		public static const SAVE_LOCAL_IMAGE_COMPLETE:String = 'saveLocalImageComplete';	
		
		//chapter
		public static const ADD_NEW_LOCAL_CAHPTER:String = 'addNewLocalCahpter';	
		public static const ADD_NEW_LOCAL_CAHPTER_COMPLETE:String = 'addNewLocalCahpterComplete';	
		public static const RETRIEVE_LESSON_CHAPTERS_COMPLETE:String = 'retrieveLessonChaptersComplete';	
		public static const RETRIEVE_CHAPTER_IMAGES_COMPLETE:String = 'retrieveChapterImagesComplete';	
		public static const RETRIEVE_CHAPTER_SOUNDS_COMPLETE:String = 'retrieveChapterSoundsComplete';	
		public static const RETRIEVE_CHAPTER_VIDEO_LIST_COMPLETE:String = 'retrieveChapterVideoListComplete';	
		public static const PARSE_LOCAL_LESSON_CHAPTERS:String = 'parseLocalLessonChapters';	
		public static const PARSE_LOCAL_CHAPTERS_FOR_DELETE_LESSON:String = 'parseLocalChaptersForDeleteLesson';	
		public static const DELETE_CHAPTER_ASSETS_FROM_DISK:String = 'deleteChapterAssetsFromDisk';	
		public static const SET_CHAPTERS_TO_LESSON:String = 'setChaptersToLesson';	
		
		//resource
		public static const ADD_NEW_LOCAL_RESOURCE:String = 'addNewLocalResource';	
		public static const ADD_NEW_LOCAL_RESOURCE_COMPLETE:String = 'addNewLocalResourceComplete';	
		public static const RETRIEVE_LESSON_RESOURCES_COMPLETE:String = 'retrieveLessonResourcesComplete';	
		public static const PARSE_LOCAL_LESSON_RESOURCES:String = 'parseLocalLessonResources';	
		public static const PARSE_LOCAL_RESOURCES_FOR_DELETE_LESSON:String = 'parseLocalResourcesForDeleteLesson';	
		public static const DELETE_RESOURCE_ASSETS_FROM_DISK:String = 'deleteResourceAssetsFromDisk';	
		public static const SET_RESOURCES_TO_LESSON:String = 'setResourcesToLesson';	
		public static const UPDATE_LOCAL_LESSON_RESOURCES_COMPLETE:String = 'updateLocalLessonResourcesComplete';
		public static const RESOURCE_CONTENT_DATA_LOADED:String = 'resourceContentDataLoaded';	
		public static const UPLOAD_RESOURCE_CONTENT_COMPLETE:String = 'uploadResourceContentComplete';	
		
		//image
		public static const GET_IMAGES_BY_TARGET_UUID_COMPLETE:String = 'getImagesByTargetUuidComplete';	
		public static const UPDTAE_IMAGE_COMPLETE:String = 'updateImageComplete';	
		public static const REMOVE_IMAGE_COMPLETE:String = 'removeImageComplete';	
		
		//sound
		public static const GET_SOUNDS_BY_TARGET_UUID_COMPLETE:String = 'getSoundsByTargetUuidComplete';	
		public static const SOUND_TRANSCODE_COMPLETE:String = 'soundTranscodeComplete';
		public static const REMOVE_AUDIO_COMPLETE:String = 'removeAudioComplete';
		
		//video
		public static const GET_VIDEO_LIST_BY_TARGET_UUID_COMPLETE:String = 'getVideoListByTargetUuidComplete';	
		public static const WRITE_VIDEO_TO_DISK_COMPLETE:String = 'writeVideoToDiskComplete';
		
		//question
		public static const UPDATE_LOCAL_QUESTIONS:String = 'updateLocalQuestions';	
		public static const UPDATE_QUESTIONS_COMPLETE:String = 'updateQuestionsComplete';	
		public static const RETRIEVE_QUESTION_ANSWERS_COMPLETE:String = 'retrieveQuestionAnswersComplete';	
		public static const RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE:String = 'retrieveQuestionsByChapterUuidComplete';	
		public static const SET_QUESTIONS_TO_CHAPTER:String = 'setQuestionsToChapter';	
		
		//publish
		public static const RETRIEVE_LESSON_ARTIFACTS_COMPLETE:String = 'retrieveLessonArtifactsComplete';	
		
		//user settings
		public static const UPDATE_USER_SETTINGS_COMPLETE:String = 'updateUserSettingsComplete';	
	}
}