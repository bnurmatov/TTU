////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.data.SQLStatement;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;

	/**
	 * StatementUtil class 
	 */
	public class StatementUtil
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
		 * StatementUtil 
		 */
		public function StatementUtil()
		{
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		public static function initSqlStatements():Array
		{
			var statements:Array = [];
			
			// getDepartments
			statements[ SqlQueryConstants.GET_ALL_DEPARTMENTS_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_ALL_DEPARTMENTS_SQL_KEY ] ).text = SqlQueryConstants.GET_ALL_DEPARTMENTS_SQL;
			
			statements[ SqlQueryConstants.GET_DEPARTMENTS_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_DEPARTMENTS_SQL_KEY ] ).text = SqlQueryConstants.GET_DEPARTMENTS_SQL;
			
			// getSpecialities
			statements[ SqlQueryConstants.GET_SPECIALITIES_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_SPECIALITIES_SQL_KEY ] ).text = SqlQueryConstants.GET_SPECIALITIES_SQL;
			
			
			// create Lesson
			statements[ SqlQueryConstants.CREATE_LESSON_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_LESSON_SQL_KEY ] ).text = SqlQueryConstants.CREATE_LESSON_SQL;
			
			// user Lessons map
			statements[ SqlQueryConstants.ADD_USER_LESSON_MAP_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.ADD_USER_LESSON_MAP_SQL_KEY ] ).text = SqlQueryConstants.ADD_USER_LESSON_MAP_SQL;
			
			// update Lesson
			statements[ SqlQueryConstants.UPDATE_LESSON_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_LESSON_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_LESSON_SQL;
			
			// update Lesson max active view index
			statements[ SqlQueryConstants.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL;
			
			// get Lessons by Uuid
			statements[ SqlQueryConstants.GET_LESSONS_BY_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_LESSONS_BY_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_LESSONS_BY_UUID_SQL;
			
			// get Lessons by department
			statements[ SqlQueryConstants.GET_LESSONS_BY_DEPARTMENT_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_LESSONS_BY_DEPARTMENT_SQL_KEY ] ).text = SqlQueryConstants.GET_LESSONS_BY_DEPARTMENT_SQL;
			
			// change Lesson
			statements[ SqlQueryConstants.CHANGED_LESSON_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CHANGED_LESSON_SQL_KEY ] ).text = SqlQueryConstants.CHANGED_LESSON_SQL;
			
			// validate Lesson name
			statements[ SqlQueryConstants.CHECK_IF_LESSON_NAME_AVAILABLE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CHECK_IF_LESSON_NAME_AVAILABLE_SQL_KEY ] ).text = SqlQueryConstants.CHECK_IF_LESSON_NAME_AVAILABLE_SQL;
			
			// delete Lesson
			statements[ SqlQueryConstants.DELETE_LESSON_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_LESSON_SQL_KEY ] ).text = SqlQueryConstants.DELETE_LESSON_SQL;
			
			// create chapter
			statements[ SqlQueryConstants.CREATE_CHAPTER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_CHAPTER_SQL_KEY ] ).text = SqlQueryConstants.CREATE_CHAPTER_SQL;
			
			// update chapter
			statements[ SqlQueryConstants.UPDATE_CHAPTER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_CHAPTER_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_CHAPTER_SQL;
			
			// max chapter position
			statements[ SqlQueryConstants.GET_MAX_CHAPTER_POSITION_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_MAX_CHAPTER_POSITION_SQL_KEY ] ).text = SqlQueryConstants.GET_MAX_CHAPTER_POSITION_SQL;
			
			// get chapters by lesson uuid
			statements[ SqlQueryConstants.GET_CHAPTERS_BY_LESSON_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_CHAPTERS_BY_LESSON_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_CHAPTERS_BY_LESSON_UUID_SQL;
			
			// remove chapter
			statements[ SqlQueryConstants.REMOVE_CHAPTER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.REMOVE_CHAPTER_SQL_KEY ] ).text = SqlQueryConstants.REMOVE_CHAPTER_SQL;
			
			// create resource
			statements[ SqlQueryConstants.CREATE_RESOURCE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_RESOURCE_SQL_KEY ] ).text = SqlQueryConstants.CREATE_RESOURCE_SQL;
			
			// update resource
			statements[ SqlQueryConstants.UPDATE_RESOURCE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_RESOURCE_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_RESOURCE_SQL;
			
			// update resource
			statements[ SqlQueryConstants.UPDATE_RESOURCE_PATH_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_RESOURCE_PATH_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_RESOURCE_PATH_SQL;
			
			// max resource position
			statements[ SqlQueryConstants.GET_MAX_RESOURCE_POSITION_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_MAX_RESOURCE_POSITION_SQL_KEY ] ).text = SqlQueryConstants.GET_MAX_RESOURCE_POSITION_SQL;
			
			// get resource by lesson uuid
			statements[ SqlQueryConstants.GET_RESOURCES_BY_LESSON_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_RESOURCES_BY_LESSON_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_RESOURCES_BY_LESSON_UUID_SQL;
			
			// remove resource
			statements[ SqlQueryConstants.REMOVE_RESOURCE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.REMOVE_RESOURCE_SQL_KEY ] ).text = SqlQueryConstants.REMOVE_RESOURCE_SQL;
			
			// create artifact
			statements[ SqlQueryConstants.CREATE_ARTIFACT_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_ARTIFACT_SQL_KEY ] ).text = SqlQueryConstants.CREATE_ARTIFACT_SQL;
			
			// get artifact by lesson uuid
			statements[ SqlQueryConstants.GET_ARTIFACT_BY_LESSON_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_ARTIFACT_BY_LESSON_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_ARTIFACT_BY_LESSON_UUID_SQL;
			
			// remove artifact
			statements[ SqlQueryConstants.REMOVE_ARTIFACT_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.REMOVE_ARTIFACT_SQL_KEY ] ).text = SqlQueryConstants.REMOVE_ARTIFACT_SQL;
			
			// remove artifacts by lesson uuid
			statements[ SqlQueryConstants.REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL_KEY ] ).text = SqlQueryConstants.REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL;
			
			// get images by uuid
			statements[ SqlQueryConstants.GET_IMAGES_BY_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_IMAGES_BY_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_IMAGES_BY_UUID_SQL;
			
			// create image
			statements[ SqlQueryConstants.CREATE_IMAGE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_IMAGE_SQL_KEY ] ).text = SqlQueryConstants.CREATE_IMAGE_SQL;
			
			// update image
			statements[ SqlQueryConstants.UPDATE_IMAGE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_IMAGE_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_IMAGE_SQL;
			
			// delete image
			statements[ SqlQueryConstants.DELETE_IMAGE_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_IMAGE_SQL_KEY ] ).text = SqlQueryConstants.DELETE_IMAGE_SQL;
			
			// get sounds by uuid
			statements[ SqlQueryConstants.GET_SOUNDS_BY_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_SOUNDS_BY_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_SOUNDS_BY_UUID_SQL;
			
			// create sound
			statements[ SqlQueryConstants.CREATE_SOUND_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_SOUND_SQL_KEY ] ).text = SqlQueryConstants.CREATE_SOUND_SQL;
			
			// update sound
			statements[ SqlQueryConstants.UPDATE_SOUND_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_SOUND_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_SOUND_SQL;
			
			// delete sound
			statements[ SqlQueryConstants.DELETE_SOUND_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_SOUND_SQL_KEY ] ).text = SqlQueryConstants.DELETE_SOUND_SQL;
			
			// get video list by uuid
			statements[ SqlQueryConstants.GET_VIDEO_LIST_BY_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_VIDEO_LIST_BY_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_VIDEO_LIST_BY_UUID_SQL;
			
			// create video
			statements[ SqlQueryConstants.CREATE_VIDEO_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_VIDEO_SQL_KEY ] ).text = SqlQueryConstants.CREATE_VIDEO_SQL;
			
			// update video
			statements[ SqlQueryConstants.UPDATE_VIDEO_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_VIDEO_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_VIDEO_SQL;
			
			// delete video
			statements[ SqlQueryConstants.DELETE_VIDEO_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_VIDEO_SQL_KEY ] ).text = SqlQueryConstants.DELETE_VIDEO_SQL;
			
			// create question
			statements[ SqlQueryConstants.CREATE_QUESTION_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_QUESTION_SQL_KEY ] ).text = SqlQueryConstants.CREATE_QUESTION_SQL;
			
			// update question
			statements[ SqlQueryConstants.UPDATE_QUESTION_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_QUESTION_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_QUESTION_SQL;
			
			// delete question
			statements[ SqlQueryConstants.DELETE_QUESTION_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_QUESTION_SQL_KEY ] ).text = SqlQueryConstants.DELETE_QUESTION_SQL;
			
			// retrieve questions
			statements[ SqlQueryConstants.GET_QUESTION_BY_CHAPTER_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_QUESTION_BY_CHAPTER_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_QUESTION_BY_CHAPTER_UUID_SQL;
			
			// create answer
			statements[ SqlQueryConstants.CREATE_ANSWER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_ANSWER_SQL_KEY ] ).text = SqlQueryConstants.CREATE_ANSWER_SQL;
			
			// update answer
			statements[ SqlQueryConstants.UPDATE_ANSWER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_ANSWER_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_ANSWER_SQL;
			
			// delete answer
			statements[ SqlQueryConstants.DELETE_ANSWER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.DELETE_ANSWER_SQL_KEY ] ).text = SqlQueryConstants.DELETE_ANSWER_SQL;
			
			// retrieve answers
			statements[ SqlQueryConstants.GET_ANSWERS_BY_QUESTION_UUID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_ANSWERS_BY_QUESTION_UUID_SQL_KEY ] ).text = SqlQueryConstants.GET_ANSWERS_BY_QUESTION_UUID_SQL;
			
			// default user 
			statements[ SqlQueryConstants.CREATE_DEFAULT_USER_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_DEFAULT_USER_SQL_KEY ] ).text = SqlQueryConstants.CREATE_DEFAULT_USER_SQL;
			
			// Create User Settings 
			statements[ SqlQueryConstants.CREATE_USER_SETTINGS_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.CREATE_USER_SETTINGS_SQL_KEY ] ).text = SqlQueryConstants.CREATE_USER_SETTINGS_SQL;
			
			// Update User Settings 
			statements[ SqlQueryConstants.UPDATE_USER_SETTINGS_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.UPDATE_USER_SETTINGS_SQL_KEY ] ).text = SqlQueryConstants.UPDATE_USER_SETTINGS_SQL;
			
			// Retrieve User Settings 
			statements[ SqlQueryConstants.GET_USER_SETTINGS_BY_USER_ID_SQL_KEY ] = new SQLStatement();
			SQLStatement( statements[ SqlQueryConstants.GET_USER_SETTINGS_BY_USER_ID_SQL_KEY ] ).text = SqlQueryConstants.GET_USER_SETTINGS_BY_USER_ID_SQL;
			
			
			return statements;
		}
		
	}
}