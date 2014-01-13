////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 13, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.model.resource
{
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.events.ResourceEvent;
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.AppBaseProxy;
	
	/**
	 * ResourceProxy class 
	 */
	public class ResourceProxy extends AppBaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "ResourceProxy";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 * Storage for resourceManager property   
		 */
		
		private var resourceManager:IResourceManager;
		
		/**
		 * Storage for added bundles 
		 */
		private var bundles:Array;
		
		/**
		 * Storage rootPath of locale swf 
		 */
		
		public var rootPath:String="";
		/**
		 * Storage for added bundles 
		 */
		private var eventDispatcher:IEventDispatcher;
		/**
		 * State of the loader. Since loader does not haveany property 
		 * which indicates if it is loading or not, we need to keep track of its state 
		 */
		private var isLoading:Boolean = false;
		private var resourceName:String = "player";
		/**
		 * Storage URL of locale swf 
		 */
		
		public var url:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ResourceProxy 
		 */
		public function ResourceProxy(bundleName:String="ttu_rb",  rootPath:String="")
		{
			super(NAME);
			this.bundleName = bundleName;
			this.rootPath 	= rootPath;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _locale:String = 'en_US';

		public function get locale():String
		{
			return _locale;
		}

		public function set locale(value:String):void
		{
			if( _locale !== value)
			{
				_locale = value;
			}
		}

		//------------------------------------------------------
		// bundleName
		//------------------------------------------------------
		private var _bundleName:String = "ttu_rb"; 
		
		public function get bundleName():String
		{
			return _bundleName;
		}
		
		public function set bundleName(value:String):void
		{
			_bundleName = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override public function onRegister() : void
		{
			super.onRegister();
			var params:Object = FlexGlobals.topLevelApplication.parameters;
			if(params && params.locale && params.locale != "")
				locale =  params.locale||"en_US";
			resourceManager = ResourceManager.getInstance(); 
			bundles = [];
			load();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove() : void
		{
			if(url && url.indexOf("rb.swf") != -1)
				resourceManager.unloadResourceModule(url);
			removeAddedBundles();
			resourceManager = null;
			removeLoaderListeners();
			eventDispatcher = null;
			bundles = null;
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
		 * Adds the specified ResourceBundle to the ResoureManager
		 *  @param bundle An instance of IresourceBundle
		 */
		public function addResourceBundle(bundle:IResourceBundle):void
		{
			if(resourceManager)
			{
				resourceManager.addResourceBundle(bundle);
				if(bundles.indexOf(bundle.bundleName) == -1)
					bundles.push(bundle.bundleName);
				update();
			}
		}
		
		/**
		 *  Calls <code>update</code> methiod of ResourceManager, which dispatches a <code>change</code> event
		 */	
		public function update() :void 
		{
			resourceManager.update();
		}
		
		/**
		 *  @private
		 */
		
		/**
		 * Removes all bundles added with this proxy 
		 */
		private function removeAddedBundles():void
		{
			for(var i:int = 0; i< bundles.length; i++)
			{
				removeResourceBundle(locale, bundles[i]);
			}
			bundles = null;
		}
		
		/**
		 *  Removes the specified ResourceBundle from the ResourceManager
		 *  so that its resources can no longer be accessed by ResourceManager
		 *  methods such as <code>getString()</code>.
		 */
		public function removeResourceBundle(locale:String, bundleName:String):void
		{
			if(resourceManager)
			{
				resourceManager.removeResourceBundle(locale,bundleName );
			}
		}
		
		
		/**
		 * Unloads current resource bundle and sends notification to invoke loading new resource bundle
		 */
		public function load(localeName:String=null, bundleName:String = null) :void 
		{
			if(localeName)
				locale = localeName;
			
			if(bundleName)
				this.bundleName = bundleName;
			
			resourceName = this.bundleName.split("_")[0];
			
			if(url && url.indexOf("rb.swf") != -1)
				resourceManager.unloadResourceModule(url);
			resourceManager.localeChain = [locale];
			url = rootPath + "locale/" + locale + "/" + this.bundleName +".swf";
			
			sendNotification( TTUConstants.LOAD_START);
			sendNotification( TTUConstants.RESOURCE_LOAD_START);
			eventDispatcher = ResourceManager.getInstance().loadResourceModule(url);
			
			eventDispatcher.addEventListener(ResourceEvent.ERROR, 		onLoadError);
			eventDispatcher.addEventListener(ResourceEvent.COMPLETE, 	onLoadComplete);
			eventDispatcher.addEventListener(ResourceEvent.PROGRESS, 	onLoadProgress);
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
		 * @private
		 * Listens to COMPLETE event and notifies aboud completion of the load
		 * This deos not mean that locales and rources are available yet,
		 * because ResourceManager needs to get data and put it in its dictionaries
		 * Use <code>LOCALE_CHANGE</code> notification to change locales  
		 * 
		 */ 
		private function onLoadComplete(event:ResourceEvent):void 
		{
			isLoading = false;
			removeLoaderListeners();
			ResourceManager.getInstance().localeChain = [ _locale ];
			update();
			sendNotification(TTUConstants.LOCALE_CHANGED, "");
			sendNotification(TTUConstants.RESOURCE_LOAD_END);
			sendNotification(TTUConstants.LOAD_END);
		}
		/**
		 * @private
		 */
		private function onLoadError(event:ResourceEvent):void 
		{
			isLoading = false;
			removeLoaderListeners();
			sendNotification(TTUConstants.LOAD_END)
			sendNotification( TTUConstants.SHOW_ERROR_WINDOW, event.errorText);
		}
		
		/**
		 * @private
		 */
		private function onLoadProgress(event:ResourceEvent):void 
		{
			isLoading = true;
			sendNotification(TTUConstants.LOAD_PROGRESS, event);
		}
		
		/**
		 * 
		 * @private
		 * Removes event listeners of resourceManager 
		 */
		private function removeLoaderListeners():void
		{
			if(eventDispatcher)
			{
				eventDispatcher.removeEventListener(ResourceEvent.ERROR, 	onLoadError);
				eventDispatcher.removeEventListener(ResourceEvent.COMPLETE, onLoadComplete);
				eventDispatcher.removeEventListener(ResourceEvent.PROGRESS, onLoadProgress);
			}
			
		}
		
		
		
	}
}