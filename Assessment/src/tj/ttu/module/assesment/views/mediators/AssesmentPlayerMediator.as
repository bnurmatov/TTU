////////////////////////////////////////////////////////////////////////////////
// Copyright Aug 28, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	import tj.ttu.module.assesment.views.components.AssesmentPlayer;
	import tj.ttu.module.assesment.views.events.ActivityEvent;
	import tj.ttu.module.assesment.views.events.AssesmentEvent;
	
	/**
	 * AssesmentPlayerMediator class 
	 */
	public class AssesmentPlayerMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'AssesmentPlayerMediator';
		
		
		
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
		 * AssesmentPlayerMediator 
		 */
		public function AssesmentPlayerMediator(viewComponent:AssesmentPlayer)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():AssesmentPlayer
		{
			return viewComponent as AssesmentPlayer;
		}
		
		private var _assesmentPlayerProxy:AssesmentPlayerProxy;
		
		public function get assesmentPlayerProxy():AssesmentPlayerProxy
		{
			if(!_assesmentPlayerProxy)
				_assesmentPlayerProxy = facade.retrieveProxy( AssesmentPlayerProxy.NAME ) as AssesmentPlayerProxy;
			return _assesmentPlayerProxy;
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
				component.addEventListener(ActivityEvent.SHOW_COMPLETE_POPUP, onShowCompletePopup);
				component.addEventListener(AssesmentEvent.SAVE_CORRECT_ANSWER_COUNT, onCorrectAnswerCountChange);
				component.addEventListener(AssesmentEvent.SEND_USER_ANSWERS_STATUS, onSendStatus);
				setData();
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ActivityEvent.SHOW_COMPLETE_POPUP, onShowCompletePopup);
				component.removeEventListener(AssesmentEvent.SAVE_CORRECT_ANSWER_COUNT, onCorrectAnswerCountChange);
				component.removeEventListener(AssesmentEvent.SEND_USER_ANSWERS_STATUS, onSendStatus);
				component.resetComponent();
			}
			viewComponent = null;
			super.onRemove();
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
		private function setData():void
		{
			if(component && assesmentPlayerProxy)
			{
				component.questions				= assesmentPlayerProxy.questions;
				component.muted 				= assesmentPlayerProxy.muted;
				component.tempoEnabled 			= assesmentPlayerProxy.tempoEnabled;
				component.volume 				= assesmentPlayerProxy.volume;
			}
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
		protected function onShowCompletePopup(event:ActivityEvent):void
		{
			if(assesmentPlayerProxy)
			{
				assesmentPlayerProxy.completed = true;
				assesmentPlayerProxy.sendStatus(null, event.data as Array);
			}
		}	
		
		protected function onSendStatus(event:AssesmentEvent):void
		{
			if(assesmentPlayerProxy)
				assesmentPlayerProxy.sendStatus(null, event.data as Array);
			
		}
		
		protected function onCorrectAnswerCountChange(event:Event):void
		{
			if(assesmentPlayerProxy)
				assesmentPlayerProxy.correct++;
		}
	}
}