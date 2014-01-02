////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 12, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.font
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.describeType;
	
	import mx.core.EmbeddedFont;
	import mx.core.EmbeddedFontRegistry;
	import mx.core.FlexGlobals;
	import mx.core.IEmbeddedFontRegistry;
	import mx.core.Singleton;
	import mx.core.UIComponent;
	
	import tj.ttu.base.events.font.FontEvent;
	
	
	/**
	 *  Dispatched when the font is loaded and registered
	 *  @eventType tj.ttu.base.events.font.FontEvent.FONT_LOAD_PROGRESS
	 */ 
	[Event(name="fontRegistered", type="tj.ttu.base.events.font.FontEvent")]
	
	/**
	 *  Dispatched while font swf is loading
	 *  @eventType tj.ttu.base.events.font.FontEvent.FONT_LOAD_PROGRESS
	 */ 
	
	[Event(name="fontLoadProgress", type="tj.ttu.base.events.font.FontEvent")]
	
	/**
	 *  Dispatched when a file error occured duraing the loading
	 *  @eventType tj.ttu.base.events.font.FontEvent.FONT_LOAD_ERROR
	 */ 
	[Event(name="fontLoadError", type="tj.ttu.base.events.font.FontEvent")]
	
	
	/**
	 * FontManager class 
	 */
	public class FontManager extends EventDispatcher implements IFontManager
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
		 * Internal storage for singleton instance of the class
		 */
		private static var instance:FontManager;
		
		/**
		 *@private 
		 *  Inernal storage for <code>fontName</code> property 
		 */		
		private var fontName:String;
		
		/**
		 *  @private 
		 *  Inernal storage for <code>loader</code> property 
		 */
		
		private var loader : Loader; 
		/**
		 * Internal property for keeping track of loading process.
		 * If load method is called but loading of another font is in process,
		 * puts  url of new font in queue.  
		 */		
		private var isLoading:Boolean = false;
		
		/**
		 * Internal storage for urls. It serves as queue for loading fonts
		 */
		private var fontsTobeLoaded:Vector.<String>;
		
		private var allTobeLoaded:Vector.<String>;
		
		private var loadInProgress:Boolean;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * FontManager 
		 */
		public function FontManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Singelton method. If class is already instantinated returns created instance,
		 * otherwise ccreates and returns it. 
		 */
		public static function getInstance():FontManager
		{
			if (!instance)
				instance = new FontManager();
			
			return instance;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		/**
		 * Stops loading the font and removes listeners
		 * Somethimes may be it is need to stop loading an asset therfore we need to call close method of loader 
		 */		
		public function close():void
		{
			if(loader)
			{
				removeListeners();
				if(isLoading)
				{
					try
					{
						loader.close();
					}
					catch(e:Error){}
					
				}
				loader = null;
			}
		}
		
		/**
		 * Starts loading a font. Poulates fontName property from given url.
		 * <p>If loading of another font is in progress, url is put in queue, o
		 * therwise starts loading of url.</p>  
		 * @param fontURL url of a swf file containig the font which need to be loaded
		 * 
		 */		
		public function load(fontURL:String):void
		{
			if(loadInProgress)
			{
				if(!fontsTobeLoaded)
				{
					fontsTobeLoaded = new Vector.<String>();
					allTobeLoaded = new Vector.<String>();
				}
				
				if(allTobeLoaded.indexOf(fontURL) == -1)
				{
					fontsTobeLoaded.push(fontURL);
					allTobeLoaded.push(fontURL);
				}
			}
			else
			{
				loadInProgress = true;
				var curFontName:String = fontURL.substring(fontURL.lastIndexOf("/")+1, fontURL.lastIndexOf("."));
				if(fontExists(curFontName))
				{
					loadNextOrComplete(curFontName);
				}
				else
				{
					var request:URLRequest = new URLRequest(fontURL);
					loader  = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onFontLoadProgress);
					loader.load(request);
				}
			}
		}
		
		/**
		 *  @private
		 */
		/**
		 * @private
		 * Checks if there is pendind font in queue qwhich needs to be loaded and
		 * if there is starts loading next font in queue, otherwise, dispatches 
		 *  <code>FontEvent.FONT_REGISTERED</code> event.
		 */ 
		private function loadNextOrComplete(curFont:String):void
		{
			isLoading = false;
			loadInProgress = false;
			removeListeners();
			dispatchEvent(new FontEvent(FontEvent.FONT_REGISTERED,false, false, curFont ));
			
			if(fontsTobeLoaded && fontsTobeLoaded.length >0)
			{
				load(fontsTobeLoaded.shift());
			}
			else
			{
				fontsTobeLoaded = null;
				dispatchEvent(new FontEvent(FontEvent.COMPLETE)); 
			}
		}
		
		/**
		 * Registers the font by getting its description using <code>describeType</code> method.
		 * 
		 * @param fontClass Font class retrieved from <code>Loader</code>
		 * 
		 */		
		private function registerFont(fontClass:Class):void
		{
			var app:UIComponent = FlexGlobals.topLevelApplication as UIComponent;
			
			var registry:IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
			
			var classDesc:XML = describeType(fontClass)
			var className:String = 	classDesc.@name;
			if (classDesc && classDesc.variable)
			{
				var variables:XMLList = classDesc.variable;
				for each(var varItem:XML in variables)
				{
					var bold:Boolean = false;
					var italic:Boolean = false;
					var name:String = 	String(varItem.@name).toLowerCase();	
					if(name.indexOf(FontWeight.BOLD) != -1)
						bold = true;
					else if(name.indexOf(FontPosture.ITALIC) != -1)
						italic = true;
					var cls:Class =  fontClass[varItem.@name];
					if(cls)
						Font.registerFont(cls);
					registry.registerFont(new EmbeddedFont(className, bold, italic), app.moduleFactory);
				}
			}
		}
		
		
		/**
		 *  @private
		 * Removes listeners registered with the <code>loaderInfo</code>. 
		 */		
		private function removeListeners():void
		{
			if(loader)
			{
				if(loader.contentLoaderInfo)
				{
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onFontLoadProgress);
				}
				loader = null;
			}
		}
		
		
		/**
		 * 
		 * @private
		 * 
		 * Gets the list of embedded fonts and checks against given font name, 
		 * if there is a font with given font name returns <code>true</code>
		 * otherwise returns </false>.
		 *  
		 * @param name name of the font to be checked if it is exists or not
		 * @return <code>true</code> if it exists </false> otherwise. 
		 */		
		private function fontExists(name:String):Boolean
		{
			var arr:Array = Font.enumerateFonts();
			for(var i:int = 0; i< arr.length; i++)
			{
				var font:Font = arr[i] as Font;
				if(font.fontName == name)
				{
					return true;
				}
			}
			return false;
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
		 * Handler for <code>Event.COMPLETE</code> of loader.
		 */ 
		private function loaderCompleteHandler(event:Event):void 
		{
			var loaderInfoUrl:String = LoaderInfo(event.currentTarget).url;
			var curFont:String =  loaderInfoUrl.substring(loaderInfoUrl.lastIndexOf("/")+1, loaderInfoUrl.lastIndexOf("."));
			var fontClass:Class = event.target.applicationDomain.getDefinition(curFont) as Class;
			if(fontClass)
				registerFont(fontClass);
			loadNextOrComplete(curFont);
		}
		
		/**
		 * @private
		 * Handler for <code>ProgressEvent.PROGRESS</code> of <code>loaderInfo</code>
		 */		
		private function onFontLoadProgress(event:ProgressEvent):void 
		{
			isLoading = true;
			dispatchEvent(new FontEvent(FontEvent.FONT_LOAD_PROGRESS, false, false, fontName, event.bytesLoaded, event.bytesTotal)); 
		}
		
		
		
		/**
		 * @private
		 * Handler for <code>IOErrorEvent.IO_ERROR</code> of <code>loaderInfo</code>
		 */			
		
		private function errorHandler(event:IOErrorEvent):void 
		{
			isLoading = false;
			loadInProgress = false;
			removeListeners();
			dispatchEvent(new FontEvent(FontEvent.FONT_LOAD_ERROR, false, false, "", 0, 0,event.text));
			if(fontsTobeLoaded && fontsTobeLoaded.length >0)
			{
				load(fontsTobeLoaded.shift());
			}
			else
			{
				fontsTobeLoaded = null;
			}
		}
		
	}
}