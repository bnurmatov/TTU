////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.constants
{
	/**
	 * SqlQueryConstants class 
	 */
	public class SqlQueryConstants
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//	departments
		//-----------------------------------
		
		public static const GET_ALL_DEPARTMENTS_SQL_KEY:String = 'getAllDepartmentsSqlKey';
		
		public static const GET_ALL_DEPARTMENTS_SQL:String = ( <![CDATA[
																		SELECT DP.fKaf_Code as departmentCode,
																				DP.fKaf_Faculty as facultyCode,
																				DP.fKaf_NameTaj as departmentTjName,
																				DP.fKaf_NameRus as departmentRuName,
																				DP.fKaf_NameEng as departmentEnName,
																				DP.fKaf_NameTajShort as departmentTjShortName,
																				DP.fKaf_NameRusShort as departmentRuShortName,
																				DP.fKaf_NameEngShort as departmentEnShortName,
																				DP.fKaf_ZavKafedra as departmentManager,
																				DP.fKaf_Ord as orderNumber
																		FROM tblSpr_Kafedra DP
																]]> ).toString();
		
	
		public static const GET_DEPARTMENTS_SQL_KEY:String = 'getDepartmentsSqlKey';
		
		public static const GET_DEPARTMENTS_SQL:String = ( <![CDATA[
																		SELECT DP.fKaf_Code as departmentCode,
																				DP.fKaf_Faculty as facultyCode,
																				DP.fKaf_NameTaj as departmentTjName,
																				DP.fKaf_NameRus as departmentRuName,
																				DP.fKaf_NameEng as departmentEnName,
																				DP.fKaf_NameTajShort as departmentTjShortName,
																				DP.fKaf_NameRusShort as departmentRuShortName,
																				DP.fKaf_NameEngShort as departmentEnShortName,
																				DP.fKaf_ZavKafedra as departmentManager,
																				DP.fKaf_Ord as orderNumber
																		FROM tblSpr_Kafedra DP 
																		INNER JOIN tbl_Lessons LESSON 
																		ON DP.fKaf_Code = LESSON.departmentId AND LESSON.locale =:locale
																		GROUP BY DP.fKaf_Code
																]]> ).toString();
		
	
		//-----------------------------------
		//	specialities
		//-----------------------------------
		
		public static const GET_SPECIALITIES_SQL_KEY:String = 'getSpecialitiesSqlKey';
		
		public static const GET_SPECIALITIES_SQL:String = ( <![CDATA[
																		SELECT SP.fID as id,
																			SP.fSpec_Faculty as facultyCode,
																			SP.fSpec_NameTaj as specialityTjName,
																			SP.fSpec_NameRus as specialityRuName,
																			SP.fSpec_NameEng as specialityEnName,
																			SP.fSpec_NameTajShort as specialityTjShortName,
																			SP.fSpec_NameRusShort as specialityRuShortName,
																			SP.fSpec_NameEngShort as specialityEnShortName,
																			SP.fSpec_Shifr as specialityCode
																		FROM tbl_Spec SP 
																]]> ).toString();
		
		//-----------------------------------
		//	lesson
		//-----------------------------------
		
		public static const CREATE_LESSON_SQL_KEY:String = 'createLessonSqlKey';
		
		public static const CREATE_LESSON_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Lessons
																			(  `uuid`,
																				`name`,
																				`description`,
																				`appcreator_name`,
																				`creator`,
																				`about_creator`,
																				`creator_url`,
																				`creation_date`,
																				`last_modified_date`,
																				`departmentId`,
																				`specialityId`,
																				`discipline`,
																				`list_state`,
																				`visibility`,
																				`ordered`,
																				`lesson_version`,
																				`changed`,
																				`published`,
																				`view_index`,
																				`max_active_view_index`,
																				`locale`				
																	  ) VALUES(	:uuid,
																				:name,
																				:description,
																				:appcreator_name,
																				:creator,
																				:about_creator,
																				:creator_url,
																				:creation_date,
																				:last_modified_date,
																				:departmentId,
																				:specialityId,
																				:discipline,
																				:list_state,
																				:visibility,
																				:ordered,
																				:lesson_version,
																				:changed,
																				:published,
																				:view_index,
																				:max_active_view_index,
																				:locale)
																			
																]]> ).toString();
		
		
		public static const UPDATE_LESSON_SQL_KEY:String = 'updateLessonSqlKey';
		
		public static const UPDATE_LESSON_SQL:String = ( <![CDATA[
																		UPDATE tbl_Lessons
																			SET
																			    `uuid` 					= :uuid,
																				`name` 					= :name,
																				`description` 			= :description,
																				`appcreator_name` 		= :appcreator_name,
																				`creator`				= :creator,
																				`about_creator` 		= :about_creator,
																				`creator_url` 			= :creator_url,
																				`creation_date` 		= :creation_date,
																				`last_modified_date` 	= :last_modified_date,
																				`departmentId` 			= :departmentId,
																				`specialityId` 			= :specialityId,
																				`discipline` 			= :discipline,
																				`list_state` 			= :list_state,
																				`visibility` 			= :visibility,
																				`ordered`	 			= :ordered,
																				`lesson_version` 		= :lesson_version,
																				`view_index` 			= :view_index,
																				`max_active_view_index` = :max_active_view_index,
																				`locale`				= :locale	
																	WHERE uuid=:uuid AND published = 0
																]]> ).toString();
		
		public static const UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL_KEY:String = 'updateLessonMaxActiveViewIndexSqlKey';
		
		public static const UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL:String = ( <![CDATA[
																		UPDATE tbl_Lessons
																			SET
																				`view_index` 			= :view_index,
																				`max_active_view_index` = :max_active_view_index	
																	WHERE uuid=:uuid AND published = 0
																]]> ).toString();
		
		
		/**
		 * addUserLEssonMap
		 */
		public static const ADD_USER_LESSON_MAP_SQL_KEY:String = 'addUserLessonMapSqlKey';
		
		public static const ADD_USER_LESSON_MAP_SQL:String = ( <![CDATA[
			INSERT INTO tbl_User_Lessons (users_user_id, lessons_lesson_id) 
			SELECT :userId, LESSON.lesson_id
			FROM tbl_Lessons LESSON
			WHERE LESSON.uuid = :uuid AND published = 0
															]]> ).toString();

		/**
		 * checkIfLessonNameAvailable
		 */
		public static const CHECK_IF_LESSON_NAME_AVAILABLE_SQL_KEY:String = 'checkIfLessonNameAvailableSqlKey';
		
		public static const CHECK_IF_LESSON_NAME_AVAILABLE_SQL:String = ( <![CDATA[
			SELECT 1 
			FROM tbl_Lessons LESSON 
			INNER JOIN tbl_User_Lessons USERLESSON ON   
			USERLESSON.lessons_lesson_id = LESSON.lesson_id
			WHERE LESSON.departmentId = :departmentId AND
			LESSON.specialityId = :specialityId AND
			LESSON.name = :lessonName AND
			USERLESSON.users_user_id = :userId AND LESSON.published = 0
															]]> ).toString();
		
		
		/**
		 * getLessonsByDepartment
		 */
		public static const GET_LESSONS_BY_DEPARTMENT_SQL_KEY:String = 'getLessonsByDepartmentSqlKey';
		
		public static const GET_LESSONS_BY_DEPARTMENT_SQL:String = ( <![CDATA[
					 SELECT LESSON.`lesson_id` as id,
							LESSON.`uuid` as guid,
							LESSON.`name`,
							LESSON.`description`,
							LESSON.`appcreator_name` as appCreatorName,
							LESSON.`creator`,
							LESSON.`about_creator` as aboutCreator,
							LESSON.`creator_url` as creatorURL,
							LESSON.`creation_date` as creationDate,
							LESSON.`last_modified_date` as lastModifiedDate,
							LESSON.`departmentId`,
							LESSON.`specialityId`,
							LESSON.`discipline`,
							LESSON.`list_state` as lessonState,
							LESSON.`visibility`,
							LESSON.`ordered` as isOrdered,
							LESSON.`lesson_version` as version,
							LESSON.`changed`,
							LESSON.`published` as isPublished,
							LESSON.`view_index` as viewIndex,
							LESSON.`max_active_view_index` as createMaxActiveViewIndex,
							LESSON.`locale`
					FROM tbl_Lessons LESSON 
					INNER JOIN tbl_User_Lessons UL
					WHERE LESSON.lesson_id = UL.lessons_lesson_id AND
						LESSON.departmentId = :departmentId AND      
						LESSON.locale = :locale AND      
						UL.[users_user_id] = :userId;
															]]> ).toString();
		
		
		/**
		 * getLessonsByUuid
		 */
		public static const GET_LESSONS_BY_UUID_SQL_KEY:String = 'getLessonsByUuidSqlKey';
		
		public static const GET_LESSONS_BY_UUID_SQL:String = ( <![CDATA[
					 SELECT LESSON.`lesson_id` as id,
							LESSON.`uuid` as guid,
							LESSON.`name`,
							LESSON.`description`,
							LESSON.`appcreator_name` as appCreatorName,
							LESSON.`creator`,
							LESSON.`about_creator` as aboutCreator,
							LESSON.`creator_url` as creatorURL,
							LESSON.`creation_date` as creationDate,
							LESSON.`last_modified_date` as lastModifiedDate,
							LESSON.`departmentId`,
							LESSON.`specialityId`,
							LESSON.`discipline`,
							LESSON.`list_state` as lessonState,
							LESSON.`visibility`,
							LESSON.`ordered` as isOrdered,
							LESSON.`lesson_version` as version,
							LESSON.`changed`,
							LESSON.`published` as isPublished,
							LESSON.`view_index` as viewIndex,
							LESSON.`max_active_view_index` as createMaxActiveViewIndex,
							LESSON.`locale`
					FROM tbl_Lessons LESSON 
					INNER JOIN tbl_User_Lessons UL
			WHERE LESSON.lesson_id = UL.lessons_lesson_id AND
			LESSON.uuid = :lessonUuid AND      
			UL.users_user_id = :userId;
															]]> ).toString();

		/**
		 * changedList
		 */
		public static const CHANGED_LESSON_SQL_KEY:String = 'changedLessonSqlKey';
		
		public static const CHANGED_LESSON_SQL:String = ( <![CDATA[
		UPDATE tbl_Lessons
		SET `changed` = 1
		WHERE uuid=:uuid AND published = 0
															]]> ).toString();
		
		/**
		 * deleteLesson
		 */
		public static const DELETE_LESSON_SQL_KEY:String = 'deleteLessonSqlKey';
		
		public static const DELETE_LESSON_SQL:String = ( <![CDATA[
		DELETE FROM tbl_Lessons WHERE uuid = :lessonUuid AND published = :isPublished
															]]> ).toString();
		
		//-----------------------------------
		//	image
		//-----------------------------------
		/**
		 * create image
		 */
		public static const CREATE_IMAGE_SQL_KEY:String = 'createImageSqlKey';
		
		public static const CREATE_IMAGE_SQL:String = ( <![CDATA[
			INSERT INTO tbl_Images
						(
							`target_uuid`,
							`image_url`,
							`original_image_url`,
							`width`,
							`height`,
							`location`,
							`text_position`,
							`padding_left`,
							`padding_right`,
							`padding_top`,
							`padding_bottom`
						) VALUES
						(
							:target_uuid,
							:image_url,
							:original_image_url,
							:width,
							:height,
							:location,
							:text_position,
							:padding_left,
							:padding_right,
							:padding_top,
							:padding_bottom
						)
			]]> ).toString();
		
		/**
		 * update image
		 */
		public static const UPDATE_IMAGE_SQL_KEY:String = 'updateImageSqlKey';
		
		public static const UPDATE_IMAGE_SQL:String = ( <![CDATA[
			UPDATE tbl_Images
			SET
				`width`			= :width,
				`height`		= :height,
				`location`		= :location,
				`text_position`	= :textPosition
			WHERE `target_uuid`=:targetUuid AND image_url = :imageUrl
			]]> ).toString();
		
		/**
		 * update image
		 */
		public static const UPDATE_IMAGE_METADATA_SQL_KEY:String = 'updateImageMetadataSqlKey';
		
		public static const UPDATE_IMAGE_METADATA_SQL:String = ( <![CDATA[
			UPDATE tbl_Images
			SET
				`width`			= :width,
				`height`		= :height,
				`location`		= :location
			WHERE image_url = :imageUrl
			]]> ).toString();
		
		/**
		 * delete an image
		 */
		public static const DELETE_IMAGE_SQL_KEY:String = 'deleteImageSqlKey';
		
		public static const DELETE_IMAGE_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Images WHERE target_uuid = :targetUuid AND image_url = :imageUrl
			]]> ).toString();
		
		
		/**
		 * delete an image
		 */
		public static const DELETE_IMAGE_BY_IMAGE_URL_SQL_KEY:String = 'deleteImageByImageUrlSqlKey';
		
		public static const DELETE_IMAGE_BY_IMAGE_URL_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Images WHERE image_url = :imageUrl
			]]> ).toString();
		
		
		/**
		 * getImagesByUuid
		 */
		public static const GET_IMAGES_BY_UUID_SQL_KEY:String = 'getImagesByUuidSqlKey';
		
		public static const GET_IMAGES_BY_UUID_SQL:String = ( <![CDATA[
					 SELECT IMAGE.`image_url` as imageUrl,
							IMAGE.`original_image_url` as originalImageUrl,
							IMAGE.`width`,
							IMAGE.`height`,
							IMAGE.`location`,
							IMAGE.`text_position` as textPosition,
							IMAGE.`padding_left` as paddingLeft,
							IMAGE.`padding_right` as paddingRight,
							IMAGE.`padding_top` as paddingTop,
							IMAGE.`padding_bottom` as paddingBottom
					FROM tbl_Images IMAGE 
					WHERE IMAGE.target_uuid = :targetUuid;
															]]> ).toString();
		
		//-----------------------------------
		//	sound
		//-----------------------------------
		/**
		 * create sound
		 */
		public static const CREATE_SOUND_SQL_KEY:String = 'createSoundSqlKey';
		
		public static const CREATE_SOUND_SQL:String = ( <![CDATA[
			INSERT INTO tbl_Sounds
						(
							`target_uuid`,
							`sound_url`,
							`location`,
							`text_position`,
							`padding_left`,
							`padding_right`,
							`padding_top`,
							`padding_bottom`
						) VALUES
						(
							:target_uuid,
							:sound_url,
							:location,
							:text_position,
							:padding_left,
							:padding_right,
							:padding_top,
							:padding_bottom
						)
			]]> ).toString();
		
		/**
		 * update sound
		 */
		public static const UPDATE_SOUND_SQL_KEY:String = 'updateSoundSqlKey';
		
		public static const UPDATE_SOUND_SQL:String = ( <![CDATA[
			UPDATE tbl_Sounds
			SET
				`location`		= :location,
				`text_position`	= :textPosition
			WHERE `target_uuid`=:targetUuid AND sound_url = :soundUrl
			]]> ).toString();
		

		/**
		 * delete an sound
		 */
		public static const DELETE_SOUND_SQL_KEY:String = 'deleteSoundSqlKey';
		
		public static const DELETE_SOUND_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Sounds WHERE target_uuid = :targetUuid AND sound_url = :soundUrl
			]]> ).toString();
		
		
		/**
		 * getSoundsByUuid
		 */
		public static const GET_SOUNDS_BY_UUID_SQL_KEY:String = 'getSoundsByUuidSqlKey';
		
		public static const GET_SOUNDS_BY_UUID_SQL:String = ( <![CDATA[
					 SELECT SOUND.`sound_url` as soundUrl,
							SOUND.`location`,
							SOUND.`text_position` as textPosition,
							SOUND.`padding_left` as paddingLeft,
							SOUND.`padding_right` as paddingRight,
							SOUND.`padding_top` as paddingTop,
							SOUND.`padding_bottom` as paddingBottom
					FROM tbl_Sounds SOUND 
					WHERE SOUND.target_uuid = :targetUuid;
															]]> ).toString();
		
		
		
		//-----------------------------------
		//	video
		//-----------------------------------
		/**
		 * create video
		 */
		public static const CREATE_VIDEO_SQL_KEY:String = 'createVideoSqlKey';
		
		public static const CREATE_VIDEO_SQL:String = ( <![CDATA[
			INSERT INTO tbl_Video
						(
							`target_uuid`,
							`video_url`,
							`location`,
							`text_position`,
							`padding_left`,
							`padding_right`,
							`padding_top`,
							`padding_bottom`
						) VALUES
						(
							:target_uuid,
							:video_url,
							:location,
							:text_position,
							:padding_left,
							:padding_right,
							:padding_top,
							:padding_bottom
						)
			]]> ).toString();
		
		/**
		 * update video
		 */
		public static const UPDATE_VIDEO_SQL_KEY:String = 'updateVideoSqlKey';
		
		public static const UPDATE_VIDEO_SQL:String = ( <![CDATA[
			UPDATE tbl_Video
			SET
				`location`		= :location,
				`text_position`	= :textPosition
			WHERE `target_uuid`=:targetUuid AND video_url = :videoUrl
			]]> ).toString();
		

		/**
		 * delete an video
		 */
		public static const DELETE_VIDEO_SQL_KEY:String = 'deleteVideoSqlKey';
		
		public static const DELETE_VIDEO_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Video WHERE target_uuid = :targetUuid AND video_url = :videoUrl
			]]> ).toString();
		
		
		/**
		 * getVideoByUuid
		 */
		public static const GET_VIDEO_LIST_BY_UUID_SQL_KEY:String = 'getVideoListByUuidSqlKey';
		
		public static const GET_VIDEO_LIST_BY_UUID_SQL:String = ( <![CDATA[
					 SELECT VIDEO.`video_url` as videoUrl,
							VIDEO.`location`,
							VIDEO.`text_position` as textPosition,
							VIDEO.`padding_left` as paddingLeft,
							VIDEO.`padding_right` as paddingRight,
							VIDEO.`padding_top` as paddingTop,
							VIDEO.`padding_bottom` as paddingBottom
					FROM tbl_Video VIDEO 
					WHERE VIDEO.target_uuid = :targetUuid;
															]]> ).toString();
		
		
		
		
		//-----------------------------------
		//	chapter
		//-----------------------------------
		
		public static const CREATE_CHAPTER_SQL_KEY:String = 'createChapterSqlKey';
		
		public static const CREATE_CHAPTER_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Chapters
																			(  `lesson_uuid`,
																				`uuid`,
																				`chapter_title`,
																				`chapter_text`,
																				`chapter_comment`,
																				`creation_date`,
																				`last_modified_date`,
																				`chapter_position`,
																				`version`,
																				`published`
																	  ) VALUES(	:lesson_uuid,
																				:uuid,
																				:chapter_title,
																				:chapter_text,
																				:chapter_comment,
																				:creation_date,
																				:last_modified_date,
																				:chapter_position,
																				:version,
																				:published)
																			
																]]> ).toString();
		
		
		public static const UPDATE_CHAPTER_SQL_KEY:String = 'updateChapterSqlKey';
		
		public static const UPDATE_CHAPTER_SQL:String = ( <![CDATA[
																		UPDATE tbl_Chapters
																			SET
																				`lesson_uuid` 		= :lesson_uuid,
																				`uuid` 				= :uuid,
																				`chapter_title` 	= :chapter_title,
																				`chapter_text` 		= :chapter_text,
																				`chapter_comment`	= :chapter_comment,
																				`creation_date` 	= :creation_date,
																				`last_modified_date`= :last_modified_date,
																				`chapter_position` 	= :chapter_position,
																				`version` 			= :version
																	WHERE uuid=:uuid AND published = 0
																]]> ).toString();
		
		/**
		 * getLessonsByUuid
		 */
		public static const GET_CHAPTERS_BY_LESSON_UUID_SQL_KEY:String = 'getChaptersByLessonUuidSqlKey';
		
		public static const GET_CHAPTERS_BY_LESSON_UUID_SQL:String = ( <![CDATA[
					 SELECT CHAPTER.`chapter_id` as id,
							CHAPTER.`lesson_uuid` as lessonUuid,
							CHAPTER.`uuid` as chapterUuid,
							CHAPTER.`chapter_title` as title,
							CHAPTER.`chapter_text` as text,
							CHAPTER.`chapter_comment` as comment,
							CHAPTER.`creation_date` as creationDate,
							CHAPTER.`last_modified_date` as lastModifiedDate,
							CHAPTER.`chapter_position` as position,
							CHAPTER.`version` as version,
							CHAPTER.`published` as isPublished
					FROM tbl_Chapters CHAPTER 
					WHERE CHAPTER.lesson_uuid = :lessonUuid;
															]]> ).toString();

		
		/**
		 * GetMaxChapterPosition
		 */
		public static const GET_MAX_CHAPTER_POSITION_SQL_KEY:String = 'getMaxChapterPositionSqlKey';
		
		public static const GET_MAX_CHAPTER_POSITION_SQL:String = ( <![CDATA[
		SELECT MAX(chapter_position) as max_chapter_position
		FROM tbl_Chapters
		WHERE lesson_uuid = :lesson_uuid AND version = :version AND published = 0
															]]> ).toString();
		
		/**
		 * removeChapter
		 */
		public static const REMOVE_CHAPTER_SQL_KEY:String = 'removeChapterSqlKey';
		
		public static const REMOVE_CHAPTER_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Chapters WHERE uuid = :chapterUuid AND published = 0
															]]> ).toString();
		//-----------------------------------
		//	resource
		//-----------------------------------
		
		public static const CREATE_RESOURCE_SQL_KEY:String = 'createResourceSqlKey';
		
		public static const CREATE_RESOURCE_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Resources
																			(  `lesson_uuid`,
																				`resource_uuid`,
																				`resource_title`,
																				`resource_url`,
																				`resource_path`,
																				`resource_comment`,
																				`resouce_type`,
																				`resource_position`,
																				`published`,
																				`version`
																	  ) VALUES(	:lesson_uuid,
																				:resource_uuid,
																				:resource_title,
																				:resource_url,
																				:resource_path,
																				:resource_comment,
																				:resouce_type,
																				:resource_position,
																				:published,
																				:version)
																			
																]]> ).toString();
		
		
		public static const UPDATE_RESOURCE_SQL_KEY:String = 'updateResourceSqlKey';
		
		public static const UPDATE_RESOURCE_SQL:String = ( <![CDATA[
																		UPDATE tbl_Resources
																			SET
																				`lesson_uuid`		= :lesson_uuid,
																				`resource_uuid`		= :resource_uuid,
																				`resource_title`	= :resource_title,
																				`resource_url`		= :resource_url,
																				`resource_path`		= :resource_path,
																				`resource_comment`	= :resource_comment,
																				`resouce_type`		= :resouce_type,
																				`resource_position`	= :resource_position,
																				`version`			= :version
																	WHERE resource_uuid =:resource_uuid AND published = 0
																]]> ).toString();
		
		public static const UPDATE_RESOURCE_PATH_SQL_KEY:String = 'updateResourcePathSqlKey';
		
		public static const UPDATE_RESOURCE_PATH_SQL:String = ( <![CDATA[
																		UPDATE tbl_Resources
																			SET
																				`resource_path`		= :resource_path
																	WHERE resource_uuid =:resource_uuid AND published = 0
																]]> ).toString();
		
		/**
		 * getResources By Lesson Uuid
		 */
		public static const GET_RESOURCES_BY_LESSON_UUID_SQL_KEY:String = 'getResourcesByLessonUuidSqlKey';
		
		public static const GET_RESOURCES_BY_LESSON_UUID_SQL:String = ( <![CDATA[
					 SELECT RESOURCE.`id` as id,
							RESOURCE.`lesson_uuid` as lessonUuid,
							RESOURCE.`resource_uuid` as resourceUuid,
							RESOURCE.`resource_title` as title,
							RESOURCE.`resource_url` as url,
							RESOURCE.`resource_path` as resourcePath,
							RESOURCE.`resource_comment` as comment,
							RESOURCE.`resouce_type` as resouceType,
							RESOURCE.`resource_position` as position,
							RESOURCE.`version` as version,
							RESOURCE.`published` as isPublished
					FROM tbl_Resources RESOURCE 
					WHERE RESOURCE.lesson_uuid =:lessonUuid;
															]]> ).toString();

		
		/**
		 * GetMaxResourcePosition
		 */
		public static const GET_MAX_RESOURCE_POSITION_SQL_KEY:String = 'getMaxResourcePositionSqlKey';
		
		public static const GET_MAX_RESOURCE_POSITION_SQL:String = ( <![CDATA[
		SELECT MAX(resource_position) as max_resource_position
		FROM tbl_Resources
		WHERE lesson_uuid = :lesson_uuid AND version =:version AND published = 0
															]]> ).toString();
		
		/**
		 * remove Resource
		 */
		public static const REMOVE_RESOURCE_SQL_KEY:String = 'removeResourceSqlKey';
		
		public static const REMOVE_RESOURCE_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Resources WHERE resource_uuid =:resourceUuid AND published = 0
															]]> ).toString();
		
		//-----------------------------------
		//	artifacts
		//-----------------------------------
		
		public static const CREATE_ARTIFACT_SQL_KEY:String = 'createArtifactSqlKey';
		
		public static const CREATE_ARTIFACT_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Artifacts
																			(  `lesson_uuid`,
																				`artifact_url`,
																				`artifact_type`
																	  ) VALUES(	:lesson_uuid,
																				:artifact_url,
																				:artifact_type)
																			
																]]> ).toString();
		
		/**
		 * getArtifacts By Lesson Uuid
		 */
		public static const GET_ARTIFACT_BY_LESSON_UUID_SQL_KEY:String = 'getArtifactByLessonUuidSqlKey';
		
		public static const GET_ARTIFACT_BY_LESSON_UUID_SQL:String = ( <![CDATA[
					 SELECT ARTIFACT.`id` as id,
							ARTIFACT.`lesson_uuid` as lessonUuid,
							ARTIFACT.`artifact_url` as url,
							ARTIFACT.`artifact_type` as artifactType
					FROM tbl_Artifacts ARTIFACT 
					WHERE ARTIFACT.lesson_uuid =:lessonUuid;
															]]> ).toString();

		/**
		 * remove ARTIFACT
		 */
		public static const REMOVE_ARTIFACT_SQL_KEY:String = 'removeArtifactSqlKey';
		
		public static const REMOVE_ARTIFACT_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Artifacts WHERE id =:id
															]]> ).toString();
		
		/**
		 * remove ARTIFACTS by Lesson UUID
		 */
		public static const REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL_KEY:String = 'removeArtifactsByLessonUuidSqlKey';
		
		public static const REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Artifacts WHERE lesson_uuid =:lessonUuid
															]]> ).toString();
		
		//-----------------------------------
		//	question
		//-----------------------------------
		
		public static const CREATE_QUESTION_SQL_KEY:String = 'createQuestionSqlKey';
		
		public static const CREATE_QUESTION_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Questions
																			(  `chapter_uuid`,
																				`uuid`,
																				`text`,
																				`incorrect_answer_hint`
																	  ) VALUES(	:chapter_uuid,
																				:uuid,
																				:text,
																				:incorrect_answer_hint
																				)
																			
																]]> ).toString();
		
		
		public static const UPDATE_QUESTION_SQL_KEY:String = 'updateQuestionSqlKey';
		
		public static const UPDATE_QUESTION_SQL:String = ( <![CDATA[
																		UPDATE tbl_Questions
																			SET
																				`chapter_uuid` 					= :chapter_uuid,
																				`uuid` 							= :uuid,
																				`text` 							= :text,
																				`incorrect_answer_hint` 		= :incorrect_answer_hint
																	WHERE uuid=:uuid
																]]> ).toString();
		
		/**
		 * getQuestionsByUuid
		 */
		public static const GET_QUESTION_BY_CHAPTER_UUID_SQL_KEY:String = 'getQuestionByChapterUuidSqlKey';
		
		public static const GET_QUESTION_BY_CHAPTER_UUID_SQL:String = ( <![CDATA[
					 SELECT 
							QUESTION.`chapter_uuid` as chapterUuid,
							QUESTION.`uuid` as guid,
							QUESTION.`text` as text,
							QUESTION.`incorrect_answer_hint` as incorrectAnswerHint
					FROM tbl_Questions QUESTION 
					WHERE QUESTION.chapter_uuid = :chapter_uuid;
															]]> ).toString();
		
		/**
		 * delete an QUESTION
		 */
		public static const DELETE_QUESTION_SQL_KEY:String = 'deleteQuestionSqlKey';
		
		public static const DELETE_QUESTION_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Questions WHERE uuid = :uuid
			]]> ).toString();
		

		
		//-----------------------------------
		//	answer
		//-----------------------------------
		
		public static const CREATE_ANSWER_SQL_KEY:String = 'createAnswerSqlKey';
		
		public static const CREATE_ANSWER_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_Answers
																			(  `question_uuid`,
																				`uuid`,
																				`text`,
																				`position`,
																				`is_correct`
																	  ) VALUES(	:question_uuid,
																				:uuid,
																				:text,
																				:position,
																				:is_correct
																				)
																			
																]]> ).toString();
		
		
		public static const UPDATE_ANSWER_SQL_KEY:String = 'updateAnswerSqlKey';
		
		public static const UPDATE_ANSWER_SQL:String = ( <![CDATA[
																		UPDATE tbl_Answers
																			SET
																				`question_uuid` 	= :question_uuid,
																				`uuid` 				= :uuid,
																				`text` 				= :text,
																				`position` 			= :position,
																				`is_correct` 		= :is_correct
																	WHERE uuid=:uuid
																]]> ).toString();
		
		/**
		 * getAnswersByUuid
		 */
		public static const GET_ANSWERS_BY_QUESTION_UUID_SQL_KEY:String = 'getAnswersByQuestionUuidSqlKey';
		
		public static const GET_ANSWERS_BY_QUESTION_UUID_SQL:String = ( <![CDATA[
					 SELECT 
							ANSWER.`uuid` as guid,
							ANSWER.`text` as text,
							ANSWER.`position` as position,
							ANSWER.`is_correct` as isCorrect
					FROM tbl_Answers ANSWER 
					WHERE ANSWER.question_uuid = :question_uuid;
															]]> ).toString();

		
		/**
		 * delete an ANSWER
		 */
		public static const DELETE_ANSWER_SQL_KEY:String = 'deleteAnswerSqlKey';
		
		public static const DELETE_ANSWER_SQL:String = ( <![CDATA[
			DELETE FROM tbl_Answers WHERE uuid = :uuid
			]]> ).toString();
		
		
		public static const CREATE_DEFAULT_USER_SQL_KEY:String = 'createDefaultUserSqlKey';
		/**
		 * CREATE_DEFAULT_USER
		 */
		public static const CREATE_DEFAULT_USER_SQL:String = ( <![CDATA[
															INSERT INTO Users(login,password,role) VALUES (:login,:password,:role)
														]]> ).toString();
		
		//-----------------------------------
		//	User Settings
		//-----------------------------------
		
		public static const CREATE_USER_SETTINGS_SQL_KEY:String = 'createUserSettingsSqlKey';
		
		public static const CREATE_USER_SETTINGS_SQL:String = ( <![CDATA[
																		INSERT INTO tbl_UserSettings
																			(  `user_id`,
																				`lesson_uuid`,
																				`view_index`
																	  ) VALUES(	:userId,
																				:lessonUuid,
																				:viewIndex)
																			
																]]> ).toString();
		
		/**
		 * updateUserSettings
		 */
		public static const UPDATE_USER_SETTINGS_SQL_KEY:String = 'updateUserSettingsSqlKey';
		
		public static const UPDATE_USER_SETTINGS_SQL:String = ( <![CDATA[
																		UPDATE tbl_UserSettings
																			SET
																				`user_id` 				= :userId,
																				`lesson_uuid` 			= :lessonUuid,
																				`view_index` 			= :viewIndex
																	WHERE user_id=:userId
																]]> ).toString();
		
		
		/**
		 * getUserSettingsByUserId
		 */
		public static const GET_USER_SETTINGS_BY_USER_ID_SQL_KEY:String = 'getUserSettingsByUserIdSqlKey';
		
		public static const GET_USER_SETTINGS_BY_USER_ID_SQL:String = ( <![CDATA[
					 SELECT `user_id` as userId,
							`lesson_uuid` as currentLessonUUID,
							`view_index` as createViewIndex,
			(SELECT 1 
			FROM tbl_User_Lessons USER_LESSONS 
			WHERE USER_LESSONS.users_user_id = :userId) as hasLesson
					FROM tbl_UserSettings 
					WHERE user_id = :userId;
															]]> ).toString();

		
	}
}