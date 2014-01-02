////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 20, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	
	import spark.utils.TextFlowUtil;
	
	import tj.ttu.base.utils.TrimUtil;

	public class TLFUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		private static const newLinePatt:RegExp = /([\u000A|\u000B|\u000C|\u000D|\u0085|\u2028|\u2029] |\r|\n)/ig;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TLFUtil()
		{
		}
		//--------------------------------------------------------------------------
		//
		// Public Methods
		//
		//--------------------------------------------------------------------------
		public static function getFont(str:String, latinFont:String = "Latin", otherFont:String="Cyrillic", direction:String="ltr"):String
		{
			otherFont = otherFont == "Latin" ? latinFont : otherFont;
			
			if(isLatin(str))
				return "Latin";
			return otherFont;
		}
		
		public static function createFlow(str:String, latinFont:String = "Latin", otherFont:String="Cyrillic"):TextFlow
		{
			if(!str)
				return null;
			var gtpat:RegExp = />/igm;
			var ltpat:RegExp = /</igm;
			str = str.replace(gtpat, "&gt;") 
			str = str.replace(ltpat, "&lt;") 
			var xml:XML = TLFUtil.createTlf(str, latinFont, otherFont);
			return TextFlowUtil.importFromXML(xml);
		}
		
		public static function createSimpleFlow(str:String):TextFlow
		{
			if(!str)
				return null;
			var gtpat:RegExp = />/igm;
			var ltpat:RegExp = /</igm;
			str = str.replace(gtpat, "&gt;") 
			str = str.replace(ltpat, "&lt;") 
			var div:XML = <div xmlns="http://ns.adobe.com/textLayout/2008" xml:space="preserve"/>;
			var par:XML = <p  whiteSpaceCollapse="preserve"/>;
			var span:XML =XML('<span>' + str + '</span>');
			span.@fontFamily ="Latin";
			par.appendChild(span);
			return TextFlowUtil.importFromXML(div);
		}
		
		/**
		 * Removes new line symboles and return new string. 
		 * @param str string
		 * 
		 */
		public static function removeNewLineSymboles(str:String):String
		{
			return str.replace( newLinePatt, " ");
		}
		
		private static function getLatin(str:String):int
		{
			if(!str || str.length == 0)
				return 0;
			var index:int = 0;
			while( (isLatin(str.charAt(index))) && (index < str.length) )
				index++;
			return index;
		}
		
		private static function createTlf(str:String, latinFont:String = "Latin", otherFont:String="Cyrillic", direction:String=null):XML
		{
			
			var div:XML = <div xmlns="http://ns.adobe.com/textLayout/2008" xml:space="preserve"/>;
			var par:XML = <p  whiteSpaceCollapse="preserve"/>;
			
			var obj:Object = XML.settings();
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			var hasDir:Boolean;
			var index:int =0;
			otherFont = otherFont == "Latin" ? latinFont : otherFont;
			
			while(str.length >0)
			{
				index = getLatin(str);
				if(index != 0)
				{
					var ltext:String =str.slice(0, index);
					str = str.substr(index);
					var span:XML =XML('<span>' +ltext + '</span>');
					span.@fontFamily ="Latin";
					par.appendChild(span);
				}
				index = getOther(str);
				if(index != 0)
				{
					var otext:String = str.slice(0, index);
					str = str.substr(index);
					var ospan:XML =XML('<span>' +otext + '</span>');
					ospan.@fontFamily = otherFont;
					par.appendChild(ospan);
					hasDir = true;
				}
			}
			if(hasDir && direction == Direction.RTL)
			{
				par.@direction=Direction.RTL;
				par.@textAlign=TextAlign.RIGHT;
			}
			div.appendChild(par);
			XML.setSettings(obj);
			return div; 
		}
		
		private static function getOther(str:String):int
		{
			if(!str || str.length == 0)
				return 0;			
			
			var index:int =0;
			while((isDiacritic(str.charAt(index)) || !isLatin(str.charAt(index))) && (index < str.length) )
				index++;
			return index;
		}
		
		
		
		private static function isLatin(str:String):Boolean
		{
			if(str == " ")
				return true;
			str = TrimUtil.trim(str);
			return  str.charCodeAt(0) <= 0x0369;
		}
		
		
		private static function isCyrillic(str:String):Boolean
		{
			if(str == " ")
				return true;
			str = TrimUtil.trim(str);
			return  str.charCodeAt(0) >= 0x0400 && str.charCodeAt(0) <= 0x04FF;
		}
		
		private static function isPunctuation(str:String):Boolean
		{
			str = TrimUtil.trim(str);
			return  str.charCodeAt(0) >= 0x0020 && str.charCodeAt(0) <= 0x0040;
		}
		
		private static function isDiacritic(str:String):Boolean
		{
			str = TrimUtil.trim(str);
			return  str.charCodeAt(0) >= 0x0300 && str.charCodeAt(0) <= 0x0362;
		}
	}
}