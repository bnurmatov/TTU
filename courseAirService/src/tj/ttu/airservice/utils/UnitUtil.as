////////////////////////////////////////////////////////////////////////////////
// Copyright May 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import tj.ttu.base.utils.ModuleData;

	/**
	 * UnitUtil class 
	 */
	public class UnitUtil
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
		 * UnitUtil 
		 */
		public function UnitUtil()
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
		public static function generateUnitXML(lessonName:String, lang:String):XML
		{
			// create list node and set attributes
			var unit:XML = new XML(<unit />);
			unit.@name						= lessonName;
			unit.@language					= lang;
			unit.@uiLanguageCode				= lang;
			
			// create and append 'head' and 'cards' nodes
			unit.appendChild(ModuleData.getInstance().config);
			
			var lesson:XML 	= new XML(<lesson />);
			lesson.@name	= lessonName;
			lesson.appendChild(ModuleData.getInstance().modules);
			unit.appendChild(lesson);
			
			return unit;
		}
	}
}