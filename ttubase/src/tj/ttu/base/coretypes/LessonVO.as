////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 24, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.coretypes
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import spark.formatters.DateTimeFormatter;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.vo.SoundVO;
	
	[Bindable]
	/**
	 * LessonVO class 
	 */
	public class LessonVO extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const DEFAULT_DATE_FORMAT:String = "MM/dd/yyyy";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *  Lesson id
		 */
		public var id:int;
		
		/**
		 *  Lesson guid
		 */
		public var guid:String;
		
		/**
		 *  Lesson aaid
		 */
		public var aaid:String;
		
		/**
		 *  Lesson name
		 */
		public var name:String;
		
		/**
		 *  Lesson description
		 */
		public var description:String;
		
		/**
		 *  Application where the Lesson was created "AppCreatorName"
		 */
		public var appCreatorName:String;
		/**
		 *  Creator of the Lesson
		 */
		public var creator:String;
		/**
		 *  Info about Creator of the Lesson
		 */
		public var aboutCreator:String;
		/**
		 *  Info about Creator of the Lesson
		 */
		[ArrayElementType("tj.ttu.base.vo.ImageVO")]
		public var aboutCreatorImages:IList;
		/**
		 *  URL of creator of the Lesson
		 */
		public var creatorURL:String;
		
		/**
		 *  Lesson creation date.
		 */
		public var creationDate:Date;

		/**
		 *  Lesson Last Modified  date.
		 */
		public var lastModifiedDate:Date;
		
		/**
		 *  Lesson department.
		 */
		public var departmentId:int;
		
		/**
		 *  Lesson department.
		 */
		public var departmentName:String;

		/**
		 *  Lesson speciality Id.
		 */
		public var specialityId:int;
		/**
		 *  Lesson speciality name.
		 */
		public var specialityName:String;

		/**
		 *  Lesson speciality Id.
		 */
		public var discipline:String;

		/**
		 *  Lesson sound.
		 */
		public var sound:SoundVO;

		
		/**
		 *  Lesson state draft or trashed
		 */
		public var lessonState:String="DRAFT";
		
		/**
		 * Visibility of the Lesson -- PRIVATE or PUBLIC
		 */
		public var visibility:String = "PRIVATE";	
		
		/**
		 *  Indicates whether Lesson is ordered. 
		 */
		public var isOrdered:Boolean;
		
		/**
		 *  Version of the Lesson
		 */
		public var version:int = 0;
		
		/**
		 *  Version of the Lesson
		 */
		public var isPublished:Boolean;
		
		/**
		 *  The locale of the Lesson will be present
		 */
		public var locale:String;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonVO 
		 */
		public function LessonVO()
		{
			super(null);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------------------
		//  Lesson resources
		//---------------------------------------------
		public var artifactList:IList;
		private var _artifacts:Array;

		public function get artifacts():Array
		{
			return _artifacts;
		}

		public function set artifacts(value:Array):void
		{
			_artifacts = value;
			artifactList = _artifacts ? new ArrayCollection(_artifacts) : null;
		}

		//---------------------------------------------
		//  Lesson resources
		//---------------------------------------------
		public var resourceList:IList;
		private var _resources:Array;

		public function get resources():Array
		{
			return _resources;
		}

		public function set resources(value:Array):void
		{
			_resources = value;
			resourceList = _resources ? new ArrayCollection(_resources) : null;
		}

		//---------------------------------------------
		//  Lesson chapters
		//---------------------------------------------
		public var chapterList:IList;
		private var _chapters:Array;

		public function get chapters():Array
		{
			return _chapters;
		}

		public function set chapters(value:Array):void
		{
			_chapters = value;
			chapterList = _chapters ? new ArrayCollection(_chapters) : null;
		}
		
		//------------------------------------------
		// lastState
		//------------------------------------------
		private var _viewIndex:int = 0;
		
		[Bindable(event="viewIndexChange")]
		public function get viewIndex():int
		{
			return _viewIndex;
		}
		
		public function set viewIndex(value:int):void
		{
			if( _viewIndex !== value)
			{
				_viewIndex = value;
				dispatchEvent(new Event("viewIndexChange"));
			}
		}
		
		//--------------------------------
		//  Lesson create Max Active View Index
		//--------------------------------
		private var _createMaxActiveViewIndex:int = 0;
		
		[Bindable(event="createMaxActiveViewIndexChange")]
		public function get createMaxActiveViewIndex():int
		{
			return _createMaxActiveViewIndex;
		}
		
		public function set createMaxActiveViewIndex(value:int):void
		{
			if( _createMaxActiveViewIndex !== value)
			{
				_createMaxActiveViewIndex = value;
				dispatchEvent(new Event("createMaxActiveViewIndexChange"));
			}
		}

		//---------------------------------------------
		//  Lesson selected
		//---------------------------------------------
		private var _selected:Boolean;

		[Bindable(event="selectedChange")]
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if( _selected !== value)
			{
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}

		//---------------------------------------------
		//  Lesson changed
		//---------------------------------------------
		private var _changed:Boolean;

		[Bindable(event="changedChange")]
		public function get changed():Boolean
		{
			return _changed;
		}

		public function set changed(value:Boolean):void
		{
			if( _changed !== value)
			{
				_changed = value;
				dispatchEvent(new Event("changedChange"));
			}
		}
		
		//---------------------------------------------
		//  Lesson creationDateString
		//---------------------------------------------
		public function get creationDateString():String
		{
			if(!creationDate)
				return "";
			
			var formater:DateTimeFormatter = new DateTimeFormatter();
			formater.dateTimePattern = DEFAULT_DATE_FORMAT;
			return formater.format( creationDate );
		}

		//---------------------------------------------
		//  Lesson lastModifiedDateString
		//---------------------------------------------
		public function get lastModifiedDateString():String
		{
			if(!lastModifiedDate)
				return "";
			
			var formater:DateTimeFormatter = new DateTimeFormatter();
			formater.dateTimePattern = DEFAULT_DATE_FORMAT;
			return formater.format( lastModifiedDate );
		}

		//----------------------------------
		//  status
		//----------------------------------
		private var _status:String = ModuleStatus.NOT_ATTEMPTED;
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			_status = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function toString():String
		{
			return name;
		}
	}
}