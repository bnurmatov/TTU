////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.popup
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.VerticalAlign;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.CloseEvent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.DepartmentVO;
	import tj.ttu.base.vo.SpecialityVO;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.coursecreatorbase.view.skins.popup.CreateCoursePopupSkin;
	import tj.ttu.coursecreatorbase.view.skins.popup.ReuseCoursePopupSkin;
	
	[Event(name="returnToMyCourses", type="tj.ttu.coursecreatorbase.view.events.CourseEvent")]
	[Event(name="createCourse", type="tj.ttu.coursecreatorbase.view.events.CourseEvent")]
	/**
	 * CourseManagePopup class 
	 */
	public class CourseManagePopup extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var courseTitle:TextArea;
		
		[SkinPart(required="true")]
		public var departmentList:DropDownList;
		
		[SkinPart(required="true")]
		public var specialtyList:DropDownList;
		
		[SkinPart(required="true")]
		public var disciplineTitle:TextArea;
		
		[SkinPart(required="false")]
		public var createLessonButton:Button;
		
		[SkinPart(required="false")]
		public var saveLessonButton:Button;
		
		[SkinPart(required="false")]
		public var reuseLessonButton:Button;
		
		[SkinPart(required="false")]
		public var cancelButton:Button;
		
		[SkinPart(required="false")]
		public var closeButton:Button;
		
		[SkinPart(required="false")]
		public var returnToLessonsButton:Button;
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
		private var latinFont:String;
		private var latinDirection:String; 
		private var cyrillicDirection:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseManagePopup 
		 */
		public function CourseManagePopup()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// cyrillicFont
		//-----------------------------------------
		private var _cyrillicFont:String = "Cyrillic";
		
		public function get cyrillicFont():String
		{
			return _cyrillicFont;
		}
		
		public function set cyrillicFont(value:String):void
		{
			if(_cyrillicFont !== value)
			{
				_cyrillicFont = value;
				disciplineChanged = true;
				titleChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// lesson
		//-----------------------------------------
		private var _lesson:LessonVO;
		
		[Bindable(event="lessonChange")]
		public function get lesson():LessonVO
		{
			return _lesson;
		}
		
		public function set lesson(value:LessonVO):void
		{
			if( _lesson !== value)
			{
				_lesson = value;
				dispatchEvent(new Event("lessonChange"));
				title = _lesson ? _lesson.name : null;
				departmentId = _lesson ? _lesson.departmentId : null;
				departmentName = _lesson ? _lesson.departmentName : null;
				specialityId = _lesson ? _lesson.specialityId : null;
				specialityName = _lesson ? _lesson.specialityName : null;
				discipline = _lesson ? _lesson.discipline : null;
			}
		}
		
		
		//-----------------------------------------
		// locale
		//-----------------------------------------
		private var _locale:String;

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
				specialityLabelField = getSpecialityLabelFieldByLocale(value);
			}
		}
		
		//-----------------------------------------
		// departments
		//-----------------------------------------
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
				_departments = sortDepartments(value);
				departmentsChanged = true;
				invalidateProperties();
			}
		}
		//-----------------------------------------
		// departmentLabelField
		//-----------------------------------------
		private var _departmentLabelField:String = "departmentRuName";

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

		//-----------------------------------------
		// department
		//-----------------------------------------
		private var departmentName:String;
		private var _departmentId:int;
		
		public function get departmentId():int
		{
			return _departmentId;
		}
		
		public function set departmentId(value:int):void
		{
			if( _departmentId !== value)
			{
				_departmentId = value;
			}
		}
		
		//-----------------------------------------
		// specialities
		//-----------------------------------------
		private var specialitiesChanged:Boolean = false;
		private var _specialities:IList;
		
		public function get specialities():IList
		{
			return _specialities;
		}
		
		public function set specialities(value:IList):void
		{
			if( _specialities !== value)
			{
				_specialities = sortSpecialities(value);
				specialitiesChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// specialityLabelField
		//-----------------------------------------
		private var _specialityLabelField:String = "specialityRuName";

		[Bindable(event="specialityLabelFieldChange")]
		public function get specialityLabelField():String
		{
			return _specialityLabelField;
		}

		public function set specialityLabelField(value:String):void
		{
			if( _specialityLabelField !== value)
			{
				_specialityLabelField = value;
				dispatchEvent(new Event("specialityLabelFieldChange"));
			}
		}

		//-----------------------------------------
		// speciality
		//-----------------------------------------
		private var specialityName:String;
		private var _specialityId:int;
		
		public function get specialityId():int
		{
			return _specialityId;
		}
		
		public function set specialityId(value:int):void
		{
			if( _specialityId !== value)
			{
				_specialityId = value;
			}
		}
		
		//-----------------------------------------
		// createEnabled
		//-----------------------------------------
		private var _createEnable:Boolean = false;
		
		[Bindable(event="createEnabledChange")]
		public function get createEnable():Boolean
		{
			return _createEnable;
		}
		
		public function set createEnable(value:Boolean):void
		{
			if( _createEnable !== value)
			{
				_createEnable = value;
				dispatchEvent(new Event("createEnabledChange"));
			}
		}
		//-----------------------------------------
		// closeEnable
		//-----------------------------------------
		private var _closeEnable:Boolean = true;
		
		[Bindable(event="closeEnableChange")]
		public function get closeEnable():Boolean
		{
			return _closeEnable;
		}
		
		public function set closeEnable(value:Boolean):void
		{
			if( _closeEnable !== value)
			{
				_closeEnable = value;
				dispatchEvent(new Event("closeEnableChange"));
			}
		}
		
		//-----------------------------------------
		// title
		//-----------------------------------------
		private var titleChanged:Boolean = false;
		private var _title:String;
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if( _title !== value)
			{
				_title = value;
				titleChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// discipline
		//-----------------------------------------
		private var disciplineChanged:Boolean = false;
		private var _discipline:String;
		
		public function get discipline():String
		{
			return _discipline;
		}
		
		public function set discipline(value:String):void
		{
			if( _discipline !== value)
			{
				_discipline = value;
				disciplineChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// isCreateLesson
		//-----------------------------------------
		private var _isCreateLesson:Boolean;
		
		[Bindable(event="isCreateLessonChange")]
		public function get isCreateLesson():Boolean
		{
			return _isCreateLesson;
		}
		
		public function set isCreateLesson(value:Boolean):void
		{
			if( _isCreateLesson !== value)
			{
				_isCreateLesson = value;
				dispatchEvent(new Event("isCreateLessonChange"));
			}
		}
		
		//-----------------------------------------
		// isReuseContent
		//-----------------------------------------
		private var _isReuseContent:Boolean;

		public function get isReuseContent():Boolean
		{
			return _isReuseContent;
		}

		public function set isReuseContent(value:Boolean):void
		{
			if( _isReuseContent !== value)
			{
				_isReuseContent = value;
			}
		}

		//-----------------------------------------
		// duplicateNameVisible
		//-----------------------------------------
		private var _duplicateNameVisible:Boolean = false;

		[Bindable(event="duplicateNameVisibleChange")]
		public function get duplicateNameVisible():Boolean
		{
			return _duplicateNameVisible;
		}

		public function set duplicateNameVisible(value:Boolean):void
		{
			if( _duplicateNameVisible !== value)
			{
				_duplicateNameVisible = value;
				dispatchEvent(new Event("duplicateNameVisibleChange"));
			}
		}
		//-----------------------------------------
		// textColor
		//-----------------------------------------
		private var textColorChange:Boolean = false;
		private var _textColor:uint = 0x2e424c;
		
		public function get textColor():uint
		{
			return _textColor;
		}
		
		public function set textColor(value:uint):void
		{
			if( _textColor !== value)
			{
				_textColor = value;
				textColorChange = true;
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
			if(departmentsChanged && departmentList)
			{
				departmentList.dataProvider = _departments;
				if(departmentId)
					departmentList.selectedItem = getCurrentDepartment( departmentId );
				departmentsChanged = false;
			}
			if(specialitiesChanged && specialtyList )
			{
				specialtyList.dataProvider = _specialities;
				if(specialityId)
					specialtyList.selectedItem = getCurrentSpeciality(specialityId);
				specialitiesChanged = false;
			}
			if(titleChanged && courseTitle)
			{
				courseTitle.textFlow = _title ? TLFUtil.createFlow(_title, latinFont, cyrillicFont) : null;
				titleChanged = false;
			}
			if(disciplineChanged && disciplineTitle)
			{
				disciplineTitle.textFlow = _discipline ? TLFUtil.createFlow(_discipline, latinFont, cyrillicFont) : null;
				disciplineChanged = false;
			}
			if( textColorChange && courseTitle && courseTitle.textFlow)
			{
				courseTitle.textFlow.format = getFormat(_textColor);
				courseTitle.textFlow.invalidateAllFormats();
				textColorChange = false;
			}
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == courseTitle)
			{
				courseTitle.addEventListener(TextOperationEvent.CHANGE, onTitleChange);
				textColorChange = true;
			}
			if(instance == departmentList)
			{
				departmentList.addEventListener(IndexChangeEvent.CHANGE, onDepartmentChange);
			}
			if(instance == specialtyList)
			{
				specialtyList.addEventListener(IndexChangeEvent.CHANGE, onSpacialityChange);
			}
			if(instance == disciplineTitle)
			{
				disciplineTitle.addEventListener(TextOperationEvent.CHANGE, onDisciplineChange);
			}
			if(instance == createLessonButton)
			{
				createLessonButton.addEventListener(MouseEvent.CLICK, onCreateLesson);
			}
			if(instance == saveLessonButton)
			{
				saveLessonButton.addEventListener(MouseEvent.CLICK, onSaveLesson);
			}
			if(instance == reuseLessonButton)
			{
				reuseLessonButton.addEventListener(MouseEvent.CLICK, onCloneLesson);
			}
			if(instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == cancelButton)
			{
				cancelButton.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == returnToLessonsButton)
			{
				returnToLessonsButton.addEventListener(MouseEvent.CLICK, onReturn);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == courseTitle)
			{
				courseTitle.removeEventListener(TextOperationEvent.CHANGE, onTitleChange);
			}
			if(instance == departmentList)
			{
				departmentList.removeEventListener(IndexChangeEvent.CHANGE, onDepartmentChange);
			}
			if(instance == specialtyList)
			{
				specialtyList.removeEventListener(IndexChangeEvent.CHANGE, onSpacialityChange);
			}
			if(instance == disciplineTitle)
			{
				disciplineTitle.removeEventListener(TextOperationEvent.CHANGE, onDisciplineChange);
			}
			if(instance == createLessonButton)
			{
				createLessonButton.removeEventListener(MouseEvent.CLICK, onCreateLesson);
			}
			if(instance == saveLessonButton)
			{
				saveLessonButton.removeEventListener(MouseEvent.CLICK, onSaveLesson);
			}
			if(instance == returnToLessonsButton)
			{
				returnToLessonsButton.removeEventListener(MouseEvent.CLICK, onReturn);
			}
			if(instance == reuseLessonButton)
			{
				reuseLessonButton.removeEventListener(MouseEvent.CLICK, onCloneLesson);
			}
			if(instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			super.partRemoved(partName, instance);
		}
		
		
		
		override protected function resourcesChanged():void
		{
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
			cyrillicDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_DIRECTION)||"ltr";
			latinDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_DIRECTION)||"ltr";
		}
		
		override protected function attachSkin():void
		{
			var skinClass:Class;
			if(isReuseContent)
				skinClass = ReuseCoursePopupSkin;
			else
				skinClass = CreateCoursePopupSkin;
			setStyle("skinClass", skinClass);
			super.attachSkin();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @public
		 */
		
		public function resetComponent():void
		{
			specialityId 	= 0;
			specialityName 	= null;
			specialities 	= null;
			lesson 			= null;
			departments 	= null;
			departmentName 	= null;
			departmentId 	= 0;
			title 			= null;
			discipline 		= null;
			createEnable 	= false;
			closeEnable 	= true;
			isCreateLesson 	= false;
			isReuseContent  = false;
			duplicateNameVisible = false;
		}
		
		public function duplicateName():void
		{
			duplicateNameVisible = true;
			textColor = 0xB23844;
			createEnable = false;
		}
		
		private function getFormat(color:uint):TextLayoutFormat
		{
			var format:TextLayoutFormat = new TextLayoutFormat();
			
			format.color = color;
			format.backgroundColor = 0xFFFFFF;
			format.fontSize = FormatValue.INHERIT;
			format.fontFamily = FormatValue.INHERIT;
			format.paddingRight = 5;
			format.paddingLeft = 5;
			format.verticalAlign = VerticalAlign.MIDDLE;
			
			return format;
		}
		/**
		 *  @private
		 */
		private function sortDepartments(list:IList):IList
		{
			if(!list)
				return null;
			var sort:Sort = new Sort();
			sort.fields = [new SortField(getDepartmentLabelFieldByLocale(_locale))];
			ArrayCollection(list).sort = sort;
			ArrayCollection(list).refresh();
			return list;
		}
		
		/**
		 *  @private
		 */
		private function sortSpecialities(list:IList):IList
		{
			if(!list)
				return null;
			var sort:Sort = new Sort();
			sort.fields = [new SortField(getSpecialityLabelFieldByLocale(_locale))];
			ArrayCollection(list).sort = sort;
			ArrayCollection(list).refresh();
			return list;
		}
		
		private function getCurrentSpeciality(specialityId:int):SpecialityVO
		{
			if(!specialityId || !specialities) return null;
			
			for each(var item:SpecialityVO in specialities)
			{
				if(item && item.id == specialityId)
					return item;
			}
			
			return null;
		}
		
		
		private function getCurrentDepartment(departmentId:int):DepartmentVO
		{
			if(!departmentId || !departments) return null;
			
			for each(var item:DepartmentVO in departments)
			{
				if(item && item.departmentCode == departmentId)
					return item;
			}
			
			return null;
		}
		
		private function compareChanges():void
		{
			if(isCreateLesson)
				createEnable = (nullOrEmpty(_title) != null && _departmentId && _specialityId && nullOrEmpty(_discipline) != null);
			else if(!isCreateLesson)
				createEnable = ((nullOrEmpty(_title) != null && lesson.name != _title) || 
								lesson.departmentId != _departmentId || 
								lesson.specialityId !=_specialityId || 
								(nullOrEmpty(_discipline) != null && lesson.discipline != _discipline));
		}
		
		private function nullOrEmpty(str:String):String
		{
			str = TrimUtil.trim( str );
			if(!str || str =="") return null;
			else return str;
		}
		
		private function getDepartmentLabelFieldByLocale(locale:String):String
		{
			if(locale == "tg_TJ")
				return  "departmentTjName";
			else if(locale == "en_US")
				return  "departmentEnName";
			return "departmentRuName";
		}
		
		private function getSpecialityLabelFieldByLocale(locale:String):String
		{
			if(locale == "tg_TJ")
				return  "specialityTjName";
			else if(locale == "en_US")
				return  "specialityEnName";
			return "specialityRuName";
		}
		
		/*private function specilatyFilterFunction(item:SpecialityVO):Boolean
		{
			if(item.facultyCode == )
		}*/
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		
		protected function onReturn(event:MouseEvent):void
		{
			dispatchEvent(new CourseEvent(CourseEvent.RETURN_TO_MY_LESSONS));
		}
		
		protected function onCreateLesson(event:MouseEvent):void
		{
			var lesson:LessonVO = new LessonVO();
			lesson.name = _title;
			lesson.departmentId = _departmentId;
			lesson.departmentName = departmentName;
			lesson.specialityId = _specialityId;
			lesson.specialityName = specialityName;
			lesson.discipline = _discipline;
			dispatchEvent(new CourseEvent(CourseEvent.CREATE_LESSON, lesson));
		}
		
		protected function onSaveLesson(event:MouseEvent):void
		{
			if(lesson)
			{
				lesson.name = _title;
				lesson.departmentId = _departmentId;
				lesson.specialityId = _specialityId;
				lesson.departmentName = departmentName;
				lesson.specialityName = specialityName;
				lesson.discipline = _discipline;
				dispatchEvent(new CourseEvent(CourseEvent.SAVE_LESSON, lesson));
			}
		}
		
		protected function onCloneLesson(event:MouseEvent):void
		{
			if(lesson)
			{
				var clonnigLesson:LessonVO = new LessonVO();
				clonnigLesson.name 			= _title;
				clonnigLesson.departmentId 	= _departmentId;
				clonnigLesson.departmentName = departmentName;
				clonnigLesson.specialityId   = _specialityId;
				clonnigLesson.specialityName = specialityName;
				clonnigLesson.discipline 	= _discipline;
				clonnigLesson.guid 			= lesson.guid;
				clonnigLesson.version 		= lesson.version;
				clonnigLesson.isPublished 	= lesson.isPublished;
				dispatchEvent(new CourseEvent(CourseEvent.CLONE_LESSON, clonnigLesson));
			}
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		protected function onDisciplineChange(event:TextOperationEvent):void
		{
			_discipline = disciplineTitle.text;
			formatInputText(disciplineTitle, event );
			compareChanges();
		}
		
		protected function onSpacialityChange(event:IndexChangeEvent):void
		{
			if(specialtyList.selectedItem)
			{
				var vo:SpecialityVO = specialtyList.selectedItem as SpecialityVO;
				_specialityId = vo.id;
				specialityName = vo[specialityLabelField];
			}
			compareChanges();
		}
		
		protected function onDepartmentChange(event:IndexChangeEvent):void
		{
			if(departmentList.selectedItem)
			{
				var vo:DepartmentVO = departmentList.selectedItem as DepartmentVO;
				_departmentId = vo.departmentCode;
				departmentName = vo[departmentLabelField];
			}
			compareChanges();
		}
		
		protected function onTitleChange(event:TextOperationEvent):void
		{
			_title = courseTitle.text;
			duplicateNameVisible = false;
			textColor = 0x2e424c;
			formatInputText(courseTitle, event );
			compareChanges();
		}
		
		/** 
		 * @private
		 * Sets Direction and font of text control based on user's input
		 */
		private function formatInputText(control:TextArea, event:TextOperationEvent):void
		{
			if(event.operation is InsertInlineGraphicOperation )
			{
				event.preventDefault();
			}
			else if(event.operation is InsertTextOperation)
			{
				var operation:InsertTextOperation = event.operation as InsertTextOperation;
				var currentPosition:int = Math.max( control.selectionAnchorPosition, control.selectionActivePosition);
				var srt:String = control.text;
				if(currentPosition > srt.length)
					currentPosition = srt.length;
				
				if(operation.text == " ")
					return;
				
				var regExp:RegExp = /\S/ig;
				var format:TextLayoutFormat =  new TextLayoutFormat();
				if(regExp.test(operation.text))
					format.fontFamily =  TLFUtil.getFont(operation.text, latinFont, cyrillicFont);
				if(format.fontFamily == cyrillicFont && latinDirection == Direction.RTL && control.getStyle("direction") == Direction.LTR)
				{
					control.setStyle("direction",  Direction.RTL);
					control.setStyle("textAlign",  TextAlign.RIGHT);
				}
				else if (format.fontFamily == latinFont && cyrillicDirection == Direction.LTR && control.getStyle("direction") == Direction.RTL)
				{
					control.setStyle("direction",  Direction.LTR);
					control.setStyle("textAlign",  TextAlign.LEFT);
				}
				control.setFormatOfRange(format, currentPosition - operation.text.length, currentPosition);
			}
		}
		
		
	}
}