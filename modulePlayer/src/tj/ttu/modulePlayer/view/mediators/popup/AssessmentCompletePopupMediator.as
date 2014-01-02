////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 3, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators.popup
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.popup.AssessmentCompletePopup;
	import tj.ttu.modulePlayer.view.events.LearningPopupEvent;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	
	/**
	 * AssessmentCompletePopupMediator class 
	 */
	public class AssessmentCompletePopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Constant for mediator's name.
		 * 
		 */
		public static const NAME:String = "AssessmentCompletePopupMediator";
		
		
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
		 * AssessmentCompletePopupMediator 
		 */
		public function AssessmentCompletePopupMediator(viewComponent:AssessmentCompletePopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 * A getter for casting viewComponet to <code>LearningPopup</code>.
		 * 
		 * @return Casts viewComponent to <code>AssessmentCompletePopup</code> and returns it. 
		 * 
		 */		
		public function get component() : AssessmentCompletePopup
		{
			return viewComponent as AssessmentCompletePopup;
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
		
		private function get topApplication():DisplayObject
		{
			return FlexGlobals.topLevelApplication as DisplayObject;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override public function onRegister():void
		{
			super.onRegister();
			
			if( component )
			{
				component.addEventListener(LearningPopupEvent.HOME			, homeHandler);
				component.addEventListener(LearningPopupEvent.RETAKE		, retakeHandler);
				if(topApplication)
					topApplication.addEventListener(Event.RESIZE, onResizeWindow);
			}	
			
			sendPauseActivityMessage(true);
		}
		
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override public function onRemove():void
		{
			if( component )
			{
				component.removeEventListener(LearningPopupEvent.HOME			, homeHandler);
				component.removeEventListener(LearningPopupEvent.RETAKE			, retakeHandler);
				if(topApplication)
					topApplication.removeEventListener(Event.RESIZE, onResizeWindow);
			}
			PopUpManager.removePopUp( component as IFlexDisplayObject);
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			if(notification.getName() == TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW)
			{
				facade.removeMediator(NAME);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW];
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Handler for <code>Event.RESIZE</code> event dispatched by view.
		 * 
		 * @param event The event dispatched by view.
		 * 
		 */	
		private function onResizeWindow(event:Event):void
		{
			PopUpManager.centerPopUp(component as IFlexDisplayObject);
		}
		
		
		protected function retakeHandler(event:Event):void
		{
			if(moduleProxy)
				moduleProxy.setStatus(ModuleStatus.NOT_ATTEMPTED);
			if(assessmentProxy)
				assessmentProxy.resetAnswerSelected();
			sendNotification(TTUConstants.RELOAD_MODULE);
			facade.removeMediator(NAME);
		}
		
		public function resetAnswerSelected():void
		{
			
		}
		
		protected function homeHandler(event:Event):void
		{
			moduleProxy.isUnitHome = true;
			moduleProxy.currentModuleIndex = 0;
			sendNotification(TTUConstants.MODULE_INDEX_CHANGE); 
			sendNotification(TTUConstants.SHOW_START_SCREEN);
			sendNotification(TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW);
		}
		
		/**
		 * @private
		 * @param isPaused A boolean value indcating paused status of the mdoule
		 * <code>true</code> means that acitivity should be paused 
		 * and <code>false</code> means that activity should not be paused 
		 * 
		 */ 
		private function sendPauseActivityMessage(isPaused:Boolean):void
		{
			var msg:ModulePipeMessage = new ModulePipeMessage(PipeConstants.SHELL_TO_MODULE_MESSAGE, 
				MessageConstants.PAUSE_MODULE,	
				isPaused);
			sendNotification(TTUConstants.SEND_MESSAGE_TO_MODULE, msg);	
		}
	}
}