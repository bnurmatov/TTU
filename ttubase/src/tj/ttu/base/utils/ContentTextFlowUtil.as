////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 24, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	import flashx.textLayout.tlf_internal;
	
	import spark.utils.TextFlowUtil;
	
	use namespace tlf_internal;
	/**
	 * PSTextFlowUtil class 
	 */
	public class ContentTextFlowUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private static const IMG_PATTERN:RegExp = /<img[^>]*[^>]*>/gi;
		private static const ANCHOR_WITH_IMAGE:RegExp = /<a[^>]*>[^>]*<img[^>]*[^>]*>[^>]*<\/a>/gi;
		private static const LINK_ACTIVE_FORMAT:String = '<linkActiveFormat><TextLayoutFormat textDecoration="none"/></linkActiveFormat>';
		private static const LINK_HOVER_FORMAT:String = '<linkHoverFormat><TextLayoutFormat textDecoration="none"/></linkHoverFormat>';
		private static const LINK_NORMAL_FORMAT:String = '<linkNormalFormat><TextLayoutFormat textDecoration="none"/></linkNormalFormat>';
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private static var configInheritingFormats:Vector.<String>;
		private static const requiredAtributes:Array = ['whiteSpaceCollapse', 'fontFamily','xmlns', 'fontStyle',  'fontWeight', 'fontSize', 'textDecoration', 'textAlign'];
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * PSTextFlowUtil 
		 */
		public function ContentTextFlowUtil()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
		public static function textFlowToString(textFlow:TextFlow, whithoutImages:Boolean = false):String 
		{
			if(!textFlow)
				return null;
			init();
			
			var obj:Object = XML.settings();
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			var xml:XML = TextFlowUtil.export(textFlow) as XML;
			var div:XML = XML(xml.children()[0]);
			if(div && div.localName() == "div")
				xml.setChildren(div.children());
			if(xml.localName() != "div")
				xml.setLocalName("div");
			
			var p:String;
			var n:int = configInheritingFormats.length;
			for (var i:int = 0; i < n; i++)
			{
				p = configInheritingFormats[i];
				if (requiredAtributes.indexOf( p ) == -1)
					delete xml.@[p];
			}
			
			var str:String = xml.toXMLString();
			if(whithoutImages)
			{
				str = str.replace(ANCHOR_WITH_IMAGE, "");
				str = str.replace(IMG_PATTERN, "");
			}
			str = str.replace(LINK_ACTIVE_FORMAT, "");
			str = str.replace(LINK_HOVER_FORMAT, "");
			str = str.replace(LINK_NORMAL_FORMAT, "");
			XML.setSettings(obj);
			return str;
		}
		
		
		public static function stringToTextFlow(divString:String):TextFlow 
		{
			if(!divString)
				return null;
			
			return TextFlowUtil.importFromString(divString, WhiteSpaceCollapse.PRESERVE);
		}
		
		public static function compare(divString:String, textFlow:TextFlow):Boolean
		{
			var tagPattern:RegExp = new RegExp("<[^<]+?>", "gi");
			var str:String;
			if(tagPattern.test( divString ))
				str = textFlowToString( textFlow );
			else
				str = textFlow.getText();
			return str == divString;
			
		}
		
		public static function compareTwoTextFlows(textFlow1:TextFlow, textFlow2:TextFlow):Boolean
		{
			var str1:String = textFlowToString( textFlow1 );
			var str2:String = textFlowToString( textFlow2 );
			return str1 == str2;
		}
		
		private static function init():void
		{
			if(configInheritingFormats)
				return;
			configInheritingFormats = new Vector.<String>();
			for (var p:String in TextLayoutFormat.description)
			{
				configInheritingFormats.push(p);
			}
		}
		//--------------------------------------------------------------------------
		//
		// Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		
	}
}