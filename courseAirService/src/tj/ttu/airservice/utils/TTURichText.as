////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 11, 2014, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.text.engine.FontLookup;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.mx_internal;
	
	import spark.components.RichText;
	use namespace mx_internal;
	
	/**
	 * TTURichText class 
	 */
	public class TTURichText extends RichText
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
		 * TTURichText 
		 */
		public function TTURichText()
		{
			super();
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
		override mx_internal function getEmbeddedFontContext():IFlexModuleFactory
		{
			var fontContext:IFlexModuleFactory;
			return fontContext;
			var fontLookup:String = getStyle("fontLookup");
			if (fontLookup != FontLookup.DEVICE)
			{
				var font:String = getStyle("fontFamily");
				var bold:Boolean = getStyle("fontWeight") == "bold";
				var italic:Boolean = getStyle("fontStyle") == "italic";
				
				fontContext = getFontContext(font, bold, italic, true);
			}
			
			return fontContext;
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
		
		
	}
}