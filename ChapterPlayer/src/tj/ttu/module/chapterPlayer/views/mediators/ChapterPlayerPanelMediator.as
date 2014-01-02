////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.mediators
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.models.ChapterPlayerProxy;
	import tj.ttu.module.chapterPlayer.views.components.ChapterPlayerPanel;
	import tj.ttu.module.chapterPlayer.views.events.ActivityEvent;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	
	/**
	 * ChapterPlayerPanelMediator class 
	 */
	public class ChapterPlayerPanelMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterPlayerPanelMediator';
		
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
		 * ChapterPlayerPanelMediator 
		 */
		public function ChapterPlayerPanelMediator(viewComponent:ChapterPlayerPanel)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():ChapterPlayerPanel
		{
			return viewComponent as ChapterPlayerPanel;
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
				component.addEventListener(ActivityEvent.SHOW_VIDEO_PLAYER, 		onShowVideoPlayer);
				component.addEventListener(ActivityEvent.SHOW_COMPLETE_POPUP, 		onShowCompletePopup);
				component.addEventListener(IOErrorEvent.IO_ERROR, 					onIOError);
				setData();
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ActivityEvent.SHOW_IMAGE_FULL_SCREEN, 	onShowImageFullScreen);
				component.removeEventListener(ActivityEvent.SHOW_VIDEO_PLAYER, 			onShowVideoPlayer);
				component.removeEventListener(ActivityEvent.SHOW_COMPLETE_POPUP, 		onShowCompletePopup);
				component.removeEventListener(IOErrorEvent.IO_ERROR, 					onIOError);
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
			if(component && chapterPlayerProxy)
			{
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
		
		protected function onShowVideoPlayer(event:ActivityEvent):void
		{
			var msg:ModuleMessage = new ModuleMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				TTUConstants.SHOW_VIDEO_PLAYER,
				event.data);
			sendNotification(ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL, msg);
		}		
		
		protected function onIOError(event:IOErrorEvent):void
		{
			var msg:ModuleMessage = new ModuleMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				TTUConstants.SHOW_ERROR_WINDOW,
				event.text);
			sendNotification(ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL, msg);
		}
		
		protected function onShowCompletePopup(event:Event):void
		{
			if(chapterPlayerProxy)
			{
				chapterPlayerProxy.completed = true;
				chapterPlayerProxy.sendStatus();
			}
		}		
		
	}
}