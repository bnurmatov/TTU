////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.ModuleConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	import tj.ttu.moduleUtility.utils.messages.ScoreMessage;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	
	/**
	 * LoadXMLProxy class 
	 */
	public class LoadXMLProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "LoadXMLProxy";
		
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
		 * LoadXMLProxy 
		 */
		public function LoadXMLProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var url:String;
		
		private var errorString:String = "";
		
		/**
		 * Instance of <code>loader</code> 
		 */		
		private var loader:URLLoader;
		
		/**
		 * State of the loader. Since loader does not haveany property 
		 * which indicates if it is loading or not, we need to keep track of its state 
		 */
		private var isLoading:Boolean = false;
		
		private function get isAir():Boolean
		{
			return Capabilities.playerType == "Desktop";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			if (loader && isLoading)
				loader.close();
			
			removeLoaderListeners();
			loader = null;
			
			super.onRemove();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads xml from specifyed url.
		 * 
		 * @param	url	xml file URL.
		 */
		public function load(url:String):void
		{
			if (!url)
			{
				errorString = "";
				sendErrorAndDispose();
				return;
			}
			
			if (loader && isLoading)
			{
				loader.close();
			}
			
			if(isAir && url.indexOf(APP_FOLDER) == -1)
				url = APP_FOLDER + url;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			
			loader.load(new URLRequest(url));
		}
		
		/**
		 * @private
		 */
		protected function dispose():void
		{
			facade.removeProxy(NAME);
		}
		
		private function sendErrorAndDispose():void
		{
			dispose();
			var messageText:String = ResourceManager.getInstance().getString("activities_utility", "moduleDataError");
			var msg:ModuleMessage = new ModuleMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, MessageConstants.MODULE_ERROR, messageText);
			sendNotification(ModuleConstants.SEND_MESSAGE_TO_SHELL, msg);
			
			var secondMsg:ScoreMessage = new ScoreMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, MessageConstants.MODULE_COMPLETED, new ScoreVO());
			sendNotification(ModuleConstants.SEND_MESSAGE_TO_SHELL, secondMsg);
		}
		
		/**
		 * @private 
		 */		
		private function removeLoaderListeners():void
		{
			if(loader)
			{
				loader.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
				loader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			}
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */		
		private function onLoadComplete(event : Event):void
		{
			var loaderData:Object = loader ? loader.data : null;
			var s:String = loaderData.toString();
			isLoading = false;
			dispose();
			
			sendNotification(ModuleConstants.XML_LOADED, s);
		}
		
		/**
		 * @private 
		 */		
		private function onLoadError(event : Event):void
		{
			isLoading = false;
			if(event is IOErrorEvent)
			{
				errorString = url;
			}
				
			else if(event is SecurityErrorEvent)
			{
				errorString = SecurityErrorEvent(event).text;
			}
			
			sendErrorAndDispose();
		}
		
		/**
		 * @private 
		 */		
		private function onLoadProgress(event : Event):void
		{
			isLoading = true;
		}

		
		
	}
}