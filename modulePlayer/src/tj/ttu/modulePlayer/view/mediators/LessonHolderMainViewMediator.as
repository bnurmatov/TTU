////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 22, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.SkinPartEvent;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.modulePlayer.controller.HandleModuleMessageCommand;
	import tj.ttu.modulePlayer.controller.HideModuleCommand;
	import tj.ttu.modulePlayer.controller.ModuleRemovedCommand;
	import tj.ttu.modulePlayer.controller.SendModuleSettingsCommand;
	import tj.ttu.modulePlayer.controller.popup.ShowAssessmentCompletePopup;
	import tj.ttu.modulePlayer.controller.popup.ShowLearningPopup;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.LessonHolderMainView;
	import tj.ttu.modulePlayer.view.events.LessonHolderEvent;
	import tj.ttu.modulePlayer.view.mediators.startscreen.AssessmentStartScreenMediator;
	import tj.ttu.modulePlayer.view.mediators.startscreen.StartScreenMediator;
	
	/**
	 * LessonHolderMainViewMediator class 
	 */
	public class LessonHolderMainViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'LessonHolderMainViewMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var notReady:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonHolderMainViewMediator 
		 */
		public function LessonHolderMainViewMediator(viewComponent:LessonHolderMainView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():LessonHolderMainView
		{
			return viewComponent as LessonHolderMainView;	
		}
		
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
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
		override public function onRegister():void
		{
			super.onRegister();
			if(component)
			{
				component.addEventListener(LessonHolderEvent.SELECTED_INDEX_CHANGE, onSelectedIndexChange); 
				
				if(facade.hasMediator(ModuleLoaderMediator.NAME))
					facade.removeMediator(ModuleLoaderMediator.NAME);
				
				if(facade.hasMediator(PlayerJunctionMediator.NAME))
					facade.removeMediator(PlayerJunctionMediator.NAME);
				facade.registerMediator(new PlayerJunctionMediator());
				
				facade.registerCommand(TTUConstants.SEND_MODULE_SETTINGS, SendModuleSettingsCommand);
				facade.registerCommand(TTUConstants.MODULE_REMOVED, ModuleRemovedCommand);
				facade.registerCommand(TTUConstants.HANDLE_MODULE_MESSAGE, HandleModuleMessageCommand);
				facade.registerCommand(TTUConstants.HIDE_MODULE, HideModuleCommand);
				facade.registerCommand(TTUConstants.LEARNING_COMPLETE, ShowLearningPopup);
				facade.registerCommand(TTUConstants.ASSESMENT_COMPLETE, ShowAssessmentCompletePopup);
				
				if(component.startScreen)
					facade.registerMediator(new StartScreenMediator(component.startScreen));
				if(component.assessmentStartScreen)
					facade.registerMediator(new AssessmentStartScreenMediator(component.assessmentStartScreen));
				
				if(component.moduleLoader)
				{
					facade.registerMediator(new ModuleLoaderMediator(component.moduleLoader));
					setData();
				}
				else
				{
					notReady = true;
					component.addEventListener(SkinPartEvent.PART_ADDED, onPartAdded);
				}
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				facade.removeMediator(ModuleLoaderMediator.NAME);
				facade.removeMediator(PlayerJunctionMediator.NAME);
				facade.removeMediator(StartScreenMediator.NAME);
				facade.removeMediator(AssessmentStartScreenMediator.NAME);
				
				facade.removeCommand(TTUConstants.SEND_MODULE_SETTINGS);
				facade.removeCommand(TTUConstants.MODULE_REMOVED);
				facade.removeCommand(TTUConstants.HANDLE_MODULE_MESSAGE);
				facade.removeCommand(TTUConstants.HIDE_MODULE);
				facade.removeCommand(TTUConstants.LEARNING_COMPLETE);
				facade.removeCommand(TTUConstants.ASSESMENT_COMPLETE);
				
				component.removeEventListener(LessonHolderEvent.SELECTED_INDEX_CHANGE, onSelectedIndexChange); 
				component.removeEventListener(SkinPartEvent.PART_ADDED, onPartAdded);
				component.resetComponent();
			}
			viewComponent = null;
			super.onRemove();
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName())
			{
				case TTUConstants.UNIT_DATA_LOADED :
				case TTUConstants.MODULE_DATA_LOADED :
				{
					isDataSet = false;
					if(!notReady)
						setData();
					break;
				}
				case TTUConstants.MODULE_INDEX_CHANGE :
				{
					if(moduleProxy && component)
						component.selectedIndex = moduleProxy.currentModuleIndex;
					break;
				}
			}
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.MODULE_DATA_LOADED,
				TTUConstants.UNIT_DATA_LOADED,
				TTUConstants.MODULE_INDEX_CHANGE];
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
		private var isDataSet:Boolean;
		private function setData():void
		{
			if(moduleProxy && component && !isDataSet )
			{
				component.modules	= null;
				component.selectedIndex	= -1;
				component.modules 	= moduleProxy.modules;
				component.currentModule	= moduleProxy.currentModule;
				component.selectedIndex = moduleProxy.currentModuleIndex;
				component.backgroundImage = moduleProxy.nextImage;
				isDataSet = true;
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		
		protected function onSelectedIndexChange(event:Event):void
		{
			if(!moduleProxy.modules)
				return;
			assessmentProxy.isAssessment = false;
			if(component.selectedIndex != -1)
			{
				moduleProxy.currentModuleIndex = component.selectedIndex;
				if(moduleProxy.currentModule.name == "Assessment")
				{
					assessmentProxy.isAssessment = true;
					sendNotification(TTUConstants.HIDE_START_SCREEN);
					sendNotification(TTUConstants.SHOW_ASSESSMENT_START_SCREEN, moduleProxy.currentModule.moduleURL);
				}
				else if(moduleProxy.isUnitHome)
					sendNotification(TTUConstants.SHOW_START_SCREEN);
				else
					sendNotification(TTUConstants.LOAD_MODULE, moduleProxy.currentModule? moduleProxy.currentModule.moduleURL : null);
				component.backgroundImage = moduleProxy.nextImage;
			}
			else
				sendNotification(TTUConstants.UNLOAD_MODULE);
		}
		
		protected function onPartAdded(event:SkinPartEvent):void
		{
			if(event.instance == component.moduleLoader)
			{
				facade.registerMediator( new ModuleLoaderMediator(component.moduleLoader));
				if(notReady)
				{
					setData();
					notReady = false;
				}
			}
			else if(event.instance == component.startScreen)
				facade.registerMediator(new StartScreenMediator(component.startScreen));
			else if(event.instance == component.assessmentStartScreen)
				facade.registerMediator(new AssessmentStartScreenMediator(component.assessmentStartScreen));
			
		}		
	}
}