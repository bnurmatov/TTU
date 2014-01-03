////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 19, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.model
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.controller.common.RegisterCommands;
	import tj.ttu.coursecreatorbase.controller.common.RemoveCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.UserSettingsVO;
	
	/**
	 * CourseProxy class 
	 */
	public class CourseProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CourseProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var lessonIndexChanged:Boolean = false;
		
		public var isMicrophoneConfigured:Boolean;
		
		public var unsavedPopupShown:Boolean;
		public var wasLessonRetrieved:Boolean = false;
		private var noteMap:Array;
		public var deletingLesson:LessonVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseProxy 
		 */
		public function CourseProxy()
		{
			super(NAME);
		}
		
				
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------------
		// userPrefs
		//----------------------------------------
		private var _userPrefs:UserSettingsVO;

		public function get userPrefs():UserSettingsVO
		{
			return _userPrefs;
		}

		public function set userPrefs(value:UserSettingsVO):void
		{
			if( _userPrefs !== value)
			{
				_userPrefs = value;
			}
		}
		//----------------------------------------
		// userPrefs
		//----------------------------------------
		private var _currentLocale:String;

		public function get currentLocale():String
		{
			return _currentLocale;
		}

		public function set currentLocale(value:String):void
		{
			if( _currentLocale !== value)
			{
				_currentLocale = value;
				if(_currentLocale && _userPrefs && _userPrefs.locale != _currentLocale)
				{
					_userPrefs.locale = _currentLocale;
					sendNotification(CourseServiceNotification.UPDATE_USER_SETTINGS, _userPrefs);
				}
			}
		}


		//----------------------------------------
		// currentMainViewState
		//----------------------------------------
		private var _currentMainViewState:String;

		public function get currentMainViewState():String
		{
			return _currentMainViewState;
		}

		public function set currentMainViewState(value:String):void
		{
			_currentMainViewState = value;
		}

		//----------------------------------------
		// currentCreateLessonState
		//----------------------------------------
		
		private var _currentCreateLessonState:String;
		
		public function get currentCreateLessonState():String
		{
			return _currentCreateLessonState;
		}
		
		public function set currentCreateLessonState(value:String):void
		{
			_currentCreateLessonState = value;
		}
		
		//----------------------------------------
		// currentViewIndex
		//----------------------------------------
		
		private var _currentStateIndex:int = 0; 
		
		public function get currentStateIndex():int
		{
			return _currentStateIndex;
		}
		
		public function set currentStateIndex(value:int):void
		{
			if(value != _currentStateIndex)
			{
				_currentStateIndex = value;
				if(_currentLesson && _currentLesson.viewIndex != value)
				{
					_currentLesson.viewIndex = value;
					updateUserPrefs();
					sendNotification(CourseServiceNotification.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX, _currentLesson);
				}
				sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED,_currentStateIndex);
			}
		}

		//----------------------------------------
		// currentViewIndex
		//----------------------------------------
		private var _createMaxActiveViewIndex:int = 0;
		
		public function get createMaxActiveViewIndex():int
		{
			return _createMaxActiveViewIndex;
		}
		
		public function set createMaxActiveViewIndex(value:int):void
		{
			value = Math.max(value, _createMaxActiveViewIndex);
			if(value != _createMaxActiveViewIndex)
			{
				_createMaxActiveViewIndex = value;
				if(_currentLesson && _currentLesson.createMaxActiveViewIndex != _createMaxActiveViewIndex)
				{
					_currentLesson.createMaxActiveViewIndex = _createMaxActiveViewIndex;
					sendNotification(CourseServiceNotification.UPDATE_LESSON_MAX_ACTIVE_VIEW_INDEX, _currentLesson);
				}
				sendNotification(CourseCreatorNotifications.CURRENT_STATE_INDEX_CHANGED, _createMaxActiveViewIndex);
			}
		}
		
		//--------------------------------------
		//  currentLesson
		//--------------------------------------
		private var _currentLesson:LessonVO;

		public function get currentLesson():LessonVO
		{
			return _currentLesson;
		}

		public function set currentLesson(value:LessonVO):void
		{
			if( _currentLesson !== value)
			{
				_currentLesson = value;
				if(_currentLesson)
					updateUserPrefs();
				lessonIndexChanged = true;
			}
		}
		//--------------------------------------
		//  chapters
		//--------------------------------------
		private var _chapters:IList;

		public function get chapters():IList
		{
			if(currentLesson && currentLesson.chapters && lessonIndexChanged)
			{
				_chapters = new ArrayCollection(currentLesson.chapters);
				lessonIndexChanged = false;
			}
			return _chapters;
		}

		//--------------------------------------
		//  currentChapter
		//--------------------------------------
		private var _currentChapter:ChapterVO;

		public function get currentChapter():ChapterVO
		{
			return _currentChapter;
		}

		public function set currentChapter(value:ChapterVO):void
		{
			_currentChapter = value;
		}


		//--------------------------------------
		//  currentChapterIndex
		//--------------------------------------
		private var _currentChapterIndex:int = -1;

		public function get currentChapterIndex():int
		{
			return _currentChapterIndex;
		}

		public function set currentChapterIndex(value:int):void
		{
			_currentChapterIndex = value;
		}

		
		//--------------------------------------
		//  departments
		//--------------------------------------
		private var _departments:IList;

		public function get departments():IList
		{
			return _departments;
		}

		public function set departments(value:IList):void
		{
			if( _departments !== value)
			{
				_departments = value;
			}
		}

		
		//-----------------------------------------
		// hasChange
		//-----------------------------------------
		private var _hasChange:Boolean;
		
		public function get hasChange():Boolean
		{
			return _hasChange;
		}
		
		public function set hasChange(value:Boolean):void
		{
			if(_hasChange != value)
			{
				_hasChange = value;
				sendNotification( CourseCreatorNotifications.HAS_CHANGE, _hasChange);
			}
		}
		
		//-----------------------------------------
		// hasQuestionsChange
		//-----------------------------------------
		private var _hasQuestionsChange:Boolean;

		public function get hasQuestionsChange():Boolean
		{
			return _hasQuestionsChange;
		}

		public function set hasQuestionsChange(value:Boolean):void
		{
			if( _hasQuestionsChange !== value)
			{
				_hasQuestionsChange = value;
				sendNotification(CourseCreatorNotifications.HAS_QUESTIONS_CHANGE, _hasQuestionsChange);
			}
		}

		//-------------------------------
		// shouldCheckOnValid
		//-------------------------------
		private var _shouldCheckOnValid:Boolean;
		
		public function get shouldCheckOnValid():Boolean
		{
			return _shouldCheckOnValid;
		}
		
		public function set shouldCheckOnValid(value:Boolean):void
		{
			if( _shouldCheckOnValid !== value)
			{
				_shouldCheckOnValid = value;
				sendNotification(CourseCreatorNotifications.SHOULD_CHECK_ON_VALID, _shouldCheckOnValid);
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
			noteMap = [];
			facade.registerCommand( CourseCreatorNotifications.REGISTER_COURSE_CREATOR_COMMANDS, RegisterCommands);
			facade.registerCommand( CourseCreatorNotifications.REMOVE_COURSE_CREATOR_COMMANDS, RemoveCommand);
			sendNotification( CourseCreatorNotifications.REGISTER_COURSE_CREATOR_COMMANDS );
		}
		
		override public function onRemove():void
		{
			sendNotification( CourseCreatorNotifications.REMOVE_COURSE_CREATOR_COMMANDS );
			facade.removeCommand( CourseCreatorNotifications.REGISTER_COURSE_CREATOR_COMMANDS);
			facade.removeCommand( CourseCreatorNotifications.REMOVE_COURSE_CREATOR_COMMANDS);
			cleanUp();
			noteMap = null;
			super.onRemove();
		}

		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function cleanUp():void
		{
			lessonIndexChanged = false;
			isMicrophoneConfigured = false;
			unsavedPopupShown = false;
			wasLessonRetrieved = false;
			_currentMainViewState = null;
			_currentCreateLessonState = null;
			_currentStateIndex = 0;
			resetCreateMaxActiveViewIndex();
			_currentLesson = null;
			deletingLesson = null;
			_chapters = null;
			_currentChapter = null;
			_currentChapterIndex = -1;
			hasChange = false;
			hasQuestionsChange = false;
			shouldCheckOnValid = false;
		}
		
		public function get hasNotification():Boolean
		{
			return noteMap && noteMap.length > 0;
		}
		
		public function sendQueueNotification():void
		{
			if(hasNotification)
			{
				var notification:INotification = noteMap.shift() as INotification;
				sendNotification(notification.getName(), notification.getBody(), notification.getType());
			}
		}
		
		public function addQueueNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			var notification:INotification = new Notification(notificationName, body, type);
			noteMap.push(notification);
		}
		/**
		 *  @public
		 */
		public function updateUserPrefs():void
		{
			if(_currentLesson && _userPrefs && (_currentLesson.viewIndex != _userPrefs.createViewIndex || _userPrefs.currentLessonUUID != _currentLesson.guid))
			{
				_userPrefs.createViewIndex = _currentStateIndex;
				_userPrefs.currentLessonUUID = _currentLesson.guid;
				sendNotification(CourseServiceNotification.UPDATE_USER_SETTINGS, _userPrefs);
			}
		}
		/**
		 *  @public
		 */
		public function resetUserPrefs():void
		{
			if(_userPrefs)
			{
				_userPrefs.createViewIndex = _currentStateIndex;
				_userPrefs.currentLessonUUID = null;
				sendNotification(CourseServiceNotification.UPDATE_USER_SETTINGS, _userPrefs);
			}
		}
		/**
		 *  @public
		 */
		
		public function updateChapter( chapter:ChapterVO ) : void
		{
			if( currentLesson && currentLesson.chapters && currentChapterIndex > -1 && 
				currentChapterIndex < chapters.length )
			{
				currentLesson.chapters[ currentChapterIndex ] = chapter;
				lessonIndexChanged = true;
			}
		}		
		
		public function updateChapters( chapters:Array ) : void
		{
			if( currentLesson  )
			{
				currentLesson.chapters = chapters;
				lessonIndexChanged = true;
			}
		}		
		
		
		public function addChapter( chapter:ChapterVO ) : void
		{
			if( currentLesson && currentLesson.chapters )
			{
				currentLesson.chapters.push( chapter );
				lessonIndexChanged = true;
			}
		}
		
		public function addChapterImage( image:ImageVO ) : void
		{
			if( currentChapter )
			{
				if(!currentChapter.images)
					currentChapter.images = new ArrayCollection();
				currentChapter.images.addItem(image);
			}
		}
		
		public function addChapterSound( sound:SoundVO ) : void
		{
			if( currentChapter )
			{
				if(!currentChapter.sounds)
					currentChapter.sounds = new ArrayCollection();
				currentChapter.sounds.addItem(sound);
			}
		}
		
		public function addChapterVideo( video:VideoVO ) : void
		{
			if( currentChapter )
			{
				if(!currentChapter.videoList)
					currentChapter.videoList = new ArrayCollection();
				currentChapter.videoList.addItem(video);
			}
		}
		
		public function removeChapter( chapter:ChapterVO ):void
		{
			if( currentLesson && currentLesson.chapters )
			{
				currentLesson.chapters.splice(currentLesson.chapters.indexOf( chapter ), 1 );
				lessonIndexChanged = true;
			}
		}
		
		public function getCurrentChapterIndexByChapter(chapter:ChapterVO):int
		{
			var i:int = 0;
			if(chapter)
			{
				for each( var item:ChapterVO in chapters)
				{
					if( item.chapterUuid == chapter.chapterUuid)
						return i;
					i++;
				}
			}
			return -1;
		}
		
		public function resetStateIndex():void
		{
			_currentStateIndex = 0;
		}
		
		
		public function setCurrentStateIndex(index:int):void
		{
			_currentStateIndex = index;
		}
		
		public function resetCreateMaxActiveViewIndex():void
		{
			_createMaxActiveViewIndex = 0;
		}
		
				
		public function setCreateMaxActiveViewIndex(index:int):void
		{
			_createMaxActiveViewIndex = index;
		}
		
	}
}