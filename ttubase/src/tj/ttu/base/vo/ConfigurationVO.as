////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	/**
	 * ConfigurationVO class 
	 */
	public class ConfigurationVO
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
		/**
		 * Name of activity defined in unit xml, if empty set to default activity name form resource
		 */
		public var activityName:String;
		/**
		 * Sound volume, values from 0..1
		 */
		public var volume:Number;
		/**
		 * Activity data. 
		 */
		public var data:Object;
		/**
		 * Current position 
		 */
		public var position:Number;
		
		/**
		 * Correct answer count
		 */
		public var correct:Number;
		
		/**
		 * Total count
		 */
		public var total:Number;
		
		/**
		 * The list of url that specified for Activity.
		 * 
		 * <p><b>Note</b>: Support of the multimple data sources is a 
		 * requirements of <i>feature request</i> IXT-6494.</p> 
		 * 
		 * @see http://jira.transparent.com:8081/browse/IXT-6494 IXT-6494 Feature Request
		 */
		public var dataURLs:Array = [];
		
		/**
		 * Activity mode. (activity specific)
		 */
		public var mode:String;
		
		/**
		 * Number of items needed for learning or assessment.
		 */
		public var items:Number;
		public var muted:Boolean 		= false;
		public var totalActivities:Number;
		public var totalCompleted:Number;
		public var tempoEnabled:Boolean = false;
		public var isAssessment:Boolean = false;
		public var isServerMode:Boolean = false;
		public var minScore:Number;
		public var minItems:Number;
		public var maxItems:Number;
		/**
		 * Number of progress before current session.
		 */
		public var assessmentTotal:int = 0;
		
		/**
		 * Number of progress after current session.
		 */		
		public var progressBefore:int = 0;
		//--------------------------------------
		//  url
		//--------------------------------------
		
		private var _url:String;
		
		/**
		 * Data location for learning. 
		 */
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		//--------------------------------------
		//  rootDataPath
		//--------------------------------------
		
		private var _rootDataPath:String = "";
		
		/**
		 */
		public function get rootDataPath():String
		{
			return _rootDataPath;
		}
		
		public function set rootDataPath(value:String):void
		{
			_rootDataPath = value;
		}
		
		//--------------------------------------
		//  activityStatus
		//--------------------------------------
		
		private var _moduleStatus:String;
		
		/**
		 * COMPLETED/INCOMPLETE - for Activity 
		 * PASSED/FAILED - for Assessment
		 */
		public function set moduleStatus(value:String):void
		{
			_moduleStatus = value;
		}
		
		public function get moduleStatus():String
		{
			return _moduleStatus;
		}
		/**
		 * Custom description for activity 
		 */		
		public var activityDescription:String;
		
		/**
		 * 	Show start screen of activity. Default <code>true</code>
		 *  ToDo: remove it to the ActivityConfig. 
		 */		
		public var showStartScreen:Boolean = true; 
		
		//----------------------------------
		//  Font configs
		//----------------------------------
		public var uiFont:String;
		public var uiDirection:String;
		public var tjLanguageFont:String;
		public var tjLanguageDirection:String;
		public var tjLanguageName:String;
		public var tjLanguageCode:String;
		public var tjTextAlign:String;
		public var ruLanguageFont:String;
		public var ruLanguageDirection:String;
		public var ruLanguageName:String;
		public var ruLanguageCode:String;
		public var ruTextAlign:String;
		public var enLanguageFont:String;
		public var enLanguageDirection:String;
		public var enLanguageName:String;
		public var enLanguageCode:String;
		public var enTextAlign:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ConfigurationVO 
		 */
		public function ConfigurationVO()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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