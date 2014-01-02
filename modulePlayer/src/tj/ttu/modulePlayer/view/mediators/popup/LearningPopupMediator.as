////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 4, 2013, Tajik Technical University
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
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.view.components.popup.LearningPopup;
	import tj.ttu.modulePlayer.view.events.LearningPopupEvent;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	
	/**
	 * LearningPopupMediator class 
	 */
	public class LearningPopupMediator extends Mediator
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
		public static const NAME:String = "LearningPopupMediator";
		
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
		 * LearningPopupMediator 
		 */
		public function LearningPopupMediator(viewComponent:LearningPopup)
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
		 * @return Casts viewComponent to <code>LearningPopup</code> and returns it. 
		 * 
		 */		
		public function get component() : LearningPopup
		{
			return viewComponent as LearningPopup;
		}
		
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
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
				component.addEventListener(LearningPopupEvent.STAY_HERE			, stayHereHandler);
				component.addEventListener(LearningPopupEvent.NEXT_STEP			, nextStepHandler);
				component.addEventListener(LearningPopupEvent.RETAKE			, retakeHandler);
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
				component.removeEventListener(LearningPopupEvent.STAY_HERE			, stayHereHandler);
				component.removeEventListener(LearningPopupEvent.NEXT_STEP			, nextStepHandler);
				component.removeEventListener(LearningPopupEvent.RETAKE				, retakeHandler);
				if(topApplication)
					topApplication.removeEventListener(Event.RESIZE, onResizeWindow);
			}
			PopUpManager.removePopUp( component as IFlexDisplayObject);
			viewComponent = null;
			super.onRemove();
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
			sendNotification(TTUConstants.RELOAD_MODULE);
			facade.removeMediator(NAME);
		}
		protected function nextStepHandler(event:Event):void
		{
			moduleProxy.currentModuleIndex++;
			sendNotification(TTUConstants.MODULE_INDEX_CHANGE);
			facade.removeMediator(NAME);
		}
		
		protected function stayHereHandler(event:Event):void
		{
			sendPauseActivityMessage(false);
			facade.removeMediator(NAME);
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