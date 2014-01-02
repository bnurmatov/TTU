////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators
{
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	import tj.ttu.moduleUtility.view.interfaces.IModuleLoader;
	
	/**
	 * ModuleLoaderMediator class 
	 */
	public class ModuleLoaderMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ModuleLoaderMediator';
		public static const APP_FOLDER:String = "app:/";
		
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
		 * ModuleLoaderMediator 
		 */
		public function ModuleLoaderMediator(viewComponent:IModuleLoader)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():IModuleLoader
		{
			return viewComponent as IModuleLoader;
		}
		
		private function get isAir():Boolean
		{
			return Capabilities.playerType == "Desktop";
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
				component.addEventListener(ModuleEvent.READY, 			onModuleInitialized);
				component.addEventListener(ModuleEvent.PROGRESS, 		onModuleLoadProgress);
				component.addEventListener(ModuleEvent.SETUP,			onModuleLoadComplete);
				component.addEventListener(ModuleEvent.ERROR,			onModuleLoadError);
				component.addEventListener(ModuleEvent.UNLOAD,			onModuleRemoved);
				component.addEventListener(FlexEvent.LOADING, 			onLoadStart);
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ModuleEvent.READY, 			onModuleInitialized);
				component.removeEventListener(ModuleEvent.PROGRESS, 		onModuleLoadProgress);
				component.removeEventListener(ModuleEvent.SETUP,			onModuleLoadComplete);
				component.removeEventListener(ModuleEvent.ERROR,			onModuleLoadError);
				component.removeEventListener(ModuleEvent.UNLOAD,			onModuleRemoved);
				component.removeEventListener(FlexEvent.LOADING, 			onLoadStart);
			}
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				
				case TTUConstants.SEND_MESSAGE_TO_MODULE:
					var message:ModulePipeMessage = note.getBody() as ModulePipeMessage;
					if(message && (message.contentType == MessageConstants.PAUSE_MODULE) &&( !Boolean(message.getBody())) && component.module)
						UIComponent(component.module).setFocus();
					break;
				
				case TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW:
				{
					if(component.module)
						UIComponent(component.module).setFocus();
					break;
				}
				case TTUConstants.LOAD_MODULE:
					loadModule(note.getBody() as String);
					break;
				case TTUConstants.UNLOAD_MODULE:
					unoadModule();
					break;
				case TTUConstants.RELOAD_MODULE:
					var url:String = note.getBody() as String;
					if(url)
						loadModule(url);
					else if(!url && component.url)
						loadModule(component.url);
				case TTUConstants.SHOW_MODULE:
					if(component.module != null)
					{
						component.visible = true;
					}
					else
					{
						sendNotification(TTUConstants.NAVIGATION_CHANGED);
					}
					break;	 
				
				case TTUConstants.HIDE_MODULE_LOADER:
					component.visible = false;
					break;  	
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.LOAD_MODULE,
				TTUConstants.UNLOAD_MODULE,
				TTUConstants.HIDE_MODULE_LOADER,
				TTUConstants.SHOW_MODULE,
				TTUConstants.RELOAD_MODULE,
				TTUConstants.SEND_MESSAGE_TO_MODULE,
				TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW];
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
		/**
		 * @private 
		 * Handler for <code>ModuleEvent.PROGRESS</code>
		 * Listens to event and sends <code>TTUConstants.LOAD_PROGRESS</code>
		 * notification, telling <code>LoadProgressBarMediator</code> to update progressbar
		 */
		
		private function onModuleLoadProgress(event:ModuleEvent):void
		{
			sendNotification(TTUConstants.LOAD_PROGRESS,event);
		}
		/**
		 * @private 
		 * Handler for <code>ModuleEvent.SETUP</code>
		 * Listens to event and sends <code>TTUConstants.LOAD_COMPLETE</code>
		 * notification, telling <code>PopupMediator</code> to remove progressbar
		 */
		private function onModuleLoadComplete(event:ModuleEvent):void
		{
			sendNotification(TTUConstants.LOAD_END);
		}
		
		/**
		 * @private 
		 * Handler for <code>ModuleEvent.ERROR</code>
		 * Listens to event and sends <code>TTUConstants.LOAD_ERROR</code>
		 * notification, telling <code>PopupMediator</code> to remove progressbar
		 */
		private function onModuleLoadError(event:ModuleEvent):void
		{
			sendNotification(TTUConstants.LOAD_END);
			var errorText : String = event.errorText;
			/*if(errorText.indexOf("URL:") != -1)
			errorText = errorText.substring(errorText.indexOf("URL:")+4);
			var str:String =  resourceProxy.getLocale("ioError");
			str  = str ? str + errorText : errorText;*/
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW,errorText);
		}
		/**
		 * @private 
		 * Handler for <code>ModuleEvent.READY</code>
		 * Listens to event, computes <code>isAssessment</code> property of
		 * <code>UnitDataProxy</code>, sets <code>currentLessonIndex</code> 
		 * and <code>currentActivityIndex</code>  of <code>UnitDataProxy</code>
		 * and sends <code>TTUConstants.MODULE_ADDED</code> notification
		 */
		private function onModuleInitialized(event:Event):void
		{
			if(component.module)
			{
				sendNotification(TTUConstants.MODULE_ADDED, component.module);
			}
			else
			{
				sendNotification(TTUConstants.LOAD_END);
				var str:String =  "Error, could not create module from loaded SWF";
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW,str);
			}
		}
		/**
		 * @private 
		 * Handler for <code>moduleRemoved</code> event.
		 * Listens to event and sends <code>TTUConstants.MODULE_REMOVED</code>
		 * notification
		 */
		private function onModuleRemoved(event:ModuleEvent):void
		{
			sendNotification(TTUConstants.MODULE_REMOVED);
		}
		/**
		 * @private
		 * Utility fucntion for defining indexes and loading module
		 */ 
		private function loadModule(url:String):void
		{
			if(url)
			{
				component.visible = true;
				if(isAir && url.indexOf(APP_FOLDER) == -1)
					url = APP_FOLDER + url;
				component.load(url);
			}
			
		} 
		
		/**
		 * @private
		 * Utility fucntion for unloading module
		 */ 
		private function unoadModule():void
		{
			if(component && component.module)
			{
				component.unloadModule();
			}
		} 
		/**
		 *  @private 
		 *  Handler for <code>ActivityLoader.LOAD_START</code> event.
		 *  Listens to event and sends <code>component.LOAD_STARTED</code>
		 *  notification, which is used by <code>PopupMediator</code>
		 *  to display progresbar
		 */
		private function onLoadStart(event:FlexEvent):void
		{
			sendNotification(TTUConstants.LOAD_START);
		}
		
	}
}