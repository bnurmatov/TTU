////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.create
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.events.StateChangeEvent;
	
	import spark.components.ButtonBarButton;
	import spark.components.TabBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.components.vo.TabBarItemVo;
	import tj.ttu.coursecreatorbase.states.CreateCourseStates;
	import tj.ttu.coursecreatorbase.view.components.chapter.EditChaptersView;
	import tj.ttu.coursecreatorbase.view.components.details.CourseDetailsView;
	import tj.ttu.coursecreatorbase.view.components.publish.PublishLessonView;
	import tj.ttu.coursecreatorbase.view.components.resource.EditResourcesView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	use namespace mx_internal;
	
	[SkinState("editInformation")]
	[SkinState("editChapters")]
	[SkinState("editResources")]
	[SkinState("publishLesson")]
	/**
	 * CreateCourse class 
	 */
	public class CreateCourse extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var navigationTabbar:TabBar;
		
		[SkinPart(required="false")]
		public var courseDetailsView:CourseDetailsView;
		
		[SkinPart(required="false")]
		public var editChaptersView:EditChaptersView;
		
		[SkinPart(required="false")]
		public var editResourcesView:EditResourcesView;
		
		[SkinPart(required="false")]
		public var publishLessonView:PublishLessonView;
		
		[SkinPart(required="true")]
		public var navigationTabbBarData:ArrayCollection;
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
		 * CreateCourse 
		 */
		public function CreateCourse()
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
		
		//-------------------------------
		// isCourseDetails
		//-------------------------------
		private var _isCourseDetails:Boolean;
		
		public function get isCourseDetails():Boolean
		{
			return _isCourseDetails;
		}
		
		public function set isCourseDetails(value:Boolean):void
		{
			if( _isCourseDetails !== value)
			{
				resetStates();
				_isCourseDetails = value;
				invalidateSkinState();
			}
		}
		
		//-------------------------------
		// isEditChapters
		//-------------------------------
		private var _isEditChapters:Boolean;
		
		public function get isEditChapters():Boolean
		{
			return _isEditChapters;
		}
		
		public function set isEditChapters(value:Boolean):void
		{
			if( _isEditChapters !== value)
			{
				resetStates();
				_isEditChapters = value;
				invalidateSkinState();
			}
		}
		
		//-------------------------------
		// isEditResources
		//-------------------------------
		private var _isEditResources:Boolean;
		
		public function get isEditResources():Boolean
		{
			return _isEditResources;
		}
		
		public function set isEditResources(value:Boolean):void
		{
			if( _isEditResources !== value)
			{
				resetStates();
				_isEditResources = value;
				invalidateSkinState();
			}
		}
		
		//-------------------------------
		// isPublishLesson
		//-------------------------------
		private var _isPublishLesson:Boolean;

		public function get isPublishLesson():Boolean
		{
			return _isPublishLesson;
		}

		public function set isPublishLesson(value:Boolean):void
		{
			if( _isPublishLesson !== value)
			{
				resetStates();
				_isPublishLesson = value;
				invalidateSkinState();
			}
		}

		//-------------------------------
		// currentViewIndex
		//-------------------------------
		private var currentViewIndexChanged:Boolean;
		private var _currentViewIndex:int;
		
		public function get currentViewIndex():int
		{
			return _currentViewIndex;
		}
		
		public function set currentViewIndex(value:int):void
		{
			if( _currentViewIndex !== value)
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
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(navigationTabbar && currentViewIndexChanged)
			{
				if(navigationTabbar.selectedIndex !== _currentViewIndex)
					navigationTabbar.setSelectedIndex(_currentViewIndex, true);
				currentViewIndexChanged = false;
			}
			if(navigationTabbar && oldViewIndexChanged)
			{
				if(navigationTabbar.selectedIndex !== oldViewIndex)
				{
					navigationTabbar.setSelectedIndex(_oldViewIndex, false);
					_currentViewIndex = _oldViewIndex;
				}
				oldViewIndexChanged = false;
				callLater(dispatchShowUnsavedPopupEvent);
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == navigationTabbar)
				navigationTabbar.addEventListener(IndexChangeEvent.CHANGE, onTabBarIndexChange);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == navigationTabbar)
				navigationTabbar.removeEventListener(IndexChangeEvent.CHANGE, onTabBarIndexChange);
			super.partRemoved(partName, instance);
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
		
		
		override protected function getCurrentSkinState():String
		{
			if(isEditChapters)
				return CreateCourseStates.EDIT_CHAPTERS;
			else if(isEditResources)
				return CreateCourseStates.EDIT_RESOURCES;
			else if(isPublishLesson)
				return CreateCourseStates.PUBLISH_LESSON;
			else
				return CreateCourseStates.COURSE_DETAILS;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function resetComponent():void
		{
			hasChange = false;
			shouldCheckOnValid = false;
			resetIndexes();
		}
		/**
		 *  @public
		 */
		public function continueAction():void
		{
			if(pendingIndex != -1)
			{
				shouldCheckOnValid = false;
				currentViewIndex = pendingIndex;
				_oldViewIndex = -1;
				pendingIndex = -1;
			}
		}
		
		public function resetIndexes():void
		{
			_oldViewIndex = -1;
			pendingIndex = -1;
		}
		
		/**
		 *  @private
		 */
		private function resetStates():void
		{
			_isCourseDetails = false;
			_isEditChapters  = false;
			_isEditResources  = false;
			_isPublishLesson  = false;
			
		}
		
		private function dispatchShowUnsavedPopupEvent():void
		{
			dispatchEvent(new CourseEvent(CourseEvent.SHOW_UNSAVED_POPUP));
		}
		
		public function enableTabbarItem(index:int):void
		{
			if(!navigationTabbBarData || index >= navigationTabbBarData.length )
				return;
			
			for (var i:int = 0; i < navigationTabbBarData.length; i++) 
			{
				var item:TabBarItemVo = navigationTabbBarData.getItemAt(i) as TabBarItemVo;
				if(item)
					item.enabled = (i <= index);
/*				var bbb:ButtonBarButton = navigationTabbar.dataGroup.getElementAt(i) as ButtonBarButton;
				if(bbb)
					bbb.enabled = (i <= index);*/
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onStateChange(event:StateChangeEvent):void
		{
			var evt:StateChangeEvent = new StateChangeEvent(event.type, false, false, event.oldState, event.newState);
			dispatchEvent( evt );
		}
		
		/**
		 *  @protected
		 */
		protected function onTabBarIndexChange(event:IndexChangeEvent):void
		{
			_oldViewIndex = -1;
			if(hasChange || hasQuestionsChange || shouldCheckOnValid)
			{
				pendingIndex = event.newIndex;
				oldViewIndex = event.oldIndex;
			}
			else
			{
				currentViewIndex = event.newIndex;
				switch(event.newIndex)
				{
					case 0:
					{
						isCourseDetails = true;
						break;
					}
					case 1:
					{
						isEditChapters = true;
						break;
					}
					case 2:
					{
						isEditResources = true;
						break;
					}
					case 3:
					{
						isPublishLesson = true;
						break;
					}
				}
			}
		}
		
		
		
	}
}