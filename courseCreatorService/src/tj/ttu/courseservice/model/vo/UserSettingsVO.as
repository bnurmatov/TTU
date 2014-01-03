////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.courseservice.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * UserSettingsVO class 
	 */
	public class UserSettingsVO extends EventDispatcher
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
		 * UserSettingsVO 
		 */
		public function UserSettingsVO()
		{
			super(null);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------
		//  userId
		//--------------------------------
		private var _userId:int;

		public function get userId():int
		{
			return _userId;
		}

		public function set userId(value:int):void
		{
			_userId = value;
		}

		//--------------------------------
		//  currentLessonUUID
		//--------------------------------
		private var _currentLessonUUID:String;
		
		[Bindable(event="currentLessonUUIDChange")]
		/**
		 * UUID of the last lesson used.
		 */
		public function get currentLessonUUID():String
		{
			return _currentLessonUUID;
		}
		
		/**
		 * @private
		 */
		public function set currentLessonUUID(value:String):void
		{
			if( _currentLessonUUID !== value)
			{
				_currentLessonUUID = value;
				dispatchEvent(new Event("currentLessonUUIDChange"));
			}
		}
		
		//--------------------------------
		//  createViewIndex
		//--------------------------------
		private var _createViewIndex:int = 0;
		
		[Bindable(event="createViewIndexChange")]
		/**
		 * Index representing the last 'create lesson' view that the user was working with.
		 */
		public function get createViewIndex():int
		{
			return _createViewIndex;
		}
		
		/**
		 * @private
		 */
		public function set createViewIndex(value:int):void
		{
			if( _createViewIndex !== value)
			{
				_createViewIndex = value;
				dispatchEvent(new Event("createViewIndexChange"));
			}
		}
		
		
		//--------------------------------
		//  locale
		//--------------------------------
		private var _locale:String;

		[Bindable(event="localeChange")]
		public function get locale():String
		{
			return _locale;
		}

		public function set locale(value:String):void
		{
			if( _locale !== value)
			{
				_locale = value;
				dispatchEvent(new Event("localeChange"));
			}
		}

		//--------------------------------
		//  hasLesson
		//--------------------------------
		private var _hasLesson:Boolean;
		
		[Bindable(event="hasLessonChange")]
		public function get hasLesson():Boolean
		{
			return _hasLesson;
		}
		
		public function set hasLesson(value:Boolean):void
		{
			if( _hasLesson !== value)
			{
				_hasLesson = value;
				dispatchEvent(new Event("hasLessonChange"));
			}
		}

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