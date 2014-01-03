////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.DataGrid;
	import spark.components.GridColumnHeaderGroup;
	import spark.components.gridClasses.GridColumn;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.DepartmentVO;
	import tj.ttu.components.components.category.DepartmentItemView;
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.components.events.DataGridEvent;
	import tj.ttu.components.events.LessonEvent;
	import tj.ttu.coursecreatorbase.states.CourseViewStates;
	
	[SkinState("departments")]
	[SkinState("lessons")]
	/**
	 * CourseView class 
	 */
	public class CourseView extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var departmentItemView:DepartmentItemView;
		
		[SkinPart(required="false")]
		public var departmentsGrid:DataGrid;
		
		[SkinPart(required="false")]
		public var lessonsGrid:DataGrid;
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
		private var gridHeaderCheckbox:CheckBox;
		
		private var operationEvent:DataGridEvent;
		private var confirmPopup:ConfirmationPopup;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseView 
		 */
		public function CourseView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------
		//  enabledHeaderCheckbox
		//--------------------------------------
		private var _enabledHeaderCheckbox:Boolean = false;
		
		private function set enabledHeaderCheckbox(value:Boolean):void
		{
			if(_enabledHeaderCheckbox !== value)
			{
				_enabledHeaderCheckbox = value;
				if(gridHeaderCheckbox)
					gridHeaderCheckbox.enabled = value;
			}
		}
		//--------------------------------------
		//  departments
		//--------------------------------------
		private var departmentsChanged:Boolean = false;
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
				departmentsChanged = true;
				invalidateProperties();
			}
		}
		//--------------------------------------
		//  currentDepartment
		//--------------------------------------
		private var currentDepartmentChanged:Boolean = false;
		private var _currentDepartment:DepartmentVO;
		
		public function get currentDepartment():DepartmentVO
		{
			return _currentDepartment;
		}
		
		public function set currentDepartment(value:DepartmentVO):void
		{
			if( _currentDepartment !== value)
			{
				_currentDepartment = value;
				if(_currentDepartment)
					dispatchEvent(new LessonEvent(LessonEvent.GET_LESSONS, _currentDepartment));
				currentDepartmentChanged = true;
				invalidateProperties();
			}
		}
		//--------------------------------------
		//  lessons
		//--------------------------------------
		private var lessonsChanged:Boolean = false;
		private var _lessons:IList;
		
		public function get lessons():IList
		{
			return _lessons;
		}
		
		public function set lessons(value:IList):void
		{
			_lessons = value;
			lessonsChanged = true;
			invalidateProperties();
		}
		//--------------------------------------
		//  isDepartment
		//--------------------------------------
		private var _isDepartment:Boolean;
		
		public function get isDepartment():Boolean
		{
			return _isDepartment;
		}
		
		public function set isDepartment(value:Boolean):void
		{
			if( _isDepartment !== value)
			{
				resetSatates();
				_isDepartment = value;
				invalidateSkinState();
				validateNow();
			}
		}
		//--------------------------------------
		//  isLesson
		//--------------------------------------
		private var _isLesson:Boolean = false;
		
		public function get isLesson():Boolean
		{
			return _isLesson;
		}
		
		public function set isLesson(value:Boolean):void
		{
			if( _isLesson !== value)
			{
				resetSatates();
				_isLesson = value;
				invalidateSkinState();
			}
		}
		
		//--------------------------------------
		//  locale
		//--------------------------------------
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
				departmentLabelField = getDepartmentLabelFieldByLocale(value);
				dispatchEvent(new Event("localeChange"));
			}
		}
		//--------------------------------------
		//  departmentLabelField
		//--------------------------------------
		private var _departmentLabelField:String;

		[Bindable(event="departmentLabelFieldChange")]
		public function get departmentLabelField():String
		{
			return _departmentLabelField;
		}

		public function set departmentLabelField(value:String):void
		{
			if( _departmentLabelField !== value)
			{
				_departmentLabelField = value;
				dispatchEvent(new Event("departmentLabelFieldChange"));
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
			if(departmentsChanged && departmentsGrid)
			{
				departmentsGrid.dataProvider = _departments;
				if(_departments)
					departmentsGrid.ensureCellIsVisible(0, 0);
				departmentsGrid.validateNow();
				departmentsChanged = false;
			}
			if(lessonsChanged && lessonsGrid)
			{
				lessonsGrid.dataProvider = _lessons;
				if(_lessons)
					lessonsGrid.ensureCellIsVisible(0, 0);
				lessonsGrid.validateNow();
				lessonsChanged = false;
			}
			if(currentDepartmentChanged && departmentItemView)
			{
				departmentItemView.currentDepartment = _currentDepartment;
				currentDepartmentChanged = false;
			}
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if( instance == departmentsGrid )
			{
				departmentsGrid.addEventListener(DataGridEvent.GRID_DOUBLE_CLICK, gridDoubleClickHandler);
				departmentsGrid.addEventListener(LessonEvent.GET_LESSONS, getLessonsHandler);
				invalidateProperties();
			}
			
			if( instance == lessonsGrid )
			{
				lessonsGrid.addEventListener( DataGridEvent.ITEM_EDIT, lessonEditHandler );
				lessonsGrid.addEventListener( DataGridEvent.ITEM_CLONE, lessonCloneHandler );
				lessonsGrid.addEventListener( DataGridEvent.ITEM_DELETE, lessonDeleteHandler );
				lessonsGrid.addEventListener( DataGridEvent.CHECK_CHANGED, lessonCheckChangedHandler );
				lessonsGrid.addEventListener( DataGridEvent.CHECK_ALL, checkAndUncheckHandler );
				lessonsGrid.addEventListener( DataGridEvent.UNCHECK_ALL, checkAndUncheckHandler );
				lessonsGrid.addEventListener( DataGridEvent.HEADER_CHECKBOX, headerCheckboxHandler );
				lessonsGrid.addEventListener(DataGridEvent.GRID_DOUBLE_CLICK, gridDoubleClickHandler);
				invalidateProperties();
			}
			if( instance == departmentItemView )
			{
				departmentItemView.addEventListener( MouseEvent.CLICK, switchCategoryModeHandler );
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == departmentsGrid )
			{
				departmentsGrid.removeEventListener(DataGridEvent.GRID_DOUBLE_CLICK, gridDoubleClickHandler);
				departmentsGrid.removeEventListener(LessonEvent.GET_LESSONS, getLessonsHandler);
			}
			
			if( instance == lessonsGrid )
			{
				lessonsGrid.removeEventListener( DataGridEvent.ITEM_EDIT, lessonEditHandler );
				lessonsGrid.removeEventListener( DataGridEvent.ITEM_CLONE, lessonCloneHandler );
				lessonsGrid.removeEventListener( DataGridEvent.ITEM_DELETE, lessonDeleteHandler );
				lessonsGrid.removeEventListener( DataGridEvent.CHECK_CHANGED, lessonCheckChangedHandler );
				lessonsGrid.removeEventListener( DataGridEvent.CHECK_ALL, checkAndUncheckHandler );
				lessonsGrid.removeEventListener( DataGridEvent.UNCHECK_ALL, checkAndUncheckHandler );
				lessonsGrid.removeEventListener( DataGridEvent.HEADER_CHECKBOX, headerCheckboxHandler );
				lessonsGrid.removeEventListener(DataGridEvent.GRID_DOUBLE_CLICK, gridDoubleClickHandler);
			}
			if( instance == departmentItemView )
			{
				departmentItemView.removeEventListener( MouseEvent.CLICK, switchCategoryModeHandler );
			}
			super.partRemoved(partName, instance);
		}
		
		
		override protected function getCurrentSkinState():String
		{
			if(_isLesson)
				return CourseViewStates.LESSONS;
			return CourseViewStates.DEPARTMENTS
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		private function getDepartmentLabelFieldByLocale(locale:String):String
		{
			if(locale == "tg_TJ")
				return  "departmentTjName";
			else if(locale == "en_US")
				return  "departmentEnName";
			return "departmentRuName";
		}
		/**
		 *  @private
		 */
		
		private function resetSatates():void
		{
			_isDepartment = false;
			_isLesson = false;
		}
		
		public function resetGridsProperty():void
		{
			var columnHeaderGroup:GridColumnHeaderGroup;
			if(lessonsGrid)
			{
				var columns:Array = lessonsGrid.columns.toArray();
				
				GridColumn(columns[2]).width = Math.max(lessonsGrid.grid.width - 345, 370);
				GridColumn(columns[3]).width = GridColumn(columns[3]).minWidth;
				GridColumn(columns[4]).width = GridColumn(columns[4]).minWidth;
				columnHeaderGroup = lessonsGrid.columnHeaderGroup;
				columnHeaderGroup.visibleSortIndicatorIndices = null;
				lessonsGrid.validateNow();
			}
		}
		
		public function resetSortIndicator():void
		{
			var columnHeaderGroup:GridColumnHeaderGroup;
			if(lessonsGrid)
			{
				columnHeaderGroup = lessonsGrid.columnHeaderGroup;
				columnHeaderGroup.visibleSortIndicatorIndices = null;
				lessonsGrid.validateNow();
			}
			if(departmentsGrid)
			{
				columnHeaderGroup = departmentsGrid.columnHeaderGroup;
				columnHeaderGroup.visibleSortIndicatorIndices = null;
				departmentsGrid.validateNow();
			}
		}
		
		public function showConfirmationPopup(title:String, message:String):void
		{
			confirmPopup = ConfirmationPopup.show(title, message, true );
			confirmPopup.addEventListener(ConfirmationPopup.YES, onConfirm);
			confirmPopup.addEventListener(ConfirmationPopup.NO, onConfirm);
			confirmPopup.addEventListener(Event.CLOSE, onConfirm);
		}
		
		public function applyCloneLesson(lesson:LessonVO):void
		{
			if(!lesson || !lessons) return;
			_lessons.addItem(lesson);
			lessons = _lessons;
		}
		
		
		public function showDepartments():void
		{
			resetGridsProperty();
			resetSortIndicator();
			isDepartment = true;
			if(_departments)
				departments = _departments;
			else
				dispatchEvent(new LessonEvent(LessonEvent.GET_DEPARTMENTS));
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		protected function onConfirm(event:Event):void
		{
			if(event.type == ConfirmationPopup.YES)
			{
				dispatchEvent( operationEvent.clone() );
			}
			
			confirmPopup = null;
			operationEvent = null;
		}
		
		/**
		 *  @protected
		 */
		
		protected function lessonDeleteHandler(event:DataGridEvent):void
		{
			operationEvent = event;
			var title:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'deleteItemTitle') || 'Delete item';
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'deleteItemConfirmationMessage') || 'Are you sure you want to delete item?';
			showConfirmationPopup(title, message);
		}
		
		protected function lessonCloneHandler(event:DataGridEvent):void
		{
			operationEvent = event;
			var title:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'cloneItemTitle') || 'Clone item';
			var message:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'cloneItemConfirmationMessage') || 'Are you sure you want to clone item?';
			showConfirmationPopup(title, message);
		}
		
		protected function lessonEditHandler(event:DataGridEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 *  @private
		 */
		private function gridDoubleClickHandler(event:DataGridEvent):void
		{
			if(event.item is LessonVO)
			{
				/*if(isAir && ((event.item as ListVO).notLoaded || (event.item as ListVO).trashed))
				return;
				currentListVo = event.item as ListVO;*/
			}
			else if(event.item is DepartmentVO)
			{
				isLesson = true;
				currentDepartment = event.item as DepartmentVO;
			}
		}
		
		private function lessonCheckChangedHandler(event:Event):void
		{
			var allChecked:Boolean = true;
			var lessonSelected:Boolean = false;
			var lesson:LessonVO;
			
			// step through collection of items, checking if all are selected
			for each(lesson in _lessons)
			{
				if(!lesson)
					continue;
				if(lesson.selected && !lessonSelected)
					lessonSelected = true;
				// if not checked, set flag to false
				if(!lesson.selected && allChecked)
					allChecked = false;
			}
			
			//	enabledElement = lessonSelected;
			
			// update header
			gridHeaderCheckbox.selected = allChecked;
		}
		
		private function checkAndUncheckHandler( event:DataGridEvent ) : void
		{
			var selectedAll:Boolean = event.type == DataGridEvent.CHECK_ALL;
			//enabledElement = selectedAll;
			
			for each(var lesson:LessonVO in _lessons) 
			{
				if(!lesson)
					continue;
				lesson.selected = selectedAll;
			}
		}
		
		private function headerCheckboxHandler( event:DataGridEvent ) : void
		{
			if(event.target.hasOwnProperty("checkBox"))
			{
				gridHeaderCheckbox = event.target.checkBox as CheckBox;
				gridHeaderCheckbox.enabled = _enabledHeaderCheckbox;
			}
		}
		
		private function switchCategoryModeHandler(event:MouseEvent) : void
		{
			showDepartments();
		}
		
		private function getLessonsHandler(event:LessonEvent) : void
		{
			isLesson = true;
			currentDepartment = event.data as DepartmentVO;
		}
	}
}