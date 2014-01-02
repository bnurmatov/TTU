////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.chapter.add.AddNewChapterCommand;
	import tj.ttu.airservice.controller.chapter.add.AddNewChapterCompleteCommand;
	import tj.ttu.airservice.controller.chapter.add.PrepareAddNewChapterCommand;
	import tj.ttu.airservice.controller.chapter.parser.ParseChaptersForDeleteLessonCommand;
	import tj.ttu.airservice.controller.chapter.parser.ParseLocalLessonChaptersCommand;
	import tj.ttu.airservice.controller.chapter.parser.SetChaptersToLessonCommand;
	import tj.ttu.airservice.controller.chapter.remove.DeleteChapterAssetsFromDiskCommand;
	import tj.ttu.airservice.controller.chapter.remove.RemoveLocalChapterCommand;
	import tj.ttu.airservice.controller.chapter.retrieve.RetrieveLessonChaptersCommand;
	import tj.ttu.airservice.controller.chapter.retrieve.RetrieveLessonChaptersComplete;
	import tj.ttu.airservice.controller.chapter.update.UpdateChapterCompleteCommand;
	import tj.ttu.airservice.controller.chapter.update.UpdateLocalLessonChaptersCommand;
	import tj.ttu.airservice.controller.chapter.update.UpdateLocalLessonChaptersCompleteCommand;
	import tj.ttu.airservice.controller.department.RetrieveAllDepartmentsCommand;
	import tj.ttu.airservice.controller.department.RetrieveDepartmentsCommand;
	import tj.ttu.airservice.controller.image.GetImagesByTargetUuidCompleteCommand;
	import tj.ttu.airservice.controller.image.RemoveImageCompleteCommand;
	import tj.ttu.airservice.controller.image.RemoveLocalImageCommand;
	import tj.ttu.airservice.controller.image.RetrieveChapterImagesCompleteCommand;
	import tj.ttu.airservice.controller.image.RetrieveLocalLessonImagesCompleteCommand;
	import tj.ttu.airservice.controller.image.SaveLocalImageCommand;
	import tj.ttu.airservice.controller.image.SaveLocalImageCompleteCommand;
	import tj.ttu.airservice.controller.image.UpdateLocalImageCommand;
	import tj.ttu.airservice.controller.image.UpdateLocalImageCompleteCommand;
	import tj.ttu.airservice.controller.init.CreateDBSchemaCommand;
	import tj.ttu.airservice.controller.init.InsertDBDataCommand;
	import tj.ttu.airservice.controller.lesson.clone.CloneLessonCommand;
	import tj.ttu.airservice.controller.lesson.clone.CloneLessonCompleteCommand;
	import tj.ttu.airservice.controller.lesson.clone.PrepareCloneLessonCommand;
	import tj.ttu.airservice.controller.lesson.create.CreateLocalLessonCommand;
	import tj.ttu.airservice.controller.lesson.create.CreateLocalLessonCompleteCommand;
	import tj.ttu.airservice.controller.lesson.parser.ParseLocalLessonsCommand;
	import tj.ttu.airservice.controller.lesson.remove.DeleteLessonAssetsFromDiskCommand;
	import tj.ttu.airservice.controller.lesson.remove.PrepareRemoveLessonCommand;
	import tj.ttu.airservice.controller.lesson.remove.RemoveLocalLessonCommand;
	import tj.ttu.airservice.controller.lesson.retrieve.RetrieveLocalLessonByUuidCommand;
	import tj.ttu.airservice.controller.lesson.retrieve.RetrieveLocalLessonsByDepartmentCommand;
	import tj.ttu.airservice.controller.lesson.retrieve.RetrieveLocalLessonsCompleteCommand;
	import tj.ttu.airservice.controller.lesson.update.UpdateLocalLessonCommand;
	import tj.ttu.airservice.controller.lesson.update.UpdateLocalLessonCompleteCommand;
	import tj.ttu.airservice.controller.lesson.update.UpdateLocalLessonMaxActiveViewIndexCommand;
	import tj.ttu.airservice.controller.lesson.validate.ValidateLocalLessonNameCommand;
	import tj.ttu.airservice.controller.publish.PublishLessonCommand;
	import tj.ttu.airservice.controller.publish.PublishLessonCompleteCommand;
	import tj.ttu.airservice.controller.publish.RetriveLessonArtifactsCommand;
	import tj.ttu.airservice.controller.publish.RetriveLessonArtifactsCompleteCommand;
	import tj.ttu.airservice.controller.publish.SaveArtifactToLocalDiskCommand;
	import tj.ttu.airservice.controller.question.retrieve.RetrieveQuestionAnswersCompleteCommand;
	import tj.ttu.airservice.controller.question.retrieve.RetrieveQuestionsByChapterUuidCommand;
	import tj.ttu.airservice.controller.question.retrieve.RetrieveQuestionsByChapterUuidCompleteCommand;
	import tj.ttu.airservice.controller.question.retrieve.SetQuestionsToChapterCommand;
	import tj.ttu.airservice.controller.question.update.PrepareUpdateQuestionsCommand;
	import tj.ttu.airservice.controller.question.update.UpdateQuestionsCommand;
	import tj.ttu.airservice.controller.question.update.UpdateQuestionsCompleteCommand;
	import tj.ttu.airservice.controller.resource.add.AddNewResourceCommand;
	import tj.ttu.airservice.controller.resource.add.AddNewResourceCompleteCommand;
	import tj.ttu.airservice.controller.resource.add.PrepareAddNewResourceCommand;
	import tj.ttu.airservice.controller.resource.parser.ParseLocalLessonResourcesCommand;
	import tj.ttu.airservice.controller.resource.remove.RemoveLocalResourceCommand;
	import tj.ttu.airservice.controller.resource.remove.RemoveResourceAssetsFromDiskCommand;
	import tj.ttu.airservice.controller.resource.retrieve.RetrieveLessonResourceCommand;
	import tj.ttu.airservice.controller.resource.retrieve.RetrieveLessonResourceCompleteCommand;
	import tj.ttu.airservice.controller.resource.update.UpdateLocalLessonResourcesCommand;
	import tj.ttu.airservice.controller.resource.update.UpdateLocalLessonResourcesCompleteCommand;
	import tj.ttu.airservice.controller.resource.upload.ResourceContentDataLoadedCommand;
	import tj.ttu.airservice.controller.resource.upload.UploadLacalResourceContentCommand;
	import tj.ttu.airservice.controller.resource.upload.UploadLocalResourceContentCompleteCommand;
	import tj.ttu.airservice.controller.settings.RetrieveUserSettingsCommand;
	import tj.ttu.airservice.controller.settings.UpdateUserSettingsCommand;
	import tj.ttu.airservice.controller.settings.UpdateUserSettingsCompleteCommand;
	import tj.ttu.airservice.controller.sound.GetSoundsByTargetUuidCompleteCommand;
	import tj.ttu.airservice.controller.sound.RemovePreviousLessonSoundCommand;
	import tj.ttu.airservice.controller.sound.RemoveSoundCommand;
	import tj.ttu.airservice.controller.sound.RemoveSoundCompleteCommand;
	import tj.ttu.airservice.controller.sound.RetrieveChapterSoundsCompleteCommand;
	import tj.ttu.airservice.controller.sound.RetrieveLocalLessonSoundCompleteCommand;
	import tj.ttu.airservice.controller.sound.SaveLocalChapterSoundCommand;
	import tj.ttu.airservice.controller.sound.SaveLocalLessonSoundCommand;
	import tj.ttu.airservice.controller.sound.SaveLocalSoundCompleteCommand;
	import tj.ttu.airservice.controller.sound.SoundDataLoadedCommand;
	import tj.ttu.airservice.controller.sound.SoundTranscodeCompleteCommand;
	import tj.ttu.airservice.controller.speciality.RetrieveSpecialitiesCommand;
	import tj.ttu.airservice.controller.user.AddDefaultUserCommand;
	import tj.ttu.airservice.controller.video.GetVideoListByTargetUuidCompleteCommand;
	import tj.ttu.airservice.controller.video.RetrieveChapterVideoListCompleteCommand;
	import tj.ttu.airservice.controller.video.SaveLocalChapterVideoCommand;
	import tj.ttu.airservice.controller.video.SaveLocalVideoCompleteCommand;
	import tj.ttu.airservice.controller.video.VideoDataLoadedCommand;
	import tj.ttu.airservice.controller.video.WriteVideoToDiskCompleteCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RegisterAirCommand class 
	 */
	public class RegisterAirCommand extends SimpleCommand
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
		 * RegisterAirCommand 
		 */
		public function RegisterAirCommand()
		{
			super();
		}
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function execute(notification:INotification):void
		{
			//init DB
			facade.registerCommand(CourseAirConstants.CREATE_DB_SCHEMA, CreateDBSchemaCommand);
			facade.registerCommand(CourseAirConstants.INSERT_DB_DATA, InsertDBDataCommand);
			
			//default user
			facade.registerCommand(CourseAirConstants.ADD_DEFAULT_USER, AddDefaultUserCommand);
			
			//lesson
			facade.registerCommand(CourseServiceNotification.CREATE_LESSON, CreateLocalLessonCommand);
			facade.registerCommand(CourseAirConstants.CREATE_LOCAL_LESSON_COMPLETE, CreateLocalLessonCompleteCommand);
			facade.registerCommand(CourseServiceNotification.UPDATE_LESSON, UpdateLocalLessonCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_LOCAL_LESSON_COMPLETE, UpdateLocalLessonCompleteCommand);
			facade.registerCommand(CourseServiceNotification.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX, UpdateLocalLessonMaxActiveViewIndexCommand);
			facade.registerCommand(CourseServiceNotification.VALIDATE_LESSON_NAME, ValidateLocalLessonNameCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_LESSONS_BY_DEPARTMENT, RetrieveLocalLessonsByDepartmentCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE, RetrieveLocalLessonsCompleteCommand);
			facade.registerCommand(CourseAirConstants.PARSE_LOCAL_LESSONS, ParseLocalLessonsCommand);
			facade.registerCommand(CourseServiceNotification.DELETE_LESSON, PrepareRemoveLessonCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_LOCAL_LESSON, RemoveLocalLessonCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_LOCAL_LESSON_ASSETS_FROM_DISK, DeleteLessonAssetsFromDiskCommand);
			facade.registerCommand(CourseServiceNotification.CLONE_LESSON, PrepareCloneLessonCommand);
			facade.registerCommand(CourseAirConstants.CLONE_LOCAL_LESSON, CloneLessonCommand);
			facade.registerCommand(CourseAirConstants.CLONE_LOCAL_LESSON_COMPLETE, CloneLessonCompleteCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_LESSON_BY_UUID, RetrieveLocalLessonByUuidCommand);
			
			//chapter
			facade.registerCommand(CourseServiceNotification.ADD_NEW_CHAPTER, PrepareAddNewChapterCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_CHAPTERS, RetrieveLessonChaptersCommand);
			facade.registerCommand(CourseServiceNotification.REMOVE_CHAPTER, RemoveLocalChapterCommand);
			facade.registerCommand(CourseAirConstants.ADD_NEW_LOCAL_CAHPTER, AddNewChapterCommand);
			facade.registerCommand(CourseAirConstants.ADD_NEW_LOCAL_CAHPTER_COMPLETE, AddNewChapterCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LESSON_CHAPTERS_COMPLETE, RetrieveLessonChaptersComplete);
			facade.registerCommand(CourseServiceNotification.UPDATE_CHAPTERS, UpdateLocalLessonChaptersCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_LOCAL_LESSON_CHAPTERS_COMPLETE, UpdateLocalLessonChaptersCompleteCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_CHAPTER_COMPLETE, UpdateChapterCompleteCommand);
			facade.registerCommand(CourseAirConstants.PARSE_LOCAL_LESSON_CHAPTERS, ParseLocalLessonChaptersCommand);
			facade.registerCommand(CourseAirConstants.DELETE_CHAPTER_ASSETS_FROM_DISK, DeleteChapterAssetsFromDiskCommand);
			facade.registerCommand(CourseAirConstants.PARSE_LOCAL_CHAPTERS_FOR_DELETE_LESSON, ParseChaptersForDeleteLessonCommand);
			facade.registerCommand(CourseAirConstants.SET_CHAPTERS_TO_LESSON, SetChaptersToLessonCommand);
			
			//resource
			facade.registerCommand(CourseServiceNotification.ADD_NEW_RESOURCE, PrepareAddNewResourceCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_RESOURCES, RetrieveLessonResourceCommand);
			facade.registerCommand(CourseServiceNotification.REMOVE_RESOURCE, RemoveLocalResourceCommand);
			facade.registerCommand(CourseAirConstants.ADD_NEW_LOCAL_RESOURCE, AddNewResourceCommand);
			facade.registerCommand(CourseAirConstants.ADD_NEW_LOCAL_RESOURCE_COMPLETE, AddNewResourceCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LESSON_RESOURCES_COMPLETE, RetrieveLessonResourceCompleteCommand);
			facade.registerCommand(CourseServiceNotification.UPDATE_RESOURCES, UpdateLocalLessonResourcesCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_LOCAL_LESSON_RESOURCES_COMPLETE, UpdateLocalLessonResourcesCompleteCommand);
			facade.registerCommand(CourseAirConstants.PARSE_LOCAL_LESSON_RESOURCES, ParseLocalLessonResourcesCommand);
			facade.registerCommand(CourseAirConstants.DELETE_RESOURCE_ASSETS_FROM_DISK, RemoveResourceAssetsFromDiskCommand);
			facade.registerCommand(CourseServiceNotification.UPLOAD_RESOURCE_CONTENT, UploadLacalResourceContentCommand);
			facade.registerCommand(CourseAirConstants.RESOURCE_CONTENT_DATA_LOADED, ResourceContentDataLoadedCommand);
			facade.registerCommand(CourseAirConstants.UPLOAD_RESOURCE_CONTENT_COMPLETE, UploadLocalResourceContentCompleteCommand);
			
			//sound
			facade.registerCommand(CourseServiceNotification.ASSOCIATE_LESSON_AUDIO, SaveLocalLessonSoundCommand);
			facade.registerCommand(CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO, SaveLocalChapterSoundCommand);
			facade.registerCommand(CourseAirConstants.LESSON_SOUND_DATA_LOADED, SoundDataLoadedCommand);
			facade.registerCommand(CourseAirConstants.CHAPTER_SOUND_DATA_LOADED, SoundDataLoadedCommand);
			facade.registerCommand(CourseAirConstants.SAVE_LOCAL_SOUND_COMPLETE, SaveLocalSoundCompleteCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_PREVIOUS_LOCAL_LESSON_SOUND, RemovePreviousLessonSoundCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LOCAL_LESSON_SOUND_COMPLETE, RetrieveLocalLessonSoundCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_CHAPTER_SOUNDS_COMPLETE, RetrieveChapterSoundsCompleteCommand);
			facade.registerCommand(CourseAirConstants.GET_SOUNDS_BY_TARGET_UUID_COMPLETE, GetSoundsByTargetUuidCompleteCommand);
			facade.registerCommand(CourseAirConstants.SOUND_TRANSCODE_COMPLETE, SoundTranscodeCompleteCommand);
			facade.registerCommand(CourseServiceNotification.REMOVE_AUDIO, RemoveSoundCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_AUDIO_COMPLETE, RemoveSoundCompleteCommand);
			
			//image
			facade.registerCommand(CourseServiceNotification.ASSOCIATE_IMAGE, SaveLocalImageCommand);
			facade.registerCommand(CourseAirConstants.SAVE_LOCAL_IMAGE_COMPLETE, SaveLocalImageCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LOCAL_LESSON_IMAGES_COMPLETE, RetrieveLocalLessonImagesCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_CHAPTER_IMAGES_COMPLETE, RetrieveChapterImagesCompleteCommand);
			facade.registerCommand(CourseAirConstants.GET_IMAGES_BY_TARGET_UUID_COMPLETE, GetImagesByTargetUuidCompleteCommand);
			facade.registerCommand(CourseServiceNotification.UPDATE_IMAGE, UpdateLocalImageCommand);
			facade.registerCommand(CourseAirConstants.UPDTAE_IMAGE_COMPLETE, UpdateLocalImageCompleteCommand);
			facade.registerCommand(CourseServiceNotification.REMOVE_IMAGE, RemoveLocalImageCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_IMAGE_COMPLETE, RemoveImageCompleteCommand);
			
			//department
			facade.registerCommand(CourseServiceNotification.RETRIEVE_DEPARTMENTS, RetrieveDepartmentsCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_ALL_DEPARTMENTS, RetrieveAllDepartmentsCommand);
			
			//speciality
			facade.registerCommand(CourseServiceNotification.RETRIEVE_SPECIALITIES, RetrieveSpecialitiesCommand);
			
			//video
			facade.registerCommand(CourseServiceNotification.ASSOCIATE_CHAPTER_VIDEO, SaveLocalChapterVideoCommand);
			facade.registerCommand(CourseAirConstants.CHAPTER_VIDEO_DATA_LOADED, VideoDataLoadedCommand);
			facade.registerCommand(CourseAirConstants.SAVE_LOCAL_VIDEO_COMPLETE, SaveLocalVideoCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_CHAPTER_VIDEO_LIST_COMPLETE, RetrieveChapterVideoListCompleteCommand);
			facade.registerCommand(CourseAirConstants.GET_VIDEO_LIST_BY_TARGET_UUID_COMPLETE, GetVideoListByTargetUuidCompleteCommand);
			facade.registerCommand(CourseAirConstants.WRITE_VIDEO_TO_DISK_COMPLETE, WriteVideoToDiskCompleteCommand);
			
			//question
			facade.registerCommand(CourseServiceNotification.UPDATE_QUESTIONS, PrepareUpdateQuestionsCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_LOCAL_QUESTIONS, UpdateQuestionsCommand);
			facade.registerCommand(CourseServiceNotification.RETRIVE_QUESTIONS_BY_CHAPTER_UUID, RetrieveQuestionsByChapterUuidCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE, RetrieveQuestionsByChapterUuidCompleteCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_QUESTIONS_COMPLETE, UpdateQuestionsCompleteCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_QUESTION_ANSWERS_COMPLETE, RetrieveQuestionAnswersCompleteCommand);
			facade.registerCommand(CourseAirConstants.SET_QUESTIONS_TO_CHAPTER, SetQuestionsToChapterCommand);
			
			//publish
			facade.registerCommand(CourseServiceNotification.PUBLISH_LESSON, PublishLessonCommand);
			facade.registerCommand(CourseAirConstants.PUBLISH_LOCAL_LESSON_COMPLETE, PublishLessonCompleteCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_ARTIFACTS, RetriveLessonArtifactsCommand);
			facade.registerCommand(CourseAirConstants.RETRIEVE_LESSON_ARTIFACTS_COMPLETE, RetriveLessonArtifactsCompleteCommand);
			facade.registerCommand(CourseServiceNotification.SAVE_ARTIFACT_TO_DISK, SaveArtifactToLocalDiskCommand);
			
			//user settings
			facade.registerCommand(CourseServiceNotification.UPDATE_USER_SETTINGS, UpdateUserSettingsCommand);
			facade.registerCommand(CourseAirConstants.UPDATE_USER_SETTINGS_COMPLETE, UpdateUserSettingsCompleteCommand);
			facade.registerCommand(CourseServiceNotification.RETRIEVE_USER_SETTINGS, RetrieveUserSettingsCommand);
			
		}
		
			
		
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
		
		/**
		 *  @private
		 */
		
		
	}
}