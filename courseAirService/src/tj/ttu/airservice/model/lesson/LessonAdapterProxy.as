////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 26, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.lesson
{
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * LessonAdapterProxy class 
	 */
	public class LessonAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'LessonAdapterProxy';
		/**
		 * TRASHED state of a list
		 */
		public static const TRASHED_LIST_STATE:String = "TRASHED";
		
		/**
		 * DRAFT state of a list
		 */
		public static const DRAFT_LIST_STATE:String = "DRAFT";
		
		/**
		 * Maximum list name size
		 */
		public static const MAXIMUM_LIST_NAME_LENGTH:uint = 255;
		
		/**
		 * Default description
		 */
		public static const DEFAULT_DESCRIPTION:String = "Lesson for TTU students";
		
		/**
		 * Default creator
		 */
		public static const DEFAULT_CREATOR:String = "TTU teacher";
		
		/**
		 * Default app creator name
		 */
		public static const DEFAULT_APP_CREATOR_NAME:String = "CourseCreatorAIR";
		
		/**
		 * Default creator url
		 */
		public static const DEFAULT_CREATOR_URL:String = "http://www.ttu.tj";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * The index of our current working lesson
		 */
		private var currentLessonIndex:int;
		
		/**
		 * The  lesson that is being clone
		 */
		public var clonningLesson:LessonVO;
		/**
		 * The current lesson that is being worked with
		 */
		public var currentLesson:LessonVO;
		
		/**
		 * The current lesson that is being worked with
		 */
		public var sourceLessonUuid:String;
		
		/**
		 * The current lesson that is being worked with
		 */
		public var sourceLessonVersion:uint;
		
		public var lessonBuildingCompleteNotification:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonAdapterProxy 
		 */
		public function LessonAdapterProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------
		//  currentLessons
		//--------------------------------------
		private var _currentLessons:Array;
		
		public function get currentLessons():Array
		{
			return _currentLessons;
		}
		
		public function set currentLessons(value:Array):void
		{
			if( _currentLessons !== value)
			{
				_currentLessons = value;
				currentLessonIndex = _currentLessons ? _currentLessons.length : -1;
			}
		}
		//--------------------------------------
		//  shouldGetChapters
		//--------------------------------------
		private var _shouldGetChapters:Boolean;
		
		public function get shouldGetChapters():Boolean
		{
			return _shouldGetChapters;
		}
		
		public function set shouldGetChapters(value:Boolean):void
		{
			if( _shouldGetChapters !== value)
			{
				_shouldGetChapters = value;
			}
		}
		/**
		 * we currently only have a single user system 
		 */
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
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			cleanUp();
			super.onRemove();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function cleanUp():void
		{
			clonningLesson = null;
			currentLesson = null;
			currentLessons = null;
			currentLessonIndex = -1;
			lessonBuildingCompleteNotification = null;
			shouldGetChapters = false;
			sourceLessonUuid = null;
			sourceLessonVersion = 0;
		}
		
		/**
		 * Shift to the next <code>LessonVO</code> in array of current lessons.
		 */
		public function shiftCurrentLesson():void
		{
			currentLesson = currentLessons ? currentLessons[--currentLessonIndex] : null;
		}
		
		/**
		 * Retrieves any images that belong to the 'current' lesson.
		 * 
		 */
		public function getCurrentLessonImages():void
		{
			if(imageAdapterProxy)
				imageAdapterProxy.getImagesByTargetUuid( currentLesson.guid, CourseAirConstants.RETRIEVE_LOCAL_LESSON_IMAGES_COMPLETE);
		}
		
		
		/**
		 * Retrieve a sound that belong to the 'current' lesson.
		 * 
		 */
		public function getCurrentLessonSound():void
		{
			if(soundAdapterProxy)
				soundAdapterProxy.getSoundsByTargetUuid( currentLesson.guid, CourseAirConstants.RETRIEVE_LOCAL_LESSON_SOUND_COMPLETE);
		}
		
		/**
		 * Retrieve a sound that belong to the 'current' lesson.
		 * 
		 */
		public function getCurrentLessonChapters():void
		{
			if(chapterAdapterProxy)
			{
				var chapterServiceVo:ChapterServiceVO = new ChapterServiceVO(currentLesson.guid, currentLesson.version, null);
				chapterAdapterProxy.currentChapterServiceVO = chapterServiceVo;
				chapterAdapterProxy.getChaptersByLessonUuid( currentLesson.guid, CourseAirConstants.RETRIEVE_LESSON_CHAPTERS_COMPLETE, CourseAirConstants.SET_CHAPTERS_TO_LESSON);
			}
		}
		
		
		/**
		 *  @public
		 */
		public function createLesson(lesson:LessonVO, createChapters:Boolean, completionNotification:String, isTransaction:Boolean = true, isEdit:Boolean = false):void
		{
			// check list name length
			if( lesson.name == null || lesson.name.length > MAXIMUM_LIST_NAME_LENGTH )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The proposed list name is either null, empty or too long.");
				sendNotification(completionNotification);
				return;
			}
			
			// create new UUID and reset version, unless editing
			if(!isEdit)
			{
				lesson.guid = UIDUtil.createUID();
				lesson.version = 0;
			}
			
			currentLesson = lesson;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			insertList(lesson, isEdit);
			insertUserLessonMapping(lesson.guid, databaseMangerProxy.userId);
			
			if(lesson.sound)
				soundAdapterProxy.createSound(lesson.sound, lesson.guid, null, false);
			
			if(lesson.aboutCreatorImages && lesson.aboutCreatorImages.length > 0)
			{
				for each(var image:ImageVO in lesson.aboutCreatorImages)
				{
					if(image)
						imageAdapterProxy.createImage(image, lesson.guid, null, false);
				}
			}
			
			// add chapters if flag is set
			if(createChapters)
			{
				for each(var chapter:ChapterVO in lesson.chapters)
				{
					chapterAdapterProxy.createChapter(chapter, lesson.guid, lesson.version, null, false, isEdit);
				}
			}
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 *  @private
		 * 
		 */
		/**
		 * Insert a new lesson into the database.
		 * 
		 * @param lesson 	The <code>LessonVO</code> object representing the list to insert
		 * @param isEdit	Flag determining whether or not we are editing
		 */
		private function insertList(lesson:LessonVO, isEdit:Boolean = false):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_LESSON_SQL_KEY);
			
			statement.parameters[':uuid']					= lesson.guid;
			statement.parameters[':name']					= lesson.name;
			statement.parameters[':description']			= lesson.description 		? lesson.description : lesson.description = DEFAULT_DESCRIPTION;
			statement.parameters[':appcreator_name']		= lesson.appCreatorName 	? lesson.appCreatorName : lesson.appCreatorName = DEFAULT_APP_CREATOR_NAME;
			statement.parameters[':creator']				= lesson.creator 			? lesson.creator : lesson.creator = DEFAULT_CREATOR;
			statement.parameters[':about_creator']			= lesson.aboutCreator;
			statement.parameters[':creator_url']			= lesson.creatorURL 		? lesson.creatorURL : lesson.creatorURL = DEFAULT_CREATOR_URL;
			statement.parameters[':creation_date']			= lesson.creationDate 		? lesson.creationDate : lesson.creationDate = new Date();
			statement.parameters[':last_modified_date']		= lesson.lastModifiedDate 	? lesson.lastModifiedDate : lesson.lastModifiedDate = new Date();
			statement.parameters[':departmentId']			= lesson.departmentId;
			statement.parameters[':specialityId']			= lesson.specialityId;
			statement.parameters[':discipline']				= lesson.discipline;
			statement.parameters[':list_state']				= lesson.lessonState;
			statement.parameters[':visibility']				= lesson.visibility;
			statement.parameters[':ordered']				= lesson.isOrdered
			statement.parameters[':lesson_version']			= lesson.version;
			statement.parameters[':changed']				= !isEdit;
			statement.parameters[':published']				= 0;
			statement.parameters[':view_index']				= lesson.viewIndex;
			statement.parameters[':max_active_view_index']	= lesson.createMaxActiveViewIndex;
			statement.parameters[':locale']					= lesson.locale;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Insert mapping between a lesson and a user.
		 * 
		 * @param lessonUuid 	UUID of the list
		 * @param userId 	ID of the currently logged in user
		 */
		private function insertUserLessonMapping(lessonUuid:String, userId:uint):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.ADD_USER_LESSON_MAP_SQL_KEY);
			
			statement.parameters[':uuid']						= lessonUuid;
			statement.parameters[':userId']						= userId;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 * Updates an existing lesson to the new state, including chapters.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to create
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isUpdateChapters				Flag determining whether or not to update chapters 
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateLesson(lesson:LessonVO, completionNotification:String = "", isUpdateChapters:Boolean = true, isTransaction:Boolean = true):void
		{
			// save lesson to proxy
			currentLesson = lesson;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			
			updateLessonRecord(lesson);
			
			if(imageAdapterProxy)
				imageAdapterProxy.updateImages(lesson.guid, lesson.version, lesson.guid, lesson.aboutCreatorImages);
			/*if(isUpdateChapters)
			cardAdapterProxy.updateCards(bykiList.cards, bykiList.guid);*/
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update lesson to match the <code>LessonVO</code> object which represents
		 * the lesson's new state.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to update
		 */
		private function updateLessonRecord(lesson:LessonVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_LESSON_SQL_KEY);
			
			statement.parameters[':uuid']					= lesson.guid;
			statement.parameters[':name']					= lesson.name;
			statement.parameters[':description']			= lesson.description ;
			statement.parameters[':appcreator_name']		= lesson.appCreatorName;
			statement.parameters[':creator']				= lesson.creator;
			statement.parameters[':about_creator']			= lesson.aboutCreator;
			statement.parameters[':creator_url']			= lesson.creatorURL;
			statement.parameters[':creation_date']			= lesson.creationDate;
			statement.parameters[':last_modified_date']		= new Date();
			statement.parameters[':departmentId']			= lesson.departmentId;
			statement.parameters[':specialityId']			= lesson.specialityId;
			statement.parameters[':discipline']				= lesson.discipline;
			statement.parameters[':list_state']				= lesson.lessonState;
			statement.parameters[':visibility']				= lesson.visibility;
			statement.parameters[':ordered']				= lesson.isOrdered
			statement.parameters[':lesson_version']			= lesson.version;
			statement.parameters[':view_index']				= lesson.viewIndex;
			statement.parameters[':max_active_view_index']	= lesson.createMaxActiveViewIndex;
			statement.parameters[':locale']					= lesson.locale;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 * Updates an existing lesson to the new state, including chapters.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to create
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isUpdateChapters				Flag determining whether or not to update chapters 
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateLessonMaxActiveViewIndex(lesson:LessonVO, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			// save lesson to proxy
			currentLesson = lesson;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			updateLessonMaxActiveViewIndexRecord(lesson);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update lesson to match the <code>LessonVO</code> object which represents
		 * the lesson's new state.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to update
		 */
		private function updateLessonMaxActiveViewIndexRecord(lesson:LessonVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX_SQL_KEY);
			
			statement.parameters[':uuid']					= lesson.guid;
			statement.parameters[':view_index']				= lesson.viewIndex;
			statement.parameters[':max_active_view_index']	= lesson.createMaxActiveViewIndex;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Interrogates the system to see if the proposed lesson name already exists.  It does NOT check published lesson.
		 * 
		 * @param lessonName 					the proposed lesson name.
		 * @param department 					department name.
		 * @param speciality 					speciality name.
		 * @param completionNotification		the notification to send upon completion
		 */
		public function validateLessonName(lessonName:String, departmentId:int, specialityId:int, completionNotification:String):void
		{
			checkIfLessonNameAvailable(lessonName, departmentId, specialityId,  databaseMangerProxy.userId, completionNotification);
		}
		
		/**
		 * Check database see if the proposed lesson name already exists. Note that if any results are returned,
		 * this will evaluate to TRUE, after being cast as a Boolean. If no results are returned, null will 
		 * be sent in the body, which evaluates to FALSE.
		 * 
		 * NOT USED.
		 * 
		 * @param lessonName 					the proposed lesson name.
		 * @param department 					department name.
		 * @param speciality 					speciality name.
		 * @param completionNotification		the notification to send upon completion
		 */
		public function checkIfLessonNameAvailable(lessonName:String, departmentId:int, specialityId:int, userId:uint, completionNotification:String):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CHECK_IF_LESSON_NAME_AVAILABLE_SQL_KEY);
			
			statement.parameters[':lessonName']		= lessonName;
			statement.parameters[':departmentId']	= departmentId;
			statement.parameters[':specialityId']	= specialityId;
			statement.parameters[':userId']			= userId;
			statement.parameters[':locale']			= resourceProxy.locale;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param lessonUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getLessonByUuid(lessonUuid:String, completionNotification:String, lessonBuildingCompleteNotification:String):void
		{
			// fetch SQL statement, set itemclass
			this.lessonBuildingCompleteNotification = lessonBuildingCompleteNotification;
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_LESSONS_BY_UUID_SQL_KEY);
			statement.itemClass = LessonVO;
			statement.parameters[':lessonUuid'] 	= lessonUuid;
			statement.parameters[':userId'] 		= databaseMangerProxy.userId;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
		
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param lessonUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getLessonsByDepartment(departmentId:int, completionNotification:String):void
		{
			lessonBuildingCompleteNotification = CourseAirConstants.PARSE_LOCAL_LESSONS;
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_LESSONS_BY_DEPARTMENT_SQL_KEY);
			statement.itemClass = LessonVO;
			
			statement.parameters[':departmentId'] = departmentId; 
			statement.parameters[':userId'] 	= databaseMangerProxy.userId;
			statement.parameters[':locale'] 	= resourceProxy.locale;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			request.nextNote = completionNotification;
			
			databaseMangerProxy.executeRequest( request );	
		}
		
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param lessonUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getLessonImagesByUuid(lessonUuid:String, completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_IMAGES_BY_UUID_SQL_KEY);
			statement.itemClass = ImageVO;
			statement.parameters[':targetUuid'] 	= lessonUuid;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
		
		/**
		 * Update lesson's changed field
		 * 
		 * @param lessonUuid	UUID of the lesson
		 */
		public function changedLesson(lessonUuid:String):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CHANGED_LESSON_SQL_KEY);
			
			statement.parameters[':uuid'] = lessonUuid;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Deletes a lesson from the system.
		 * 
		 * @param lessonUuid					UUID of the lesson to delete
		 * @param completionNotification	Notification to send upon completion, if needed
		 */
		public function deleteLessonByUuid(lessonUuid:String, completionNotification:String = "", isPublished:Boolean = false):void
		{
			deleteLessonRecord(lessonUuid, completionNotification, isPublished);
		}
		
		/**
		 * Delete the lesson from the database, based on the <code>lessonUuid</code>. Upon
		 * completion, send the <code>completionNotification</code>.
		 * 
		 * @param lessonUuid					UUID of the lesson to delete
		 * @param completionNotification	Notification to send when deletion completes
		 */
		private function deleteLessonRecord(lessonUuid:String, completionNotification:String, isPublished:Boolean = false, isTransaction:Boolean = true):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.DELETE_LESSON_SQL_KEY);
			
			statement.parameters[':lessonUuid'] 		= lessonUuid;
			statement.parameters[':isPublished'] 		= isPublished;
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			//request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
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