////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.controller
{
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ConfigurationVO;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ConfigurationMessage;
	
	/**
	 * SendModuleSettingsCommand class 
	 */
	public class SendModuleSettingsCommand extends SimpleCommand
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
		 * Holds ConfigurationVO objects which is sent in message body
		 */ 
		private var confVo:ConfigurationVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SendModuleSettingsCommand 
		 */
		public function SendModuleSettingsCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _moduleProxy:ModuleProxy;
		
		public function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
		}
		
		private var _configProxy:AppConfigProxy;
		
		public function get configProxy():AppConfigProxy
		{
			if(!_configProxy)
				_configProxy = facade.retrieveProxy(AppConfigProxy.NAME) as AppConfigProxy;
			return _configProxy;
		}
		
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
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(notification:INotification):void
		{
			var confMessage:ConfigurationMessage;
			confVo = configProxy.config;
			confVo.rootDataPath = configProxy.rootDataPath;
			confVo.isServerMode	= true;	
			updateBundle();
			
			if(moduleProxy)
			{
				moduleProxy.changedScore				= []; // empty learing history
				if(moduleProxy.currentModule)
				{
					confVo.activityName					= moduleProxy.currentModule.name;
					confVo.activityDescription			= ResourceManager.getInstance().getString(ResourceConstants.ACTIVITY, moduleProxy.currentModule.helpName + "Description");
				}
				confVo.dataURLs 						= !StringUtil.isNullOrEmpty(moduleProxy.currentModule.dataURL) ? [moduleProxy.currentModule.dataURL] : [moduleProxy.lesson];
				confVo.totalActivities					= moduleProxy.modules.length;
			}
			
			if(	setConfigActivityVo())
			{
				confMessage = new ConfigurationMessage(PipeConstants.SHELL_TO_MODULE_MESSAGE, MessageConstants.ALL, confVo);
				sendNotification(TTUConstants.SEND_MESSAGE_TO_MODULE, confMessage);	
			}
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
		/**
		 *  @private
		 */ 
		private function setConfigActivityVo():Boolean
		{
			var moduleVO:ModuleVO = moduleProxy.currentModule;
			if(!moduleVO)
				return false;
			confVo.activityName = moduleVO.name;
			confVo.url = "CourseCreator";
			confVo.position = moduleVO.position;
			confVo.correct = moduleVO.correct;
			confVo.total = moduleVO.total;
			confVo.moduleStatus = moduleVO.status;
			
			if(assessmentProxy && assessmentProxy.isAssessment)
			{
				confVo.isAssessment				= true;
				confVo.minScore 				= 69;
				if(assessmentProxy.questions && assessmentProxy.questions.length > 0)
					confVo.data 					= assessmentProxy.questions;
				else
					confVo.data 					= null;
				confVo.minItems 				= assessmentProxy.minItems;
				confVo.maxItems 				= assessmentProxy.maxItems;
				confVo.items					= assessmentProxy.total;
				moduleVO.moduleURL 				= moduleProxy.currentModule.moduleURL;
				confVo.assessmentTotal			= assessmentProxy.total;
				confVo.progressBefore			= assessmentProxy.progressBefore;
			}
			return true;
		}
		
		private function updateBundle():void
		{
			ResourceManager.getInstance().update();
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
		
		
	}
}