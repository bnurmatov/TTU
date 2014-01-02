////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.model
{
	import flash.events.Event;
	
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	
	/**
	 * ModuleProxy class 
	 */
	public class ModuleProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ModuleProxy';
		public static const MODULE_PATH:String = 'modules/';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var listScores:Array;
		public var scoreVo:ScoreVO;
		public var changedScore:Array;
		private var imageLength:int;
		public var currentImageIndex:int = -1;
		public var isUnitHome:Boolean;
		public var isPaused:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ModuleProxy 
		 */
		public function ModuleProxy()
		{
			super(NAME);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 *  Total number of modules
		 */       
		
		public function get total():uint
		{
			return modules? modules.length : 0;
		}
		
		//----------------------------------
		//  totalCompleted
		//----------------------------------
		/**
		 *  @private
		 *  Internal storage for totalCompleted property.
		 */
		private var _totalCompleted:int;
		
		/**
		 * An value which holds total number of completed activities.
		 */ 
		public function get totalCompleted():int
		{
			return _totalCompleted;
		}
		/**
		 *  @private
		 */ 
		public function set totalCompleted(value:int):void
		{
			_totalCompleted = value;
		}
		//-------------------------------------------------------------------
		// currentModuleIndex
		//-------------------------------------------------------------------
		private var _currentModuleIndex:int = 0;
		
		public function get currentModuleIndex():int
		{
			return _currentModuleIndex;
		}
		
		public function set currentModuleIndex(value:int):void
		{
			if( _currentModuleIndex !== value)
			{
				_currentModuleIndex = value;
			}
		}
		//-------------------------------------------------------------------
		// modules
		//-------------------------------------------------------------------
		private var _modules:IList;
		
		[ArrayElementType("tj.ttu.base.vo.ModuleVO")]
		public function get modules():IList
		{
			return _modules;
		}
		
		public function set modules(value:IList):void
		{
			if( _modules !== value)
			{
				_modules = value;
			}
		}
		//-------------------------------------------------------------------
		// lesson
		//-------------------------------------------------------------------
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
			}
		}
		
		//----------------------------------
		//  currentActivity
		//----------------------------------	
		
		/**
		 *  @private
		 */
		
		public function get currentModule():ModuleVO
		{
			if(isInRange(currentModuleIndex, modules))
			{ 
				return modules.getItemAt(currentModuleIndex) as ModuleVO;
			}
			return null;
		}
		
		/**
		 *  @private
		 */
		
		public function get nextModule():ModuleVO
		{
			if(isInRange(currentModuleIndex + 1 , modules))
			{
				return modules.getItemAt(currentModuleIndex + 1) as ModuleVO;
			}
			return null;
		}
		
		//----------------------------------
		//  backgroundImages
		//----------------------------------	
		private var _backgroundImages:Array;
		
		public function get backgroundImages():Array
		{
			return _backgroundImages;
		}
		
		public function set backgroundImages(value:Array):void
		{
			_backgroundImages = value;
			imageLength = _backgroundImages ? _backgroundImages.length : -1;
		}
		//----------------------------------
		//  lessonName
		//----------------------------------
		public function get lessonName():String
		{
			return _lesson ? _lesson.name : "";
		}
		//----------------------------------
		//  lessonDescription
		//----------------------------------
		public function get lessonDescription():String
		{
			return _lesson ? _lesson.description : "";
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
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			_lesson = null;
			modules = null;
			currentModuleIndex = -1;
			listScores = null;
			isUnitHome = false;
			super.onRemove();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  Sets the satus of the application 
		 *  and calculates number of completed activities
		 */ 
		public function setStatus(value:String):void
		{
			if(currentModule) 
				currentModule.status = value;
			
			setCurrentLessonStatus(value);
			setCurrentUnitStatus(value);
			totalCompleted 	= calculateTotalCompletion(modules);
			enableNext();
		}
	
		public function get nextImage():String
		{
			if(!_backgroundImages || imageLength == 0)
				return null;
			if(imageLength == 1)
				return _backgroundImages[0];
			
			var nextIndex:int = Math.random() * imageLength;
			var count:int = 0;
			while(nextIndex == currentImageIndex  && count <= imageLength)
			{
				nextIndex = Math.random() * imageLength;
				count++;
			}
			currentImageIndex = nextIndex;
			return  _backgroundImages[nextIndex] ;
		}
		
		/**
		 *  @private
		 */
		/**
		 *  @private
		 */
		
		private function isInRange(index:int, list:IList):Boolean
		{
			return index >= 0 && list && list.length != 0 && list.length > index;
		}
		
		/**
		 *  @private
		 */
		
		private function enableNext():void
		{
			var prevStatus:Boolean = true;
			var index:int = 0;
			for (var i:int = 0; i < modules.length; i++) 
			{
				var module:ModuleVO = modules.getItemAt(i) as ModuleVO;
				module.enabled = prevStatus;
				index = module.enabled ? i :index; 
				if(i > 1)
					prevStatus = module.status == ModuleStatus.COMPLETED || module.status == ModuleStatus.PASSED;
			}
		}
		
		/**
		 * @private
		 *  Sets status of current lesson
		 * @param statusString  Current Status
		 * 
		 */        
		private function setCurrentLessonStatus(statusString:String):void
		{
			if(lesson)
			{
				lesson.status = isAllActivitiesCompleted(modules)?ModuleStatus.COMPLETED:ModuleStatus.INCOMPLETE;
			}
		}
		/**
		 *  @private 
		 *  Sets status based on satus received form LMS or module 
		 * 
		 */	
		public function setCurrentUnitStatus(statusString:String):void
		{
			/**
			 * Since the satus of a unit depends on assessment we need only
			 * worry about FAILED and PASSED states 
			 */ 
			switch(statusString)
			{
				case ModuleStatus.INCOMPLETE:
				{
					status = ModuleStatus.INCOMPLETE;
					break;
				}
				case ModuleStatus.COMPLETED:
				{
					status = ModuleStatus.COMPLETED;
					break;
				}
				case ModuleStatus.FAILED:
				{
					status = ModuleStatus.FAILED;
					if(assessmentProxy && assessmentProxy.isAssessment)
					{
						assessmentProxy.status = ModuleStatus.FAILED;
					}
					break;
				}
				case ModuleStatus.PASSED:
				{
					status = ModuleStatus.PASSED;
					if(assessmentProxy && assessmentProxy.isAssessment)
					{
						assessmentProxy.status = ModuleStatus.PASSED;
					}
					break;
				}
					
			}
		}
		
		/**
		 * 
		 * @param activities Vector of ActivityVos
		 * 
		 * @return  <code>true</code> indicates that all activitis are completed 
		 */
		public static function isAllActivitiesCompleted(activities:IList):Boolean
		{
			if(activities)
			{
				var completeCount:int = 0;
				for(var i:int = 0; i< activities.length; i++)
				{
					var act:ModuleVO = activities.getItemAt(i) as ModuleVO;
					if(act.status == ModuleStatus.COMPLETED || act.status == ModuleStatus.PASSED)
					{
						completeCount++;
					}
				}
				return completeCount == activities.length;
			}
			return false;
		}
		
		/**
		 * 
		 * @param activities Alist containing  ActivityVo value objects
		 * 
		 * @return  Amount of completed activities 
		 */
		
		public static function calculateTotalCompletion(activities:IList):int
		{
			var completedCount:int = 0;
			if(activities)
			{
				var total:int = activities.length;
				for(var i:int =0 ; i< total; i++)
				{
					var act:ModuleVO = activities.getItemAt(i)  as ModuleVO;
					completedCount =  act.status == ModuleStatus.COMPLETED || act.status == ModuleStatus.PASSED ? completedCount +  1 : completedCount;
				}
			}
			return completedCount;
		} 
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
		
		//-----------------------------------
		//	assessmentProxy
		//-----------------------------------
		
		/**
		 * @private
		 * Storage for the assessmentProxy property.
		 */
		private var _assessmentProxy:AssessmentProxy;
		
		/**
		 * Reference to the <code>AssessmentProxy</code>.
		 */
		public function get assessmentProxy():AssessmentProxy
		{
			if (!this._assessmentProxy)
				this._assessmentProxy = this.facade.retrieveProxy(AssessmentProxy.NAME) as AssessmentProxy;
			
			return this._assessmentProxy;
		}		
		
	}
}