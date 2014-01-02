////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 9, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.create
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Fade;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	/**
	 * BaseCreateCourseView class 
	 */
	public class BaseCreateCourseView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var lessonTitleLabel:RichText;
		
		[SkinPart(required="false")]
		public var backButton:Button;
		
		[SkinPart(required="false")]
		public var saveButton:Button;
		
		[SkinPart(required="false")]
		public var saveAndNextButton:Button;
		
		[SkinPart(required="false")]
		public var detailsButton:Button;
		
		[SkinPart(required="false")]
		public var buttonBlink:Fade;
		
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
		 * BaseCreateCourseView 
		 */
		public function BaseCreateCourseView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  lesson
		//--------------------------------------
		private var _lesson:LessonVO;
		
		public function get lesson():LessonVO
		{
			return _lesson;
		}
		
		public function set lesson(value:LessonVO):void
		{
			if( _lesson !== value)
			{
				_lesson = value;
				title 				= _lesson ? _lesson.name : null;
				createdDate 		= _lesson ? _lesson.creationDateString : null;
				lastModifiedDate 	= _lesson ? _lesson.lastModifiedDateString : null;
			}
		}


		//-------------------------------
		// title
		//-------------------------------
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

		//-------------------------------
		// createdDate
		//-------------------------------
		private var _createdDate:String;

		[Bindable(event="createdDateChange")]
		public function get createdDate():String
		{
			return _createdDate;
		}

		public function set createdDate(value:String):void
		{
			if( _createdDate !== value)
			{
				_createdDate = value;
				dispatchEvent(new Event("createdDateChange"));
			}
		}

		//-------------------------------
		// lastModifiedDate
		//-------------------------------
		private var _lastModifiedDate:String;

		[Bindable(event="lastModifiedDateChange")]
		public function get lastModifiedDate():String
		{
			return _lastModifiedDate;
		}

		public function set lastModifiedDate(value:String):void
		{
			if( _lastModifiedDate !== value)
			{
				_lastModifiedDate = value;
				dispatchEvent(new Event("lastModifiedDateChange"));
			}
		}
		
		//-------------------------------
		// hasChange
		//-------------------------------
		private var _hasChange:Boolean = false;
		
		[Bindable(event="hasChange")]
		public function get hasChange():Boolean
		{
			return _hasChange;
		}
		
		public function set hasChange(value:Boolean):void
		{
			if( _hasChange !== value)
			{
				_hasChange = value;
				pulsingSaveButton(_hasChange);
				dispatchEvent(new CourseEvent(CourseEvent.HAS_CHANGE, _hasChange));
			}
		}
		
		//-----------------------------------------
		// isSaveInProcess
		//-----------------------------------------
		private var _isSaveInProcess:Boolean;
		
		[Bindable(event="isSaveInProcessChange")]
		public function get isSaveInProcess():Boolean
		{
			return _isSaveInProcess;
		}
		
		public function set isSaveInProcess(value:Boolean):void
		{
			if( _isSaveInProcess !== value)
			{
				_isSaveInProcess = value;
				dispatchEvent(new Event("isSaveInProcessChange"));
			}
		}

		//-------------------------------
		// nextClicked
		//-------------------------------
		private var _nextClicked:Boolean;
		
		public function get nextClicked():Boolean
		{
			return _nextClicked;
		}
		
		public function set nextClicked(value:Boolean):void
		{
			if( _nextClicked !== value)
			{
				_nextClicked = value;
			}
		}
		//-------------------------------
		// uiFont
		//-------------------------------
		private var _uiFont:String = "Latin";

		[Bindable(event="uiFontChange")]
		public function get uiFont():String
		{
			return _uiFont;
		}

		public function set uiFont(value:String):void
		{
			if( _uiFont !== value)
			{
				_uiFont = value;
				dispatchEvent(new Event("uiFontChange"));
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
			if(titleChanged && lessonTitleLabel)
			{
				titleChanged = false;
				lessonTitleLabel.text = _title;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == backButton)
			{
				backButton.addEventListener(MouseEvent.CLICK, onBackClick);
			}
			
			if(instance == saveButton)
			{
				saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			}
			
			if(instance == saveAndNextButton)
			{
				saveAndNextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			}
			
			if(instance == detailsButton)
			{
				detailsButton.addEventListener(MouseEvent.CLICK, onDetailsButtonClick);
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == backButton)
			{
				backButton.removeEventListener(MouseEvent.CLICK, onBackClick);
			}
			
			if(instance == saveButton)
			{
				saveButton.removeEventListener(MouseEvent.CLICK, onSaveClick);
			}
			
			if(instance == saveAndNextButton)
			{
				saveAndNextButton.removeEventListener(MouseEvent.CLICK, onNextClick);
			}
			
			if(instance == detailsButton)
			{
				detailsButton.removeEventListener(MouseEvent.CLICK, onDetailsButtonClick);
			}
			
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			uiFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.UI_FONT) || 'Latin';
		}
		
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
		protected function pulsingSaveButton(play:Boolean):void
		{
			if(!buttonBlink) return;
			
			if(play) 
				buttonBlink.play();
			else 
				buttonBlink.stop();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onNextClick(event:MouseEvent):void
		{
			dispatchEvent(new CourseEvent(CourseEvent.NEXT));
		}
		
		protected function onSaveClick(event:MouseEvent):void
		{
			
		}
		
		protected function onBackClick(event:MouseEvent):void
		{
			dispatchEvent(new CourseEvent(CourseEvent.BACK_TO_PREVIOUS_SCREEN));
		}
		/**
		 *  @private
		 */
		
		protected function onDetailsButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new CourseEvent(CourseEvent.SHOW_EDIT_LESSON_DETAILS_WINDOW, lesson));
		}
		
		
	}
}