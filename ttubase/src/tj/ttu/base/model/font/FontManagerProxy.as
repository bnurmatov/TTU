////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 12, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.model.font
{
	import flash.system.Capabilities;
	import flash.text.engine.FontWeight;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	
	import mx.core.EmbeddedFont;
	import mx.core.FlexGlobals;
	import mx.core.IEmbeddedFontRegistry;
	import mx.core.IFlexModuleFactory;
	import mx.core.Singleton;
	import mx.core.UIComponent;
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.events.font.FontEvent;
	import tj.ttu.base.font.IFontManager;
	import tj.ttu.base.model.AppBaseProxy;
	
	/**
	 * FontManagerProxy class 
	 */
	public class FontManagerProxy extends AppBaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "FontManagerProxy";
		
		private static const FONT_URL:String = "fonts/";
		
		public static const APP_FOLDER:String = "app:/";
			
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * List of fonts which needs to be loaded 
		 */			
		private var fonts:Array;
		/**
		 * List of fonts which needs to be loaded 
		 */			
		private var loadedFonts:Array;
		
		/**
		 * Instance of IFontManager 
		 */		
		private var manager:IFontManager;
		
		/**
		 * State of the loader. Since loader does not haveany property 
		 * which indicates if it is loading or not, we need to keep track of its state 
		 */
		private var isLoading:Boolean = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * FontManagerProxy 
		 */
		public function FontManagerProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get resourceManager():IResourceManager
		{
			return ResourceManager.getInstance();
		}
		
		public function get baseFontUrl():String
		{
			if(isAir)
				return APP_FOLDER + FONT_URL;
			return FONT_URL;
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
			if(manager && isLoading)
				manager.close();
			removeListeners();
			fonts= null;
			manager = null;
			loadedFonts = null;
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
		/**
		 *	Loads fonts
		 *  @param url Url of module data
		 */		
		public function load(fontsToLoad:Array):void
		{
			if(!fontsToLoad || fontsToLoad.length == 0)
			{
				sendNotification(TTUConstants.LOAD_END);
				sendNotification( TTUConstants.SHOW_ERROR_WINDOW, resourceManager.getString('ttuComponents', 'fontIOError') || 'Font load error');
			}
			
			var len:int = fontsToLoad.length;
			if(!fonts)
				fonts = [];
			if(!loadedFonts)
				loadedFonts = [];
			for (var i:int = 0; i < len; i++)
			{
				addFontUrl(fontsToLoad[i], fonts);
				
			}
			if(fonts.length == 0)
			{
				sendCompleteNotification();
			}
			else if(!manager)
			{
				//try to get instance of font manager if it is registered with main app
				//otherwise register it here and use it
				try
				{
					manager = IFontManager(Singleton.getInstance("tj.ttu.base.font::IFontManager"));
				}
				catch(e:Error)
				{
					Singleton.registerClass("tj.ttu.base.font::IFontManager",	Class(getDefinitionByName("tj.ttu.base.font::FontManager")));
					manager = IFontManager(Singleton.getInstance("tj.ttu.base.font::IFontManager"));
				}
				manager.addEventListener(FontEvent.FONT_LOAD_ERROR, errorHandler);
				manager.addEventListener(FontEvent.FONT_REGISTERED, loaderCompleteHandler);
				manager.addEventListener(FontEvent.FONT_LOAD_PROGRESS,onFontLoadProgress);
				loadFont(fonts.shift());
			}
			else if(manager && !isLoading)
			{
				loadFont(fonts.shift());
			}
		}
		
		
		private function loadFont(fontUrl:String):void
		{
			manager.load(fontUrl);
		}
		
		
		
		/**
		 *  @private
		 */		
		private function removeListeners():void
		{
			if(manager)
			{
				manager.removeEventListener(FontEvent.FONT_LOAD_ERROR, errorHandler);
				manager.removeEventListener(FontEvent.FONT_REGISTERED, loaderCompleteHandler);
				manager.removeEventListener(FontEvent.FONT_LOAD_PROGRESS,onFontLoadProgress);
			}
		}
		
		/**
		 *  @private
		 */	
		private function getFontNameFormURL(url:String):String
		{
			var  fontPat:RegExp = /fonts\//ig;
			var swfPat:RegExp = /\.swf/ig;
			url = url.replace(fontPat, "");
			url = url.replace(swfPat, "");
			return url;
		}
		
		/**
		 *  @private
		 */	
		private function sendCompleteNotification():void
		{
			addAllFontBundle();
			sendNotification(TTUConstants.LOAD_END);
			sendNotification(TTUConstants.FONT_LOADED, loadedFonts[loadedFonts.length-1]); 
		}
		
		/**
		 *  @private
		 * 
		 */	
		private function addFontUrl(fontUrl:String, fontUrls:Array):void
		{
			if(!fontUrl)
				return;
			
			fontUrl = getFontNameFormURL(fontUrl);
			
			if((loadedFonts.indexOf(fontUrl) == -1) && (fontUrls.indexOf(fontUrl) == -1) && (fontUrls.indexOf(baseFontUrl + fontUrl + ".swf") == -1))
			{
				fontUrls.push(baseFontUrl + fontUrl + ".swf");
			}
		}
		/**
		 *  @private
		 * 
		 */	
		public function addAllFontBundle():void
		{
			if(resourceProxy)
			{
				var bundle:IResourceBundle = new ResourceBundle(resourceProxy.locale || "en_US", "font");
				
				bundle.content[FontConstants.UI_FONT] 		= configProxy.uiFont;
				bundle.content[FontConstants.UI_DIRECTION]	= configProxy.uiDirection;
				
				//Tajiki
				bundle.content[FontConstants.TJ_FONT] 			= configProxy.tjLanguageFont||"Cyrillic";
				bundle.content[FontConstants.TJ_DIRECTION] 		= configProxy.tjLanguageDirection;
				bundle.content[FontConstants.TJ_LANGUAGE_NAME] 	= configProxy.tjLanguageName;
				bundle.content[FontConstants.TJ_LANGUAGE_CODE] 	= configProxy.tjLanguageCode;
				bundle.content[FontConstants.TJ_FONT_SIZE] 		= 14;
				bundle.content[FontConstants.TJ_TEXT_ALIGN] 	= configProxy.tjLanguageDirection == Direction.RTL ? TextAlign.RIGHT : TextAlign.LEFT;
				
				//Russian
				bundle.content[FontConstants.RU_FONT] 			= configProxy.ruLanguageFont||"Russian";
				bundle.content[FontConstants.RU_DIRECTION] 		= configProxy.ruLanguageDirection;
				bundle.content[FontConstants.RU_LANGUAGE_NAME] 	= configProxy.ruLanguageName;
				bundle.content[FontConstants.RU_LANGUAGE_CODE] 	= configProxy.ruLanguageCode;
				bundle.content[FontConstants.RU_FONT_SIZE] 		= 14;
				bundle.content[FontConstants.RU_TEXT_ALIGN] 	= configProxy.ruLanguageDirection == Direction.RTL ? TextAlign.RIGHT : TextAlign.LEFT;
				
				//English
				bundle.content[FontConstants.EN_FONT] 			= configProxy.enLanguageFont||"Latin";
				bundle.content[FontConstants.EN_DIRECTION] 		= configProxy.enLanguageDirection;
				bundle.content[FontConstants.EN_LANGUAGE_NAME] 	= configProxy.enLanguageName;
				bundle.content[FontConstants.EN_LANGUAGE_CODE] 	= configProxy.enLanguageCode;
				bundle.content[FontConstants.EN_FONT_SIZE] 		= 14;
				bundle.content[FontConstants.EN_TEXT_ALIGN] 	= configProxy.enLanguageDirection == Direction.RTL ? TextAlign.RIGHT : TextAlign.LEFT;
				
				resourceProxy.addResourceBundle(bundle);
				setGlobalStyle(configProxy.uiFont, ".uiFont");
				resourceManager.update();
			}
		}
		
		private function setGlobalStyle(fontName:String, selectorName:String):void
		{
			var app:IFlexModuleFactory = UIComponent(FlexGlobals.topLevelApplication).moduleFactory as IFlexModuleFactory;
			var styleManager:IStyleManager2 = StyleManager.getStyleManager(app);
			var cssCustom:CSSStyleDeclaration;
			var styleChanged:Boolean = false;
			var toolTipCSS:CSSStyleDeclaration = styleManager.getStyleDeclaration("mx.controls.ToolTip");
			if(toolTipCSS)
			{
				if(toolTipCSS.getStyle("fontFamily") != configProxy.uiFont)
				{
					toolTipCSS.setStyle( "fontFamily", configProxy.uiFont );
				}
			}
			
			
				var font:EmbeddedFont = hasFont(fontName);
				if(font)
				{
					try
					{
						cssCustom = styleManager.getStyleDeclaration("spark.components.Label");
						if(cssCustom)
						{
							styleChanged = false;
							if(cssCustom.getStyle("fontFamily") != fontName)
							{
								styleChanged = true;
								cssCustom.setStyle( "fontFamily", fontName );
							}
							if(styleChanged)
								styleManager.setStyleDeclaration("spark.components.Label", cssCustom, true);
						}
						else if(!cssCustom)
						{
							cssCustom = new CSSStyleDeclaration("spark.components.Label");
							cssCustom.setStyle( "fontFamily", fontName );
							styleManager.setStyleDeclaration("spark.components.Label", cssCustom, true);
						}
					}
					catch(e:Error){}
					
					try
					{
						cssCustom = styleManager.getStyleDeclaration(selectorName);
						if(cssCustom)
						{
							styleChanged = false;
							if(cssCustom.getStyle("fontFamily") != fontName)
							{
								styleChanged = true;
								cssCustom.setStyle( "fontFamily", fontName );
							}
							if(styleChanged)
								styleManager.setStyleDeclaration(selectorName, cssCustom, true);
						}
						else if(!cssCustom)
						{
							cssCustom = new CSSStyleDeclaration(selectorName);
							cssCustom.setStyle( "fontFamily", fontName );
							styleManager.setStyleDeclaration(selectorName, cssCustom, true);
						}
					}
					catch(e:Error){}
					
					
				}
		}
		
		/**
		 * @private
		 */	
		
		private function hasFont(name:String):EmbeddedFont
		{
			var registry:IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
			var fonts:Array = registry.getFonts();
			var isFontExists:Boolean = false;
			var isBold:Boolean = false;
			for each (var font:EmbeddedFont in fonts) 
			{
				if(font.fontName == name)
				{
					isFontExists = true;
					isBold = !isBold ? font.bold : true;
				}
			}
			return isFontExists ? new EmbeddedFont(name, isBold, false) : null;
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
		 * Listens to COMPLETE event and notifies aboud availability of font
		 */ 
		private function loaderCompleteHandler(event:FontEvent):void 
		{
			isLoading = false;
			if(loadedFonts.indexOf(event.fontName) == -1)
				loadedFonts.push(event.fontName);
			
			if(fonts.length > 0)
			{
				loadFont(fonts.shift());
			}
			else
			{
				sendCompleteNotification();
			}
		}
		
		
		/**
		 * @private
		 * @param event
		 * 
		 */		
		private function onFontLoadProgress(event:FontEvent):void 
		{
			isLoading = true;
			sendNotification(TTUConstants.LOAD_PROGRESS, event);
			
		}
		/**
		 * @private
		 * @param event
		 * 
		 */		
		private function errorHandler(event:FontEvent):void 
		{
			isLoading = false;
			if(fonts.length > 0)
			{
				loadFont(fonts.shift());
			}
			else if(loadedFonts.length >0)
			{
				sendCompleteNotification();
			}
			else
			{
				sendNotification(TTUConstants.LOAD_END);
				var str:String = resourceManager.getString('ttuComponents', 'fontIOError') || 'Font load error';
				str = str ? str + " : " + event.text : event.text;
				sendNotification( TTUConstants.SHOW_ERROR_WINDOW,  str);
			}
		}
		
		
	}
}