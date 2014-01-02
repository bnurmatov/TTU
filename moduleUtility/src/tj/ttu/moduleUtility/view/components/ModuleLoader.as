////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.view.components
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.events.Request;
	
	import spark.components.Group;
	
	import tj.ttu.base.utils.MemoryLeakImport;
	import tj.ttu.moduleUtility.view.interfaces.IModule;
	import tj.ttu.moduleUtility.view.interfaces.IModuleLoader;
	
	/**
	 * ModuleLoader class 
	 */
	public class ModuleLoader extends Group implements IModuleLoader
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 *  @private
		 * Internal storage for loader
		 */ 
		private var loader:Loader;
		
		private var isLoading:Boolean = false;
		
		/**
		 *  @private
		 * Internal storage for isPending
		 */ 
		private var isPending:Boolean = false;
		
		private var imports:MemoryLeakImport;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ModuleLoader 
		 */
		public function ModuleLoader()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-------------------------------------------------------------------
		// module
		//-------------------------------------------------------------------
		private var _module:IModule;
		
		/**
		 *  @private
		 * Internal storage for module
		 */
		public function get module():IModule
		{
			return _module;
		}
		
		public function set module(value:IModule):void
		{
			_module = value;
		}
		
		
		//-------------------------------------------------------------------
		// url
		//-------------------------------------------------------------------
		private var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @inheritDoc
		 */		
		override public function removeElement(element:IVisualElement):IVisualElement
		{
			cleanUp();
			return super.removeElement(element);
		}
		
		
		/**
		 * @inheritDoc
		 */ 
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			dispatchEvent(new FlexEvent(value ? FlexEvent.SHOW : FlexEvent.HIDE));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function load(url:String):void
		{
			_url = url; 
			if(isLoading && loader)
			{
				try
				{
					loader.close();
				}
				catch(e:Error){}
			}
			
			if(module)
			{
				isPending = true;
				unloadModule();
			}
			else
			{
				loadModule();
			}
		}
		
		
		public function unloadModule():void
		{
			if(!module)
				return;
			if(stage)
				stage.focus = this;
			this.setFocus();
			module.dispose();
			
			loader.unloadAndStop(true);
			loader = null;
			if(module)
				removeElement(module as IVisualElement);
			module = null;
			
			if(isPending)
			{
				loadModule();
			}
			dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
			//forceGC();
		}
		
		/**
		 *  @private
		 */
		private function loadModule():void
		{
			dispatchEvent(new FlexEvent(FlexEvent.LOADING));
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain); 
			attachLoaderListeners();
			loader.load(new URLRequest(url), context);
		}
		
		/**
		 * @private
		 */ 
		private function cleanUp():void
		{
			detachLoaderListeners();
			_module = null;
			loader = null;
		}
		
		private function attachLoaderListeners():void
		{
			if(!loader)
				loader = new Loader();
			
			if(loader.contentLoaderInfo)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onModuleIOErrorHandler);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onModuleSecurityErrorHandler);
			}
		}
		
		private function detachLoaderListeners():void
		{
			if(loader && isLoading )
			{
				try
				{
					loader.close();
				}
				catch(e:Error){}
			}
			
			if(loader && loader.contentLoaderInfo)
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onModuleIOErrorHandler);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onModuleSecurityErrorHandler);
			}
		}
		
		private function attachLoaderContentListeners():void
		{
			try
			{
				loader.contentLoaderInfo.content.addEventListener(ModuleEvent.READY, onModuleReady);
				loader.contentLoaderInfo.content.addEventListener(ModuleEvent.ERROR, onModuleError);
				loader.contentLoaderInfo.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
					getFlexModuleFactoryRequestHandler, false, 0, true);    
				dispatchModuleEvent(ModuleEvent.SETUP);
			}
			catch(e:Error)
			{
				var errorEvent:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR,false, false, 0, 0, e.message)
				dispatchEvent(errorEvent);
			}
		}
		
		private function detachLoaderContentListeners():void
		{
			isPending = false;
			try
			{
				loader.contentLoaderInfo.content.removeEventListener(ModuleEvent.READY, onModuleReady);
				loader.contentLoaderInfo.content.removeEventListener(ModuleEvent.ERROR, onModuleError);
				loader.contentLoaderInfo.content.removeEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
					getFlexModuleFactoryRequestHandler, false);
			}
			catch(e:Error)
			{
				dispatchModuleErrorEvent(e.message);
			}
		}
		/**
		 *  @private
		 */
		private function dispatchModuleErrorEvent(errorText:String):void
		{
			var errorEvent:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR,false, false, 0, 0,errorText);
			dispatchEvent(errorEvent);
		}
		
		/**
		 * @private
		 */ 
		private function dispatchModuleEvent(type:String):void
		{
			var moduleEvent:ModuleEvent = new ModuleEvent(type, false, false,0,0);
			dispatchEvent(moduleEvent);
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
		/**
		 * @private
		 */ 
		private function onLoadComplete(event:Event): void 
		{
			isLoading = false;
			detachLoaderListeners();
			attachLoaderContentListeners();
		}
		
		/**
		 *  @private
		 */
		private function onLoadProgress(event:ProgressEvent):void
		{
			isLoading = true;
			var moduleEvent:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, event.bubbles, event.cancelable);
			moduleEvent.bytesLoaded = event.bytesLoaded;
			moduleEvent.bytesTotal = event.bytesTotal;
			dispatchEvent(moduleEvent);
		}
		
		/**
		 *  @private
		 */
		private function onModuleIOErrorHandler(event:IOErrorEvent):void
		{
			isLoading = false;
			detachLoaderListeners();
			dispatchModuleErrorEvent(event.text);
		}
		/**
		 *  @private
		 */
		private function onModuleSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			isLoading = false;
			detachLoaderListeners();
			dispatchModuleErrorEvent(event.text);
		}
		
		public function getFlexModuleFactoryRequestHandler(request:Request):void
		{
			request.value = this.moduleFactory;
		}
		
		/**
		 * @private
		 */ 
		private function onModuleReady(event:Event): void 
		{
			detachLoaderContentListeners();
			var factory:IFlexModuleFactory = IFlexModuleFactory(event.target);
			module = factory.create() as IModule;
			if(module)
			{
				var el:IVisualElement = module as IVisualElement;
				if(el)
				{
					el.percentHeight = 100;
					el.percentWidth = 100;
					addElement(el);
					dispatchModuleEvent(ModuleEvent.READY);
				}
			}
			else
			{
				dispatchModuleErrorEvent("Can not create module");
			}
		}
		
		private function onModuleError(event:Event):void
		{
			detachLoaderContentListeners();
		}
	}
}