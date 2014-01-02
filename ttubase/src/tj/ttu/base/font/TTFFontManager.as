////////////////////////////////////////////////////////////////////////////////
// Copyright May 6, 2013, Tajik Technical University
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
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.describeType;
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	
	/**
	 * EmbeddedFontManager manages loading and registing fonts in an application. This class should be registered in main application, 
	 * and than any child application can call its load method to load and register a font.
	 * 
	 */
	public class TTFFontManager extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
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
		
		public var fonts:Array;
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function getFont(fontName:String):Class
		{
			return fonts[fontName]
		}
		
		/**
		 * Stops loading the font and removes listeners
		 * Somethimes may be it is need to stop loading an asset therfore we need to call close method of loader 
		 */		
		public function close():void
		{
			if(loader)
				removeListeners();
		}
		
		/**
		 * Starts loading a font. Poulates fontName property from given url.
		 * <p>If loading of another font is in progress, url is put in queue, o
		 * therwise starts loading of url.</p>  
		 * @param fontURL url of a swf file containig the font which need to be loaded
		 * 
		 */		
		public function load(urls:Array):void
		{
			if(!fonts)
				fonts = [];
			if(!fontsTobeLoaded)
				fontsTobeLoaded = new Vector.<String>();
			
			addUrls(urls);
			
			if(!isLoading)
				loadFont(fontsTobeLoaded.shift());
		}
		
		
		private function loadFont(fontUrl:String):void
		{
			var request:URLRequest = new URLRequest(fontUrl);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onFontLoadProgress);
			loader.load(request);
		}		
		/**
		 * @private
		 * Handler for <code>Event.COMPLETE</code> of loader.
		 */ 
		private function loaderCompleteHandler(event:Event):void 
		{
			isLoading = false;
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			var loaderInfoUrl:String = info.url;
			
			var fontName:String = loaderInfoUrl.substring(loaderInfoUrl.lastIndexOf("/")+1, loaderInfoUrl.lastIndexOf("."));
			var fontClass:Class;
			if(info.applicationDomain.hasDefinition("ttfForPdf."+fontName))
			{	
				fontClass = info.applicationDomain.getDefinition("ttfForPdf."+fontName) as Class;
				if(fontClass)
					registerFont(fontClass);
				
			}
			else if(info.applicationDomain.hasDefinition(fontName))
			{
				fontClass = info.applicationDomain.getDefinition(fontName) as Class;
				if(fontClass)
					registerFont(fontClass);
			}
			removeListeners();
			loadNextOrComplete();
		}
		
		/**
		 * @private
		 * Checks if there is pendind font in queue qwhich needs to be loaded and
		 * if there is starts loading next font in queue, otherwise, dispatches 
		 *  <code>FontEvent.FONT_REGISTERED</code> event.
		 */ 
		private function loadNextOrComplete():void
		{
			isLoading = false;
			if(fontsTobeLoaded && fontsTobeLoaded.length >0)
			{
				loadFont( fontsTobeLoaded.shift() );
			}
			else
			{
				fontsTobeLoaded = null;
				dispatchEvent(new Event(Event.COMPLETE));
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
			var classDesc:XML = describeType(fontClass)
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
						fonts[varItem.@name] = cls;
				}
			}
		}
		
		/**
		 * @private
		 * Handler for <code>ProgressEvent.PROGRESS</code> of <code>loaderInfo</code>
		 */		
		private function onFontLoadProgress(event:ProgressEvent):void 
		{
			isLoading = true;
			dispatchEvent( event.clone() );
		}
		
		
		
		/**
		 * @private
		 * Handler for <code>IOErrorEvent.IO_ERROR</code> of <code>loaderInfo</code>
		 */			
		
		private function errorHandler(event:IOErrorEvent):void 
		{
			isLoading = false; 
			removeListeners();
			fontsTobeLoaded = null;
			dispatchEvent( event.clone() );
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
				if(isLoading)
					loader.close();
				loader = null;
			}
		}
		
		/**
		 *  @private
		 */		
		private function addUrls(arr:Array):void
		{
			for each(var url:String in arr)
			{
				if(fontsTobeLoaded.indexOf(url) == -1)
					fontsTobeLoaded.push(url);
			}
		}
	}
}