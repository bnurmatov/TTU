////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 25, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.chapter
{
	import flash.data.SQLStatement;
	
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.courseservice.model.vo.ChapterServiceVO;
	
	/**
	 * ChapterProxy class 
	 */
	public class ChapterAdapterProxy extends  BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * The current chapter that is being worked with
		 */
		public var currentChapter:ChapterVO;
		
		/**
		 * The current ChapterServiceVO that is being worked with
		 */
		public var currentChapterServiceVO:ChapterServiceVO;
		
		/**
		 * The index of our current working chapter
		 */
		private var currentChapterIndex:int;
		
		public var chaptersBuildingCompleteNotification:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterProxy 
		 */
		public function ChapterAdapterProxy()
		{
			super(NAME);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _currentChapters:Array;
		
		/**
		 * The current chapters that is being worked with
		 */
		public function get currentChapters():Array
		{
			return _currentChapters;
		}
		
		/**
		 * @private
		 */
		public function set currentChapters(value:Array):void
		{
			if( _currentChapters !== value)
			{
				_currentChapters = value;
				currentChapterIndex = _currentChapters ? _currentChapters.length : -1;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
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
		
		/**
		 *  @public
		 */
		public function cleanUp():void
		{
			currentChapterIndex = 0;
			currentChapter = null;
			currentChapters = null;
			currentChapterServiceVO = null;
			chaptersBuildingCompleteNotification = null;
		}
		/**
		 * Shift to the next <code>ChapterVO</code> in array of current chapters.
		 */
		public function shiftCurrentChapter():void
		{
			currentChapter = currentChapters ? currentChapters[--currentChapterIndex] : null;
		}
		
		/**
		 * Retrieves any images that belong to the 'current' chapter.
		 * 
		 */
		public function getCurrentChapterImages():void
		{
			if(imageAdapterProxy)
				imageAdapterProxy.getImagesByTargetUuid( currentChapter.chapterUuid, CourseAirConstants.RETRIEVE_CHAPTER_IMAGES_COMPLETE);
		}
		
		/**
		 * Retrieves any sounds that belong to the 'current' chapter.
		 * 
		 */
		public function getCurrentChapterSounds():void
		{
			if(soundAdapterProxy)
				soundAdapterProxy.getSoundsByTargetUuid( currentChapter.chapterUuid, CourseAirConstants.RETRIEVE_CHAPTER_SOUNDS_COMPLETE);
		}
		
		/**
		 * Retrieves any video that belong to the 'current' chapter.
		 * 
		 */
		public function getCurrentChapterVideoList():void
		{
			if(videoAdapterProxy)
				videoAdapterProxy.getVideoByTargetUuid( currentChapter.chapterUuid, CourseAirConstants.RETRIEVE_CHAPTER_VIDEO_LIST_COMPLETE);
		}
		
		/**
		 * Retrieves any video that belong to the 'current' chapter.
		 * 
		 */
		public function getCurrentChapterQuestions():void
		{
			if(questionAdapterProxy)
				questionAdapterProxy.retrieveQuestionsByChapterUuid( currentChapter.chapterUuid, CourseAirConstants.RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE, CourseAirConstants.SET_QUESTIONS_TO_CHAPTER);
		}
		
		/**
		 * Retrieves any chapters that belong to the lesson.
		 * 
		 */
		public function getChaptersByLessonUuid(lessonUuid:String, completionNotification:String, chaptersBuildingCompleteNotification:String):void
		{
			this.chaptersBuildingCompleteNotification = chaptersBuildingCompleteNotification;
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = new SQLStatement()
			/*var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_CHAPTERS_BY_LESSON_UUID_SQL_KEY);*/
			statement.text = SqlQueryConstants.GET_CHAPTERS_BY_LESSON_UUID_SQL;
			statement.itemClass = ChapterVO;
			statement.parameters[':lessonUuid'] 	= lessonUuid;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 *  @public
		 */
		public function createChapter(chapter:ChapterVO, lessonUuid:String, lessonVersion:int, completionNotification:String, isTransaction:Boolean = true, isEdit:Boolean = false):void
		{
			// create new UUID and reset version, unless editing
			if(!isEdit|| StringUtil.isNullOrEmpty(chapter.chapterUuid))
			{
				chapter.chapterUuid = UIDUtil.createUID();
			}
			
			currentChapter = chapter;
			chapter.lessonUuid = lessonUuid;
			chapter.version = lessonVersion;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			insertChapter(chapter, isEdit);
			
			if(chapter.images && chapter.images.length > 0)
			{
				for each(var image:ImageVO in chapter.images)
				{
					if(image)
						imageAdapterProxy.createImage(image, chapter.chapterUuid, null, false);
				}
			}
			
			if(chapter.sounds && chapter.sounds.length > 0)
			{
				for each(var sound:SoundVO in chapter.sounds)
				{
					if(sound)
						soundAdapterProxy.createSound(sound, chapter.chapterUuid, null, false);
				}
			}
			
			if(chapter.videoList && chapter.videoList.length > 0)
			{
				for each(var video:VideoVO in chapter.videoList)
				{
					if(video)
						videoAdapterProxy.createVideo(video, chapter.chapterUuid, null, false);
				}
			}
			
			if(chapter.questions && chapter.questions.length > 0)
			{
				for each(var question:QuestionVo in chapter.questions)
				{
					if(question)
					{
						question.chapterUuid = chapter.chapterUuid;
						questionAdapterProxy.addNewQuestion(question, null, false);
					}
				}
			}
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Insert a new chapter into the database.
		 * 
		 * @param chapter 	The <code>ChapterVO</code> object representing the list to insert
		 * @param isEdit	Flag determining whether or not we are editing
		 */
		private function insertChapter(chapter:ChapterVO, isEdit:Boolean = false):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_CHAPTER_SQL_KEY);
			
			statement.parameters[':lesson_uuid']		= chapter.lessonUuid;
			statement.parameters[':uuid']				= chapter.chapterUuid;
			statement.parameters[':chapter_title']		= chapter.title;
			statement.parameters[':chapter_text']		= chapter.text;
			statement.parameters[':chapter_comment']	= chapter.comment;
			statement.parameters[':creation_date']		= chapter.creationDate 		? chapter.creationDate : chapter.creationDate = new Date();
			statement.parameters[':last_modified_date']	= chapter.lastModifiedDate 	? chapter.lastModifiedDate : chapter.lastModifiedDate = new Date();
			statement.parameters[':chapter_position']	= chapter.position;
			statement.parameters[':version']			= chapter.version;
			statement.parameters[':published']			= 0;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 * Updates an existing chapter to the new state.
		 * 
		 * @param chapter The <code>ChapterVO</code> object representing the chapter to create
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateChapters(chapters:Array, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			// save chapters to proxy
			currentChapters = chapters;
			for each(var item:ChapterVO in chapters)
			{
				if(item)
					updateChapter(item, CourseAirConstants.UPDATE_CHAPTER_COMPLETE);
			}
			
			sendNotification(completionNotification);
		}
		
		/**
		 * Updates an existing chapter to the new state.
		 * 
		 * @param chapter The <code>ChapterVO</code> object representing the chapter to create
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateChapter(chapter:ChapterVO, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			// save chapter to proxy
			currentChapter = chapter;
			
			if(imageAdapterProxy)
				imageAdapterProxy.getImagesByTargetUuid(chapter.chapterUuid, CourseAirConstants.GET_IMAGES_BY_TARGET_UUID_COMPLETE);
			
			if(soundAdapterProxy)
				soundAdapterProxy.getSoundsByTargetUuid(chapter.chapterUuid, CourseAirConstants.GET_SOUNDS_BY_TARGET_UUID_COMPLETE);
			
			if(videoAdapterProxy)
				videoAdapterProxy.getVideoByTargetUuid(chapter.chapterUuid, CourseAirConstants.GET_VIDEO_LIST_BY_TARGET_UUID_COMPLETE);
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			if(imageAdapterProxy)
				imageAdapterProxy.updateImages(chapter.lessonUuid, chapter.version, chapter.chapterUuid, chapter.images);
			
			if(soundAdapterProxy)
				soundAdapterProxy.updateSounds(chapter.lessonUuid, chapter.version, chapter.chapterUuid, chapter.sounds);
			
			if(videoAdapterProxy)
				videoAdapterProxy.updateVideoList(chapter.lessonUuid, chapter.version, chapter.chapterUuid, chapter.videoList);
			
			updateChapterRecord(chapter);
			
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update chapter to match the <code>ChapterVO</code> object which represents
		 * the chapter's new state.
		 * 
		 * @param chapter The <code>ChapterVO</code> object representing the chapter to update
		 */
		private function updateChapterRecord(chapter:ChapterVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_CHAPTER_SQL_KEY);
			
			statement.parameters[':lesson_uuid']		= chapter.lessonUuid;
			statement.parameters[':uuid']				= chapter.chapterUuid;
			statement.parameters[':chapter_title']		= chapter.title;
			statement.parameters[':chapter_text']		= chapter.text;
			statement.parameters[':chapter_comment']	= chapter.comment;
			statement.parameters[':creation_date']		= chapter.creationDate;
			statement.parameters[':last_modified_date']	= new Date();
			statement.parameters[':chapter_position']	= chapter.position;
			statement.parameters[':version']			= chapter.version;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Given a existing chapter, remove the chapter from the lesson.
		 * 
		 * @param chapter 					The <code>ChapterVO</code> object representing the chapter
		 * @param completionNotification	Notification to send upon completion
		 */
		public function removeChapter(chapter:ChapterVO, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			currentChapter = chapter;
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			removeChapterRecord(chapter.chapterUuid, completionNotification);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction();
		}
		
		/**
		 * Remove a chapter record from the database
		 * 
		 * @param chapterUuid					UUID of the chapter to remove
		 * @param completionNotification	Notification to send upon completion
		 */
		private function removeChapterRecord(chapterUuid:String, completionNotification:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.REMOVE_CHAPTER_SQL_KEY);
			statement.parameters[':chapterUuid']		= chapterUuid;
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Get a max chapter position by the lesson's uuid. 
		 * 
		 * @param lessonUuid 					UUID of the parent lesson
		 * @param lessonVersion 				Version of the parent lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getMaxChapterPosition(lessonUuid:String, lessonVersion:uint, completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_MAX_CHAPTER_POSITION_SQL_KEY);
			statement.parameters[':lesson_uuid'] 	= lessonUuid;
			statement.parameters[':version'] 		= lessonVersion;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
		
	}
}