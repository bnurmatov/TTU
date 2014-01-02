////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 13, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	/**
	 * LanguageInfoUtil class 
	 */
	public class LanguageInfoUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var languages:XML =<languages>
										<language code="ENGLISH" name="English"	flashLocale="en_US" contentCode="ENGus"  locale="eng_US" script="Latn"  font="Latin"/>
										<language code="RUSSIAN" name="Russian" flashLocale="ru_RU" contentCode="RUSru"  locale="rus_RU" script="Cyrl" 	font="Russian"/>
										<language code="TAJIKI"	 name="Tajiki"  flashLocale="tg_TJ" contentCode="TGKtj"  locale="tgk_TJ" script="Cyrl"  font="Cyrillic"/>
									</languages>;
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
		 * LanguageInfoUtil 
		 */
		public function LanguageInfoUtil()
		{
			if(instance != null) 
				throw new Error("Private constructor. Use LanguageManager.getInstance() instead.");
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * static instance of the class for singleton
		 */ 
		private static var instance : LanguageInfoUtil;
		
		//--------------------------------------------------------
		// Class Methods
		//--------------------------------------------------------
		/**
		 *  Class method for getting singleton insatnce of the class 
		 */ 
		public static function getInstance():LanguageInfoUtil
		{
			if(instance == null)
				instance = new LanguageInfoUtil();
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
		
		public function getLanguageNames():Array
		{
			var languageNames:Array = new Array();
			for each (var language:XML in languages.language)
			{
				var name:String = language.@name;
				if (name && name.length)
					languageNames.push(name);
			}
			return languageNames;
		}
		
		public function getFonts():Array
		{
			var fonts:Array = new Array();
			for each (var language:XML in languages.language)
			{
				var font:String = language.@font;
				if (font && font.length && (-1 == fonts.indexOf(font)))
					fonts.push(font);
			}
			fonts.sort();
			return fonts;
		}
		
		public function getLanguageNameByLocale(locale:String):String
		{
			if(isEmpty(locale))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			
			var xml:XML = getElementByAttribute("flashLocale", locale) ;
			
			return xml? xml.@name :null;
		}
		
		/**
		 * @param languageCode Language Code of the Language in question
		 * @return String Name of SFW font file for given language code 
		 */ 
		public function getLanguageCode(locale:String):String
		{
			if(isEmpty(locale))
				throw new ArgumentError("Parameter languageName can not be null or empty");
			
			var xml:XML = getElementByAttribute("flashLocale", locale) ;
			
			return xml? xml.@code : null;
		}
		
		
		/**
		 * Support for Flash globalization library. gets locale code which is used by flash golbalization for a selected language
		 * @param languageCode C of the Language in question
		 * @return flashLocale code for given Language 
		 */ 
		
		public function getFlashLocaleByLanguageCode(languageCode:String):String
		{
			if(isEmpty(languageCode))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			
			var xml:XML = getElementByAttribute("code", languageCode) ;
			
			return xml? xml.@flashLocale : null;
		}
		
		/**
		 * Retrieves content Code for given lanaguage
		 * @param languageCode C of the Language in question
		 * @return contentCode for given Language 
		 */ 
		
		public function getLocaleByLanguageCode(languageCode:String):String
		{
			if(isEmpty(languageCode))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			
			var xml:XML = getElementByAttribute("code", languageCode) ;
			
			return xml? xml.@locale : null;
		}
		
		/**
		 * @param languageName Language name of the Language in question
		 * @return Boolean <code>true</code> means that this language has <code>RTL</code> direction, 
		 * <code>false</code> means that this lanaguage has <code>LTR</code> direction. 
		 */ 
		
		public function getIsRTLByLocale(locale:String):Boolean
		{
			if(isEmpty(locale))
				throw new ArgumentError("Parameter languageName can not be null or empty");
			
			var xml:XML = getElementByAttribute("flashLocale", locale) ;
			
			return xml? xml.@rtl == "true" : false;
		}
		
		/**
		 * @param languageCode Language Code of the language in question
		 * @return Boolean <code>true</code> means that this language has <code>RTL</code> direction, 
		 * <code>false</code> means that this lanaguage has <code>LTR</code> direction. 
		 */ 
		
		public function getIsRTLByLanguageCode(languageCode:String):Boolean
		{
			if(isEmpty(languageCode))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			var xml:XML= getElementByAttribute("code", languageCode) ;
			
			return xml? xml.@rtl == "true" : false;
		}
		
		
		/**
		 * @param languageCode Language Code of the Language in question
		 * @return String Name of SFW font file for given language code 
		 */ 
		public function getFontByLocale(locale:String):String
		{
			if(isEmpty(locale))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			var xml:XML  = getElementByAttribute("flashLocale", locale) ;
			
			return xml ? xml.@font : null;
		}
		
		/**
		 * @param languageCode Language Code of the Language in question
		 * @return String Name of SFW font file for given language code 
		 */ 
		public function getFontByLanguageCode(languageCode:String):String
		{
			if(languageCode == "ENGLISH" )
				return "Latin";
			
			if(isEmpty(languageCode))
				throw new ArgumentError("Parameter languageCode can not be null or empty");
			var xml:XML  = getElementByAttribute("code", languageCode) ;
			
			return xml ? xml.@font : null;
		}
		
		
		/**
		 * @param languageCode Language Name of the Language in question
		 * @return String Name of SFW font file for given language name 
		 */ 
		
		public function getFontByLanguageName(languageName:String):String
		{
			if(isEmpty(languageName))
				throw new ArgumentError("Parameter languageName can not be null or empty");
			
			var xml:XML = getElementByAttribute("name", languageName) ;
			
			return xml ? xml.@font : null;
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
		 * A utility method for validating existence of given attibute in xml element 
		 * @param attrName Name of attribute
		 * @param param value of attribute
		 * @return xml contaning given attribute or <code>null</code>
		 */		
		
		private function getElementByAttribute(attrName:String, param:String):XML
		{
			var xml:XMLList = languages.language.(attribute(attrName) == param);
			return xml && xml.length()> 0 ? XML(xml[0]): null;
		}
		
		/**
		 * @private
		 */	
		private function isEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		
	}
}