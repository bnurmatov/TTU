////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 30, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components
{
	import flash.events.Event;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
	import spark.components.ButtonBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.components.components.buttonbar.ButtonBarButtonExt;
	import tj.ttu.coursecreatorbase.states.CourseBaseState;
	import tj.ttu.coursecreatorbase.view.components.create.CreateCourse;
	import tj.ttu.coursecreatorbase.view.components.view.CourseView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.modulePlayer.view.components.LessonHolder;
	
	use namespace mx_internal;
	
	
	[SkinState("normal")]
	[SkinState("disabled")]
	[SkinState("createLesson")]
	[SkinState("lessonList")]
	[SkinState("lessonPlayer")]
	/**
	 * CourseBase class 
	 */
	public class CourseBase extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var tabBarViews:ButtonBar;
		
		[SkinPart(required="false")]
		public var createCourseView:CreateCourse;
		
		[SkinPart(required="false")]
		public var courseView:CourseView;
		
		[SkinPart(required="false")]
		public var lessonHolder:LessonHolder;
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
		private var pendingIndex:int = -1;
		public var shouldCheckOnValid:Boolean = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseBase 
		 */
		public function CourseBase()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//-----------------------------------
		// hasChange
		//-----------------------------------
		private var _hasChange:Boolean;
		
		public function get hasChange():Boolean
		{
			return _hasChange;
		}
		
		public function set hasChange(value:Boolean):void
		{
			_hasChange = value;
		}
		
		//-----------------------------------
		// hasQuestionsChange
		//-----------------------------------
		private var _hasQuestionsChange:Boolean;
		
		public function get hasQuestionsChange():Boolean
		{
			return _hasQuestionsChange;
		}
		
		public function set hasQuestionsChange(value:Boolean):void
		{
			_hasQuestionsChange = value;
		}
		
		
		//-----------------------------------
		// isCourseView
		//-----------------------------------
		private var _isCourseView:Boolean = false;
		
		
		public function get isCourseView():Boolean
		{
			return _isCourseView;
		}
		
		public function set isCourseView(value:Boolean):void
		{
			if( _isCourseView !== value)
			{
				_isCourseView = value;
				invalidateSkinState();
				validateNow();
			}
		}
		
		//-----------------------------------
		// isCreateCourse
		//-----------------------------------
		private var _isCreateCourse:Boolean = true;
		
		public function get isCreateCourse():Boolean
		{
			return _isCreateCourse;
		}
		
		public function set isCreateCourse(value:Boolean):void
		{
			if( _isCreateCourse !== value)
			{
				resetStates();
				_isCreateCourse = value;
				invalidateSkinState();
			}
		}
		
		//-----------------------------------
		// isLessonPlayer
		//-----------------------------------
		private var _isLessonPlayer:Boolean;
		
		public function get isLessonPlayer():Boolean
		{
			return _isLessonPlayer;
		}
		
		public function set isLessonPlayer(value:Boolean):void
		{
			if( _isLessonPlayer !== value)
			{
				resetStates();
				_isLessonPlayer = value;
				invalidateSkinState();
			}
		}
		
		//--------------------------------------
		//  currentViewIndex
		//--------------------------------------
		private var currentViewIndexChanged:Boolean;
		private var _currentViewIndex:int = -1;
		
		/**
		 *  Stes selected index of tabbar adn chaes state 
		 */
		public function get currentViewIndex():int
		{
			return _currentViewIndex;
		}
		
		/**
		 * @private
		 */
		public function set currentViewIndex(value:int):void
		{
			if(_currentViewIndex !== value)
			{
				_currentViewIndex = value;
				currentViewIndexChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  oldViewIndex
		//--------------------------------------
		private var oldViewIndexChanged:Boolean = false;
		private var _oldViewIndex:int = -1;
		
		public function get oldViewIndex():int
		{
			return _oldViewIndex;
		}
		
		public function set oldViewIndex(value:int):void
		{
			if( _oldViewIndex !== value)
			{
				_oldViewIndex = value;
				oldViewIndexChanged = true;
				invalidateProperties();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == tabBarViews)
			{
				tabBarViews.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
				tabBarViews.addEventListener(IndexChangeEvent.CHANGE, onTabChange);
			}
			if(instance == courseView)
			{
			}
			if(instance == createCourseView)
			{
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == tabBarViews)
			{
				tabBarViews.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
				tabBarViews.removeEventListener(IndexChangeEvent.CHANGE, onTabChange);
			}
			if(instance == courseView)
			{
			}
			if(instance == createCourseView)
			{
			}
			super.partRemoved(partName, instance);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(tabBarViews &&  currentViewIndexChanged)
			{
				if(tabBarViews.selectedIndex !== currentViewIndex)
					tabBarViews.setSelectedIndex(currentViewIndex, true);
				currentViewIndexChanged = false;
			}
			if(tabBarViews && oldViewIndexChanged)
			{
				if(tabBarViews.selectedIndex !== _oldViewIndex)
				{
					tabBarViews.setSelectedIndex(_oldViewIndex, false);
					_currentViewIndex = _oldViewIndex;
				}
				oldViewIndexChanged = false;
				callLater(dispatchUnsavedPopupEvent);
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if(isCourseView)
				return CourseBaseState.COURSE_LIST;
			if(isLessonPlayer)
				return CourseBaseState.LESSON_PLAYER;
			return CourseBaseState.CREATE_COURSE;
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			if(skin)
				skin.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
		}
		
		override protected function detachSkin():void
		{
			if(skin)
				skin.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
			super.detachSkin();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		public function continueAction():void
		{
			if(pendingIndex != -1)
			{
				shouldCheckOnValid = false;
				if(pendingIndex == 2)
				{
					currentViewIndex = pendingIndex;
					pendingIndex = -1;
					dispatchEvent(new CourseEvent(CourseEvent.SHOW_CREATE_LESSON_WINDOW));
				}
				else
				{
					currentViewIndex = pendingIndex;
					pendingIndex = -1;
					isCourseView = currentViewIndex == 1;
				}
			}
		}
		
		public function enableTabbarItem(index:int, enable:Boolean = true):void
		{
			if(!tabBarViews || index >= tabBarViews.dataProvider.length )
				return;
			
			var bbb:ButtonBarButtonExt = tabBarViews.dataGroup.getElementAt(index) as ButtonBarButtonExt;
			if(bbb)
				bbb.enabled = enable;
		}
		
		public function resetIndexes():void
		{
			pendingIndex = -1;
		}
		/**
		 *  @private
		 */
		private function dispatchUnsavedPopupEvent():void
		{
			dispatchEvent(new CourseEvent(CourseEvent.SHOW_UNSAVED_POPUP));
		}
		
		private function resetStates():void
		{
			_isCreateCourse = false;
			_isCourseView = false;
			_isLessonPlayer = false;
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onTabChange(event:IndexChangeEvent):void
		{
			_oldViewIndex = -1;
			if(event.newIndex == 2)
			{
				currentViewIndex = event.newIndex;
				dispatchEvent(new CourseEvent(CourseEvent.SHOW_CREATE_LESSON_WINDOW));
			}
			else if(hasChange || hasQuestionsChange || shouldCheckOnValid)
			{
				pendingIndex = event.newIndex;
				oldViewIndex = event.oldIndex;
			}
			else
			{
				currentViewIndex = event.newIndex;
				isCourseView = event.newIndex == 1;
			}
		}
		
		/**
		 *  @private
		 */
		
		protected function onStateChange(event:StateChangeEvent):void
		{
			var evt:StateChangeEvent = new StateChangeEvent(event.type, false, false, event.oldState,event.newState);
			dispatchEvent(evt);
		}
		
		/**
		 *  @private
		 */
		protected function onUpdateComplete(event:FlexEvent):void
		{
			tabBarViews.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
			tabBarViews.setSelectedIndex(0, true );
		}
		
	}
}