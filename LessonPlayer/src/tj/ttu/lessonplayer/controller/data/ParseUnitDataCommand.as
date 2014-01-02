////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.controller.data
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.Icons;
	import tj.ttu.base.utils.LanguageInfoUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.LocaleVO;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.lessonplayer.controller.BaseCommand;
	import tj.ttu.lessonplayer.model.LessonPlayerProxy;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	
	/**
	 * ParseUnitDataCommand class 
	 */
	public class ParseUnitDataCommand extends BaseCommand
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ParseUnitDataCommand 
		 */
		public function ParseUnitDataCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _lessonPlayerProxy:LessonPlayerProxy;
		
		private function get lessonPlayerProxy():LessonPlayerProxy
		{
			if(!_lessonPlayerProxy)
				_lessonPlayerProxy = facade.retrieveProxy(LessonPlayerProxy.NAME) as LessonPlayerProxy;
			return _lessonPlayerProxy;
		}
		
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Loads  XML file for Unit
		 *  sends <code>LOAD_STARTED</code> notification used by
		 *  <code>PopupMedaitor</code> to dispaly Loading progress.
		 *  <p>Adds event listeners for <code>IOErrorEvent.IO_ERROR</code>,
		 *  <code>Event.COMPLETE</code>, <code>ProgressEvent.PROGRESS</code> events
		 *  and starts laoding of unit.xml</p>
		 *   
		 */
		override public function execute (note:INotification) :void 
		{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			var xml:XML 
			try
			{
				xml  = XML(note.getBody());
			}
			catch(e:Error)
			{
				sendError();
				return;
			}
			
			//TO DO move it to proxy
			if( !populateFromXML(xml))
				return;
			
			
			//we can set XML global properties back here since we finished parsing it
			XML.ignoreWhitespace = true;
			XML.prettyPrinting = true;
			
		}
		
		
		/**
		 * @private
		 * @param value XML Populates properties  with values from XML
		 * @example :
		 * name="Unit 15 At the Restaurant 1" 
		 * knownLanguage="ENGLISH" 
		 * learningLanguage="ITALIAN" 
		 * learningFontUrl="data/Italian.swf" 
		 * isRTL="false" translitFont="" 
		 * transliterated="false"
		 */		
		private function populateFromXML(value:XML):Boolean
		{
			var manager:LanguageInfoUtil = LanguageInfoUtil.getInstance();
			
			var locale:String = manager.getFlashLocaleByLanguageCode(value.@language);
			var localeVO:LocaleVO = new LocaleVO();
			localeVO.locale = locale;
			sendNotification(TTUConstants.LANGUAGE_CHANGE, localeVO);
			
			lessonPlayerProxy.unitName 					= TrimUtil.trim( value.@name);
			lessonPlayerProxy.unitDescription			= parseDescription( value)
			parseLessons(value);
			
			moduleProxy.isUnitHome = true;
			moduleProxy.isPaused = true;
			sendNotification(TTUConstants.UNIT_DATA_LOADED);
			
			return true;
		}
		
		
		
		/**
		 * The description of unit can be rich text or plain text.
		 * if it is rich text it should be in div element 
		 * @param xml unit xml
		 * @return String representation of unit description
		 * 
		 */		
		private function parseDescription(xml:XML):String
		{
			var desc:String;
			if(xml.hasOwnProperty("description") && ( xml.description.hasOwnProperty("div") ||  xml.description.hasOwnProperty("p"))) 
			{
				var xmlDesc:XMLList = xml.description;
				if(!xml.description.hasOwnProperty("div"))
				{
					var div:XML = <div/>;
					div.setChildren(  xml.description.children());
					desc = div;
				}
				else
				{
					desc = xmlDesc[0].div;
				}
			}
			else
			{
				desc = xml.description;
			}
			return desc;
		}
		/**
		 * The parsess units into UnitVo value objects
		 * @param xml unit xml
		 * @return Vector of UnitVo objects
		 * 
		 */		
		private function parseLessons(xml:XML):void
		{
			moduleProxy.backgroundImages = randomize(getUnitImages(xml));
			for each(var item:XML in xml.lesson)
			{
				moduleProxy.modules = parseLessonElement(item, moduleProxy.backgroundImages);
			}
		}
		
		
		
		/**
		 * Evaluates a string and retirns <code>true</code> if it is equalsto  'true' or <code>false</code> otherwise
		 * @param booleanString A string which is 'true' or ' false'
		 * @return Boolean representation of given string
		 */	
		private function getDefaultBoolean(booleanString:String):Boolean
		{
			if(booleanString =="true")
				return true;
			if(booleanString =="false")
				return false;
			return true;
		}
		/**
		 * Evaluates a string and retirns <code>true</code> if it is equalsto  'true' or <code>false</code> otherwise
		 * @param booleanString A string which is 'true' or ' false'
		 * @return Boolean representation of given string
		 */	
		private function getBooleanValue(booleanString:String):Boolean
		{
			if(booleanString =="true")
				return true;
			return false
		}
		
		/**
		 * @private
		 *  Sends error to main app
		 */		
		private function sendError():void
		{
			var errString:String ="unit Data  Error";
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, errString);
		}
		
		
		
		
		/**
		 * @private
		 *  Parses lesson elelemnt
		 */	
		private function  parseLessonElement(lessonElement:XML, images:Array):IList
		{
			var activities:IList = new ArrayCollection();
			var actList:XMLList = lessonElement.activity;
			var prevImage:String;
			for each (var actElement:XML in actList)
			{
				var backString:String;
				if (actElement.@backgroundImageUrl.toString().length > 0)
					backString = actElement.@backgroundImageUrl;
				else
					backString =  getRandomImage(images, prevImage);
				
				prevImage  = backString;
				
				var moduleVo:ModuleVO = parseActvitiy(actElement, backString);
				
				
				activities.addItem( moduleVo );
			}
			return activities;
		}
		/**
		 * @private
		 *  Parses activity elelemnt
		 */	
		private function parseActvitiy(activityElement:XML,backgroundString:String):ModuleVO
		{
			var moduleVo:ModuleVO 		= new ModuleVO();			
			moduleVo.isB4u 		 		= getBooleanValue(activityElement.@isB4u);
			moduleVo.name 			 	= activityElement.@name;			
			moduleVo.required		 	= getBooleanValue(activityElement.@required);
			moduleVo.dataURL		 	= File.applicationDirectory.url + getActivityURL(activityElement.@dataUrl, "");
			moduleVo.moduleURL		 	= File.applicationDirectory.url + activityElement.@module;
			
			moduleVo.moduleName	 		= moduleVo.moduleURL.substring(moduleVo.moduleURL.lastIndexOf("/")+1, moduleVo.moduleURL.lastIndexOf("."));
			moduleVo.activityType	 	= activityElement.@activityType;
			moduleVo.description	 	= activityElement.description;
			moduleVo.backgroundImageUrl = File.applicationDirectory.url + getActivityURL(backgroundString, "");
			moduleVo.icon    		 	= activityElement.@icon;
			moduleVo.icon = getIcon(moduleVo);
			
			
			if (moduleVo.description && moduleVo.description.length > 0)
			{
				moduleVo.description = moduleVo.description.replace(/^\s+/, "");
			}
			
			return moduleVo;
		}
		
		/**
		 * @private
		 */
		
		/**
		 * @private
		 *  Gets Icon class for a given activity
		 */
		private function getIcon(module:ModuleVO):Object
		{
			if (module.icon && (module.icon.length > 0))
				return Icons.getIcon(String(module.icon))
			else
				return Icons.getIcon(module.moduleName);
		}
		
		
		/**
		 * @private 
		 */	
		private function isEmpty(str:String):Boolean
		{
			return !str || TrimUtil.trim(str) == "";
		}
		/**
		 * @private 
		 */	
		private function getUnitImages(xml:XML):Array
		{
			var backgroundList:XMLList = xml.config.background.image;
			var backgroundArray:Array = [];
			for each (var image:XML in backgroundList)
			{
				if(!isEmpty(image.toString()))
					backgroundArray.push(image.toString());
			}
			return backgroundArray;
		}
		
		private function getRandomImage(array:Array, prevImage:String):String
		{
			var len:uint = array.length;
			if (len == 0 )
				return "";
			if(len == 1)
				return array[0];
			
			var ind:uint = Math.random() * len;
			
			while(array[ind] == prevImage)
			{
				ind = Math.random() * len;
			}
			return array[ind];
		}
		
		private function getActivityURL(str:String, baseURL:String):String
		{
			var pat:RegExp = /^\.\.\//ig;
			if(pat.test(str))
				return str.replace(pat, "");
			return str.charAt(0) == "/" ? str.substring(1) : baseURL + str;
		}
		
		
		/**
		 *  Randomizes elements in the array.
		 */
		public  function randomize(array:Array):Array
		{
			var arr:Array = array.concat();
			var randomizedArray:Array = new Array();
			while(arr.length>0)
			{
				var rnd:int = Math.random()*arr.length;
				randomizedArray.push(arr[rnd]);
				arr.splice(rnd, 1);
			}
			return randomizedArray;	
		}
		
	}
}