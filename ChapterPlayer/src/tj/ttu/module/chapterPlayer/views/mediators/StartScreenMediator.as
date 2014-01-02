////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.models.ChapterPlayerProxy;
	import tj.ttu.module.chapterPlayer.views.components.StartScreenView;
	import tj.ttu.module.chapterPlayer.views.events.ActivityEvent;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	import tj.ttu.moduleUtility.view.components.ActivityModuleState;
	
	/**
	 * StartScreenMediator class 
	 */
	public class StartScreenMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'StartScreenMediator';
		
		
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
		 * StartScreenMediator 
		 */
		public function StartScreenMediator(viewComponent:StartScreenView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():StartScreenView
		{
			return viewComponent as StartScreenView;
		}
		
		private var _chapterPlayerProxy:ChapterPlayerProxy;
		
		public function get chapterPlayerProxy():ChapterPlayerProxy
		{
			if(!_chapterPlayerProxy)
				_chapterPlayerProxy = facade.retrieveProxy( ChapterPlayerProxy.NAME ) as ChapterPlayerProxy;
			return _chapterPlayerProxy;
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
				component.addEventListener(ActivityEvent.SHOW_IMAGE_FULL_SCREEN, 	onShowImageFullScreen);
				component.addEventListener(ActivityEvent.START, onStartLesson);
				setData();
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ActivityEvent.SHOW_IMAGE_FULL_SCREEN, 	onShowImageFullScreen);
				component.removeEventListener(ActivityEvent.START, onStartLesson);
				component.resetComponent();
			}
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName())
			{
				case ChapterPlayerNotifications.CONFIGURATION_DATA_LOADED:
					setData();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [ChapterPlayerNotifications.CONFIGURATION_DATA_LOADED];
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
			if(component && chapterPlayerProxy)
			{
				component.activityDescription 	= chapterPlayerProxy.moduleDescription;
				component.lesson 				= chapterPlayerProxy.lesson;
				component.muted 				= chapterPlayerProxy.muted;
				component.tempoEnabled 			= chapterPlayerProxy.tempoEnabled;
				component.volume 				= chapterPlayerProxy.volume;
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
		protected function onShowImageFullScreen(event:ActivityEvent):void
		{
			var msg:ModuleMessage = new ModuleMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				TTUConstants.SHOW_IMAGE_FULL_SCREEN_WINDOW,
				event.data);
			sendNotification(ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL, msg);
		}
		
		protected function onStartLesson(event:Event):void
		{
			sendNotification(ChapterPlayerNotifications.CHANGE_MODULE_STATE, ActivityModuleState.CONTENT);
			facade.removeMediator( NAME );
		}
	}
}