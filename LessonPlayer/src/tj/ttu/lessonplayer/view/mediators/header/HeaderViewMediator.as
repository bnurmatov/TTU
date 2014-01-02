////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.mediators.header
{
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.components.events.AudioSettingEvent;
	import tj.ttu.lessonplayer.model.LessonPlayerProxy;
	import tj.ttu.lessonplayer.view.components.header.HeaderView;
	import tj.ttu.lessonplayer.view.events.HeaderEvent;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	
	/**
	 * HeaderViewMediator class 
	 */
	public class HeaderViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'HeaderViewMediator';
		
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
		 * HeaderViewMediator 
		 */
		public function HeaderViewMediator(viewComponent:HeaderView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():HeaderView
		{
			return viewComponent as HeaderView;	
		}
		
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
		}
		
		private var _lessonPlayerProxy:LessonPlayerProxy;
		
		private function get lessonPlayerProxy():LessonPlayerProxy
		{
			if(!_lessonPlayerProxy)
				_lessonPlayerProxy = facade.retrieveProxy(LessonPlayerProxy.NAME) as LessonPlayerProxy;
			return _lessonPlayerProxy;
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
				component.addEventListener(HeaderEvent.GET_HELP, onShowHelp); 
				component.addEventListener(HeaderEvent.RELOAD_MODULE, onReloadModule); 
				component.addEventListener(AudioSettingEvent.AUDIO_SETTING_CHANGE, onAudioSettingChange);
				setData();
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(HeaderEvent.GET_HELP, onShowHelp);
				component.removeEventListener(HeaderEvent.RELOAD_MODULE, onReloadModule);
				component.removeEventListener(AudioSettingEvent.AUDIO_SETTING_CHANGE, onAudioSettingChange);
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
				{
					setData();
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.UNIT_DATA_LOADED];
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
			if(lessonPlayerProxy && component)
			{
				component.lessonName		= lessonPlayerProxy.unitName ? lessonPlayerProxy.unitName : null ;
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
		
		
		protected function onReloadModule(event:Event):void
		{
			if(moduleProxy)
				moduleProxy.setStatus(ModuleStatus.NOT_ATTEMPTED);
			if(assessmentProxy)
				assessmentProxy.resetAnswerSelected();
			sendNotification(TTUConstants.RELOAD_MODULE);
		}
		
		protected function onShowHelp(event:Event):void
		{
			
		}		
		
		
	}
}