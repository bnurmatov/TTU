////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import tj.ttu.base.constants.ModuleStatus;
	
	/**
	 * ModuleVO class 
	 */
	public class ModuleVO extends EventDispatcher
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
		
		public var moduleName:String;
		
		/**
		 * Boolean parameter indicating if activity is marked as completed
		 * Default <code>false</code>
		 */
		
		public var markedAsCompleted:Boolean = false
		
		/**
		 * Boolean.Inidcate has the activity feedback or not
		 */		
		
		public var hasFeedback:Boolean;
		
		/**
		 * Boolean.Inidcateis if this activity is type of bykiCards
		 */
		
		public var isB4u:Boolean;
		
		/**
		 * Number of correct answers 
		 */		
		
		public var correct:Number =0;
		
		/**
		 *  Total Number of questions/ items/ cards 
		 */
		
		public var total:Number =0;
		
		/**
		 * Position of current Item in anActivity 
		 * 
		 * For example card position in card modules 
		 */		
		
		public var position:Number=0;
		
		/**
		 * For renderer if does not have preview we do not show label 
		 */		
		[Bindable]
		public var hasPreview:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		
		public function ModuleVO()
		{
			super(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------
		//activityType
		//---------------------------
		
		/**
		 *Internal propery 
		 */
		private var _activityType:String
		public function set activityType(value:String):void
		{
			_activityType = value;
		}
		public function get activityType():String
		{
			return _activityType
		}
		
		
		//---------------------------
		//description
		//---------------------------
		/**
		 * 
		 *Internal propery 
		 * 
		 */
		private var _description:String;
		public function set description(value:String):void
		{	
			if (value && value != "")
				_description = value;
		}
		public function get description():String
		{
			return _description;
		}
		
		//---------------------------
		//icon
		//---------------------------
		
		private var _icon:Object;
		public function get icon():Object
		{
			return _icon;
		}
		public function set icon(value:Object):void
		{
			_icon = value;
		}
		
		
		//---------------------------
		//name
		//---------------------------
		/**
		 * 
		 * @return String The Name of the Lesson 
		 * 
		 */
		
		protected var _name:String;
		public function get name():String
		{
			return _name;
		}		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		//---------------------------
		//required
		//---------------------------
		/**
		 * 
		 * @return Boolean Indicates that this Lesson  is requared or not.
		 * 
		 */
		protected var _required:Boolean;
		
		[Bindable("requiredChange")]
		public function get required():Boolean
		{
			return _required;
		}
		public function set required(value:Boolean):void
		{
			_required = value;
		}
		
		//---------------------------
		//dataURL
		//---------------------------
		/**
		 * 
		 * @return String URL for the BykiList, needed for card activities 
		 * 
		 */
		
		protected var _dataURL:String;
		public function get dataURL():String
		{
			return _dataURL;
		}
		public function set dataURL(value:String):void
		{
			_dataURL = value;
		}
		
		//-----------------------------------
		// dataURLs
		//-----------------------------------
		
		/**
		 * @private
		 */
		private var _dataURLs:Array = [];
		
		/**
		 * The list of url that specified for Activity.
		 * 
		 * <p><b>Note</b>: Support of the multimple data sources is a 
		 * requirements of <i>feature request</i> IXT-6494.</p> 
		 * 
		 * @see http://jira.transparent.com:8081/browse/IXT-6494 IXT-6494 Feature Request
		 */
		public function get dataURLs():Array
		{
			return _dataURLs;
		}
		
		/**
		 * @private
		 */		
		public function set dataURLs(value:Array):void
		{
			_dataURLs = value;
		}
		
		
		//---------------------------
		//moduleURL
		//---------------------------
		/**
		 * 
		 * @return String URL for the BykiList, needed for card activities 
		 * 
		 */
		protected var _moduleURL:String;
		public function get moduleURL():String
		{
			return _moduleURL;
		}
		/**
		 * @private
		 */		
		public function set moduleURL(value:String):void
		{
			_moduleURL = value;
		}
		
		
		//---------------------------
		//moduleVersion
		//---------------------------
		/**
		 * 
		 * @return String 
		 * The version of the module.
		 * <p>
		 * The version has the form: major.minor.revision.build_number:
		 * <ul>
		 * 	<il>major - major version number;</il>
		 * 	<il>minor - minor version number;</il>
		 * 	<il>revision - sprint number;</il>
		 * 	<il>build_number - cruise control bild number;</il>
		 * </ul>
		 * for example: 1.0.0.0000
		 * </p>
		 * 
		 */
		protected var _moduleVersion:String;
		public function get moduleVersion():String
		{
			return _moduleVersion;
		}
		/**
		 * @private
		 */		
		public function set moduleVersion(value:String):void
		{
			_moduleVersion = value;
		}
		
		
		//---------------------------
		//helpName
		//---------------------------
		/**
		 * 
		 * @return String hard coded Hel pConstant  
		 * 
		 */
		public function get helpName():String
		{
			return moduleURL.substring(moduleURL.lastIndexOf("/")+1, moduleURL.lastIndexOf("."));
		}
		
		
		//---------------------------
		//iconName
		//---------------------------
		/**
		 * 
		 * @return String Icon constant for activity 
		 * 
		 */
		public function get iconName():String
		{
			return moduleURL.substring(moduleURL.lastIndexOf("/")+1, moduleURL.lastIndexOf("."))+"Icon";
		}
		//---------------------------
		//status
		//---------------------------
		/**
		 * The <code>status</code> of Activity.
		 * 
		 * @see StatusConstants for more info
		 * 
		 * @default: Not Attempted 
		 */
		private var _status:String = ModuleStatus.NOT_ATTEMPTED;
		
		[Bindable]
		
		public function get status():String
		{
			return _status;
		}
		public function set status(value:String):void
		{
			if( (value != ModuleStatus.FAILED) &&(_status == ModuleStatus.COMPLETED || _status == ModuleStatus.PASSED) )
				return;
			_status = value;
		}
		
		//---------------------------
		//passedScore
		//---------------------------
		/**
		 * The <code>passedScore</code> of Activity. 
		 * If students gets less then 75% stus of activity changes 
		 * to failed.
		 * 
		 * @default: 75%
		 */
		private var _passedScore:uint = 69;
		
		public function get passedScore():uint
		{
			return _passedScore;
		}
		
		public function set passedScore(value:uint):void
		{
			_passedScore = value;
		}
		
		//-------------------------------
		// backgroundImageUrl
		//-------------------------------
		private var _backgroundImageUrl:String = "";
		
		public function get backgroundImageUrl():String
		{
			return _backgroundImageUrl;
		}
		
		public function set backgroundImageUrl(value:String):void
		{
			_backgroundImageUrl = value;
		}
		
		//-------------------------------------------------------------------------------
		// enabled
		//-------------------------------------------------------------------------------
		
		private var _enabled:Boolean = false;
		
		[Bindable(event="activityEnabledChnage")]
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if( _enabled !== value)
			{
				_enabled = value;
				dispatchEvent(new Event("activityEnabledChnage"));
			}
		}
		
		
		//-------------------------------
		// selected
		//-------------------------------
		
		private var _selected:Boolean = false;
		[Bindable("selectedChange")]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		
		
	}
}