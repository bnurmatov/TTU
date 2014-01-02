////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 22, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.components.events.AudioSettingEvent;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.LessonHolderHeader;
	import tj.ttu.modulePlayer.view.events.LessonHolderEvent;
	
	/**
	 * LessonHolderHeaderMediator class 
	 */
	public class LessonHolderHeaderMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		public static const NAME:String = 'LessonHolderHeaderMediator';
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
		 * LessonHolderHeaderMediator 
		 */
		public function LessonHolderHeaderMediator(viewComponent:LessonHolderHeader)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():LessonHolderHeader
		{
			return viewComponent as LessonHolderHeader;	
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
				component.addEventListener(LessonHolderEvent.BACK_TO_VIEW, onBackToView); 
				component.addEventListener(LessonHolderEvent.RELOAD_MODULE, onReloadModule); 
				component.addEventListener(AudioSettingEvent.AUDIO_SETTING_CHANGE, onAudioSettingChange);
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(LessonHolderEvent.BACK_TO_VIEW, onBackToView); 
				component.removeEventListener(LessonHolderEvent.RELOAD_MODULE, onReloadModule);
				component.removeEventListener(AudioSettingEvent.AUDIO_SETTING_CHANGE, onAudioSettingChange);
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
			if(moduleProxy && component)
			{
				component.lessonName		= moduleProxy.lesson ? moduleProxy.lesson.name : null ;
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
		
		protected function onAudioSettingChange(event:Event):void
		{
			sendNotification(TTUConstants.AUDIO_SETTINGS_CHANGE, event);
		}
		
		protected function onBackToView(event:Event):void
		{
			sendNotification(TTUConstants.BACK_TO_VIEW);
		}
		
		protected function onReloadModule(event:Event):void
		{
			if(moduleProxy)
				moduleProxy.setStatus(ModuleStatus.NOT_ATTEMPTED);
			if(assessmentProxy)
				assessmentProxy.resetAnswerSelected();
			sendNotification(TTUConstants.RELOAD_MODULE);
		}
		
	}
}