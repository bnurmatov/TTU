////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 20, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	/**
	 * TrimUtil class 
	 */
	public class TrimUtil
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
		 * TrimUtil 
		 */
		public function TrimUtil()
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
		
		/**
		 *Removes whitepsace from beginning and of a string 
		 * @param str String which should be cleaned
		 * @return A string without whitespaces in the beginning and end
		 * 
		 */		
		public static function trim(str:String):String
		{
			
			if(str == null)
				return null;
			
			str = rightTrim(str);
			str = leftTrim(str);
			
			return str;
		}
		
		/**
		 * Removes whitespace from beginning and end of a string.
		 * Removes double spaces.
		 * @param str String which should be cleaned
		 * @return A string without whitespaces in the beginning and end,
		 * and double white spaces. 
		 */		
		public static function superTrim(str:String):String
		{
			if (str == null)
				return null;
			
			return trim(str).replace(/  +/g, ' ');
		}
		
		/**
		 *Removes whitepsace from beginning of a string 
		 * @param str String which should be cleaned
		 * @return A string without whitespaces at the beginning.
		 * 
		 */	
		public static function leftTrim(str:String):String
		{
			var lpat:RegExp = /^\s+/ig;
			return  str.replace(lpat, "");
		}
		
		/**
		 * Removes whitepsace from end and of a string. 
		 * @param str String which should be cleaned
		 * @return A string without whitespaces atthe end
		 * 
		 */	
		public static function rightTrim(str:String):String
		{
			var rpat:RegExp = /\s+$/ig;
			return  str.replace(rpat, "");
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
		
		
	}
}